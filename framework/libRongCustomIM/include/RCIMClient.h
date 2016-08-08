/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RongIMClient.h
//  Created by xugang on 14/12/23.

#ifndef __RongIMClient
#define __RongIMClient
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "RCStatusDefine.h"
#import "RCMessage.h"
#import "RCUserInfo.h"
#import "RCWatchKitStatusDelegate.h"
#import "RCUploadImageStatusListener.h"
#import "RCConversation.h"
#import "RCChatRoomInfo.h"


#pragma mark - 消息接收监听器

/*!
 IMlib消息接收的监听器
 
 @discussion 设置IMLib的消息接收监听器请参考RCIMClient的setReceiveMessageDelegate:object:方法。
 
 @warning 如果您使用IMlib，可以设置并实现此Delegate监听消息接收；
 如果您使用IMKit，请使用RCIM中的RCIMReceiveMessageDelegate监听消息接收，而不要使用此监听器，否则会导致IMKit中无法自动更新UI！
 */
@protocol RCIMClientReceiveMessageDelegate <NSObject>

/*!
 接收消息的回调方法
 
 @param message     当前接收到的消息
 @param nLeft       还剩余的未接收的消息数，left>=0
 @param object      消息监听设置的key值
 
 @discussion 如果您设置了IMlib消息监听之后，SDK在接收到消息时候会执行此方法。
 其中，left为还剩余的、还未接收的消息数量。比如刚上线一口气收到多条消息时，通过此方法，您可以获取到每条消息，left会依次递减直到0。
 您可以根据left数量来优化您的App体验和性能，比如收到大量消息时等待left为0再刷新UI。
 object为您在设置消息接收监听时的key值。
 */
- (void)onReceived:(RCMessage *)message
              left:(int)nLeft
            object:(id)object;

@end

#pragma mark - 连接状态监听器

/*!
 IMLib连接状态的的监听器
 
 @discussion 设置IMLib的连接状态监听器，请参考RCIMClient的setRCConnectionStatusChangeDelegate:方法。
 
 @warning 如果您使用IMLib，可以设置并实现此Delegate监听消息接收；
 如果您使用IMKit，请使用RCIM中的RCIMConnectionStatusDelegate监听消息接收，而不要使用此监听器，否则会导致IMKit中无法自动更新UI！
 */
@protocol RCConnectionStatusChangeDelegate <NSObject>

/*!
 IMLib连接状态的的监听器
 
 @param status  SDK与融云服务器的连接状态
 
 @discussion 如果您设置了IMLib消息监听之后，当SDK与融云服务器的连接状态发生变化时，会回调此方法。
 */
- (void)onConnectionStatusChanged:(RCConnectionStatus)status;

@end

#pragma mark - IMLib核心类

/*!
 融云IMLib核心类
 
 @discussion 您需要通过sharedRCIMClient方法，获取单例对象。
 */
@interface RCIMClient : NSObject

/*!
 获取融云通讯能力库IMLib的核心类单例
 
 @return 融云通讯能力库IMLib的核心类单例
 
 @discussion 您可以通过此方法，获取IMLib的单例，访问对象中的属性和方法.
 */
+ (instancetype)sharedRCIMClient;

#pragma mark - SDK初始化

/*!
 初始化融云SDK
 
 @param appKey  从融云开发者平台创建应用后获取到的App Key
 
 @discussion 您在使用融云SDK所有功能(包括显示SDK中或者继承于SDK的View)之前，您必须先调用此方法初始化SDK。
 在App整个生命周期中，您只需要执行一次初始化。
 
 @warning 如果您使用IMLib，请使用此方法初始化SDK；
 如果您使用IMKit，请使用RCIM中的initWithAppKey:方法初始化，而不要使用此方法。
 
 **升级说明:**
 **从2.4.1版本开始，为了兼容Swift的风格与便于使用，将此方法升级为initWithAppKey:方法，方法的功能和使用均不变。**
 */
- (void)init:(NSString *)appKey;

