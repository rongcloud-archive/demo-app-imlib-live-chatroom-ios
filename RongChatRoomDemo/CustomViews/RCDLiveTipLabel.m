//
//  RCMessageTipLabel.m
//  iOS-IMKit
//
//  Created by Gang Li on 10/27/14.
//  Copyright (c) 2014 RongCloud. All rights reserved.
//

#import "RCDLiveTipLabel.h"
#import "RCDLiveKitCommonDefine.h"

@implementation RCDLiveTipLabel

+ (instancetype)greyTipLabel {
    RCDLiveTipLabel *tip = [[RCDLiveTipLabel alloc] init];
    if (tip) {
        tip.marginInsets = UIEdgeInsetsMake(5.f, 5.f, 5.f, 5.f);
        tip.textColor = [UIColor whiteColor];
        tip.numberOfLines = 0;
        tip.lineBreakMode = NSLineBreakByCharWrapping;
        tip.textAlignment = NSTextAlignmentCenter;
        tip.font = [UIFont systemFontOfSize:12.5f];
        tip.layer.masksToBounds = YES;
        tip.layer.cornerRadius = 5.f;
        
    }
    return tip;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.marginInsets)];
}

- (void)setMarginInsets:(UIEdgeInsets)marginInsets {
    _marginInsets = marginInsets;
    [self invalidateIntrinsicContentSize];
}
- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    size.width += self.marginInsets.left + self.marginInsets.right;
    size.height += self.marginInsets.top + self.marginInsets.bottom;
    return size;
}

@end
