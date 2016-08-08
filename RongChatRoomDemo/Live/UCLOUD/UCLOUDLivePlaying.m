////
////  UCLOUDLivePlaying.m
////  RongChatRoomDemo
////
////  Created by 杜立召 on 16/6/21.
////  Copyright © 2016年 rongcloud. All rights reserved.
////
//
//#import "UCLOUDLivePlaying.h"
//#import "UCloudPlayback.h"
//
//@implementation UCLOUDLivePlaying
//
//- (instancetype)initPlaying:(NSString *)mediaURL inView:(UIView *)displayView{
//    self = [super init];
//    if (self) {
//        self.currentMediaURL = mediaURL;
//        self.mediaPlayer = [UCloudMediaPlayer ucloudMediaPlayer];
//        self.mediaPlayer.defaultScalingMode = MPMovieScalingModeAspectFill;
//        [self.mediaPlayer showMediaPlayer:mediaURL urltype:UrlTypeAuto frame:CGRectNull view:displayView completion:^(NSInteger defaultNum, NSArray *data) {
//            if (self.mediaPlayer) {
//                
//            }
//        }];
//
//    }
//    return self;
//}
//- (void)showInview:(UIView *)view definition:(void(^)(NSInteger defaultNum, NSArray *data))block{
//    [self.mediaPlayer showInview:view definition:block ];
//}
//
//- (void)startPlaying {
//    [self.mediaPlayer.player prepareToPlay];
//    [self.mediaPlayer.player play];
//}
//
//- (void)pausePlaying {
//    [self.mediaPlayer.player pause];
//}
//
//- (void)resumePlaying {
//    [self.mediaPlayer.player play];
//}
//
//- (void)destroyPlaying {
//    [self.mediaPlayer.player stop];
//}
//
//- (UIView *)currentLiveView {
//    return self.mediaPlayer.player.view;
//}
//
//@end
