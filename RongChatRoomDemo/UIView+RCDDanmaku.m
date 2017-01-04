//
//  UIView+RCDDanmaku.m
//  DanMuDemo
//
//  Created by Sin on 16/9/26.
//  Copyright © 2016年 Sin. All rights reserved.
//

#import "UIView+RCDDanmaku.h"
#import "RCDDanmaku.h"
#import "RCDDanmakuInfo.h"
#import "RCDDanmakuManager.h"

#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y
#define Width(view) view.frame.size.width
#define Height(view) view.frame.size.height
#define Left(view) X(view)
#define Right(view) (X(view) + Width(view))
#define Top(view) Y(view)
#define Bottom(view) (Y(view) + Height(view))
#define CenterX(view) (Left(view) + Right(view))/2
#define CenterY(view) (Top(view) + Bottom(view))/2


@implementation UIView (RCDDanmaku)
#pragma mark - public method
//发送一个弹幕
- (void)sendDanmaku:(RCDDanmaku *)danmaku
{
    [RCDanmakuManager.danmakus addObject:danmaku];
    //如果允许过量加载demo，就不进行弹幕的缓存，
    if(RCDanmakuManager.isAllowOverLoad){
        if(!RCDanmakuManager.isPlaying) {
            
        }else {
            [self rc_playDanmaku:danmaku];
        }
    }else {
        [self rc_playOverLoadDanmaku];
    }
    
}

//发送一个特定位置的弹幕，根据point来确定弹幕左上角的位置
- (void)sendDanmaku:(RCDDanmaku *)danmaku atPoint:(CGPoint)point {
    [RCDanmakuManager.danmakus addObject:danmaku];
    UILabel* playerLabel = [self rc_getOneLabelWithDanmaku:danmaku];
    CGRect playLabelFrame = playerLabel.frame;
    playLabelFrame.origin.x = point.x;
    playLabelFrame.origin.y = point.y;
    playerLabel.frame = playLabelFrame;
    
    //确定好弹幕的位置之后发一个中心点位置的弹幕
    [self sendDanmaku:danmaku atCenterPoint:playerLabel.center];
    
}

//发送一个特定位置的弹幕，根据point来确定弹幕的中心点位置
- (void)sendDanmaku:(RCDDanmaku *)danmaku atCenterPoint:(CGPoint)point {
    [RCDanmakuManager.danmakus addObject:danmaku];
    UILabel* playerLabel = [self rc_getOneLabelWithDanmaku:danmaku];
    playerLabel.center = point;
    
    RCDDanmakuInfo *info = [[RCDDanmakuInfo alloc]init];
    info.danmaku = danmaku;
    info.playLabel = playerLabel;
    
    //检测该特殊位置弹幕是否在可视范围内，如果需要对在不可视范围的弹幕进行处理，可以在此方法中操作
    [self rc_checkDanmakuLabelInView:playerLabel];
    
    [self rc_playSpecialDanamku:info];
}
//停止弹幕
- (void)stopDanmaku
{
    RCDanmakuManager.isPlaying = NO;
    [RCDanmakuManager.timer invalidate];
    RCDanmakuManager.timer = nil;
    [RCDanmakuManager.danmakus removeAllObjects];
    [RCDanmakuManager.linesDict removeAllObjects];
    [RCDanmakuManager.subDanmakuInfos removeAllObjects];
    
    for(UILabel *label in RCDanmakuManager.currentDanmakuCache){
        [label removeFromSuperview];
    }
    for(UIView *view in self.subviews){
        if(RCDDanmakuLabelTag == view.tag){
            [view removeFromSuperview];
        }
    }
    [RCDanmakuManager.currentDanmakuCache removeAllObjects];
    
    [RCDanmakuManager reset];
}