/*!
 初始化融云SDK
 
 @param appKey  从融云开发者平台创建应用后获取到的App Key
 
 @discussion 您在使用融云SDK所有功能（包括显示SDK中或者继承于SDK的View）之前，您必须先调用此方法初始化SDK。
 在App整个生命周期中，您只需要执行一次初始化。
 
 **升级说明:**
 **从2.4.1版本开始，为了兼容Swift的风格与便于使用，将原有的init:方法升级为此方法，方法的功能和使用均不变。**
 
 @warning 如果您使用IMLib，请使用此方法初始化SDK；
 如果您使用IMKit，请使用RCIM中的同名方法初始化，而不要使用此方法。
 */
- (void)initWithAppKey:(NSString *)appKey;

/*!
 设置deviceToken，用于远程推送
 
 @param deviceToken     从系统获取到的设备号deviceToken(需要去掉空格和尖括号)
 
 @discussion deviceToken是系统提供的，从苹果服务器获取的，用于APNs远程推送必须使用的设备唯一值。
 您需要将-application:didRegisterForRemoteNotificationsWithDeviceToken:获取到的deviceToken，转为NSString类型，并去掉其中的空格和尖括号，作为参数传入此方法。
 
 如:

    - (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
        NSString *token = [deviceToken description];
        token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
        token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
        token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
        [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    }
 
 */
- (void)setDeviceToken:(NSString *)deviceToken;


- (void)setReceiveMessageDelegate:(id<RCIMClientReceiveMessageDelegate>)delegate
                           object:(id)userData;
#pragma mark - 连接与断开服务器

/*!
 与融云服务器建立连接
 
 @param token                   从您服务器端获取的token(用户身份令牌)
 @param successBlock            连接建立成功的回调 [userId:当前连接成功所用的用户ID]
 @param errorBlock              连接建立失败的回调 [status:连接失败的错误码]
 @param tokenIncorrectBlock     token错误或者过期的回调
 
 @discussion 在App整个生命周期，您只需要调用一次此方法与融云服务器建立连接。
 之后无论是网络出现异常或者App有前后台的切换等，SDK都会负责自动重连。
 除非您已经手动将连接断开，否则您不需要自己再手动重连。
 
 tokenIncorrectBlock有两种情况：
 一是token错误，请您检查客户端初始化使用的AppKey和您服务器获取token使用的AppKey是否一致；
 二是token过期，是因为您在开发者后台设置了token过期时间，您需要请求您的服务器重新获取token并再次用新的token建立连接。
 
 @warning 如果您使用IMLib，请使用此方法建立与融云服务器的连接；
 如果您使用IMKit，请使用RCIM中的同名方法建立与融云服务器的连接，而不要使用此方法。
 
 在tokenIncorrectBlock的情况下，您需要请求您的服务器重新获取token并建立连接，但是注意避免无限循环，以免影响App用户体验。
 
 此方法的回调并非为原调用线程，您如果需要进行UI操作，请注意切换到主线程。
 */
- (void)connectWithToken:(NSString *)token
                 success:(void (^)(NSString *userId))successBlock
                   error:(void (^)(RCConnectErrorCode status))errorBlock
          tokenIncorrect:(void (^)())tokenIncorrectBlock;

///*!
// 重新建立与服务器的连接
//
// @param successBlock 重新连接成功的回调
// @param errorBlock   重新连接失败的回调
//
// @warning 升级说明：从2.2.3版本开始，删除此方法。
// SDK在前后台切换或者网络出现异常都会自动重连，会保证连接的可靠性，不需要App手动进行重连操作。
// */
//- (void)reconnect:(void (^)(NSString *userId))successBlock
//            error:(void (^)(RCConnectErrorCode status))errorBlock;

/*!
 断开与融云服务器的连接
 
 @param isReceivePush   App在断开连接之后，是否还接收远程推送
 
 @discussion 因为SDK在前后台切换或者网络出现异常都会自动重连，会保证连接的可靠性。
 所以除非您的App逻辑需要登出，否则一般不需要调用此方法进行手动断开。
 
 @warning 如果您使用IMLib，请使用此方法断开与融云服务器的连接；
 如果您使用IMKit，请使用RCIM中的同名方法断开与融云服务器的连接，而不要使用此方法。
 
 isReceivePush指断开与融云服务器的连接之后，是否还接收远程推送。
 [[RCIMClient sharedRCIMClient] disconnect:YES]与[[RCIMClient sharedRCIMClient] disconnect]完全一致；
 [[RCIMClient sharedRCIMClient] disconnect:NO]与[[RCIMClient sharedRCIMClient] logout]完全一致。
 您只需要按照您的需求，使用disconnect:与disconnect以及logout三个接口其中一个即可。
 */
