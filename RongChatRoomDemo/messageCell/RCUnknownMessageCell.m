//
//  RCUnknownMessageCell.m
//  RongIMKit
//
//  Created by xugang on 3/31/15.
//  Copyright (c) 2015 RongCloud. All rights reserved.
//

#import "RCUnknownMessageCell.h"
#import "RCTipLabel.h"
#import "RCKitUtility.h"
#import "RCKitCommonDefine.h"

@implementation RCUnknownMessageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.messageLabel = [RCTipLabel greyTipLabel];
        [self.baseContentView addSubview:self.messageLabel];
        self.messageLabel.marginInsets = UIEdgeInsetsMake(0.5f, 0.5f, 0.5f, 0.5f);
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.messageLabel = [RCTipLabel greyTipLabel];
        [self.baseContentView addSubview:self.messageLabel];
        self.messageLabel.marginInsets = UIEdgeInsetsMake(0.5f, 0.5f, 0.5f, 0.5f);
    }
    return self;
}
- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];

    // RCMessageContent *content = model.content;

    CGFloat maxMessageLabelWidth = self.baseContentView.bounds.size.width - 30 * 2;

    [self.messageLabel setText:NSLocalizedStringFromTable(@"unknown_message_cell_tip", @"RongCloudKit", nil) dataDetectorEnabled:NO];

    NSString *__text = self.messageLabel.text;
    // ios 7
//    CGSize __textSize =
//        [__text boundingRectWithSize:CGSizeMake(maxMessageLabelWidth, MAXFLOAT)
//                             options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |
//                                     NSStringDrawingUsesFontLeading
//                          attributes:@{
//                              NSFontAttributeName : [UIFont systemFontOfSize:12.5f]
//                          } context:nil]
//            .size;
    
//    CGSize __textSize = RC_MULTILINE_TEXTSIZE(__text, [UIFont systemFontOfSize:12.5f], CGSizeMake(maxMessageLabelWidth, MAXFLOAT), NSLineBreakByTruncatingTail);
    CGSize __textSize = CGSizeZero;
    if (IOS_FSystenVersion < 7.0) {
        __textSize = RC_MULTILINE_TEXTSIZE_LIOS7(__text, [UIFont systemFontOfSize:12.5f], CGSizeMake(maxMessageLabelWidth, MAXFLOAT), NSLineBreakByTruncatingTail);
    }else {
        __textSize = RC_MULTILINE_TEXTSIZE_GEIOS7(__text, [UIFont systemFontOfSize:12.5f], CGSizeMake(maxMessageLabelWidth, MAXFLOAT));
    }


        __textSize = CGSizeMake(ceilf(__textSize.width), ceilf(__textSize.height));
    CGSize __labelSize = CGSizeMake(__textSize.width + 5, __textSize.height + 5);

    self.messageLabel.frame = CGRectMake((self.baseContentView.bounds.size.width - __labelSize.width) / 2.0f, 10,
                                         __labelSize.width, __labelSize.height);
}

@end
