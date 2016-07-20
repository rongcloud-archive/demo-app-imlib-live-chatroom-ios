//
//  RCVoiceMessageCell.m
//  RongIMKit
//
//  Created by xugang on 15/2/2.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCVoiceMessageCell.h"
#import "RCVoicePlayer.h"
#import <RongIMLib/RongIMLib.h>
#import "RCKitUtility.h"
#import "RCIM.h"
#import "RCKitCommonDefine.h"



NSString *const kNotificationStopVoicePlayer = @"kNotificationStopVoicePlayer";

static NSTimer *s_previousAnimationTimer = nil;
static UIImageView *s_previousPlayVoiceImageView = nil;
static RCMessageDirection s_previousMessageDirection;
static long s_messageId = 0;

@interface RCVoiceMessageCell () <RCVoicePlayerObserver>
@property(nonatomic) long duration;

@property(nonatomic) CGSize voiceViewSize;

@property(nonatomic, strong) NSTimer *animationTimer;
@property(nonatomic) int animationIndex;
@property(nonatomic, strong) RCVoicePlayer *voicePlayer;

- (void)initialize;

- (void)scheduleAnimationOperation;
- (void)enableCurrentAnimationTimer;
- (void)disableCurrentAnimationTimer;
- (void)disablePreviousAnimationTimer;

- (void)startPlayingVoiceData;
- (void)stopPlayingVoiceData;
- (void)resetActiveEventInBackgroundMode;

- (void)tapBubbleBackgroundViewEvent:(UIGestureRecognizer *)gestureRecognizer;
- (void)receivedVoIPRunningStateNotification:(NSNotification *)notification;
@end

@implementation RCVoiceMessageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.playVoiceView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.voiceDurationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.voiceDurationLabel setTextAlignment:NSTextAlignmentCenter];
    self.voiceDurationLabel.textColor = HEXCOLOR(0xe8e8e8);
    [self.bubbleBackgroundView addSubview:self.playVoiceView];
    [self.bubbleBackgroundView addSubview:self.voiceDurationLabel];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self.bubbleBackgroundView addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *bubbleBackgroundViewTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBubbleBackgroundViewEvent:)];
    bubbleBackgroundViewTap.numberOfTapsRequired = 1;
    bubbleBackgroundViewTap.numberOfTouchesRequired = 1;
    [self.bubbleBackgroundView addGestureRecognizer:bubbleBackgroundViewTap];
    self.bubbleBackgroundView.userInteractionEnabled = YES;

    self.voicePlayer = [RCVoicePlayer defaultPlayer];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetActiveEventInBackgroundMode)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
#if RC_VOIP_ENABLE
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedVoIPRunningStateNotification:)
                                                 name:kVoIPRunningStateNotification
                                               object:nil];
