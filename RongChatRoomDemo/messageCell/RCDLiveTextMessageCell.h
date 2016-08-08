//
//  RCDLiveTextMessageCell.h
//  RongIMKit
//
//  Created by xugang on 15/2/2.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDLiveMessageCell.h"
#import "RCDLiveAttributedLabel.h"

#define Text_Message_Font_Size 16

/*!
 文本消息Cell
 */
@interface RCDLiveTextMessageCell : RCDLiveMessageCell<RCDLiveAttributedLabelDelegate>

/*!
 显示消息内容的Label
 */
@property(strong, nonatomic) RCDLiveAttributedLabel *textLabel;

@property(assign, nonatomic) BOOL isFullScreenMode;

/*!
 设置当前消息Cell的数据模型
 
 @param model 消息Cell的数据模型
 */
- (void)setDataModel:(RCDLiveMessageModel *)model;

+ (CGSize)getMessageCellSize:(NSString *)content withWidth:(CGFloat)width;
@end
