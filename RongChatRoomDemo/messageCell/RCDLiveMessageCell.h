//
//  RCMessageCommonCell.h
//  RongIMKit
//
//  Created by xugang on 15/1/28.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDLiveMessageBaseCell.h"
#import "RCDLiveMessageCellNotificationModel.h"
#import "RCDLiveMessageCellDelegate.h"
#import "RCDLiveContentView.h"
//#define PORTRAIT_WIDTH 45
//#define PORTRAIT_HEIGHT 45

/*!
 展示的消息Cell类
 
 @discussion 需要展示用户信息和内容的消息Cell可以继承此类，
 如：RCDLiveTextMessageCell、RCImageMessageCell、RCLocationMessageCell、RCVoiceMessageCell、RCRichContentMessageCell等。
 如果您需要显示自定义消息，可以继承此类。
 */
@interface RCDLiveMessageCell : RCDLiveMessageBaseCell

///*!
//消息发送者的用户头像
//*/
//@property(nonatomic, strong) RCEmoticonImageView *portraitImageView;

/*!
 消息发送者的用户名称
 */
@property(nonatomic, strong) UILabel *nicknameLabel;

/*!
 消息内容的View
 */
@property(nonatomic, strong) RCDLiveContentView *messageContentView;

/*!
 消息的背景View
 */
@property(nonatomic, strong) RCDLiveContentView *bubbleBackgroundView;
/*!
 显示发送状态的View
 
 @discussion 其中包含messageFailedStatusView子View。
 */
@property(nonatomic, strong) UIView *statusContentView;

/*!
 显示发送失败状态的View
 */
@property(nonatomic, strong) UIButton *messageFailedStatusView;

/*!
 消息发送指示View
 */
@property(nonatomic, strong) UIActivityIndicatorView *messageActivityIndicatorView;

/*!
 消息内容的View的宽度
 */
@property(nonatomic, readonly) CGFloat messageContentViewWidth;

/*!
 是否显示用户名称
 */
@property(nonatomic, readonly) BOOL isDisplayNickname;

/*!
 显示消息已阅读状态的View
 */
@property(nonatomic, strong) UIView *messageHasReadStatusView;

/*!
 显示消息发送成功状态的View
 */
@property(nonatomic, strong) UIView *messageSendSuccessStatusView;

/*!
 设置当前消息Cell的数据模型
 
 @param model 消息Cell的数据模型
 */
- (void)setDataModel:(RCDLiveMessageModel *)model;

/*!
 更新消息发送状态
 
 @param model 消息Cell的数据模型
 */
- (void)updateStatusContentView:(RCDLiveMessageModel *)model;

@end
