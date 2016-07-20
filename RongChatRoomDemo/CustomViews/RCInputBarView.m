//
//  RCInputBarView.m
//  RongIMKit
//
//  Created by MiaoGuangfa on 2/12/15.
//  Copyright (c) 2015 RongCloud. All rights reserved.
//

#import "RCInputBarView.h"

@interface RCInputBarView ()

- (void) initialize;
@end

@implementation RCInputBarView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize
{
    
}

@end