//暂停弹幕配合 resumeDanmaku 使用
- (void)pauseDanmaku
{
    if(RCDanmakuManager.isAllowOverLoad){
        if(!RCDanmakuManager.isPlaying)  return ;
    }else {
        if(!RCDanmakuManager.timer || !RCDanmakuManager.timer.isValid ) return;
    }
    
    RCDanmakuManager.isPlaying = NO;
    
    [RCDanmakuManager.timer invalidate];
    RCDanmakuManager.timer = nil;
    
    for (UILabel* label in self.subviews) {
        if(RCDDanmakuLabelTag == label.tag){
            CALayer *layer = label.layer;
            CGRect rect = label.frame;
            if (layer.presentationLayer) {
                rect = ((CALayer *)layer.presentationLayer).frame;
            }
            label.frame = rect;
            [label.layer removeAllAnimations];
        }
    }
}

//重开弹幕配合 pauseDanmaku 使用
- (void)resumeDanmaku
{
    if( RCDanmakuManager.isPlaying )return;
    RCDanmakuManager.isPlaying = YES;
    for (RCDDanmakuInfo* info in RCDanmakuManager.subDanmakuInfos) {
        if (info.danmaku.position == RCDDanmakuPositionNone) {
            //计算暂停在屏幕上的弹幕的剩余时间
            UILabel *label = info.playLabel;
            CGFloat scale = 1.0 * Right(label) / (Width(self) + Width(label));
            NSTimeInterval duration = RCDanmakuManager.duration *scale;
            [self rc_performAnimationWithDuration:duration danmakuInfo:info];
        }else{
            [self rc_performCenterAnimationWithDuration:info.leftTime danmakuInfo:info];
        }
    }
    
}


#pragma mark - private method

- (void)rc_playDanmaku:(RCDDanmaku *)danmaku
{
    NSLog(@"总弹幕数%zd",RCDanmakuManager.danmakus.count);
    UILabel* playerLabel = [[UILabel alloc] init];
    playerLabel.tag = RCDDanmakuLabelTag;
    playerLabel.attributedText = danmaku.contentStr;
    [playerLabel sizeToFit];
    playerLabel.backgroundColor = [UIColor clearColor];
    switch (danmaku.position) {
        case RCDDanmakuPositionNone:
            [self rc_playFromRightDanmaku:danmaku playerLabel:playerLabel];
            break;
            
        case RCDDanmakuPositionCenterTop:
        case RCDDanmakuPositionCenterBottom:
            [self rc_playCenterDanmaku:danmaku playerLabel:playerLabel];
            break;
            
        default:
            break;
    }
    
}

#pragma mark over load danmaku
- (void)rc_playOverLoadDanmaku {
    if (!RCDanmakuManager.timer && RCDanmakuManager.isPlaying) {
        NSTimeInterval interval = RCDanmakuManager.duration / RCDanmakuManager.maxShowLineCount * 1.0 + 0.1;
        RCDanmakuManager.timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(rc_sendOverLoadDanmaku) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:RCDanmakuManager.timer forMode:NSRunLoopCommonModes];
        [RCDanmakuManager.timer fire];
    }
}


- (void)rc_sendOverLoadDanmaku {
    if(RCDanmakuManager.danmakus.count > 0){
        NSLog(@"count total %zd",RCDanmakuManager.danmakus.count);
        [self rc_playDanmaku:RCDanmakuManager.danmakus[0]];
        [RCDanmakuManager.danmakus removeObjectAtIndex:0];
    }
}



#pragma mark center top \ bottom
- (void)rc_playCenterDanmaku:(RCDDanmaku *)danmaku playerLabel:(UILabel *)playerLabel
{
    NSAssert(RCDanmakuManager.centerDuration && RCDanmakuManager.maxCenterLineCount, @"如果要使用中间弹幕 必须先设置中间弹幕的时间及最大行数");
    
    RCDDanmakuInfo* newInfo = [[RCDDanmakuInfo alloc] init];
    newInfo.playLabel = playerLabel;
    newInfo.leftTime = RCDanmakuManager.centerDuration;
    newInfo.danmaku = danmaku;
    
    NSMutableDictionary* centerDict = nil;
    
    if (danmaku.position == RCDDanmakuPositionCenterTop) {
        centerDict = RCDanmakuManager.centerTopLinesDict;
    }else{
        centerDict = RCDanmakuManager.centerBottomLinesDict;
    }
    
    NSInteger valueCount = centerDict.allKeys.count;
    if (valueCount == 0) {
        newInfo.lineCount = 0;
        [self rc_addCenterAnimation:newInfo centerDict:centerDict];
        return;
    }
    for (int i = 0; i<valueCount; i++) {
        RCDDanmakuInfo* oldInfo = centerDict[@(i)];
        if (!oldInfo) break;
        if (![oldInfo isKindOfClass:[RCDDanmakuInfo class]]) {
            newInfo.lineCount = i;
            [self rc_addCenterAnimation:newInfo centerDict:centerDict];
            break;
        }else if (i == valueCount - 1){
            if (valueCount < RCDanmakuManager.maxCenterLineCount) {
                newInfo.lineCount = i+1;
                [self rc_addCenterAnimation:newInfo centerDict:centerDict];
            }else{
                [self rc_removeDanmakuInfoAfterAnimation:newInfo];
                NSLog(@"同一时间评论太多--排不开了--------------------------");
            }
        }
    }
    
}

