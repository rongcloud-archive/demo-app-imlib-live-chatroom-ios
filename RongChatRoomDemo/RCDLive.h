//
//  RongUIKit.h
//  RongIMKit
//
//  Created by xugang on 15/1/13.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMLib/RongIMLib.h>

/*!
 @const 收到消息的Notification
 
 @discussion 接收到消息后，SDK会分发此通知。
 
 Notification的object为RCMessage消息对象。
 userInfo为NSDictionary对象，其中key值为@"left"，value为还剩余未接收的消息数的NSNumber对象。
 */
FOUNDATION_EXPORT NSString *const RCDLiveKitDispatchMessageNotification;

#pragma mark - IMKit核心类

/*!
 管理融云核心类
 
 @discussion 您需要通过sharedRCDLive方法，获取单例对象
 */
@interface RCDLive : NSObject

/*!
 获取融云核心类单例
 
 @return    融云界面组件IMKit的核心类单例
 
 @discussion 您可以通过此方法，获取IMKit的单例，访问对象中的属性和方法。
 */
+ (instancetype)sharedRCDLive;

#pragma mark - SDK初始化

/*!
 初始化融云SDK
 
 @param appKey  从融云开发者平台创建应用后获取到的App Key
 
 @discussion 您在使用融云SDK所有功能（包括显示SDK中或者继承于SDK的View）之前，您必须先调用此方法初始化SDK。
 在App整个生命周期中，您只需要执行一次初始化。
 */
- (void)initRongCloud:(NSString *)appKey;

#pragma mark - 连接与断开服务器

/*!
 与融云服务器建立连接
 
 @param token                   从您服务器端获取的token(用户身份令牌)
 @param successBlock            连接建立成功的回调 [userId:当前连接成功所用的用户ID
 @param errorBlock              连接建立失败的回调 [status:连接失败的错误码]
 @param tokenIncorrectBlock     token错误或者过期的回调
 
 @discussion 在App整个生命周期，您只需要调用一次此方法与融云服务器建立连接。
 之后无论是网络出现异常或者App有前后台的切换等，SDK都会负责自动重连。
 除非您已经手动将连接断开，否则您不需要自己再手动重连。
 
 tokenIncorrectBlock有两种情况：
 一是token错误，请您检查客户端初始化使用的AppKey和您服务器获取token使用的AppKey是否一致；
 二是token过期，是因为您在开发者后台设置了token过期时间，您需要请求您的服务器重新获取token并再次用新的token建立连接。
 
 @warning 如果您使用IMKit，请使用此方法建立与融云服务器的连接；
 如果您使用IMLib，请使用RCIMClient中的同名方法建立与融云服务器的连接，而不要使用此方法。
 
 在tokenIncorrectBlock的情况下，您需要请求您的服务器重新获取token并建立连接，但是注意避免无限循环，以免影响App用户体验。
 
 此方法的回调并非为原调用线程，您如果需要进行UI操作，请注意切换到主线程。
 */
- (void)connectRongCloudWithToken:(NSString *)token
                 success:(void (^)(NSString *userId))successBlock
                   error:(void (^)(RCConnectErrorCode status))errorBlock
          tokenIncorrect:(void (^)())tokenIncorrectBlock;

/*!
 断开与融云服务器的连接
 
 @param isReceivePush   App在断开连接之后，是否还接收远程推送
 
 @discussion 因为SDK在前后台切换或者网络出现异常都会自动重连，会保证连接的可靠性。
 所以除非您的App逻辑需要登出，否则一般不需要调用此方法进行手动断开。
 
 @warning 如果您使用IMKit，请使用此方法断开与融云服务器的连接；
 如果您使用IMLib，请使用RCIMClient中的同名方法断开与融云服务器的连接，而不要使用此方法。
 
 isReceivePush指断开与融云服务器的连接之后，是否还接收远程推送。
 [[RCDLive sharedRCDLive] disconnect:YES]与[[RCDLive sharedRCDLive] disconnect]完全一致；
 [[RCDLive sharedRCDLive] disconnect:NO]与[[RCDLive sharedRCDLive] logout]完全一致。
 您只需要按照您的需求，使用disconnect:与disconnect以及logout三个接口其中一个即可。
 */
