//
//  LELivePlaying.m
//  RongChatRoomDemo
//
//  Created by 岑裕 on 16/4/25.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import "LELivePlaying.h"
#import "LCPlayerService.h"
#import "LECLivingPlayer.h"

@interface LELivePlaying ()

@property (nonatomic, strong) NSString *currentMediaURL;
@property (nonatomic, strong) LECLivingPlayer *player;

@end

@implementation LELivePlaying

- (instancetype)initPlaying:(NSString *)mediaURL {
    self = [super init];
    if (self) {
        self.currentMediaURL = mediaURL;
        [[LCPlayerService sharedService] startService];
        self.player = [[LECLivingPlayer alloc] init];
    }
    return self;
}

- (void)startPlaying {
    [self.player registerWithLiveId:self.currentMediaURL
                          mediaType:LECPlayerMediaTypeRTMP
                         completion:^(BOOL result) {
                             [self.player prepare];
                             [self.player play];
                         }];
}

- (void)pausePlaying {
    [self.player pause];
}

- (void)resumePlaying {
    [self.player resume];
}

- (void)destroyPlaying {
    [self.player unregister];
    [[LCPlayerService sharedService] stopService];
    self.currentMediaURL = nil;
    self.player = nil;
}

- (UIView *)currentLiveView {
    return self.player.videoView;
}

@end
