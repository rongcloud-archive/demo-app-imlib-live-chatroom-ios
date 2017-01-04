//
//  RCDDanmakuManager.m
//  DanMuDemo
//
//  Created by Sin on 16/9/26.
//  Copyright © 2016年 Sin. All rights reserved.
//

#import "RCDDanmakuManager.h"

@interface RCDDanmakuManager ()

@end

@implementation RCDDanmakuManager
+ (instancetype)sharedManager {
    static RCDDanmakuManager *manger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[self alloc]init];
    });
    return manger;
}

- (void)reset {
    self.danmakus = [[NSMutableArray alloc]init];
    self.subDanmakuInfos = [[NSMutableArray alloc]init];
    self.linesDict = [[NSMutableDictionary alloc]init];
    self.centerTopLinesDict = [[NSMutableDictionary alloc]init];
    self.centerBottomLinesDict = [[NSMutableDictionary alloc]init];
    self.currentDanmakuCache = [[NSMutableArray alloc]init];
    self.duration = 5;
    self.centerDuration = 2.5;
    self.specialDuration = 2.5;
    self.lineHeight = 25;
    self.maxShowLineCount = 15;
    self.maxCenterLineCount = 5;
    self.isAllowOverLoad = NO;
    self.isPlaying = YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

- (void)setIsAllowOverLoad:(BOOL)isAllowOverLoad {
    //如果过量加载切换为缓存加载，那么需要将弹道清空，否则会一直碰撞
    if(_isAllowOverLoad && !isAllowOverLoad) {
        [self.linesDict removeAllObjects];
    }
    _isAllowOverLoad = isAllowOverLoad;
}

@end
