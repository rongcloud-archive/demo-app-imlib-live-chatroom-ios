//
//  RongUIKit.m
//  RongIMKit
//
//  Created by xugang on 15/1/13.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCIM.h"
#import "RCKitUtility.h"
#import "RCLocalNotification.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>

#import <RongIMLib/RongIMLib.h>


NSString *const RCKitDispatchMessageNotification = @"RCKitDispatchMessageNotification";
NSString *const RCKitDispatchTypingMessageNotification = @"RCKitDispatchTypingMessageNotification";
NSString *const RCKitSendingMessageNotification = @"RCKitSendingMessageNotification";
NSString *const RCKitDispatchConnectionStatusChangedNotification = @"RCKitDispatchConnectionStatusChangedNotification";

@interface RCIM () <RCIMClientReceiveMessageDelegate, RCConnectionStatusChangeDelegate>
@property(nonatomic, strong) NSString *appKey;
@property(nonatomic, assign) SystemSoundID soundId;

@end

dispatch_queue_t __rc__conversationList_refresh_queue = NULL;

static RCIM *__rongUIKit = nil;
@implementation RCIM

+ (instancetype)sharedRCIM {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      if (__rongUIKit == nil) {
          __rongUIKit = [[RCIM alloc] init];
          __rc__conversationList_refresh_queue = dispatch_queue_create("com.rongcloud.refreshConversationList", NULL);
          __rongUIKit.globalMessagePortraitSize = CGSizeMake(46, 46);
          __rongUIKit.globalConversationPortraitSize = CGSizeMake(46, 46);
          __rongUIKit.globalNavigationBarTintColor=[UIColor whiteColor];
          __rongUIKit.portraitImageViewCornerRadius = 4;
          __rongUIKit.maxVoiceDuration = 60;
      }
    });
    return __rongUIKit;
}

- (void)setGlobalMessagePortraitSize:(CGSize)globalMessagePortraitSize {
    CGFloat width = globalMessagePortraitSize.width;
    CGFloat height = globalMessagePortraitSize.height;

    _globalMessagePortraitSize.width = width;
    _globalMessagePortraitSize.height = height;
}
- (void)setGlobalConversationPortraitSize:(CGSize)globalConversationPortraitSize {
    CGFloat width = globalConversationPortraitSize.width;
    CGFloat height = globalConversationPortraitSize.height;
    if (height < 36.0f) {
        height = 36.0f;
    }

    _globalConversationPortraitSize.width = width;
    _globalConversationPortraitSize.height = height;
}

