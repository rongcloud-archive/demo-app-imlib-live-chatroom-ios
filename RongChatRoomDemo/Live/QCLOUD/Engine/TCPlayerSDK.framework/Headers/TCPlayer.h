//
//  TCPlayer.h
//  TCPlayer
//
//  Created by  on 15/8/14.
//  Copyright (c) 2015年 . All rights reserved.
//

#ifndef TCPlayer_TCPlayer_h
#define TCPlayer_TCPlayer_h

#import <UIKit/UIKit.h>


@protocol TCPlayerEngine;

typedef NS_ENUM(int, TCPlayerErrorType)
{
    TCPlayerError_UnKnowError,               // 未知错误
    TCPlayerError_MediaFormat_Error,         // 格式错误
    TCPlayerError_BufferingTimerOut,         // 缓冲超时
    TCPlayerError_Unsupport,                 // 不支持格式
//    TCPlayerError_PlayerTimeOut,             // 开始时，准备时间过长
//    TCPlayerError_LimitTime,                 // 播放到限制时间
};


// 播放器状态
typedef NS_ENUM(int, TCPlayerState)
{
    TCPlayerState_Init,                          // 初始化
    TCPlayerState_Preparing,                     // 准备阶段(初次播放时，至状态变为TCPlayerState_Play可理解为首次播放缓冲)
    TCPlayerState_Buffering,                     // 缓冲(特指播放过程中出现缓冲)
    TCPlayerState_Play,                          // 播放
    TCPlayerState_Pause,                         // 暂停
    TCPlayerState_PauseByLimitTime,              // 限时暂停
    TCPlayerState_Stop,                          // 停止
};

// 播放器内部网络状态
typedef NS_ENUM(int, TCPlayerNetworkState)
{
    TCPlayerNetwork_NotReachable,                // 无网络
    TCPlayerNetwork_WWAN,                        // 移动网络
    TCPlayerNetwork_WIFI,                        // WIFI
};




@protocol TCPlayerEngineDelegate <NSObject>

@optional

// 开始缓冲
// 传入的地址格式正确，可以播放
// 播放过程中出现缓冲也会回调到
- (void)onWillBuffering:(id<TCPlayerEngine>)play;

// 初步检查资源成功，准备渲染
// 播放器创建成功，内部使用，外部可不关心此回调，等同于onWillBuffering
- (void)onCheckResourceSucc:(id<TCPlayerEngine>)play;

// 缓冲进度回调
- (void)onBuffering:(id<TCPlayerEngine>)play progress:(CGFloat)progress;

// 准备资源失败
- (void)onPlayerFailed:(id<TCPlayerEngine>)player errorType:(TCPlayerErrorType)errType;

// 缓冲结束即将播放回调
// 设置图片，时长，当前播时间（0）
// 返回: YES, 首次缓冲完成后继续播放缓冲
- (BOOL)onWillPlay:(id<TCPlayerEngine>)player;

// 回调当前播放时间
- (void)onCurrentTime:(id<TCPlayerEngine>)player time:(NSInteger)time;

// 作播放完成（播放到结束位置，中途切换不会回调）逻辑，
- (void)onPlayOver:(id<TCPlayerEngine>)player;

// 播放器状态改变
- (void)onStateChanged:(id<TCPlayerEngine>)player toState:(TCPlayerState)state;

// 播放器网络状态改变
- (void)onNetworkStateChanged:(id<TCPlayerEngine>)player toState:(TCPlayerNetworkState)state;

@end


/**
 * 提供播放器可供操作的接口
 */

@protocol TCPlayerEngine <NSObject>

@property (nonatomic, weak) id<TCPlayerEngineDelegate> playerDelegate;

// 播放状态
// 内部状态机制，外部不要去更新
@property (nonatomic, assign) TCPlayerState state;

// 当前播放视频信息
- (id<TCCanPlayAble>)playingItem;

// 播放歌曲
- (void)play:(id<TCCanPlayAble>)item;

// 从第startSeconds处开始播放
- (void)play:(id<TCCanPlayAble>)item from:(NSInteger)startSeconds;

// 暂停
- (void)pause;

// 限时暂停
- (void)pauseByLimitTime;

// 停止
- (void)stop;

// 停止并释放
- (void)stopAndRelease;

// 恢复播放
- (void)play;

// 播放或暂停
- (void)playOrPause;

// 是否在播放
- (BOOL)isPlaying;

// 是否正在缓冲
- (BOOL)isBuffering;

// 是否播放过程中出现缓冲
- (BOOL)isBufferingWhenPlay;

// 是否因限制时间到而暂停
- (BOOL)isPausedByLimitTime;

// 是否暂停 state 为TCPlayerState_Pause或TCPlayerState_PauseByLimitTime
- (BOOL)isPaused;

// 是否停止
- (BOOL)isStoped;

// 跳至具体时间
- (void)startSeek;

// 跳到time处，不处理是否播放
- (void)seekToTime:(NSInteger)time;

// 跳到time处，会继续播放
- (void)seekToTime:(NSInteger)time completion:(void(^)())completion;

- (void)stopSeek:(NSInteger)time;

// 当前播放时间
- (NSInteger)currentTime;

// 播放时长
- (NSInteger)duration;


@end


#endif