#endif
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetActiveEventInBackgroundMode)
                                                 name:kNotificationStopVoicePlayer
                                               object:nil];
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];

    if (s_messageId == self.model.messageId) {
        if ((self.voicePlayer.isPlaying)) {
            [self disableCurrentAnimationTimer];
            [self enableCurrentAnimationTimer];
        }
    }else{
        [self disableCurrentAnimationTimer];
    }
    
    RCVoiceMessage *_voiceMessage = (RCVoiceMessage *)model.content;
    if (_voiceMessage) {
        self.duration = _voiceMessage.duration;
        self.voiceDurationLabel.text = [NSString stringWithFormat:@"%ld''", self.duration];
        [self.voiceDurationLabel setTextAlignment:NSTextAlignmentCenter];
    } else {
//        DebugLog(@"[RongIMKit]: RCMessageModel.content is NOT RCVoiceMessage object");
    }

    CGFloat audioLength = self.duration;
    CGFloat audioBubbleWidth =
        kAudioBubbleMinWidth + (kAudioBubbleMaxWidth - kAudioBubbleMinWidth) * audioLength / [RCIM sharedRCIM].maxVoiceDuration;

    CGRect messageContentViewRect = self.messageContentView.frame;
    [self.voiceUnreadTagView removeFromSuperview];
    self.voiceUnreadTagView.image=nil;
    [self.voiceUnreadTagView setHidden: YES];
    if (MessageDirection_RECEIVE == model.messageDirection) {
        messageContentViewRect.size.width = audioBubbleWidth;
        messageContentViewRect.size.height = 36;
        self.messageContentView.frame = messageContentViewRect;
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, audioBubbleWidth, 36);
        self.bubbleBackgroundView.image = [RCKitUtility imageNamed:@"chat_from_bg_normal" ofBundle:@"RongCloud.bundle"];
        self.playVoiceView.frame = CGRectMake(20, 10, 16, 16);
        self.playVoiceView.image = [RCKitUtility imageNamed:@"from_voice_play" ofBundle:@"RongCloud.bundle"];
        self.voiceDurationLabel.frame = CGRectMake(CGRectGetMaxX(self.bubbleBackgroundView.frame)-36, 0, 36, 36);
        self.voiceDurationLabel.textColor = HEXCOLOR(0x8c8c8c);
        //self.voiceUnreadTagView.hidden=YES;
        if (ReceivedStatus_LISTENED != self.model.receivedStatus) {
            self.voiceUnreadTagView = [[UIImageView alloc] initWithFrame:CGRectZero];
            self.voiceUnreadTagView.backgroundColor = [UIColor clearColor];
            [self.voiceUnreadTagView setHidden: NO];
            [self.messageContentView addSubview:self.voiceUnreadTagView];
            self.voiceUnreadTagView.image = [RCKitUtility imageNamed:@"voice_unread" ofBundle:@"RongCloud.bundle"];
            CGRect voiceDurationLabelFrame = self.voiceDurationLabel.frame;
            UIImage *unreadImage = self.voiceUnreadTagView.image;
            CGFloat x = voiceDurationLabelFrame.origin.x + voiceDurationLabelFrame.size.width + 5;
            CGFloat y = (voiceDurationLabelFrame.size.height - unreadImage.size.height) / 2;
            CGFloat w = unreadImage.size.width;
            CGFloat h = unreadImage.size.height;
            self.voiceUnreadTagView.frame = CGRectMake(x, y, w, h);
        }
        UIImage *image = self.bubbleBackgroundView.image;
        self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image
            resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8,image.size.height * 0.2, image.size.width * 0.2)];
    } else {
        self.voiceDurationLabel.textColor = HEXCOLOR(0xe8e8e8);
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, audioBubbleWidth, 36);
        self.bubbleBackgroundView.image = [RCKitUtility imageNamed:@"chat_to_bg_normal" ofBundle:@"RongCloud.bundle"];
        self.playVoiceView.frame = CGRectMake(audioBubbleWidth - (20 + 16), 10, 16, 16);
        self.playVoiceView.image = [RCKitUtility imageNamed:@"to_voice_play" ofBundle:@"RongCloud.bundle"];
        self.voiceDurationLabel.frame = CGRectMake(3, 0, 36, 36);
        CGRect statusFrame = self.statusContentView.frame;
        statusFrame.origin.x = statusFrame.origin.x +15;
        [self.statusContentView setFrame:statusFrame];
        [self.voiceUnreadTagView setHidden: YES];
        UIImage *image = self.bubbleBackgroundView.image;
        self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image
            resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.2,
                                                         image.size.height * 0.2, image.size.width * 0.8)];
        messageContentViewRect.size.width = audioBubbleWidth;
        messageContentViewRect.size.height = 36;
        messageContentViewRect.origin.x = self.baseContentView.bounds.size.width -
        (messageContentViewRect.size.width + 8 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10);
        self.messageContentView.frame = messageContentViewRect;
    }
}

#pragma mark - stop and disable timer during VoIP.
- (void)receivedVoIPRunningStateNotification:(NSNotification *)notification {
    BOOL isRunning_VoIP = [notification.object boolValue];
    if (isRunning_VoIP) {
        [self stopPlayingVoiceData];
        [self disableCurrentAnimationTimer];
    }
}

#pragma mark - stop and disable timer during background mode.
- (void)resetActiveEventInBackgroundMode {
    [self stopPlayingVoiceData];
    [self disableCurrentAnimationTimer];
}

/**
 *  @override, implement the playing animation indicator after tapping voice message cell.
 *
 *  @param gestureRecognizer, UITapGestureRecognizer that added for bubbleBackgroundView in super class.
 */
- (void)tapBubbleBackgroundViewEvent:(UIGestureRecognizer *)gestureRecognizer {
//    DebugLog(@"%s", __FUNCTION__);

    [self playVoice];
   
}

