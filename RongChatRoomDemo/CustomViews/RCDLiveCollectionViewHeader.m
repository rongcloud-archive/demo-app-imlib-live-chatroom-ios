//
//  RCDLiveCollectionViewHeader.m
//  RongChatRoomDemo
//
//  Created by 杜立召 on 16/4/25.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import "RCDLiveCollectionViewHeader.h"

@implementation RCDLiveCollectionViewHeader
@synthesize indicatorView = _indicatorView;
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.indicatorView =
        [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.frame = CGRectMake(0, 0, 20.0f, 20.0f);
        [self addSubview:_indicatorView];
        [_indicatorView setCenter:CGPointMake(frame.size.width / 2, frame.size.height / 2)];
    }
    return self;
}
- (void)startAnimating {
    if (self.indicatorView.isAnimating == NO) {
        [self.indicatorView startAnimating];
    }
}
- (void)stopAnimating {
    if (self.indicatorView.isAnimating == YES) {
        [self.indicatorView stopAnimating];
    }
}


@end
