//
//  KSYLivePlaying.m
//  RongChatRoomDemo
//
//  Created by 岑裕 on 16/4/25.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import "KSYLivePlaying.h"
#import <KSYMediaPlayer/KSYMediaPlayer.h>
#import <CommonCrypto/CommonDigest.h>

@interface KSYLivePlaying ()

@property (nonatomic, strong) NSString *currentMediaURL;
@property (nonatomic, strong) KSYMoviePlayerController *player;

@end

@implementation KSYLivePlaying

- (instancetype)initPlaying:(NSString *)mediaURL {
    self = [super init];
    if (self) {
        [self initKSYAuth];
        self.currentMediaURL = mediaURL;
        NSString *urlStr =[NSString stringWithFormat:@"%@", mediaURL];
        NSURL *url = [NSURL URLWithString:urlStr];
        self.player = [[KSYMoviePlayerController alloc] initWithContentURL:url];
        self.player.scalingMode = MPMovieScalingModeAspectFill;
    }
    return self;
}

- (void)initKSYAuth {
    NSString *time = [NSString stringWithFormat:@"%d",(int)[[NSDate date]timeIntervalSince1970]];
    NSString *sk = [NSString stringWithFormat:@"sff25dc4a428479ff1e20ebf225d113%@", time];
    NSString *sksign = [self MD5:sk];
    [[KSYPlayerAuth sharedInstance]setAuthInfo:@"QYA0EEF0FDDD38C79913" accessKey:@"abc73bb5ab2328517415f8f52cd5ad37" secretKeySign:sksign timeSeconds:time];
}

- (NSString *)MD5:(NSString*)raw {
    const char *pointer = [raw UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(pointer, (CC_LONG)strlen(pointer), md5Buffer);
    
    NSMutableString *string = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [string appendFormat:@"%02x",md5Buffer[i]];
    
    return string;
}

- (void)startPlaying {
    [self.player prepareToPlay];
    [self.player play];
}

- (void)pausePlaying {
    [self.player pause];
}

- (void)resumePlaying {
    [self.player play];
}

- (void)destroyPlaying {
    [self.player stop];
}

- (UIView *)currentLiveView {
    return self.player.view;
}

@end
