//
//  QINIULivePlaying.m
//  RongChatRoomDemo
//
//  Created by 岑裕 on 16/4/26.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import "QINIULivePlaying.h"
#import "PLPlayerKit.h"

@interface QINIULivePlaying ()

@property (nonatomic, strong) PLPlayer *player;
@property (nonatomic, strong) NSString *currentMediaURL;

@end

@implementation QINIULivePlaying

- (instancetype)initPlaying:(NSString *)mediaURL {
    self = [super init];
    if (self) {
        self.currentMediaURL = mediaURL;
        self.player = [[PLPlayer alloc] initWithURL:[NSURL URLWithString:self.currentMediaURL] option:nil];
        self.player.playerView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)startPlaying {
    [self.player play];
}

- (void)pausePlaying {
    [self.player pause];
}

- (void)resumePlaying {
    [self.player resume];
}

- (void)destroyPlaying {
    [self.player stop];
    self.currentMediaURL = nil;
}

- (UIView *)currentLiveView {
    return self.player.playerView;
}

@end