- (void)disconnect:(BOOL)isReceivePush;

/*!
 断开与融云服务器的连接，但仍然接收远程推送
 
 @discussion 因为SDK在前后台切换或者网络出现异常都会自动重连，会保证连接的可靠性。
 所以除非您的App逻辑需要登出，否则一般不需要调用此方法进行手动断开。
 
 @warning 如果您使用IMLib，请使用此方法断开与融云服务器的连接；
 如果您使用IMKit，请使用RCIM中的同名方法断开与融云服务器的连接，而不要使用此方法。
 
 [[RCIMClient sharedRCIMClient] disconnect:YES]与[[RCIMClient sharedRCIMClient] disconnect]完全一致；
 [[RCIMClient sharedRCIMClient] disconnect:NO]与[[RCIMClient sharedRCIMClient] logout]完全一致。
 您只需要按照您的需求，使用disconnect:与disconnect以及logout三个接口其中一个即可。
 */
- (void)disconnect;

/*!
 断开与融云服务器的连接，并不再接收远程推送
 
 @discussion 因为SDK在前后台切换或者网络出现异常都会自动重连，会保证连接的可靠性。
 所以除非您的App逻辑需要登出，否则一般不需要调用此方法进行手动断开。
 
 @warning 如果您使用IMKit，请使用此方法断开与融云服务器的连接；
 如果您使用IMLib，请使用RCIMClient中的同名方法断开与融云服务器的连接，而不要使用此方法。
 
 [[RCIMClient sharedRCIMClient] disconnect:YES]与[[RCIMClient sharedRCIMClient] disconnect]完全一致；
 [[RCIMClient sharedRCIMClient] disconnect:NO]与[[RCIMClient sharedRCIMClient] logout]完全一致。
 您只需要按照您的需求，使用disconnect:与disconnect以及logout三个接口其中一个即可。
 */
- (void)logout;

#pragma mark - 连接状态监听

/*!
 设置IMLib的连接状态监听器
 
 @param delegate    IMLib连接状态监听器
 
 @warning 如果您使用IMLib，可以设置并实现此Delegate监听消息接收；
 如果您使用IMKit，请使用RCIM中的connectionStatusDelegate监听连接状态变化，而不要使用此方法，否则会导致IMKit中无法自动更新UI！
 */
- (void)setRCConnectionStatusChangeDelegate: (id<RCConnectionStatusChangeDelegate>)delegate;

/*!
 获取当前SDK的连接状态
 
 @return 当前SDK的连接状态
 */
- (RCConnectionStatus)getConnectionStatus;

/*!
 获取当前的网络状态
 
 @return 当前的网路状态
 */
- (RCNetworkStatus)getCurrentNetworkStatus;

/*!
 SDK当前所处的运行状态
 */
@property(nonatomic, assign, readonly) RCSDKRunningMode sdkRunningMode;

#pragma mark - Apple Watch状态监听

/*!
 用于Apple Watch的IMLib事务监听器
 */
@property(nonatomic, strong) id<RCWatchKitStatusDelegate> watchKitStatusDelegate;

#pragma mark - 用户信息

/*!
 当前登录用户的用户信息
 
 @discussion 与融云服务器建立连接之后，应该设置当前用户的用户信息。
 
 @warning 如果您使用IMLib，请使用此字段设置当前登录用户的用户信息；
 如果您使用IMKit，请使用RCIM中的currentUserInfo设置当前登录用户的用户信息，而不要使用此字段。
 */
@property(nonatomic, strong) RCUserInfo *currentUserInfo;

#pragma mark - 消息接收与发送

/*!
 注册自定义的消息类型
 
 @param messageClass    自定义消息的类，该自定义消息需要继承于RCMessageContent
 
 @discussion 如果您需要自定义消息，必须调用此方法注册该自定义消息的消息类型，否则SDK将无法识别和解析该类型消息。
 
 @warning 如果您使用IMLib，请使用此方法注册自定义的消息类型；
 如果您使用IMKit，请使用RCIM中的同名方法注册自定义的消息类型，而不要使用此方法。
 */