- (void)setCurrentUserInfo:(RCUserInfo *)currentUserInfo {
    
    [[RCIMClient sharedRCIMClient] setCurrentUserInfo:currentUserInfo];
}
- (RCUserInfo *)currentUserInfo {
    return [[RCIMClient sharedRCIMClient] currentUserInfo];
}
- (void)initWithAppKey:(NSString *)appKey {
    if ([self.appKey isEqual:appKey]) {
        NSLog(@"Warning:请不要重复调用Init！！！");
        return;
    }
    
    self.appKey = appKey;
    [[RCIMClient sharedRCIMClient] init:appKey];
    // listen receive message
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
    [[RCIMClient sharedRCIMClient] setRCConnectionStatusChangeDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}
- (void)appEnterBackground
{ 
}

- (void)registerMessageType:(Class)messageClass {
    [[RCIMClient sharedRCIMClient] registerMessageType:messageClass];
}
- (void)connectWithToken:(NSString *)token
                 success:(void (^)(NSString *userId))successBlock
                   error:(void (^)(RCConnectErrorCode status))errorBlock
          tokenIncorrect:(void (^)())tokenIncorrectBlock {

    [[RCIMClient sharedRCIMClient] connectWithToken:token
        success:^(NSString *userId) {
            if (successBlock!=nil) {
                successBlock(userId);
            }
        }
        error:^(RCConnectErrorCode status) {
            if(errorBlock!=nil)
                errorBlock(status);
        }
        tokenIncorrect:^() {
          tokenIncorrectBlock();
        }];
}

/**
 *  断开连接。
 *
 *  @param isReceivePush 是否接收回调。
 */
- (void)disconnect:(BOOL)isReceivePush {
    [[RCIMClient sharedRCIMClient] disconnect:isReceivePush];
}

/**
 *  断开连接。
 */
- (void)disconnect {
    [[RCIMClient sharedRCIMClient] disconnect];
}

/**
 *  Log out。不会接收到push消息。
 */
- (void)logout {
    [[RCIMClient sharedRCIMClient] logout];
}


- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object {
    
    NSDictionary *dic_left = @{ @"left" : @(nLeft) };
    // dispatch message
    [[NSNotificationCenter defaultCenter] postNotificationName:RCKitDispatchMessageNotification
                                                            object:message
                                                          userInfo:dic_left];
    
    //收到消息时播放提示音
    if(nLeft == 0){
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        
        NSError *err = nil;
        [audioSession setCategory:AVAudioSessionCategoryAmbient  error:&err];
        
    #if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
        //是否扬声器播放
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    #else
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    #endif
        
        [audioSession setActive:YES error:&err];
        
        if (nil != err) {
            NSLog(@"[RongIMKit]: Exception is thrown when setting audio session");
            return;
        }
        NSString *soundFilePath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"RongCloud.bundle"]
                              stringByAppendingPathComponent:@"sms-received.caf"];
        
        OSStatus error =
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundFilePath], &_soundId);
        if (error != kAudioServicesNoError) { //获取的声音的时候，出现错误
            NSLog(@"[RongIMKit]: Exception is thrown when creating system sound ID");
            return;
        }
        
        
        if ([[[UIDevice currentDevice] systemVersion]  floatValue] >= 9) {
            AudioServicesPlaySystemSoundWithCompletion(_soundId, ^{
                
            });
        } else {
            AudioServicesPlaySystemSound(_soundId);
            AudioServicesAddSystemSoundCompletion (_soundId, NULL, NULL, playSoundEnd, NULL);
        }
    //如果app正在播放视频或者音频，不要调用 setActivce ：NO，这样会中断音频，如果没有播放声音，建议调用这样播放完消息提示音之后会恢复后台播放的音乐
//        [[AVAudioSession sharedInstance] setActive:NO
//                                       withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
//                                             error:nil];
    }
}
static void playSoundEnd(SystemSoundID mySSID, void *myself) {
    AudioServicesRemoveSystemSoundCompletion (mySSID);
    AudioServicesDisposeSystemSoundID(mySSID);
    
}

/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onConnectionStatusChanged:(RCConnectionStatus)status {
    if (/*ConnectionStatus_NETWORK_UNAVAILABLE != status && */ConnectionStatus_UNKNOWN != status &&
        ConnectionStatus_Unconnected != status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RCKitDispatchConnectionStatusChangedNotification
                                                        object:[NSNumber numberWithInt:status]];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(delayNotifyUnConnectedStatus) withObject:nil afterDelay:3];
        });
    }
}

/*!
 获取当前SDK的连接状态
 
 @return 当前SDK的连接状态
 */
- (RCConnectionStatus)getConnectionStatus {
    return [[RCIMClient sharedRCIMClient] getConnectionStatus];
}

- (void)delayNotifyUnConnectedStatus {
    RCConnectionStatus status = [[RCIMClient sharedRCIMClient] getConnectionStatus];
    if (ConnectionStatus_NETWORK_UNAVAILABLE == status || ConnectionStatus_UNKNOWN == status ||
        ConnectionStatus_Unconnected == status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RCKitDispatchConnectionStatusChangedNotification
                                                            object:[NSNumber numberWithInt:status]];
    }
}

