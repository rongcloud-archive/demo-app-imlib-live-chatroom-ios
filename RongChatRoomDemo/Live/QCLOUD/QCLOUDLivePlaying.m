//
//  QCLOUDLivePlaying.m
//  RongChatRoomDemo
//
//  Created by 岑裕 on 16/4/26.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import "QCLOUDLivePlaying.h"
#import <TCPlayerSDK/TCPlayerSDK.h>

@interface QCLOUDLivePlaying ()<TCCanPlayAble>

@property (nonatomic, strong) NSString *currentMediaURL;
@property (nonatomic, strong) TCPlayerView *playerView;

@end

@implementation QCLOUDLivePlaying

- (instancetype)initPlaying:(NSString *)mediaURL {
    self = [super init];
    if (self) {
        self.currentMediaURL = mediaURL;
        self.playerView = [[TCPlayerView alloc] init];
    }
    return self;
}

- (void)startPlaying {
    [self.playerView play:self];
}

- (void)pausePlaying {
    [self.playerView pause];
}

- (void)resumePlaying {
    [self.playerView play];
}

- (void)destroyPlaying {
    [self.playerView stopAndRelease];
    self.currentMediaURL = nil;
}

- (UIView *)currentLiveView {
    return self.playerView;
}

- (NSString *)url {
    return self.currentMediaURL;
}

- (void)setUrl:(NSString *)url {
    self.currentMediaURL = url;
}

@end
