//
//  RCLikeMessageCell.h
//  RongChatRoomDemo
//
//  Created by 杜立召 on 16/5/17.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCDLiveMessageCell.h"

@interface RCDLiveGiftMessageCell : RCDLiveMessageCell

/*!
 提示的Label
 */
@property(strong, nonatomic) UILabel *messageLabel;
@property(strong, nonatomic) UIImageView *giftImageView;

@property(assign, nonatomic) BOOL isFullScreenMode;

/*!
 设置当前消息Cell的数据模型
 
 @param model 消息Cell的数据模型
 */
- (void)setDataModel:(RCDLiveMessageModel *)model;

+ (CGSize)getMessageCellSize:(NSString *)content withWidth:(CGFloat)width;

@end
