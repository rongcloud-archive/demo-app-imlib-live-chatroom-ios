//
//  LCPlayerViewGlobalDefine.h
//  NetRequestDemo
//
//  Created by CC on 15/9/21.
//  Copyright © 2015年 CC. All rights reserved.
//



#ifndef LCPlayerViewGlobalDefine_h
#define LCPlayerViewGlobalDefine_h

/*
 播放屏幕状态
 */
typedef NS_ENUM(NSInteger, LCPlayerScreenState) {
    LCPlayerScreenStateHalfScreen = 0,
    LCPlayerScreenStateFullScreen = 1
};

/*
 播放器类型
 */
typedef NS_ENUM(NSInteger, LCPlayerStytle) {
    LCPlayerStytleVod = 100,
    LCPlayerStytleLive = 101,
    LCPlayerStytleActivityLive = 102
};

/*
 错误页面类型
 */
typedef NS_ENUM(NSInteger, LCPlayerState) {
    LCPlayerStateUnregister = 0,  //未注册
    LCPlayerStatePrepareToPlay = 1,
    LCPlayerStateStop = 2,
    LCPlayerStatePlay = 3,
    LCPlayerStatePause = 4
};


#define kBaseGestureSensitivity   0.000025
#define kBaseSysGestureSensitivity   0.00025
/*
 Pan手势事件方向
 */
typedef NS_ENUM(NSInteger, LCPanGestureDirection) {
    LCPanGestureDirectionNone = 0,
    LCPanGestureDirectionUp = 1,
    LCPanGestureDirectionLeft = 2,
    LCPanGestureDirectionDown = 3,
    LCPanGestureDirectionRight = 4
};

/*
 播放手势事件
 */
typedef NS_ENUM(NSInteger, LCPlayerGestureEvent) {
    LCPlayerGestureEventNone = 0,
    LCPlayerGestureEventSeek = 1,
    LCPlayerGestureEventBrightness = 2,
    LCPlayerGestureEventVolume = 3
};

/*
 错误页面类型
 */
typedef NS_ENUM(NSInteger, LCErrorViewEvent) {
    LCErrorViewEventNone = 0,  //无错误
    LCErrorViewEventLaunching = 1,//启动加载
    LCErrorViewEventNoMedia = 2,//无媒体资源状态
    LCErrorViewEventFail = 3,//统一失败页面
    LCErrorViewEventLoading = 4,//缓冲卡顿等加载事件
};


/*
 按钮类型
 */
typedef NS_ENUM(NSInteger, LCPlayerButtonEvent) {
    LCPlayerButtonEventBack = 100,//返回
    LCPlayerButtonEventRate = 101,//码率
    LCPlayerButtonEventChangeScreen = 102,//全屏半屏
    LCPlayerButtonEventPlay = 103, //播放
    LCPlayerButtonEventPause = 104, //停止播放
    LCPlayerButtonEventLockRotation = 105, //锁定屏幕方向
    LCPlayerButtonEventDownload = 106, //下载
    LCPlayerButtonEventBackToLiveTime = 107 //返回当前直播最新时间
};

/*
 下载按钮状态
 */
typedef NS_ENUM(NSInteger, LCDownloadButtonState) {
    LCDownloadButtonStateNormal = 0,//普通状态
    LCDownloadButtonStateNone = 1,  //无下载按钮
    LCDownloadButtonStateDownloading = 2,//下载中
    LCDownloadButtonStateDownload = 3,//已经下载
    LCDownloadButtonStateDisable = 4,//下载不可用
};


/*
 播放Control事件状态
 */
typedef NS_ENUM(NSInteger, LCPlayerControlEvent) {
    LCPlayerControlEventNone = 0,  //无状态
    LCPlayerControlEventStart = 1,//开始加载Control
    LCPlayerControlEventRegisterFinish,//注册完成
    LCPlayerControlEventPrepareDone,//Player准备完成可以开播
    LCPlayerControlEventBufferStart,//开始缓冲
    LCPlayerControlEventBufferEnd,//结束缓冲
    LCPlayerControlEventEOF,//播放结束
    LCPlayerControlEventFail//统一失败处理
};

#endif /* LCPlayerViewGlobalDefine_h */

