//
//  LECPlayer.h
//  LECPlayerSDK
//
//  Created by 侯迪 on 9/13/15.
//  Copyright (c) 2015 letv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LCProcStatus.h"
#import "LCStreamRateItem.h"
#import "LCPlayerOption.h"

@class LECPlayer;

typedef NSInteger LECPlayerPlayOperation;

static LECPlayerPlayOperation LECPlayerPlayOperationRegister = 0;
static LECPlayerPlayOperation LECPlayerPlayOperationUnregister = 1;
static LECPlayerPlayOperation LECPlayerPlayOperationPrepare = 2;
static LECPlayerPlayOperation LECPlayerPlayOperationPlay = 3;
static LECPlayerPlayOperation LECPlayerPlayOperationPause = 4;
static LECPlayerPlayOperation LECPlayerPlayOperationResume = 5;
static LECPlayerPlayOperation LECPlayerPlayOperationStop = 6;
static LECPlayerPlayOperation LECPlayerPlayOperationSeek = 7;
static LECPlayerPlayOperation LECPlayerPlayOperationSwitch = 8;

typedef NS_ENUM(int, LECDeviceOrientation) {
    LECDeviceOrientationPortrait,
    LECDeviceOrientationPortraitUpsideDown,
    LECDeviceOrientationLandscapeLeft,
    LECDeviceOrientationLandscapeRight
};

//enum播放状态
typedef NS_ENUM(int, LECPlayerPlayEvent) {
    LECPlayerPlayEventPrepareDone = 0,
    LECPlayerPlayEventEOS = 1,
    LECPlayerPlayEventGetVideoSize,
    LECPlayerPlayEventRenderFirstPic,
    LECPlayerPlayEventBufferStart,
    LECPlayerPlayEventBufferEnd,
    LECPlayerPlayEventSeekComplete,
    LECPlayerPlayEventNoStream = 100,
    LECPlayerPlayEventPlayError
};

typedef NS_ENUM(int, LECPlayerPlayStatus) {
    LECPlayerPlayStatusUnInit = 0,
    LECPlayerPlayStatusInit = 1,
    LECPlayerPlayStatusPrepared = 2,
    LECPlayerPlayStatusPlaying = 3,
    LECPlayerPlayStatusPaused = 4,
    LECPlayerPlayStatusStoped = 5,
    LECPlayerPlayStatusEOS = 6,
    LECPlayerPlayStatusError = 7
};

typedef NS_ENUM(int, LECPlayerContentType) {
    LECPlayerContentTypeUnknow = 0,     //未初始化等
    LECPlayerContentTypeAdv = 1,        //广告
    LECPlayerContentTypeFeature = 2     //正片
};

@protocol LECPlayerDelegate <NSObject>

@optional

/*内容类型变换回调*/
- (void) lecPlayer:(LECPlayer *) player contentTypeChanged:(LECPlayerContentType) contentType;

/*播放器播放状态*/
- (void) lecPlayer:(LECPlayer *) player
       playerEvent:(LECPlayerPlayEvent) playerEvent;

/*播放器播放时间回调*/
- (void) lecPlayer:(LECPlayer *) player
          position:(int64_t) position
     cacheDuration:(int64_t) cacheDuration
          duration:(int64_t) duration;

@end

@protocol LECPlayerDatasource <NSObject>

@optional
- (BOOL) needDisableIdleTimeWhenFinishPlayerWithPlayer:(LECPlayer *) player;

@end

@interface LECPlayer : NSObject

/* 异步方法需要等待block回调后才能进行其他操作 */
- (BOOL) registerWithURLString:(NSString *) urlString completion:(void (^)(BOOL result))completion;                         //async
- (BOOL) unregister;                                                                                                        //sync
- (BOOL) prepare;                                                                                                           //async
- (BOOL) play;                                                                                                              //async
- (BOOL) pause;                                                                                                             //sync
- (BOOL) resume;                                                                                                            //sync
- (BOOL) stop;                                                                                                              //async
- (BOOL) seekToPosition:(NSInteger) position;                                                                               //async
- (BOOL) switchSelectStreamRateItem:(LCStreamRateItem *) selectStreamRateItem;                                              //async
- (BOOL) canDoOperation:(LECPlayerPlayOperation) playOperation;

//completionblock代表操作结束，可继续别的操作；该返回并不代表操作结果成功，播放状态需要根据回调决定
- (BOOL) prepareWithCompletion:(void (^)(BOOL))completion;                                                                  //async
- (BOOL) playWithCompletion:(void (^)())completion;                                                                         //async
- (BOOL) seekToPosition:(NSInteger) position completion:(void (^)())completion;                                             //async
- (BOOL) switchSelectStreamRateItem:(LCStreamRateItem *) selectStreamRateItem completion:(void (^)())completion;            //async
- (BOOL) stopWithCompletion:(void (^)())completion;                                                                         //async; stop为异步方法，如果stop后需要立即进行其他播放操作，可新建player示例

@property (nonatomic, readonly) UIView *videoView;
@property (nonatomic, assign) float volume;
@property (nonatomic, readonly) float actualVideoWidth;
@property (nonatomic, readonly) float actualVideoHeight;
@property (nonatomic, readonly) NSArray *streamRatesList;
@property (nonatomic, readonly) LCStreamRateItem *selectedStreamRateItem;
@property (nonatomic, readonly) NSString *errorCode;
@property (nonatomic, readonly) __block NSString *errorDescription;
@property (nonatomic, readonly) NSString *readableErrorDescription;
@property (nonatomic, weak) id<LECPlayerDelegate> delegate;
@property (nonatomic, weak) id<LECPlayerDatasource> datasource;
@property (nonatomic, readonly) int64_t position;
@property (nonatomic, readonly) int64_t duration;
@property (nonatomic, readonly) LECPlayerPlayStatus playStatus;
@property (nonatomic, readonly) LECPlayerContentType contentType;
@property (nonatomic, readonly) BOOL isPanorama;
@property (nonatomic, assign) LECDeviceOrientation lecOrientation;     //设备方向，影响全景视频陀螺仪
@property (nonatomic, assign) float startPlayCacheDuration;     //起播缓冲duration，prepare前设置有效，0将采用默认值
@property (nonatomic, assign) float startBufferCacheDuration;   //开始缓冲duration，prepare前设置有效，0将采用默认值
@property (nonatomic, assign) float endBufferCacheDuration;     //结束缓冲duration，prepare前设置有效，0将采用默认值
@property (nonatomic, assign) float maxDelayDuration;           //直播时有效，大于该值的缓冲区数据会被丢弃，prepare前设置有效，0将采用默认值
@property (nonatomic, assign) float maxCacheDuration;           //最大缓冲区duration，prepare前设置有效，0将采用默认值

@end
