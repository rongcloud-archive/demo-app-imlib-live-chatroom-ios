//
//  RCDLiveMessageBaseCell.m
//  RongIMKit
//
//  Created by xugang on 15/1/28.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDLiveMessageBaseCell.h"
#import "RCDLiveTipLabel.h"
#import "RCDLiveKitUtility.h"
#import "RCDLiveKitCommonDefine.h"

NSString *const RCDLiveNotificationMessageBaseCellUpdateSendingStatus = @"RCDLiveNotificationMessageBaseCellUpdateSendingStatus";

@interface RCDLiveMessageBaseCell ()

- (void)setBaseAutoLayout;

@end

@implementation RCDLiveMessageBaseCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupMessageBaseCellView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMessageBaseCellView];
    }
    return self;
}

-(void)setupMessageBaseCellView{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageCellUpdateSendingStatusEvent:)
                                                 name:RCDLiveNotificationMessageBaseCellUpdateSendingStatus
                                               object:nil];
    self.model = nil;
    self.baseContentView = [[UIView alloc] initWithFrame:CGRectZero];
    _isDisplayReadStatus = NO;
    [self.contentView addSubview:_baseContentView];
}

- (void)setDataModel:(RCDLiveMessageModel *)model {
    self.model = model;
    self.messageDirection = model.messageDirection;
    [self setBaseAutoLayout];
}
- (void)setBaseAutoLayout {
    [_baseContentView setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
}

- (void)messageCellUpdateSendingStatusEvent:(NSNotification *)notification {
    RCDLive_DebugLog(@"%s", __FUNCTION__);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
