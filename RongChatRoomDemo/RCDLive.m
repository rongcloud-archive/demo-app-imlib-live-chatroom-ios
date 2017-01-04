//
//  RongUIKit.m
//  RongIMKit
//
//  Created by xugang on 15/1/13.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDLive.h"
#import "RCDLiveKitUtility.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>

//如果您的APP中只使用融云的底层通讯库 IMLib ，请把IsUseRongCloudIMKit 设置成 0，如果使用 IMKit 请设置成 1
#define IsUseRongCloudIMKit 0

NSString *const RCDLiveKitDispatchMessageNotification = @"RCDLiveKitDispatchMessageNotification";
NSString *const RCDLiveKitDispatchTypingMessageNotification = @"RCDLiveKitDispatchTypingMessageNotification";
NSString *const RCDLiveKitSendingMessageNotification = @"RCDLiveKitSendingMessageNotification";
NSString *const RCDLiveKitDispatchConnectionStatusChangedNotification = @"RCDLiveKitDispatchConnectionStatusChangedNotification";

//使用 IMKit 需要放开注释的地方
@interface RCDLive () <
#if !IsUseRongCloudIMKit
RCIMClientReceiveMessageDelegate, RCConnectionStatusChangeDelegate
#else
RCIMReceiveMessageDelegate, RCIMConnectionStatusDelegate
#endif
>
@property(nonatomic, strong) NSString *appKey;

@end

dispatch_queue_t __RCDLive_ConversationList_refresh_queue = NULL;

static RCDLive *__rongUIKit = nil;
@implementation RCDLive

+ (instancetype)sharedRCDLive {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      if (__rongUIKit == nil) {
          __rongUIKit = [[RCDLive alloc] init];
          __RCDLive_ConversationList_refresh_queue = dispatch_queue_create("com.rongcloud.refreshConversationList", NULL);
      }
    });
    return __rongUIKit;
}


- (void)setCurrentUserInfo:(RCUserInfo *)currentUserInfo {
    
    [[RCIMClient sharedRCIMClient] setCurrentUserInfo:currentUserInfo];
}
- (RCUserInfo *)currentUserInfo {
    return [[RCIMClient sharedRCIMClient] currentUserInfo];
}
- (void)initRongCloud:(NSString *)appKey{
    if ([self.appKey isEqual:appKey]) {
        NSLog(@"Warning:请不要重复调用Init！！！");
        return;
    }
    
    self.appKey = appKey;
#if !IsUseRongCloudIMKit
  [[RCIMClient sharedRCIMClient] initWithAppKey:appKey];
  // listen receive message
  [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
  [[RCIMClient sharedRCIMClient] setRCConnectionStatusChangeDelegate:self];
# else
  [[RCIM sharedRCIM] initWithAppKey:appKey];
  [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
  [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
#endif
}

- (void)disconnectRongCloud{
  
}

- (void)registerRongCloudMessageType:(Class)messageClass {
    [[RCIMClient sharedRCIMClient] registerMessageType:messageClass];
}
- (void)connectRongCloudWithToken:(NSString *)token
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
- (void)disconnectRongCloud:(BOOL)isReceivePush {
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:nil object:nil];
    [[RCIMClient sharedRCIMClient] setRCConnectionStatusChangeDelegate:nil];
    [[RCIMClient sharedRCIMClient] disconnect:isReceivePush];
}

/**
 *  Log out。不会接收到push消息。
 */
- (void)logoutRongCloud {
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:nil object:nil];
    [[RCIMClient sharedRCIMClient] setRCConnectionStatusChangeDelegate:nil];
    [[RCIMClient sharedRCIMClient] logout];
}

#if !IsUseRongCloudIMKit
- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object {
    
    NSDictionary *dic_left = @{ @"left" : @(nLeft) };
    // dispatch message
    [[NSNotificationCenter defaultCenter] postNotificationName:RCDLiveKitDispatchMessageNotification
                                                            object:message
                                                          userInfo:dic_left];
    
}

#else

-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    NSDictionary *dic_left = @{ @"left" : @(left) };
    // dispatch message
    [[NSNotificationCenter defaultCenter] postNotificationName:RCDLiveKitDispatchMessageNotification
                                                        object:message
                                                      userInfo:dic_left];
}
#endif

#if !IsUseRongCloudIMKit
/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onConnectionStatusChanged:(RCConnectionStatus)status {
    if (/*ConnectionStatus_NETWORK_UNAVAILABLE != status && */ConnectionStatus_UNKNOWN != status &&
        ConnectionStatus_Unconnected != status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RCDLiveKitDispatchConnectionStatusChangedNotification
                                                        object:[NSNumber numberWithInt:status]];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(delayNotifyUnConnectedStatus) withObject:nil afterDelay:3];
        });
    }
}

#else


-(void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    if (/*ConnectionStatus_NETWORK_UNAVAILABLE != status && */ConnectionStatus_UNKNOWN != status &&
        ConnectionStatus_Unconnected != status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RCDLiveKitDispatchConnectionStatusChangedNotification
                                                            object:[NSNumber numberWithInt:status]];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(delayNotifyUnConnectedStatus) withObject:nil afterDelay:3];
        });
    }
}

#endif

/*!
 获取当前SDK的连接状态
 
 @return 当前SDK的连接状态
 */
- (RCConnectionStatus)getRongCloudConnectionStatus {
    return [[RCIMClient sharedRCIMClient] getConnectionStatus];
}

- (void)delayNotifyUnConnectedStatus {
    RCConnectionStatus status = [[RCIMClient sharedRCIMClient] getConnectionStatus];
    if (ConnectionStatus_NETWORK_UNAVAILABLE == status || ConnectionStatus_UNKNOWN == status ||
        ConnectionStatus_Unconnected == status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RCDLiveKitDispatchConnectionStatusChangedNotification
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
                                 postNotificationName:RCDLiveKitSendingMessageNotification
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
                                 postNotificationName:RCDLiveKitSendingMessageNotification
                                 object:nil
                                 userInfo:statusDic];
                                
                                errorBlock(nErrorCode,messageId);
                            }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RCDLiveKitSendingMessageNotification
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
                                 postNotificationName:RCDLiveKitSendingMessageNotification
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
                                 postNotificationName:RCDLiveKitSendingMessageNotification
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
                                 postNotificationName:RCDLiveKitSendingMessageNotification
                                 object:nil
                                 userInfo:statusDic];
                                
                                errorBlock(errorCode, messageId);
                            }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RCDLiveKitSendingMessageNotification
                                                        object:rcMessage
                                                      userInfo:nil];
    
    return rcMessage;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