- (void)registerMessageType:(Class)messageClass;

#pragma mark 消息发送

/*!
 发送消息
 
 @param conversationType    发送消息的会话类型
 @param targetId            发送消息的目标会话ID
 @param content             消息的内容
 @param pushContent         接收方离线时需要显示的远程推送内容
 @param successBlock        消息发送成功的回调 [messageId:消息的ID]
 @param errorBlock          息发送失败的回调 [nErrorCode:发送失败的错误码, messageId:消息的ID]
 @return                    发送的消息实体
 
 @discussion 当接收方离线并允许远程推送时，会收到远程推送。
 远程推送中包含两部分内容，一是pushContent，用于显示；二是pushData，用于携带不显示的数据。
 
 SDK内置的消息类型，如果您将pushContent和pushData置为nil，会使用默认的推送格式进行远程推送。
 自定义类型的消息，需要您自己设置pushContent和pushData来定义推送内容，否则将不会进行远程推送。
 
 使此方法会将pushData设置为nil，如果需要设置pushData可以使用RCIMClient的
 sendMessage:targetId:content:pushContent:pushData:success:error:方法。
 
 如果您使用此方法发送图片消息，需要您自己实现图片的上传，然后构建一个RCImageMessage对象，
 并将RCImageMessage中的imageUrl字段设置为最终上传的地址，使用此方法发送。
 
 @warning 如果您使用IMLib，可以使用此方法发送消息；
 如果您使用IMKit，请使用RCIM中的同名方法发送消息，否则不会自动更新UI。
 */
- (RCMessage *)sendMessage:(RCConversationType)conversationType
                  targetId:(NSString *)targetId
                   content:(RCMessageContent *)content
               pushContent:(NSString *)pushContent
                   success:(void (^)(long messageId))successBlock
                     error:(void (^)(RCErrorCode nErrorCode, long messageId))errorBlock;

/*!
 发送消息
 
 @param conversationType    发送消息的会话类型
 @param targetId            发送消息的目标会话ID
 @param content             消息的内容
 @param pushContent         接收方离线时需要显示的远程推送内容
 @param pushData            接收方离线时需要在远程推送中携带的非显示数据
 @param successBlock        消息发送成功的回调 [messageId:消息的ID]
 @param errorBlock          消息发送失败的回调 [nErrorCode:发送失败的错误码, messageId:消息的ID]
 @return                    发送的消息实体
 
 @discussion 当接收方离线并允许远程推送时，会收到远程推送。
 远程推送中包含两部分内容，一是pushContent，用于显示；二是pushData，用于携带不显示的数据。
 
 SDK内置的消息类型，如果您将pushContent和pushData置为nil，会使用默认的推送格式进行远程推送。
 自定义类型的消息，需要您自己设置pushContent和pushData来定义推送内容，否则将不会进行远程推送。
 
 如果您使用此方法发送图片消息，需要您自己实现图片的上传，构建一个RCImageMessage对象，
 并将RCImageMessage中的imageUrl字段设置为上传成功的URL地址，然后使用此方法发送。
 
 @warning 如果您使用IMLib，可以使用此方法发送消息；
 如果您使用IMKit，请使用RCIM中的同名方法发送消息，否则不会自动更新UI。
 */
- (RCMessage *)sendMessage:(RCConversationType)conversationType
                  targetId:(NSString *)targetId
                   content:(RCMessageContent *)content
               pushContent:(NSString *)pushContent
                  pushData:(NSString *)pushData
                   success:(void (^)(long messageId))successBlock
                     error:(void (^)(RCErrorCode nErrorCode, long messageId))errorBlock;

