//
//  RCDLiveTextMessageCell.m
//  RongIMKit
//
//  Created by xugang on 15/2/2.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDLiveTextMessageCell.h"
#import "RCDLiveKitUtility.h"
#import "RCDLive.h"
#import "RCDLiveKitCommonDefine.h"

@interface RCDLiveTextMessageCell ()

- (void)initialize;

@end

@implementation RCDLiveTextMessageCell
- (NSDictionary *)attributeDictionary {
    if (self.messageDirection == MessageDirection_SEND) {
        return @{
            @(NSTextCheckingTypeLink) : @{NSForegroundColorAttributeName : [UIColor blueColor]},
            @(NSTextCheckingTypePhoneNumber) : @{NSForegroundColorAttributeName : [UIColor blueColor]}
        };
    } else {
        return @{
            @(NSTextCheckingTypeLink) : @{NSForegroundColorAttributeName : [UIColor blueColor]},
            @(NSTextCheckingTypePhoneNumber) : @{NSForegroundColorAttributeName : [UIColor blueColor]}
        };
    }
    return nil;
}

- (NSDictionary *)highlightedAttributeDictionary {
    return [self attributeDictionary];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize {
    self.alpha = 0.6;
    self.textLabel = [[RCDLiveAttributedLabel alloc] initWithFrame:CGRectZero];
    self.textLabel.attributeDictionary = [self attributeDictionary];
    self.textLabel.highlightedAttributeDictionary = [self highlightedAttributeDictionary];
    [self.textLabel setFont:[UIFont systemFontOfSize:Text_Message_Font_Size]];

    self.textLabel.numberOfLines = 0;
    [self.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.textLabel setTextAlignment:NSTextAlignmentLeft];
    
    if (RCDLive_IOS_FSystenVersion < 7.0) {
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
    }
    self.textLabel.delegate=self;
    [self.messageContentView addSubview:self.textLabel];
//    
//    [self.nicknameLabel setFrame:CGRectMake(10, 3, 100, 20)];
//    [self.bubbleBackgroundView addSubview:self.nicknameLabel];
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self.bubbleBackgroundView addGestureRecognizer:longPress];


    UITapGestureRecognizer *textMessageTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTextMessage:)];
    textMessageTap.numberOfTapsRequired = 1;
    textMessageTap.numberOfTouchesRequired = 1;
    [self.textLabel addGestureRecognizer:textMessageTap];
    self.textLabel.userInteractionEnabled = YES;
}
- (void)tapTextMessage:(UIGestureRecognizer *)gestureRecognizer {

    if (self.textLabel.currentTextCheckingType == NSTextCheckingTypeLink) {
        // open url
        NSString *urlString = [self.textLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([self.delegate respondsToSelector:@selector(didTapUrlInMessageCell:model:)]) {
            [self.delegate didTapUrlInMessageCell:urlString model:self.model];
            return;
        }
    } else if (self.textLabel.currentTextCheckingType == NSTextCheckingTypePhoneNumber) {
        // call phone number
        NSString *number = [@"tel://" stringByAppendingString:self.textLabel.text];
        if ([self.delegate respondsToSelector:@selector(didTapPhoneNumberInMessageCell:model:)]) {
            [self.delegate didTapPhoneNumberInMessageCell:number model:self.model];
            return;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}
- (void)setDataModel:(RCDLiveMessageModel *)model {
    [super setDataModel:model];

    [self updateUI];
}
- (void)updateUI {
    RCTextMessage *_textMessage = (RCTextMessage *)self.model.content;
    if (_textMessage) {
        self.textLabel.text = _textMessage.content;
    }
    CGSize __textSize = [RCDLiveTextMessageCell getMessageCellSize:_textMessage.content withWidth:self.baseContentView.bounds.size.width];

    if (self.model.content.senderUserInfo) {
        CGSize __nameSize = [RCDLiveKitUtility getContentSize:self.model.content.senderUserInfo.name withFrontSize:Text_Message_Font_Size withWidth:self.baseContentView.bounds.size.width];
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
    self.textLabel.frame = CGRectMake(6,5, __textSize.width, __textSize.height);
    self.bubbleBackgroundView.backgroundColor = RCDLive_HEXCOLOR(0x61a1ff);
    [self.textLabel setTextColor:RCDLive_HEXCOLOR(0xffffff)];
    
    if (!_isFullScreenMode) {
        self.bubbleBackgroundView.alpha = 1;
        self.bubbleBackgroundView.backgroundColor = [UIColor clearColor];
        [self.textLabel setTextColor:[UIColor blackColor]];
        if (self.messageDirection == MessageDirection_RECEIVE) {
            [self.nicknameLabel setTextColor:RCDLive_HEXCOLOR(0x999999)];
        }else{
            [self.nicknameLabel setTextColor:RCDLive_HEXCOLOR(0x62e0ff)];
        }
        
    }else{
        self.bubbleBackgroundView.alpha = 0.7;
        self.bubbleBackgroundView.backgroundColor = RCDLive_HEXCOLOR(0x61a1ff);
        [self.textLabel setTextColor:[UIColor whiteColor]];
        if (MessageDirection_RECEIVE == self.messageDirection) {
            [self.nicknameLabel setTextColor:RCDLive_HEXCOLOR(0xe2e2e2)];
        }else{
            [self.nicknameLabel setTextColor:RCDLive_HEXCOLOR(0x62e0ff)];
        }
        
    }

    self.bubbleBackgroundView.layer.cornerRadius = 4;
}

- (void)longPressed:(id)sender {
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        RCDLive_DebugLog(@"long press end");
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        [self.delegate didLongTouchMessageCell:self.model inView:self.bubbleBackgroundView];
    }
}

- (void)attributedLabel:(RCDLiveAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSString *urlString=[url absoluteString];
    if (![urlString hasPrefix:@"http"]) {
        urlString = [@"http://" stringByAppendingString:urlString];
    }
    if ([self.delegate respondsToSelector:@selector(didTapUrlInMessageCell:model:)]) {
        [self.delegate didTapUrlInMessageCell:urlString model:self.model];
        return;
    }
}

/**
 Tells the delegate that the user did select a link to an address.
 
 @param label The label whose link was selected.
 @param addressComponents The components of the address for the selected link.
 */
- (void)attributedLabel:(RCDLiveAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents
{
    
}

/**
 Tells the delegate that the user did select a link to a phone number.
 
 @param label The label whose link was selected.
 @param phoneNumber The phone number for the selected link.
 */
- (void)attributedLabel:(RCDLiveAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    NSString *number = [@"tel://" stringByAppendingString:phoneNumber];
    if ([self.delegate respondsToSelector:@selector(didTapPhoneNumberInMessageCell:model:)]) {
        [self.delegate didTapPhoneNumberInMessageCell:number model:self.model];
        return;
    }
}

-(void)attributedLabel:(RCDLiveAttributedLabel *)label didTapLabel:(NSString *)content
{
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

+ (CGSize)getMessageCellSize:(NSString *)content withWidth:(CGFloat)width{
    CGSize textSize = CGSizeZero;
    float maxWidth = width-(10+45+8)*2-28;
    textSize = [RCDLiveKitUtility getContentSize:content withFrontSize:Text_Message_Font_Size withWidth:maxWidth];
    textSize.height = textSize.height + 17;
    return textSize;
}

@end
