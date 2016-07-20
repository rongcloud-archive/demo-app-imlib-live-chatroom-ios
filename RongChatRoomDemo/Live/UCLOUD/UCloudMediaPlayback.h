/*
 * UCloudPlayback.h
 *
 */

#import <Foundation/Foundation.h>
#import "UCloudPlayback.h"

@protocol UCloudMediaPlayback;


#pragma mark UCloudMediaPlayback

@protocol UCloudMediaPlayback <UCloudPlayback>

#pragma mark Notifications

/**
 *  点击返回按钮
 */
UCLOUD_EXTERN NSString *const UCloudMoviePlayerClickBack;

/**
 *  跳转进度完成
 */
UCLOUD_EXTERN NSString *const UCloudMoviePlayerSeekCompleted;

/**
 *  缓冲进度变更
 */
UCLOUD_EXTERN NSString *const UCloudMoviePlayerBufferingUpdate;

/**
 *  播放器所在的视图控制器旋转完成的时候发布这个通知
 */
UCLOUD_EXTERN NSString *const UCloudViewControllerDidRotate;

/**
 *  播放器所在的视图控制器将要旋转的时候发布这个通知
 */
UCLOUD_EXTERN NSString *const UCloudViewControllerWillRotate;

@end
