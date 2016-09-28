//
//  TCVideoPlayer.h
//  TCPlayerDemo
//
//  Created by  on 15/8/14.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "TCBasePlayerEngine.h"
#import <AVFoundation/AVFoundation.h>

@interface TCVideoPlayer : TCBasePlayerEngine
{
@private
    AVPlayer            *_avPlayer;
    AVPlayerItem        *_mplayerItem;
    id                  _mTimeObserver;
    float               _playRate;
    NSTimer             *_outTimer;
}

@property (nonatomic, readonly) AVPlayer *avPlayer;


// 当前 _currentTime ＋ willBufferingTime > _loadingTime，会提求播放过程中出现缓冲
// 默认10s
@property (nonatomic, assign) NSInteger willBufferingTimeInterval;

// 对于非HLS资源默认不缓存，默认YES
// 下次播放有效
@property (nonatomic, assign) BOOL enableCache;

// 是否允许上报，默认YES
// 
@property (nonatomic, assign) BOOL enableReport;

// 是否静音播放，默认不静音播放
@property(nonatomic, assign) BOOL isSilent;

// 是否循环播放，默认不循环播放
@property(nonatomic, assign) BOOL isCyclePlay;

// 是否清空缓存，默认清空
// 当enableCache = YES时，是事清除掉本次播放过程中产生的Cahce文件
@property(nonatomic, assign) BOOL clearPlayCache;

// 清除所有的播放缓存
+ (void)clearAllPlayCache;

// 播放本地视频不上报网络状态变化
// 打开网络监听
- (void)enableNetworkMonitoring;
// 关闭网络监听
- (void)disableNetworkMonitoring;

#ifdef DEBUG
- (void)testResumeLoad;
- (void)testStopLoad;
#endif
@end
