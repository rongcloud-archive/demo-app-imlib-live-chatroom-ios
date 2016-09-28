//
//  RCDLiveMessageCellDelegate.h
//  RongIMKit
//
//  Created by xugang on 3/14/15.
//  Copyright (c) 2015 RongCloud. All rights reserved.
//

#import "RCDLiveMessageModel.h"

/*!
 消息Cell点击的回调
 */
@protocol RCDLiveMessageCellDelegate <NSObject>
@optional

/*!
 点击Cell内容的回调
 
 @param model 消息Cell的数据模型
 */
- (void)didTapMessageCell:(RCDLiveMessageModel *)model;

/*!
 点击Cell中URL的回调
 
 @param url   点击的URL
 @param model 消息Cell的数据模型
 
 @discussion 点击Cell中的URL，会调用此回调，不会再触发didTapMessageCell:。
 */
- (void)didTapUrlInMessageCell:(NSString *)url model:(RCDLiveMessageModel *)model;

/*!
 点击Cell中电话号码的回调
 
 @param phoneNumber 点击的电话号码
 @param model       消息Cell的数据模型
 
 @discussion 点击Cell中的电话号码，会调用此回调，不会再触发didTapMessageCell:。
 */
- (void)didTapPhoneNumberInMessageCell:(NSString *) phoneNumber model:(RCDLiveMessageModel *)model;

/*!
 点击Cell中用户头像的回调
 
 @param userId 头像对应的用户ID
 */
- (void)didTapCellPortrait:(NSString *)userId;

/*!
 长按Cell中用户头像的回调
 
 @param userId 头像对应的用户ID
 */
- (void)didLongPressCellPortrait:(NSString *)userId;

/*!
 长按Cell内容的回调
 
 @param model 消息Cell的数据模型
 @param view  长按区域的View
 */
- (void)didLongTouchMessageCell:(RCDLiveMessageModel *)model inView:(UIView *)view;

/*!
 点击消息发送失败红点的回调
 
 @param model 消息Cell的数据模型
 */
- (void)didTapmessageFailedStatusViewForResend:(RCDLiveMessageModel *)model;

@end

/*!
 公众服务会话中消息Cell点击的回调
 */
@protocol RCPublicServiceMessageCellDelegate <NSObject>
@optional

/*!
 公众服务会话中，点击Cell内容的回调
 
 @param model 消息Cell的数据模型
 */
- (void)didTapPublicServiceMessageCell:(RCDLiveMessageModel *)model;

/*!
 公众服务会话中，点击Cell中URL的回调
 
 @param url   点击的URL
 @param model 消息Cell的数据模型
 
 @discussion 点击Cell中的URL，会调用此回调，不会再触发didTapMessageCell:。
 */
- (void)didTapUrlInPublicServiceMessageCell:(NSString *)url model:(RCDLiveMessageModel *)model;

/*!
 公众服务会话中，点击Cell中电话号码的回调
 
 @param phoneNumber 点击的电话号码
 @param model       消息Cell的数据模型
 
 @discussion 点击Cell中的电话号码，会调用此回调，不会再触发didTapMessageCell:。
 */
- (void)didTapPhoneNumberInPublicServiceMessageCell:(NSString *) phoneNumber model:(RCDLiveMessageModel *)model;

/*!
 公众服务会话中，长按Cell内容的回调
 
 @param model 消息Cell的数据模型
 @param view  长按区域的View
 */
- (void)didLongTouchPublicServiceMessageCell:(RCDLiveMessageModel *)model inView:(UIView *)view;

/*!
 公众服务会话中，点击消息发送失败红点的回调
 
 @param model 消息Cell的数据模型
 */
- (void)didTapPublicServiceMessageFailedStatusViewForResend:(RCDLiveMessageModel *)model;

@end
