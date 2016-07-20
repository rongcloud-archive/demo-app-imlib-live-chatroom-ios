//
//  LELivePlaying.h
//  RongChatRoomDemo
//
//  Created by 岑裕 on 16/4/25.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LELivePlaying : NSObject

@property (nonatomic, readonly) UIView *currentLiveView;

- (instancetype)initPlaying:(NSString *)mediaURL;

- (void)startPlaying;

- (void)pausePlaying;

- (void)resumePlaying;

- (void)destroyPlaying;

@end