- (void)rc_addCenterAnimation:(RCDDanmakuInfo *)info  centerDict:(NSMutableDictionary *)centerDict
{
    
    UILabel* label = info.playLabel;
    NSInteger lineCount = info.lineCount;
    
    if (info.danmaku.position == RCDDanmakuPositionCenterTop) {
        label.frame = CGRectMake((Width(self) - Width(label)) * 0.5, (RCDanmakuManager.lineHeight + RCDanmakuManager.lineMargin) * lineCount, Width(label), Height(label));
        NSLog(@"top frame %@",NSStringFromCGRect(label.frame));
    }else{
        label.frame = CGRectMake((Width(self) - Width(label)) * 0.5, Height(self) - Height(label) - (RCDanmakuManager.lineHeight + RCDanmakuManager.lineMargin) * lineCount, Width(label), Height(label));
        NSLog(@"bottom frame %@",NSStringFromCGRect(label.frame));
    }
    
    centerDict[@(lineCount)] = info;
    [RCDanmakuManager.subDanmakuInfos addObject:info];
    
    [self rc_performCenterAnimationWithDuration:info.leftTime danmakuInfo:info ];
}

- (void)rc_performCenterAnimationWithDuration:(NSTimeInterval)duration danmakuInfo:(RCDDanmakuInfo *)info
{
    UILabel* label = info.playLabel;
    [RCDanmakuManager.currentDanmakuCache addObject:label];
    
    NSLog(@"index %zd",info.lineCount);
    
    [self addSubview:label];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(!RCDanmakuManager.isPlaying) return ;
        
        if (info.danmaku.position == RCDDanmakuPositionCenterBottom) {
            RCDanmakuManager.centerBottomLinesDict[@(info.lineCount)] = @(0);
        }else{
            RCDanmakuManager.centerTopLinesDict[@(info.lineCount)] = @(0);
        }
        [weakSelf rc_removeDanmakuInfoAfterAnimation:info];
    });
}


#pragma mark from right
- (void)rc_playFromRightDanmaku:(RCDDanmaku *)danmaku playerLabel:(UILabel *)playerLabel
{
    
    RCDDanmakuInfo* newInfo = [[RCDDanmakuInfo alloc] init];
    newInfo.playLabel = playerLabel;
    newInfo.leftTime = RCDanmakuManager.duration;
    newInfo.danmaku = danmaku;
    [RCDanmakuManager.currentDanmakuCache addObject:playerLabel];
    
    NSMutableArray *arr = [self rc_getNSArray];
    NSArray *lineArr = RCDanmakuManager.linesDict.allKeys;
    [arr removeObjectsInArray:lineArr];
    NSInteger lineCount = [self rc_getRandomNum:arr];
    if(!RCDanmakuManager.isAllowOverLoad) {
        newInfo.lineCount = lineCount;
        while (1) {
            RCDDanmakuInfo* oldInfo = RCDanmakuManager.linesDict[@(newInfo.lineCount)];
            if(oldInfo){
                NSInteger randNum = [self rc_getRandomNum:arr];
                NSLog(@"----------------------------------");
                newInfo.lineCount = randNum*randNum % RCDanmakuManager.maxShowLineCount;
            }else{
                break;
            }
        }
    }else {
        lineCount = abs((int)arc4random()) % RCDanmakuManager.maxShowLineCount;
        newInfo.lineCount = lineCount;
    }
    
    playerLabel.frame = CGRectMake(Width(self), 0, Width(playerLabel), Height(playerLabel));
    
    [self rc_addAnimationToViewWithInfo:newInfo];
    
}

