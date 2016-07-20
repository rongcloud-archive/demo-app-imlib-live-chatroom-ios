//
//  TCCorePlayerView.h
//  TCPlayerDemo
//
//  Created by  on 15/8/14.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCPlayer.h"

@interface TCCorePlayerView : UIView<TCPlayerEngine, TCPlayerEngineDelegate>
{
@protected
    id<TCPlayerEngine> _playerEngine;
}

@property (nonatomic, weak) id<TCPlayerEngineDelegate> playerDelegate;

// 强制横屏时，横屏方向，默认UIDeviceOrientationLandscapeRight
// 只能是UIDeviceOrientationLandscapeLeft/UIDeviceOrientationLandscapeRight
// 设置其他值，默认使用UIDeviceOrientationLandscapeRight
@property (nonatomic, assign) UIDeviceOrientation defaultForceToOrientation;

// 是否锁定屏幕，默认NO
// 为YES时屏幕旋转与强制旋转都不响应
@property (nonatomic, assign) BOOL isLockScreen;

// 是否支持旋转进行横竖屏切换, YES:支持 NO:不支持, 默认YES,
// 不会随手机横竖屏切换，仍可强制横屏
@property (nonatomic, assign) BOOL isEnableRotateFullScreen;

// 是否外部控制旋转，默认为NO;
// isUsingOutSideRotate为YES，会将isEnableRotateFullScreen置为NO;
// 同时强制旋转, SDK内部调用设备旋转接口，触发外部UIViewController旋转代码
// 外部旋转完成后，使用didRotateToFull来更新播放器内部视图
@property (nonatomic, assign) BOOL usingOutSideRotate;

// 对于HLS资源，以及本地视频默认不缓存，其他默认YES
// 下次播放有效，建议播放前设置
@property (nonatomic, assign) BOOL enableCache;

// 是否允许上报，默认YES
@property (nonatomic, assign) BOOL enableReport;

// 是否静音播放，默认NO不静音播放
@property(nonatomic, assign) BOOL isSilent;

// 是否循环播放，默认NO不循环播放
@property(nonatomic, assign) BOOL isCyclePlay;

// 当enableCache = YES时，clearPlayCache为真，清除掉本次播放过程中产生的Cahce文件
@property(nonatomic, assign) BOOL clearPlayCache;

// 清除所有的播放缓存
+ (void)clearAllPlayCache;

// 强制旋转
- (void)forceToDeviceOrientation;

// 当使用外部旋转逻辑时，需要调用此方法，通知修改内部maskview
// usingOutSideRotate为YES时有效
// fullScreen：YES:旋转到全屏，NO：退出全屏
- (void)didRotateToFull:(BOOL)fullScreen;

// 当前是否全屏
- (BOOL)isFullScreen;

// 自行设置画面填充模式：
// AVLayerVideoGravityResizeAspect
// AVLayerVideoGravityResizeAspectFill
// AVLayerVideoGravityResize
- (void)setVideoFillMode:(NSString *)fillMode;

// 当前 _currentTime ＋ willBufferingTime > _loadingTime，会提求播放过程中出现缓冲
- (void)setWillBufferingTimeInterval:(NSInteger)time;

// 开启网络监听
- (void)enableNetworkMonitoring;

// 关闭网络监听
- (void)disableNetworkMonitoring;

#ifdef DEBUG
// 测试接口
- (void)testResumeLoad;
- (void)testStopLoad;
#endif


@end
