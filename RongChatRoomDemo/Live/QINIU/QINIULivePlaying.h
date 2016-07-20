//
//  QINIULivePlaying.h
//  RongChatRoomDemo
//
//  Created by 岑裕 on 16/4/26.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QINIULivePlaying : NSObject

@property (nonatomic, readonly) UIView *currentLiveView;

- (instancetype)initPlaying:(NSString *)mediaURL;

- (void)startPlaying;

- (void)pausePlaying;

- (void)resumePlaying;

- (void)destroyPlaying;

@end