/*!
 发送图片消息
 
 @param conversationType    发送消息的会话类型
 @param targetId            发送消息的目标会话ID
 @param content             消息的内容
 @param pushContent         接收方离线时需要显示的远程推送内容
 @param progressBlock       消息发送进度更新的回调 [progress:当前的发送进度, 0 <= progress <= 100, messageId:消息的ID]
 @param successBlock        消息发送成功的回调 [messageId:消息的ID]
 @param errorBlock          消息发送失败的回调 [errorCode:发送失败的错误码, messageId:消息的ID]
 @return                    发送的消息实体
 
 @discussion 当接收方离线并允许远程推送时，会收到远程推送。
 远程推送中包含两部分内容，一是pushContent，用于显示；二是pushData，用于携带不显示的数据。
 
 SDK内置的消息类型，如果您将pushContent和pushData置为nil，会使用默认的推送格式进行远程推送。
 自定义类型的消息，需要您自己设置pushContent和pushData来定义推送内容，否则将不会进行远程推送。
 
 使此方法会将pushData设置为nil，如果需要设置pushData可以使用RCIMClient的
 sendImageMessage:targetId:content:pushContent:pushData:progress:success:error:方法。
 
 如果您需要上传图片到自己的服务器并使用IMLib，构建一个RCImageMessage对象，
 并将RCImageMessage中的imageUrl字段设置为上传成功的URL地址，然后使用RCIMClient的
 sendMessage:targetId:content:pushContent:pushData:success:error:方法
 或sendMessage:targetId:content:pushContent:success:error:方法进行发送，不要使用此方法。
 
 @warning 如果您使用IMKit，使用此方法发送图片消息SDK会自动更新UI；
 如果您使用IMLib，请使用RCIMClient中的同名方法发送图片消息，不会自动更新UI。
 */
- (RCMessage *)sendImageMessage:(RCConversationType)conversationType
                       targetId:(NSString *)targetId
                        content:(RCMessageContent *)content
                    pushContent:(NSString *)pushContent
                       progress:(void (^)(int progress, long messageId))progressBlock
                        success:(void (^)(long messageId))successBlock
                          error:(void (^)(RCErrorCode errorCode, long messageId))errorBlock;

/*!
 发送图片消息
 
 @param conversationType    发送消息的会话类型
 @param targetId            发送消息的目标会话ID
 @param content             消息的内容
 @param pushContent         接收方离线时需要显示的远程推送内容
 @param pushData            接收方离线时需要在远程推送中携带的非显示数据
 @param progressBlock       消息发送进度更新的回调 [progress:当前的发送进度, 0 <= progress <= 100, messageId:消息的ID]
 @param successBlock        消息发送成功的回调 [messageId:消息的ID]
 @param errorBlock          消息发送失败的回调 [errorCode:发送失败的错误码, messageId:消息的ID]
 @return                    发送的消息实体
 
 @discussion 当接收方离线并允许远程推送时，会收到远程推送。
 远程推送中包含两部分内容，一是pushContent，用于显示；二是pushData，用于携带不显示的数据。
 
 SDK内置的消息类型，如果您将pushContent和pushData置为nil，会使用默认的推送格式进行远程推送。
 自定义类型的消息，需要您自己设置pushContent和pushData来定义推送内容，否则将不会进行远程推送。
 
 如果您需要上传图片到自己的服务器，构建一个RCImageMessage对象，
 并将RCImageMessage中的imageUrl字段设置为上传成功的URL地址，然后使用RCIMClient的
 sendMessage:targetId:content:pushContent:pushData:success:error:方法
 或sendMessage:targetId:content:pushContent:success:error:方法进行发送，不要使用此方法。
 
 @warning 如果您使用IMKit，使用此方法发送图片消息SDK会自动更新UI；
 如果您使用IMLib，请使用RCIMClient中的同名方法发送图片消息，不会自动更新UI。
 */
- (RCMessage *)sendImageMessage:(RCConversationType)conversationType
                       targetId:(NSString *)targetId
                        content:(RCMessageContent *)content
                    pushContent:(NSString *)pushContent
                       pushData:(NSString *)pushData
                       progress:(void (^)(int progress, long messageId))progressBlock
                        success:(void (^)(long messageId))successBlock
                          error:(void (^)(RCErrorCode errorCode, long messageId))errorBlock;

