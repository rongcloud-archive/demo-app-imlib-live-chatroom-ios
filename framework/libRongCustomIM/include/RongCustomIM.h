//
//  RongCustomIM.h
//  RongIMLib
//
//  Created by 岑裕 on 10/30/15.
//  Copyright © 2015 RongCloud. All rights reserved.
//

#ifndef RongCustomIM_h
#define RongCustomIM_h
#define RongCustomIMVersion @""

#import <UIKit/UIKit.h>

// In this header, you should import all the public headers of your framework
// using statements like #import <PublicHeader.h>

/// IMLib核心类
#import <RongIMLib/RCIMClient.h>
#import <RongIMLib/RCStatusDefine.h>
/// 会话相关类
#import <RongIMLib/RCConversation.h>
#import <RongIMLib/RCDiscussion.h>
#import <RongIMLib/RCGroup.h>
#import <RongIMLib/RCUserTypingStatus.h>
#import <RongIMLib/RCChatRoomInfo.h>
/// 消息相关类
#import <RongIMLib/RCMessage.h>
#import <RongIMLib/RCMessageContent.h>
#import <RongIMLib/RCMessageContentView.h>
#import <RongIMLib/RCTextMessage.h>
#import <RongIMLib/RCImageMessage.h>
#import <RongIMLib/RCVoiceMessage.h>
#import <RongIMLib/RCLocationMessage.h>
#import <RongIMLib/RCRichContentMessage.h>
#import <RongIMLib/RCHandShakeMessage.h>
#import <RongIMLib/RCSuspendMessage.h>
#import <RongIMLib/RCRealTimeLocationStartMessage.h>
#import <RongIMLib/RCRealTimeLocationEndMessage.h>
#import <RongIMLib/RCCommandMessage.h>
#import <RongIMLib/RCCommandNotificationMessage.h>
#import <RongIMLib/RCInformationNotificationMessage.h>
#import <RongIMLib/RCUnknownMessage.h>
#import <RongIMLib/RCProfileNotificationMessage.h>
#import <RongIMLib/RCPublicServiceCommandMessage.h>
#import <RongIMLib/RCPublicServiceMultiRichContentMessage.h>
#import <RongIMLib/RCPublicServiceRichContentMessage.h>
#import <RongIMLib/RCDiscussionNotificationMessage.h>
#import <RongIMLib/RCGroupNotificationMessage.h>
#import <RongIMLib/RCContactNotificationMessage.h>
/// 工具类
#import <RongIMLib/RCUtilities.h>
#import <RongIMLib/RCAmrDataConverter.h>
#import <RongIMLib/interf_enc.h>
#import <RongIMLib/interf_dec.h>
/// 其他
#import <RongIMLib/RCUserInfo.h>
#import <RongIMLib/RCChatRoomMemberInfo.h>
#import <RongIMLib/RCPublicServiceMenu.h>
#import <RongIMLib/RCPublicServiceProfile.h>
#import <RongIMLib/RCRealTimeLocationManager.h>
#import <RongIMLib/RCUploadImageStatusListener.h>
#import <RongIMLib/RCWatchKitStatusDelegate.h>
#import <RongIMLib/RCStatusMessage.h>
#import <RongIMLib/RCCustomServiceConfig.h>
#endif /* RongCustomIM_h */