- (void)playVoice{
    if (self.voiceUnreadTagView) {
        [self.voiceUnreadTagView removeFromSuperview];
        self.voiceUnreadTagView = nil;
//        [[RCIMClient sharedRCIMClient] setMessageReceivedStatus:self.model.messageId
//                                                 receivedStatus:ReceivedStatus_LISTENED];
    }
    
    [self disablePreviousAnimationTimer];
    [self enableCurrentAnimationTimer];
    
    if (self.model.messageId == s_messageId) {
        if (self.voicePlayer.isPlaying) {
            [self.voicePlayer stopPlayVoice];
            [self disablePreviousAnimationTimer];
        }else{
            [self startPlayingVoiceData];
        }
    }else{
        [self startPlayingVoiceData];
    }
    
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

// override
- (void)msgStatusViewTapEventHandler:(id)sender {

    // to do something.
}

- (void)startPlayingVoiceData {
    RCVoiceMessage *_voiceMessage = (RCVoiceMessage *)self.model.content;

    if (_voiceMessage.wavAudioData) {

        /**
         *  if the previous voice message is playing, then
         *  stop it and reset the prevoius animation timer indicator
         */
        [self stopPlayingVoiceData];

//        BOOL bPlay = [self.voicePlayer playVoice:[@(self.model.messageId) stringValue]
//                                       voiceData:_voiceMessage.wavAudioData
//                                        observer:self];

        BOOL bPlay = [self.voicePlayer playVoice:self.model.conversationType
                                        targetId:self.model.targetId
                                       messageId:self.model.messageId
                                       direction:self.model.messageDirection
                                       voiceData:_voiceMessage.wavAudioData
                                        observer:self];
        // if failed to play the voice message, reset all indicator.
        if (!bPlay) {
            [self stopPlayingVoiceData];
            [self disableCurrentAnimationTimer];
        }
        
        s_messageId = self.model.messageId;
        
    } else {
        DebugLog(@"[RongIMKit]: RCVoiceMessage.voiceData is NULL");
    }
}
- (void)stopPlayingVoiceData {
    if (self.voicePlayer.isPlaying) {
        [self.voicePlayer stopPlayVoice];
    }
}
- (void)enableCurrentAnimationTimer {
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                           target:self
                                                         selector:@selector(scheduleAnimationOperation)
                                                         userInfo:nil
                                                          repeats:YES];
    [self.animationTimer fire];

    s_previousAnimationTimer = self.animationTimer;
    s_previousPlayVoiceImageView = self.playVoiceView;
    s_previousMessageDirection = self.model.messageDirection;
}

/**
 *  Implement the animation operation
 */
- (void)scheduleAnimationOperation {
    DebugLog(@"%s", __FUNCTION__);

    self.animationIndex++;

    NSString *_playingIndicatorIndex;

    if (MessageDirection_SEND == self.model.messageDirection) {
        _playingIndicatorIndex = [NSString stringWithFormat:@"to_voice_play%d", (self.animationIndex % 4)];
    } else {
        _playingIndicatorIndex = [NSString stringWithFormat:@"from_voice_play%d", (self.animationIndex % 4)];
    }
    DebugLog(@"_playingIndicatorIndex > %@", _playingIndicatorIndex);
    self.playVoiceView.image = [RCKitUtility imageNamed:_playingIndicatorIndex ofBundle:@"RongCloud.bundle"];
}

- (void)disableCurrentAnimationTimer {
    if (self.animationTimer && [self.animationTimer isValid]) {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
        self.animationIndex = 0;
    }

    /**
     *  reset the original image
     */
    if (MessageDirection_SEND == self.model.messageDirection) {
        self.playVoiceView.image = [RCKitUtility imageNamed:@"to_voice_play" ofBundle:@"RongCloud.bundle"];
    } else {
        self.playVoiceView.image = [RCKitUtility imageNamed:@"from_voice_play" ofBundle:@"RongCloud.bundle"];
    }
}
- (void)disablePreviousAnimationTimer {
    if (s_previousAnimationTimer && [s_previousAnimationTimer isValid]) {
        [s_previousAnimationTimer invalidate];
        s_previousAnimationTimer = nil;

        /**
         *  reset the previous playVoiceView indicator image
         */
        if (s_previousPlayVoiceImageView) {
            if (MessageDirection_SEND == s_previousMessageDirection) {
                s_previousPlayVoiceImageView.image =
                    [RCKitUtility imageNamed:@"to_voice_play" ofBundle:@"RongCloud.bundle"];
            } else {
                s_previousPlayVoiceImageView.image =
                    [RCKitUtility imageNamed:@"from_voice_play" ofBundle:@"RongCloud.bundle"];
            }
            s_previousPlayVoiceImageView = nil;
            s_previousMessageDirection = 0;
        }
    }
}

#pragma mark RCVoicePlayerObserver
- (void)PlayerDidFinishPlaying:(BOOL)isFinish {
    if (isFinish) {
        [self disableCurrentAnimationTimer];
    }
}
- (void)audioPlayerDecodeErrorDidOccur:(NSError *)error {
    [self disableCurrentAnimationTimer];
}

- (void)longPressed:(id)sender {
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        DebugLog(@"long press end");
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        [self.delegate didLongTouchMessageCell:self.model inView:self.bubbleBackgroundView];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
