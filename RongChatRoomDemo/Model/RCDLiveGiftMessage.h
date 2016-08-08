//
//  RCLikeMessage.h
//  RongChatRoomDemo
//
//  Created by 杜立召 on 16/5/17.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMLib/RongIMLib.h>

#define RCDLiveGiftMessageIdentifier @"RC:GiftMsg"
/* 点赞消息
 *
 * 对于聊天室中发送频率较高，不需要存储的消息要使用状态消息，自定义消息继承RCMessageContent 
 * 然后persistentFlag 方法返回 MessagePersistent_STATUS
 */
@interface RCDLiveGiftMessage : RCMessageContent

/*
 * 类型 0 小花，1，鼓掌
 */
@property(nonatomic, strong) NSString *type;
@end
