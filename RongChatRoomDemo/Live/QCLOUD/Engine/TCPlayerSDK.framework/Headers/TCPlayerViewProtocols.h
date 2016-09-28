//
//  TCPlayerViewProtocols.h
//  TCPlayer
//
//  Created by  on 15/8/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol TCMaskAbleView;

@protocol TCPlayerSubAbleView;

typedef void (^TCCompletionAction)(void);

// maskViewSelf : mask本身
// inView ：maskViewSelf的父控件
// completion ：动画完成的回调
typedef void (^TCMaskViewAnimationAction)(UIView<TCMaskAbleView> *maskViewSelf, UIView<TCPlayerSubAbleView> *inView, TCCompletionAction completion);





@protocol TCPlayerAbleView;

@protocol TCPlayerSubAbleView <NSObject>


@required
// 所在播放器控件的引用，内部会自动设置
@property (nonatomic, weak) UIView<TCPlayerAbleView, TCPlayerEngine> *playerView;

// 相应控件重写此方法进行布局
- (void)layoutWithRecommendRect:(CGRect)rect;

// 每次播放前都会reset一次
- (void)reset;

@optional

//@property (nonatomic, weak) id delegate;

// 状态更新
- (void)updateOnWillBuffering;

// 加载视频失败
- (void)updateOnPlayerFailed:(TCPlayerErrorType)type;

// 缓冲后开始播放
- (void)updateOnWillPlay;

//// 已播放过程中出现缓冲
//- (void)updateOnBufferingWhenPlayed;

// 状态改变
- (void)updateOnStateChanged:(TCPlayerState)state;

// 网络状态变化通知
- (void)updateOnNetworkStateChanged:(TCPlayerNetworkState)state;

// 更新当前播放时间
- (void)updateOnCurrentTime:(NSInteger)time;

- (void)updateOnPlayOver;

@optional
// 界面状态更新
- (void)updateOnFullScreenChangeTo:(BOOL)full;

// 更新缓冲进度
- (void)updateOnBufferingProgress:(CGFloat)progress;

@optional

- (void)showMask:(UIView<TCMaskAbleView> *)mask;

- (UIView<TCMaskAbleView> *)maskWithTag:(NSInteger)tag;

// completionBlock 为动画结束回调，不需要在些作移除操作
// 该 API自身会作移除操作
- (void)removeMask:(UIView<TCMaskAbleView> *)mask;

@end


@protocol TCMaskAbleView <TCPlayerSubAbleView>

@required

- (void)reload;

@optional
// 添加到相应的控件后，showMask内会自动调用
@property (nonatomic, copy) TCMaskViewAnimationAction showAnimation;

// 除移动画，removeMask内部自动调用
@property (nonatomic, copy) TCMaskViewAnimationAction removeAnimation;

@end


typedef void(^TCPlayerViewActionBlock)(UIView<TCPlayerAbleView, TCPlayerEngine> *playerView);

typedef void(^TCPlayerNetworkBlock)(UIView<TCPlayerAbleView, TCPlayerEngine> *playerView, TCPlayerNetworkState networkState);

typedef void(^TCPlayerViewPlayFailedBlock)(UIView<TCPlayerAbleView, TCPlayerEngine> *playerView, TCPlayerErrorType errType);

// actionType支持自定义，下列数据已用
// 0 : 单击，已处理隐藏
// 1 : 双击
// 2 : 捏合
// 其他由用户自定义
typedef void(^TCPlayerViewClickActionBlock)(UIView<TCPlayerAbleView, TCPlayerEngine> *playerView, NSInteger actionType);

@protocol TCPlayerViewActionAble <NSObject>

@optional
// 准备播放回调, 对应TCPlayerEngineDelegate onWillPlay;
@property (nonatomic, copy) TCPlayerViewActionBlock      playbackReadyBlock;

// 开始播放（暂停后恢复也会回调）, 对应 TCPlayerEngineDelegate onStateChanged:TCPlayerState_Play
@property (nonatomic, copy) TCPlayerViewActionBlock      playbackBeginBlock;

// 播放失败回掉, 对应 TCPlayerEngineDelegate - (void)onPlayerFailed:(id<TCPlayerEngine>)player errorType:(TCPlayerErrorType)errType
@property (nonatomic, copy) TCPlayerViewPlayFailedBlock     playbackFailedBlock;

// 播放结束, 对应 TCPlayerEngineDelegate  - (void)onPlayOver:(id<TCPlayerEngine>)player;
@property (nonatomic, copy) TCPlayerViewActionBlock   playbackEndBlock;

// 播放暂停回调, 对应 TCPlayerEngineDelegate onStateChanged:TCPlayerState_Paused 或 TCPlayerState_PauseByLimitTime， 具体状态查询state方法
@property (nonatomic, copy) TCPlayerViewActionBlock      playbackPauseBlock;

// 点击播放界面回调
@property (nonatomic, copy) TCPlayerViewClickActionBlock      clickPlaybackViewblock;

// 点击界面 bottomView 是否是隐藏
@property (nonatomic, copy) TCPlayerViewActionBlock      showHideBottomViewblock;

// 全屏回调, isFullScreen查询是否全屏
@property (nonatomic, copy) TCPlayerViewActionBlock enterExitFullScreenBlock;

// 缓冲提示
@property (nonatomic, copy) TCPlayerViewActionBlock bufferingPlayBlock;

// 网络变化提示
@property (nonatomic, copy) TCPlayerNetworkBlock networkStateBlock;

@end


// 云播放器通用操作

@protocol TCPlayerAbleView <TCPlayerSubAbleView>

@property (nonatomic, readonly) UIView<TCPlayerSubAbleView> *ctrlView;              // 播放控制View
@property (nonatomic, readonly) UIView<TCPlayerSubAbleView> *bottomView;            // 进度条View

@property (nonatomic, readonly) id<TCPlayResAbleItem> videoResItem;                 // 播放的资源组合
@property (nonatomic, readonly) id<TCCanPlayAble> playingItem;                      // 当前播放的视频

@property (nonatomic, strong) id<TCPlayerViewActionAble> playAction;                // 播放器外部监听事件集合

@property (nonatomic, readonly) NSMutableArray *maskViews;                          // 界面上显示的maskView;

// 是否支持旋转进行横竖屏切换, YES:支持 NO:不支持, 默认YES
@property (nonatomic, assign) BOOL isEnableRotateFullScreen;

// 播放res第index个资源
- (void)play:(id<TCPlayResAbleItem>)res atIndex:(NSUInteger)index;
// 从sec秒播放res第index个资
- (void)play:(id<TCPlayResAbleItem>)res atIndex:(NSUInteger)index fromSeconds:(NSUInteger)sec;

// 播放
- (void)play:(id<TCCanPlayAble>)videoItem;

// 显示或隐藏进部条
- (void)autoShowOrHideBottomView:(CGFloat)seconds;

// toFull (YES), 进入全屏，NO 退出全屏
- (void)changeToFullScreen:(BOOL)toFull;

// 是否全屏显示
- (BOOL)isFullScreen;

// 底部状态栏是否显示
- (BOOL)isBottomViewShow;

@optional

// 开启网络监听
- (void)enableNetworkMonitoring;

// 关闭网络监听
- (void)disableNetworkMonitoring;

@end




