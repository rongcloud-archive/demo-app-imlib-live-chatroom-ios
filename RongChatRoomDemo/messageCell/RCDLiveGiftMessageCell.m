//
//  RCLikeMessageCell.m
//  RongChatRoomDemo
//
//  Created by 杜立召 on 16/5/17.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import "RCDLiveGiftMessageCell.h"
#import "RCDLiveKitUtility.h"
#import "RCDLiveKitCommonDefine.h"
#import "RCDLiveGiftMessage.h"
#import "RCDLive.h"

@implementation RCDLiveGiftMessageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.messageLabel = [[UILabel alloc]init];
        //        self.tipMessageLabel.delegate = self;
        self.messageLabel.userInteractionEnabled = YES;
        self.giftImageView = [[UIImageView alloc]init];
        [self.messageContentView addSubview:self.giftImageView];
        [self.messageContentView addSubview:self.messageLabel];
    }
    return self;
}

- (void)setDataModel:(RCDLiveMessageModel *)model {
    [super setDataModel:model];
    [self updateUI];
}

/**
 *  更新UI
 */
- (void)updateUI {
    RCDLiveGiftMessage *_likeMessage = (RCDLiveGiftMessage *)self.model.content;
    if (_likeMessage) {
        if(_likeMessage.senderUserInfo){
            if ([_likeMessage.senderUserInfo.userId isEqualToString:[RCDLive sharedRCDLive].currentUserInfo.userId]) {
                self.messageLabel.text = @"你送出一个";
            }else{
                self.messageLabel.text = [NSString stringWithFormat:@"%@送出一个",_likeMessage.senderUserInfo.name];
            }
        }else{
            self.nicknameLabel.text = @"神秘人";
            self.messageLabel.text = @"神秘人送出一个";
        }
      if ([_likeMessage.type isEqualToString:@"0"]) {
        self.messageLabel.text = [self.messageLabel.text stringByAppendingString:@"礼物"];
      }else{
        self.messageLabel.text = [self.messageLabel.text stringByAppendingString:@"赞"];
      }
    }
    CGSize __textSize = [RCDLiveGiftMessageCell getMessageCellSize:self.messageLabel.text  withWidth:self.baseContentView.bounds.size.width];
    
    if (self.model.content.senderUserInfo) {
        CGSize __nameSize = [RCDLiveKitUtility getContentSize:self.model.content.senderUserInfo.name withFrontSize:16 withWidth:self.baseContentView.bounds.size.width];
        __nameSize.width = __nameSize.width + 5;
        if (__nameSize.width > __textSize.width) {
            __textSize.width = __nameSize.width;
        }
        CGRect nameLabelRect = self.nicknameLabel.frame;
        nameLabelRect.size.width = __nameSize.width;
        nameLabelRect.size.height = __nameSize.height;
        self.nicknameLabel.frame = nameLabelRect;
    }
    
    CGFloat __textHeight = __textSize.height;
    CGFloat __textWidth = __textSize.width + 20 < 50 ? 50 : (__textSize.width + 20);
    
    CGFloat __bubbleHeight = __textHeight < 35 ? 35: (__textHeight);
    CGFloat __bubbleWidth = __textWidth < 50 ? 50 : (__textWidth);
    CGSize __bubbleSize = CGSizeMake(__bubbleWidth - 6, __bubbleHeight + 10);
    CGRect messageContentViewRect = self.messageContentView.frame;
    messageContentViewRect.size.width = __textSize.width;
    messageContentViewRect.size.height = __textSize.height;
    self.messageContentView.frame = messageContentViewRect;
    self.bubbleBackgroundView.frame = CGRectMake(6, 0, __bubbleSize.width, __bubbleSize.height);
    self.messageLabel.frame = CGRectMake(10,10, __textSize.width, __textSize.height);
    self.bubbleBackgroundView.backgroundColor = RCDLive_HEXCOLOR(0x61a1ff);
    [self.messageLabel setTextColor:RCDLive_HEXCOLOR(0xffffff)];
    
    if (!_isFullScreenMode) {
        self.bubbleBackgroundView.alpha = 1;
        self.bubbleBackgroundView.backgroundColor = [UIColor clearColor];
        [self.messageLabel setTextColor:[UIColor blackColor]];
        if (self.messageDirection == MessageDirection_RECEIVE) {
            [self.nicknameLabel setTextColor:RCDLive_HEXCOLOR(0x999999)];
        }else{
            [self.nicknameLabel setTextColor:RCDLive_HEXCOLOR(0x62e0ff)];
        }
        
    }else{
        self.bubbleBackgroundView.alpha = 0.7;
        self.bubbleBackgroundView.backgroundColor = RCDLive_HEXCOLOR(0x61a1ff);
        [self.messageLabel setTextColor:[UIColor whiteColor]];
        if (MessageDirection_RECEIVE == self.messageDirection) {
            [self.nicknameLabel setTextColor:RCDLive_HEXCOLOR(0xe2e2e2)];
        }else{
            [self.nicknameLabel setTextColor:RCDLive_HEXCOLOR(0x62e0ff)];
        }
        
    }
    
    self.giftImageView.frame = CGRectMake(self.messageLabel.frame.size.width - 4,20, 20, 20);
  
    self.bubbleBackgroundView.layer.cornerRadius = 4;
}

+ (CGSize)getMessageCellSize:(NSString *)content withWidth:(CGFloat)width{
    CGSize textSize = CGSizeZero;
    float maxWidth = width-(10+45+8)*2-28;
    textSize = [RCDLiveKitUtility getContentSize:content withFrontSize:16 withWidth:maxWidth];
    textSize.width = textSize.width + 24 ;//加上礼物的宽度
    textSize.height = textSize.height + 17;
    return textSize;
}


@end
