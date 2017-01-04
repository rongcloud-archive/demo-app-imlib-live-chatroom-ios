//
//  RCDDanmakuManager.h
//  DanMuDemo
//
//  Created by Sin on 16/9/26.
//  Copyright © 2016年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RCDanmakuManager [RCDDanmakuManager sharedManager]

@interface RCDDanmakuManager : NSObject

+ (instancetype)sharedManager;

- (void)reset;

@property (nonatomic, assign) BOOL isPlaying;

// 以下属性都是必须配置的--------//
// 弹幕动画时间
@property (nonatomic, assign) CGFloat duration;
// 中间上边/下边弹幕动画时间
@property (nonatomic, assign) CGFloat centerDuration;
// 特定位置弹幕的持续时间
@property (nonatomic, assign) CGFloat specialDuration;
// 弹幕弹道高度
@property (nonatomic, assign) CGFloat lineHeight;
// 弹幕弹道之间的间距
@property (nonatomic, assign) CGFloat lineMargin;
// 弹幕弹道最大行数
@property (nonatomic, assign) NSInteger maxShowLineCount;
// 弹幕弹道中间上边/下边最大行数
@property (nonatomic, assign) NSInteger maxCenterLineCount;


//是否允许过量加载弹幕，如果为yes，那么不做弹幕缓存，来多少弹幕，就直接加载多少
//如果做缓存，弹幕会以固定的时间弹出，整个屏幕最多显示maxShowLineCount条弹幕
@property (nonatomic,assign) BOOL isAllowOverLoad;

// 以上属性都是必须配置的--------//


//弹幕缓存的计时器，如果允许过量加载弹幕，该定时器无效
@property(nonatomic, strong) NSTimer *timer;
//所有弹幕的数组
@property(nonatomic, strong) NSMutableArray* danmakus;
//所有弹幕info的数组
@property(nonatomic, strong) NSMutableArray* subDanmakuInfos;
//当前页面上显示的弹幕所在的label的数组
@property(nonatomic, strong) NSMutableArray *currentDanmakuCache;

//从右往左的弹幕的弹道的路径字典
@property(nonatomic, strong) NSMutableDictionary* linesDict;
//居中靠上的弹幕的弹道的路径字典
@property(nonatomic, strong) NSMutableDictionary* centerTopLinesDict;
//居中靠下的弹幕的弹道的路径字典
@property(nonatomic, strong) NSMutableDictionary* centerBottomLinesDict;

@end
