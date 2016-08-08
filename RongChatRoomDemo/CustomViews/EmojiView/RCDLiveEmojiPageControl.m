//
//  RCDLiveEmojiPageControl.m
//  iOS-IMKit
//
//  Created by Heq.Shinoda on 14-7-12.
//  Copyright (c) 2014年 Heq.Shinoda. All rights reserved.
//

#import "RCDLiveEmojiPageControl.h"
#import "RCDLiveKitCommonDefine.h"
#import "RCDLiveKitUtility.h"

@implementation RCDLiveEmojiPageControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        activeImage = RCDLive_IMAGE_BY_NAMED(@"emoji_pagecontrol_selected");
        inactiveImage = RCDLive_IMAGE_BY_NAMED(@"emoji_pagecontrol_normol");
        
        self.hidesForSinglePage = YES;
        self.enabled = NO;
        self.currentPage = 0;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)updateDots {

    for (int i = 0; i < [self.subviews count]; i++) {

        UIImageView *dot = (self.subviews)[i];

        if (i == self.currentPage) {

            if ([dot isKindOfClass:UIImageView.class]) {

                ((UIImageView *)dot).image = activeImage;
            } else {

                dot.backgroundColor = [UIColor colorWithPatternImage:activeImage];
            }
        } else {

            if ([dot isKindOfClass:UIImageView.class]) {

                ((UIImageView *)dot).image = inactiveImage;
            } else {

                dot.backgroundColor = [UIColor colorWithPatternImage:inactiveImage];
            }
        }
    }
}

- (void)setCurrentPage:(NSInteger)page {

    [super setCurrentPage:page];

    [self updateDots];
}

@end