- (RCMessage *)sendMessage:(RCConversationType)conversationType
                  targetId:(NSString *)targetId
                   content:(RCMessageContent *)content
               pushContent:(NSString *)pushContent
                  pushData:(NSString *)pushData
                   success:(void (^)(long messageId))successBlock
                     error:(void (^)(RCErrorCode nErrorCode,
                                     long messageId))errorBlock {
    RCMessage *rcMessage = [[RCIMClient sharedRCIMClient]
                            sendMessage:conversationType
                            targetId:targetId
                            content:content
                            pushContent:pushContent
                            pushData:pushData
                            success:^(long messageId) {
                                NSDictionary *statusDic = @{@"targetId":targetId,
                                                            @"conversationType":@(conversationType),
                                                            @"messageId": @(messageId),
                                                            @"sentStatus": @(SentStatus_SENT),
                                                            @"content":content};
                                [[NSNotificationCenter defaultCenter]
                                 postNotificationName:RCKitSendingMessageNotification
                                 object:nil
                                 userInfo:statusDic];
                                
                                successBlock(messageId);
                            } error:^(RCErrorCode nErrorCode, long messageId) {
                                NSDictionary *statusDic = @{@"targetId":targetId,
                                                            @"conversationType":@(conversationType),
                                                            @"messageId": @(messageId),
                                                            @"sentStatus": @(SentStatus_FAILED),
                                                            @"error": @(nErrorCode),
                                                            @"content":content};
                                [[NSNotificationCenter defaultCenter]
                                 postNotificationName:RCKitSendingMessageNotification
                                 object:nil
                                 userInfo:statusDic];
                                
                                errorBlock(nErrorCode,messageId);
                            }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RCKitSendingMessageNotification
                                                        object:rcMessage
                                                      userInfo:nil];
    return rcMessage;
}

- (RCMessage *)sendImageMessage:(RCConversationType)conversationType
                       targetId:(NSString *)targetId
                        content:(RCMessageContent *)content
                    pushContent:(NSString *)pushContent
                       pushData:(NSString *)pushData
                       progress:(void (^)(int progress, long messageId))progressBlock
                        success:(void (^)(long messageId))successBlock
                          error:(void (^)(RCErrorCode errorCode, long messageId))errorBlock {
    RCMessage *rcMessage = [[RCIMClient sharedRCIMClient]
                            sendImageMessage:conversationType
                            targetId:targetId
                            content:content
                            pushContent:pushContent
                            pushData:pushData
                            progress:^(int progress, long messageId) {
                                NSDictionary *statusDic = @{@"targetId":targetId,
                                                            @"conversationType":@(conversationType),
                                                            @"messageId": @(messageId),
                                                            @"sentStatus": @(SentStatus_SENDING),
                                                            @"progress": @(progress)};
                                [[NSNotificationCenter defaultCenter]
                                 postNotificationName:RCKitSendingMessageNotification
                                 object:nil
                                 userInfo:statusDic];
                                
                                progressBlock(progress, messageId);
                            } success:^(long messageId) {
                                NSDictionary *statusDic = @{@"targetId":targetId,
                                                            @"conversationType":@(conversationType),
                                                            @"messageId": @(messageId),
                                                            @"sentStatus": @(SentStatus_SENT),
                                                            @"content":content};
                                [[NSNotificationCenter defaultCenter]
                                 postNotificationName:RCKitSendingMessageNotification
                                 object:nil
                                 userInfo:statusDic];
                                
                                successBlock(messageId);
                            } error:^(RCErrorCode errorCode, long messageId) {
                                NSDictionary *statusDic = @{@"targetId":targetId,
                                                            @"conversationType":@(conversationType),
                                                            @"messageId": @(messageId),
                                                            @"sentStatus": @(SentStatus_FAILED),
                                                            @"error": @(errorCode),
                                                            @"content":content};
                                [[NSNotificationCenter defaultCenter]
                                 postNotificationName:RCKitSendingMessageNotification
                                 object:nil
                                 userInfo:statusDic];
                                
                                errorBlock(errorCode, messageId);
                            }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RCKitSendingMessageNotification
                                                        object:rcMessage
                                                      userInfo:nil];
    
    return rcMessage;
}
- (void)setMaxVoiceDuration:(NSUInteger)maxVoiceDuration {
    if (maxVoiceDuration < 5 || maxVoiceDuration > 60) {
        return;
    }
    _maxVoiceDuration = maxVoiceDuration;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}
@end
