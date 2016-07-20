/*
 * UCloudPlayback.h
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@protocol UCloudPlayback;


#pragma mark UCloudPlayback

@protocol UCloudPlayback <NSObject>

/**
 *  视频画面
 */
@property(nonatomic, readonly)  UIView *view;

/**
 *  当前播放的位置
 */
@property(assign, nonatomic) NSTimeInterval currentPlaybackTime;

/**
 *  视频总时间
 */
@property(nonatomic, readonly)  NSTimeInterval duration;

/**
 *  媒体可播放时长，主要用于表示网络媒体已下载视频时长
 */
@property(nonatomic, readonly)  NSTimeInterval playableDuration;

/**
 *  缓冲进度
 */
@property(nonatomic, readonly)  NSInteger bufferingProgress;

/**
 *  是否准备好播放
 */
@property(nonatomic, readonly)  BOOL isPreparedToPlay;

/**
 *  媒体播放状态
 */
@property(nonatomic, readonly)  MPMoviePlaybackState playbackState;

/**
 *  网络媒体加载状态
 */
@property(nonatomic, readonly)  MPMovieLoadState loadState;


@property(nonatomic, readonly) int64_t numberOfBytesTransferred;

/**
 *  控制面板风格，枚举类型：
 */
@property(assign, nonatomic) MPMovieControlStyle controlStyle;

/**
 *  视频缩放填充模式，枚举类型：
 */
@property(assign, nonatomic) MPMovieScalingMode scalingMode;

/**
 *  是否自动播放
 */
@property(assign, nonatomic) BOOL shouldAutoplay;

/**
 *  是否允许通过AirPlay播放
 */
@property (assign, nonatomic) BOOL allowsMediaAirPlay;

@property (assign, nonatomic) BOOL isDanmakuMediaAirPlay;

/**
 *  当前媒体是否正在通过AirPlay播放
 */
@property (nonatomic, readonly) BOOL airPlayMediaActive;

/**
 *  准备播放
 */
- (void)prepareToPlay;

/**
 *  播放
 */
- (void)play;

/**
 *  暂停
 */
- (void)pause;

/**
 *  停止
 */
- (void)stop;

/**
 *  播放状态
 */
- (BOOL)isPlaying;

/**
 *  关闭播放器
 */
- (void)shutdown;

/**
 *  进入后台自动暂停
 *
 *  @param pause 是否暂停
 */
- (void)setPauseInBackground:(BOOL)pause;

/**
 *  截图
 */
- (UIImage *)thumbnailImageAtCurrentTime;

#pragma mark Notifications

#ifdef __cplusplus
#define UCLOUD_EXTERN extern "C" __attribute__((visibility ("default")))
#else
#define UCLOUD_EXTERN extern __attribute__((visibility ("default")))
#endif

/**
 *  准备好播放
 */
UCLOUD_EXTERN NSString *const UCloudPlaybackIsPreparedToPlayDidChangeNotification;

/**
 *  开始播放时候的这种状态改变通知(object 是实现该代理的对象，取loadState得到状态)
 */
UCLOUD_EXTERN NSString *const UCloudPlayerLoadStateDidChangeNotification;

/**
 *  结束播放的各种状态改变通知
 *  userInfo:
 key                                                value
 MPMoviePlayerPlaybackDidFinishReasonUserInfoKey    MPMovieFinishReason
 error                                              NSError
 */
UCLOUD_EXTERN NSString *const UCloudPlayerPlaybackDidFinishNotification;
/**
 *  播放过程中的各种状态改变通知(object 是实现该代理的对象，取playbackState得到状态)
 */
UCLOUD_EXTERN NSString *const UCloudPlayerPlaybackStateDidChangeNotification;
/**
 *  KVO_AVPlayer_airplay
 */
UCLOUD_EXTERN NSString *const UCloudPlayerIsAirPlayVideoActiveDidChangeNotification;
/**
 *  底层开始解析视频
 */
UCLOUD_EXTERN NSString *const UCloudPlayerVideoDecoderOpenNotification;
/**
 *  直播推流端旋转方向
 */
UCLOUD_EXTERN NSString *const UCloudPlayerVideoChangeRotationNotification;
@end

#pragma mark UCloudMediaResource

@protocol UCloudMediaSegmentResolver <NSObject>

- (NSString *)urlOfSegment:(int)segmentPosition;

@end
