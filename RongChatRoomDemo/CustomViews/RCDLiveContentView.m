//
//  RCDLiveContentView.m
//  RongIMKit
//
//  Created by xugang on 3/31/15.
//  Copyright (c) 2015 RongCloud. All rights reserved.
//

#import "RCDLiveContentView.h"

@implementation RCDLiveContentView

- (id)init {
    self = [super init];
    if (self) {
        _eventBlock = NULL;
    }
    return self;
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (_eventBlock) {
        _eventBlock(frame);
    }
}

- (void)registerFrameChangedEvent:(void (^)(CGRect frame))eventBlock {
    self.eventBlock = eventBlock;
}
@end
