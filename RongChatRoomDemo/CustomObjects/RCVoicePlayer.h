//
//  RCVoicePlayer.h
//  RongIMKit
//
//  Created by xugang on 15/1/22.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMLib/RongIMLib.h>

@protocol RCVoicePlayerObserver;

@interface RCVoicePlayer : NSObject

@property(nonatomic, readonly) BOOL isPlaying;
@property(nonatomic, assign) long messageId;
@property(nonatomic, assign) RCConversationType conversationType;
@property(nonatomic, strong) NSString *targetId;

+ (RCVoicePlayer *)defaultPlayer;
//- (BOOL)playVoice:(NSString *)messageId voiceData:(NSData *)data observer:(id<RCVoicePlayerObserver>)observer;
- (BOOL)playVoice:(RCConversationType)conversationType
         targetId:(NSString *)targetId
        messageId:(long)messageId
        direction:(RCMessageDirection)messageDirection
        voiceData:(NSData *)data
         observer:(id<RCVoicePlayerObserver>)observer;

- (void)stopPlayVoice;

@end

@protocol RCVoicePlayerObserver <NSObject>

- (void)PlayerDidFinishPlaying:(BOOL)isFinish;

- (void)audioPlayerDecodeErrorDidOccur:(NSError *)error;

@end