- (void)disconnectRongCloud:(BOOL)isReceivePush;

/*!
 断开与融云服务器的连接，但仍然接收远程推送
 
 @discussion 因为SDK在前后台切换或者网络出现异常都会自动重连，会保证连接的可靠性。
 所以除非您的App逻辑需要登出，否则一般不需要调用此方法进行手动断开。
 
 @warning 如果您使用IMKit，请使用此方法断开与融云服务器的连接；
 如果您使用IMLib，请使用RCIMClient中的同名方法断开与融云服务器的连接，而不要使用此方法。
 
 [[RCDLive sharedRCDLive] disconnectRongCloud:YES]与[[RCDLive sharedRCDLive] disconnectRongCloud]完全一致；
 [[RCDLive sharedRCDLive] disconnectRongCloud:NO]与[[RCDLive sharedRCDLive] logoutRongCloud]完全一致。
 您只需要按照您的需求，使用disconnect:与disconnect以及logout三个接口其中一个即可。
 */
- (void)disconnectRongCloud;

/*!
 断开与融云服务器的连接，并不再接收远程推送
 
 @discussion 因为SDK在前后台切换或者网络出现异常都会自动重连，会保证连接的可靠性。
 所以除非您的App逻辑需要登出，否则一般不需要调用此方法进行手动断开。
 
 @warning 如果您使用IMKit，请使用此方法断开与融云服务器的连接；
 如果您使用IMLib，请使用RCIMClient中的同名方法断开与融云服务器的连接，而不要使用此方法。
 
 [[RCDLive sharedRCDLive] disconnectRongCloud:YES]与[[RCDLive sharedRCDLive] disconnectRongCloud]完全一致；
 [[RCDLive sharedRCDLive] disconnectRongCloud:NO]与[[RCDLive sharedRCDLive] logoutRongCloud]完全一致。
 您只需要按照您的需求，使用disconnect:与disconnect以及logout三个接口其中一个即可。
 */
- (void)logoutRongCloud;

#pragma mark 连接状态监听


/*!
 获取当前SDK的连接状态
 
 @return 当前SDK的连接状态
 */
- (RCConnectionStatus)getRongCloudConnectionStatus;

#pragma mark - 消息接收与发送

/*!
 注册自定义的消息类型
 
 @param messageClass    自定义消息的类，该自定义消息需要继承于RCMessageContent
 
 @discussion 如果您需要自定义消息，必须调用此方法注册该自定义消息的消息类型，否则SDK将无法识别和解析该类型消息。
 
 @warning 如果您使用IMKit，请使用此方法注册自定义的消息类型；
 如果您使用IMLib，请使用RCIMClient中的同名方法注册自定义的消息类型，而不要使用此方法。
 */
- (void)registerRongCloudMessageType:(Class)messageClass;

#pragma mark 消息发送
/*!
 发送消息(除图片消息外的所有消息)，会自动更新UI
 
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
 
 @warning 如果您使用IMKit，使用此方法发送消息SDK会自动更新UI；
 如果您使用IMLib，请使用RCIMClient中的同名方法发送消息，不会自动更新UI。
 */
- (RCMessage *)sendMessage:(RCConversationType)conversationType
                  targetId:(NSString *)targetId
                   content:(RCMessageContent *)content
               pushContent:(NSString *)pushContent
                  pushData:(NSString *)pushData
                   success:(void (^)(long messageId))successBlock
                     error:(void (^)(RCErrorCode nErrorCode, long messageId))errorBlock;

/*!
 发送图片消息，会自动更新UI
 
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

#pragma mark 消息接收监听
#pragma mark - 用户信息、群组信息相关

/*!
 当前登录的用户的用户信息
 
 @discussion 与融云服务器建立连接之后，应该设置当前用户的用户信息，用于SDK显示和发送。
 */
@property(nonatomic, strong) RCUserInfo *currentUserInfo;
@end
