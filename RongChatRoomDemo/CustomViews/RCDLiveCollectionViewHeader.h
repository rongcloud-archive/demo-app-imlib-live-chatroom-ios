//
//  RCDLiveCollectionViewHeader.h
//  RongChatRoomDemo
//
//  Created by 杜立召 on 16/4/25.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCDLiveCollectionViewHeader : UIView

@property(nonatomic, strong) UIActivityIndicatorView *indicatorView;

- (void)startAnimating;
- (void)stopAnimating;
@end
