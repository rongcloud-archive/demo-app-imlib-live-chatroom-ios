//
//  RCVoicePlayer.m
//  RongIMKit
//
//  Created by xugang on 15/1/22.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCVoicePlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <UIKit/UIKit.h>
#import "RCKitCommonDefine.h"

static BOOL bSensorStateStart = YES;
static RCVoicePlayer *rcVoicePlayerHandler = nil;

@interface RCVoicePlayer () <AVAudioPlayerDelegate>

@property(nonatomic, strong) AVAudioPlayer *audioPlayer;
@property(nonatomic) BOOL isPlaying;
@property(nonatomic, weak) id<RCVoicePlayerObserver> voicePlayerObserver;
@property(nonatomic) RCMessageDirection messageDirection;
- (void)enableProximityMonitoring;
- (void)setDefaultAudioSession;
- (void)disableProximityMonitoring;
- (BOOL)startPlayVoice:(NSData *)data;
@end

@implementation RCVoicePlayer

+ (RCVoicePlayer *)defaultPlayer {
    @synchronized(self) {
        if (nil == rcVoicePlayerHandler) {
            rcVoicePlayerHandler = [[[self class] alloc] init];
            [rcVoicePlayerHandler setDefaultAudioSession];
        }
    }
    return rcVoicePlayerHandler;
}
- (void)setDefaultAudioSession {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
}

//处理监听触发事件

- (void)sensorStateChange:(NSNotification *)notification {
    if (bSensorStateStart) {
        bSensorStateStart = NO;

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[UIDevice currentDevice] proximityState] == YES) {
                DebugLog(@"[RongIMKit]: Device is close to user");
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
            } else {
                DebugLog(@"[RongIMKit]: Device is not close to user");
                
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            }
            bSensorStateStart = YES;
        });
    }
}

- (BOOL)playVoice:(RCConversationType)conversationType
         targetId:(NSString *)targetId
        messageId:(long)messageId
        direction:(RCMessageDirection)messageDirection
        voiceData:(NSData *)data
         observer:(id<RCVoicePlayerObserver>)observer {
    self.voicePlayerObserver = observer;
    self.messageId = messageId;
    self.conversationType = conversationType;
    self.targetId = targetId;
    [self enableProximityMonitoring];
//    [self setDefaultAudioSession];
    self.messageDirection = messageDirection;
    return [self startPlayVoice:data];
}

//停止播放
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    DebugLog(@"%s", __FUNCTION__);

    self.isPlaying = self.audioPlayer.playing;
    [self disableProximityMonitoring];

    // notify at the end
    if ([self.voicePlayerObserver respondsToSelector:@selector(PlayerDidFinishPlaying:)]) {
        [self.voicePlayerObserver PlayerDidFinishPlaying:flag];
    }

    // set the observer to nil
    self.voicePlayerObserver = nil;
    self.audioPlayer = nil;
    [[AVAudioSession sharedInstance] setActive:NO
                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                         error:nil];
    
    if (self.messageDirection == MessageDirection_RECEIVE
        && [RCIMClient sharedRCIMClient].sdkRunningMode == RCSDKRunningMode_Foregroud) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"kRCPlayVoiceFinishNotification"
             object:@(self.messageId)
             userInfo:@{@"conversationType":@(self.conversationType),
                        @"targetId":self.targetId}];
        });
    }
    
}

//播放错误
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error;
{
    DebugLog(@"%s", __FUNCTION__);

    // do something
    self.isPlaying = self.audioPlayer.playing;
    [self disableProximityMonitoring];

    // notify at the end
    if ([self.voicePlayerObserver respondsToSelector:@selector(audioPlayerDecodeErrorDidOccur:)]) {
        [self.voicePlayerObserver audioPlayerDecodeErrorDidOccur:error];
    }
    self.voicePlayerObserver = nil;
    self.audioPlayer = nil;
    [[AVAudioSession sharedInstance] setActive:NO
                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                         error:nil];
}

- (BOOL)startPlayVoice:(NSData *)data {
    NSError *error = nil;

    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
    self.audioPlayer.delegate = self;
    self.audioPlayer.volume = 1.0;

    BOOL ready = NO;
    if (!error) {

        DebugLog(@"[RongIMKit]: init AudioPlayer %@", error);

        ready = [self.audioPlayer prepareToPlay];
        DebugLog(@"[RongIMKit]: prepare audio player %@", ready ? @"success" : @"failed");
        ready = [self.audioPlayer play];
        DebugLog(@"[RongIMKit]: async play is %@", ready ? @"success" : @"failed");
    }
    self.isPlaying = self.audioPlayer.playing;
    DebugLog(@"self.isPlaying > %d", self.isPlaying);

    return ready;
}

- (void)stopPlayVoice {
    if (nil != self.audioPlayer && self.audioPlayer.playing) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;

        [self disableProximityMonitoring];
    }
    self.messageId = -1;
    self.isPlaying = self.audioPlayer.playing;
    self.voicePlayerObserver = nil;
    [[AVAudioSession sharedInstance] setActive:NO
                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                         error:nil];
    
    

}
- (void)enableProximityMonitoring {
    [[UIDevice currentDevice]
        setProximityMonitoringEnabled:YES]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceProximityStateDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sensorStateChange:)
                                                 name:UIDeviceProximityStateDidChangeNotification
                                               object:nil];
}
- (void)disableProximityMonitoring {
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        if(!self.isPlaying){
            [self setDefaultAudioSession];
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:UIDeviceProximityStateDidChangeNotification
                                                          object:nil];
        }
    });
 
}

@end