/*!
 发送图片消息(上传图片到指定的服务器)
 
 @param conversationType    发送消息的会话类型
 @param targetId            发送消息的目标会话ID
 @param content             消息的内容
 @param pushContent         接收方离线时需要显示的远程推送内容
 @param pushData            接收方离线时需要在远程推送中携带的非显示数据
 @param uploadPrepareBlock  图片上传进度更新的IMKit监听 [uploadListener:当前的发送进度监听，SDK通过此监听更新IMKit UI]
 @param progressBlock       消息发送进度更新的回调 [progress:当前的发送进度, 0 <= progress <= 100, messageId:消息的ID]
 @param successBlock        消息发送成功的回调 [messageId:消息的ID]
 @param errorBlock          消息发送失败的回调 [errorCode:发送失败的错误码, messageId:消息的ID]
 @return                    发送的消息实体
 
 @discussion 此方法仅用于IMKit。
 如果您需要上传图片到自己的服务器并使用IMLib，构建一个RCImageMessage对象，
 并将RCImageMessage中的imageUrl字段设置为上传成功的URL地址，然后使用RCIMClient的
 sendMessage:targetId:content:pushContent:pushData:success:error:方法
 或sendMessage:targetId:content:pushContent:success:error:方法进行发送，不要使用此方法。
 */
- (RCMessage *)sendImageMessage:(RCConversationType)conversationType
                       targetId:(NSString *)targetId
                        content:(RCMessageContent *)content
                    pushContent:(NSString *)pushContent
                       pushData:(NSString *)pushData
                  uploadPrepare:(void (^)(RCUploadImageStatusListener *uploadListener))uploadPrepareBlock
                       progress:(void (^)(int progress, long messageId))progressBlock
                        success:(void (^)(long messageId))successBlock
                          error:(void (^)(RCErrorCode errorCode, long messageId))errorBlock;

/*!
 发送状态消息
 
 @param conversationType    会话类型
 @param targetId            目标会话ID
 @param content             消息内容
 @param successBlock        发送消息成功的回调 [messageId:消息的ID]
 @param errorBlock          发送消息失败的回调 [nErrorCode:发送失败的错误码, messageId:消息的ID]
 
 @discussion 通过此方法发送的消息，根据接收方的状态进行投递。
 如果接收方不在线，则不会收到远程推送，再上线也不会收到此消息。
 */
- (RCMessage *)sendStatusMessage:(RCConversationType)conversationType
                        targetId:(NSString *)targetId
                         content:(RCMessageContent *)content
                         success:(void (^)(long messageId))successBlock
                           error:(void (^)(RCErrorCode nErrorCode, long messageId))errorBlock;

/*!
 插入消息
 
 @param conversationType    会话类型
 @param targetId            目标会话ID
 @param senderUserId        消息发送者的用户ID
 @param sendStatus          发送状态
 @param content             消息的内容
 @return                    插入的消息实体
 
 @discussion 此方法不支持聊天室的会话类型。
 
 @warning 目前仅支持插入向外发送的消息，不支持插入接收的消息。
 */
- (RCMessage *)insertMessage:(RCConversationType)conversationType
                    targetId:(NSString *)targetId
                senderUserId:(NSString *)senderUserId
                  sendStatus:(RCSentStatus)sendStatus
                     content:(RCMessageContent *)content;

/*!
 下载消息内容中的媒体信息
 
 @param conversationType    消息的会话类型
 @param targetId            消息的目标会话ID
 @param mediaType           消息内容中的多媒体文件类型，目前仅支持图片
 @param mediaUrl            多媒体文件的网络URL
 @param progressBlock       消息下载进度更新的回调 [progress:当前的下载进度, 0 <= progress <= 100]
 @param successBlock        下载成功的回调 [mediaPath:下载成功后本地存放的文件路径]
 @param errorBlock          下载失败的回调[errorCode:下载失败的错误码]
 */
- (void)downloadMediaFile:(RCConversationType)conversationType
                 targetId:(NSString *)targetId
                mediaType:(RCMediaType)mediaType
                 mediaUrl:(NSString *)mediaUrl
                 progress:(void (^)(int progress))progressBlock
                  success:(void (^)(NSString *mediaPath))successBlock
                    error:(void (^)(RCErrorCode errorCode))errorBlock;

#pragma mark - 消息操作
/*!
 删除消息
 
 @param messageIds  消息ID的列表
 @return            是否删除成功
 */
- (BOOL)deleteMessages:(NSArray *)messageIds;

/*!
 设置消息的附加信息
 
 @param messageId   消息ID
 @param value       附加信息
 @return            是否设置成功
 */
