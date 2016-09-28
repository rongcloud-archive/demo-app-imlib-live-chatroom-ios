//
//  TCBasePlayerEngine.h
//  TCPlayerDemo
//
//  Created by  on 15/8/14.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TCPlayer.h"
@interface TCBasePlayerEngine : NSObject<TCPlayerEngine>
{
@protected
    TCPlayerState               _state;         // 播放器状态
    NSInteger                   _currentTime;   // 当前已播放时间
    NSInteger                   _duration;      // 播放时长
    id<TCCanPlayAble>          _playingItem;
    __weak id<TCPlayerEngineDelegate> _playerDelegate;
}


@property (nonatomic, readonly)     NSInteger currentTime;
@property (nonatomic, readonly)     NSInteger duration;
@property (nonatomic, weak)         id<TCPlayerEngineDelegate> playerDelegate;
@property (nonatomic, assign)       TCPlayerState state;
@property (nonatomic, readonly)     id<TCCanPlayAble> playingItem;

@end
