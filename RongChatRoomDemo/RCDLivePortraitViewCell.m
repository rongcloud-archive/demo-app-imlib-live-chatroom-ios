//
//  RCDLivePortraitViewCell.m
//  RongChatRoomDemo
//
//  Created by 张改红 on 16/7/8.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import "RCDLivePortraitViewCell.h"

@implementation RCDLivePortraitViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.portaitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        self.portaitView.layer.cornerRadius = 35/2.0;
        self.portaitView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.portaitView];
        
    }
    return self;
}
@end