- (BOOL)setMessageExtra:(long)messageId
                  value:(NSString *)value;


/*!
 设置消息的发送状态
 
 @param messageId       消息ID
 @param sentStatus      消息的发送状态
 @return                是否设置成功
 */
- (BOOL)setMessageSentStatus:(long)messageId
                  sentStatus:(RCSentStatus)sentStatus;


#pragma mark - 会话列表操作
/*!
 获取单个会话数据
 
 @param conversationType    会话类型
 @param targetId            目标会话ID
 @return                    会话的对象
 */
- (RCConversation *)getConversation:(RCConversationType)conversationType
                           targetId:(NSString *)targetId;


#pragma mark - 聊天室操作

/*!
 加入聊天室（如果聊天室不存在则会创建）
 
 @param targetId                聊天室ID
 @param messageCount            进入聊天室时获取历史消息的数量，-1<=messageCount<=50
 @param successBlock            加入聊天室成功的回调
 @param errorBlock              加入聊天室失败的回调 [status:加入聊天室失败的错误码]
 
 @discussion 可以通过传入的messageCount设置加入聊天室成功之后，需要获取的历史消息数量。
 -1表示不获取任何历史消息，0表示不特殊设置而使用SDK默认的设置（默认为获取10条），0<messageCount<=50为具体获取的消息数量,最大值为50。
 */
- (void)joinChatRoom:(NSString *)targetId
        messageCount:(int)messageCount
             success:(void (^)())successBlock
               error:(void (^)(RCErrorCode status))errorBlock;


/*!
 加入已经存在的聊天室（如果不存在或超限会返回聊天室不存在错误23410 或 人数超限 23411）
 
 @param targetId                聊天室ID
 @param messageCount            进入聊天室时获取历史消息的数量，-1<=messageCount<=50
 @param successBlock            加入聊天室成功的回调
 @param errorBlock              加入聊天室失败的回调 [status:加入聊天室失败的错误码]
 
 @warning 注意：使用Kit库的会话页面viewDidLoad会自动调用joinChatRoom加入聊天室（聊天室不存在会自动创建），
 如果您只想加入已存在的聊天室，需要在push到会话页面之前调用这个方法并且messageCount 传-1，成功之后push到会话页面，失败需要您做相应提示处理
 
 @discussion 可以通过传入的messageCount设置加入聊天室成功之后，需要获取的历史消息数量。
 -1表示不获取任何历史消息，0表示不特殊设置而使用SDK默认的设置（默认为获取10条），0<messageCount<=50为具体获取的消息数量,最大值为50。
 */
- (void)joinExistChatRoom:(NSString *)targetId
             messageCount:(int)messageCount
                  success:(void (^)())successBlock
                    error:(void (^)(RCErrorCode status))errorBlock;

/*!
 退出聊天室
 
 @param targetId                聊天室ID
 @param successBlock            退出聊天室成功的回调
 @param errorBlock              退出聊天室失败的回调 [status:退出聊天室失败的错误码]
 */
- (void)quitChatRoom:(NSString *)targetId
             success:(void (^)())successBlock
               error:(void (^)(RCErrorCode status))errorBlock;

/*!
 获取聊天室的信息（包含部分成员信息和当前聊天室中的成员总数）
 
 @param targetId     聊天室ID
 @param count        需要获取的成员信息的数量（目前获取到的聊天室信息中仅包含不多于20人的成员信息，即0 <= count <= 20，传入0获取到的聊天室信息将或仅包含成员总数，不包含具体的成员列表）
 @param order        需要获取的成员列表的顺序（最早加入或是最晚加入的部分成员）
 @param successBlock 获取成功的回调 [chatRoomInfo:聊天室信息]
 @param errorBlock   获取失败的回调 [status:获取失败的错误码]
 
 @discussion 因为聊天室一般成员数量巨大，权衡效率和用户体验，目前返回的聊天室信息仅包含不多于20人的成员信息和当前成员总数。
 如果您使用RC_ChatRoom_Member_Asc升序方式查询，将返回最早加入的成员信息列表，按加入时间从旧到新排列；
 如果您使用RC_ChatRoom_Member_Desc降序方式查询，将返回最晚加入的成员信息列表，按加入时间从新到旧排列。
 */