- (NSMutableArray *)rc_getNSArray {
    NSMutableArray *arr = [NSMutableArray new];
    arr = [NSMutableArray new];
    for (int i=0;i<RCDanmakuManager.maxShowLineCount;i++){
        [arr addObject:@(i)];
    }
    return arr;
}

- (NSInteger)rc_getRandomNum:(NSArray *)selectingList{
    
    if(selectingList.count == 0){
        return 0;
    }
    NSInteger index = arc4random_uniform((u_int32_t)selectingList.count-1);
    if(index<0){
        index = 0;
    }else if(index >selectingList.count-1) {
        index = selectingList.count-1;
    }
    return [selectingList[index] integerValue];
}

- (void)rc_addAnimationToViewWithInfo:(RCDDanmakuInfo *)info
{
    UILabel* label = info.playLabel;
    NSInteger lineCount = info.lineCount;
    
    label.frame = CGRectMake(Width(self), (RCDanmakuManager.lineHeight + RCDanmakuManager.lineMargin) * lineCount, Width(label), Height(label));
    
    [RCDanmakuManager.subDanmakuInfos addObject:info];
    RCDanmakuManager.linesDict[@(lineCount)] = info;
    
    [self rc_performAnimationWithDuration:info.leftTime danmakuInfo:info];
}

- (void)rc_performAnimationWithDuration:(NSTimeInterval)duration danmakuInfo:(RCDDanmakuInfo *)info
{
    RCDanmakuManager.isPlaying = YES;
    
    UILabel* label = info.playLabel;
    CGRect endFrame = CGRectMake(-Width(label), Y(label), Width(label), Height(label));
    
    
    [self addSubview:label];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        label.frame = endFrame;
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf rc_removeDanmakuInfoAfterAnimation:info];
            [RCDanmakuManager.linesDict removeObjectForKey:@(info.lineCount)];
            NSLog(@"count left %zd",RCDanmakuManager.danmakus.count);
        }
    }];
}
#pragma mark special point danmaku
//播放特定位置的弹幕的动画
- (void)rc_playSpecialDanamku:(RCDDanmakuInfo *)info {
    UILabel *label = info.playLabel;
    [RCDanmakuManager.currentDanmakuCache addObject:label];
    
    [self addSubview:label];
    
    __weak typeof(self) weakSelf = self;
    NSTimeInterval duration = RCDanmakuManager.specialDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(!RCDanmakuManager.isPlaying) return ;
        
        [weakSelf rc_removeDanmakuInfoAfterAnimation:info];
    });
}
#pragma mark util method
//获取一个弹幕label
- (UILabel *)rc_getOneLabelWithDanmaku:(RCDDanmaku *)danmaku {
    UILabel* playerLabel = [[UILabel alloc] init];
    playerLabel.tag = RCDDanmakuLabelTag;
    playerLabel.attributedText = danmaku.contentStr;
    [playerLabel sizeToFit];
    playerLabel.backgroundColor = [UIColor clearColor];
    return playerLabel;
}

//一个弹幕消失之后，将其彻底移除
- (void)rc_removeDanmakuInfoAfterAnimation:(RCDDanmakuInfo *)info {
    UILabel *label = info.playLabel;
    [label removeFromSuperview];
    [RCDanmakuManager.danmakus removeObject:info.danmaku];
    [RCDanmakuManager.currentDanmakuCache removeObject:label];
    [RCDanmakuManager.subDanmakuInfos removeObject:info];
    info = nil;
}

//检测特定位置弹幕是否是在视频页面的可视范围中，如果需要做不在可视范围的处理，可以在该方法中进行操作
- (void)rc_checkDanmakuLabelInView:(UILabel *)label {
    if(!CGRectContainsRect(self.frame, label.frame)){
        NSLog(@"warning : 特殊点弹幕的位置超出可视范围");
    }
}

@end
