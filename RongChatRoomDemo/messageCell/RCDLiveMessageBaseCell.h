//
//  RCDLiveMessageBaseCell.h
//  RongIMKit
//
//  Created by xugang on 15/1/28.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <RongIMLib/RongIMLib.h>
#import "RCDLiveMessageModel.h"
#import "RCDLiveMessageCellNotificationModel.h"
#import "RCDLiveMessageCellDelegate.h"
#import "RCDLiveTipLabel.h"

/*!
 消息发送状态更新的Notification
 */
UIKIT_EXTERN NSString *const RCDLiveNotificationMessageBaseCellUpdateSendingStatus;

/*!
 消息Cell基类
 
 @discussion 消息Cell基类包含了所有消息Cell的必要信息。
 消息Cell基类针对用户头像是否显示，主要可以分为两类的：
 一是提醒类的Cell，不显示用户信息，如：RCDLiveTipMessageCell和RCUnknownMessageCell；
 二是展示类的Cell，显示用户信息和内容，如：RCDLiveMessageCell以及RCDLiveMessageCell的子类。
 */
@interface RCDLiveMessageBaseCell : UICollectionViewCell

/*!
 消息Cell点击回调
 */
@property(nonatomic, weak) id<RCDLiveMessageCellDelegate> delegate;

/*!
 显示时间的Label
 */
@property(strong, nonatomic) RCDLiveTipLabel *messageTimeLabel;

/*!
 消息Cell的数据模型
 */
@property(strong, nonatomic) RCDLiveMessageModel *model;

/*!
 Cell显示的View
 */
@property(strong, nonatomic) UIView *baseContentView;

/*!
 消息的方向
 */
@property(nonatomic) RCMessageDirection messageDirection;

/*!
 时间Label是否显示
 */
@property(nonatomic, readonly) BOOL isDisplayMessageTime;

/*!
 是否显示阅读状态
 */
@property(nonatomic) BOOL isDisplayReadStatus;

/*!
 初始化消息Cell
 
 @param frame 显示的Frame
 @return 消息Cell基类对象
 */
- (instancetype)initWithFrame:(CGRect)frame;

/*!
 设置当前消息Cell的数据模型
 
 @param model 消息Cell的数据模型
 */
- (void)setDataModel:(RCDLiveMessageModel *)model;

/*!
 消息发送状态更新的监听回调
 
 @param notification 消息发送状态更新的Notification
 */
- (void)messageCellUpdateSendingStatusEvent:(NSNotification *)notification;

@end