- (void)getChatRoomInfo:(NSString *)targetId
                  count:(int)count
                  order:(RCChatRoomMemberOrder)order
                success:(void (^)(RCChatRoomInfo *chatRoomInfo))successBlock
                  error:(void (^)(RCErrorCode status))errorBlock;


#pragma mark - 推送业务数据统计

/*!
 统计App启动的事件
 
 @param launchOptions   App的启动附加信息
 
 @discussion 此方法用于统计融云推送服务的点击率。
 如果您需要统计推送服务的点击率，只需要在AppDelegate的-application:didFinishLaunchingWithOptions:中，
 调用此方法并将launchOptions传入即可。
 */
- (void)recordLaunchOptionsEvent:(NSDictionary *)launchOptions;

/*!
 统计本地通知的事件
 
 @param notification   本体通知的内容
 
 @discussion 此方法用于统计融云推送服务的点击率。
 如果您需要统计推送服务的点击率，只需要在AppDelegate的-application:didReceiveLocalNotification:中，
 调用此方法并将launchOptions传入即可。
 */
- (void)recordLocalNotificationEvent:(UILocalNotification *)notification;

/*!
 统计远程推送的事件
 
 @param userInfo    远程推送的内容
 
 @discussion 此方法用于统计融云推送服务的点击率。
 如果您需要统计推送服务的点击率，只需要在AppDelegate的-application:didReceiveRemoteNotification:中，
 调用此方法并将launchOptions传入即可。
 */
- (void)recordRemoteNotificationEvent:(NSDictionary *)userInfo;

/*!
 获取点击的启动事件中，融云推送服务的扩展字段
 
 @param launchOptions   App的启动附加信息
 @return                收到的融云推送服务的扩展字段，nil表示该启动事件不包含来自融云的推送服务
 
 @discussion 此方法仅用于获取融云推送服务的扩展字段。
 */
- (NSDictionary *)getPushExtraFromLaunchOptions:(NSDictionary *)launchOptions;

/*!
 获取点击的远程推送中，融云推送服务的扩展字段
 
 @param userInfo    远程推送的内容
 @return            收到的融云推送服务的扩展字段，nil表示该远程推送不包含来自融云的推送服务
 
 @discussion 此方法仅用于获取融云推送服务的扩展字段。
 */
- (NSDictionary *)getPushExtraFromRemoteNotification:(NSDictionary *)userInfo;

#pragma mark - 工具类方法

/*!
 获取当前IMLib SDK的版本号
 
 @return 当前IMLib SDK的版本号，如: @"2.0.0"
 */
- (NSString *)getSDKVersion;

/*!
 将AMR格式的音频数据转化为WAV格式的音频数据
 
 @param data    AMR格式的音频数据，必须是AMR-NB的格式
 @return        WAV格式的音频数据
 */
- (NSData *)decodeAMRToWAVE:(NSData *)data;

/*!
 将WAV格式的音频数据转化为AMR格式的音频数据（8KHz采样）
 
 @param data            WAV格式的音频数据
 @param nChannels       声道数
 @param nBitsPerSample  采样位数（精度）
 @return                AMR-NB格式的音频数据
 
 @discussion 此方法为工具类方法，您可以使用此方法将任意WAV音频转换为AMR-NB格式的音频。
 
 @warning 如果您想和SDK自带的语音消息保持一致和互通，考虑到跨平台和传输的原因，SDK对于WAV音频有所限制.
 具体可以参考RCVoiceMessage中的音频参数说明(nChannels为1，nBitsPerSample为16)。
 */
- (NSData *)encodeWAVEToAMR:(NSData *)data
                   channel:(int)nChannels
            nBitsPerSample:(int)nBitsPerSample;

/**
 * 获取历史消息记录。
 *
 * @param conversationType 会话类型
 * @param targetId   会话 Id
 * @param oldestMessageId  最后一条消息的 Id
 * @param count            要获取的消息数量
 * @return 历史消息记录，按照时间顺序新到旧排列。
 */
- (NSArray *)getHistoryMessages:(RCConversationType)conversationType
                       targetId:(NSString *)targetId
                oldestMessageId:(long)oldestMessageId
                          count:(int)count;

@end
#endif
