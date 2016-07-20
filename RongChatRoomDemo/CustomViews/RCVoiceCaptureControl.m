//
//  VoiceCaptureView.m
//  iOS-IMKit
//
//  Created by xugang on 7/4/14.
//  Copyright (c) 2014 Heq.Shinoda. All rights reserved.
//

#import "RCVoiceCaptureControl.h"
#import "RCKitUtility.h"
#import "RCVoiceRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import "RCIM.h"
#import "RCKitCommonDefine.h"

@interface RCVoiceCaptureControl () <RCVoiceRecorderDelegate>

@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIImageView *microPhoneView;
@property(nonatomic, strong) UILabel *escapeTimeLabel;
@property(nonatomic, strong) UILabel *TextLabel;
@property(nonatomic, strong) RCVoiceRecorder *myRecorder;
@property(nonatomic, strong) UIView *recordCancelView;
@property(nonatomic, strong) NSData *wavAudioData;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) double escapeTime;
@property(nonatomic, assign) double seconds;
@property(nonatomic, assign) BOOL isStopped;

@end
@implementation RCVoiceCaptureControl

- (instancetype)initWithFrame:(CGRect)frame {

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleAppSuspend)
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];
    // frame = CGRectMake(frame.origin.x, frame.origin.y,160.0f, 160.0f);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        // self.userInteractionEnabled = YES;
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
        [self addSubview:self.contentView];

        [self.contentView setCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)];

        self.microPhoneView = [[UIImageView alloc] initWithFrame:CGRectMake(50.0f, 10.0f, 60.0f, 60.0f)];
        self.escapeTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 75.0f, 160, 30)];
        self.TextLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 110, 150, 30)];

        [self.contentView addSubview:self.microPhoneView];
        [self.contentView addSubview:self.escapeTimeLabel];
        [self.contentView addSubview:self.TextLabel];

        [self.escapeTimeLabel setBackgroundColor:[UIColor clearColor]];
        [self.escapeTimeLabel setTextColor:[UIColor whiteColor]];
        [self.escapeTimeLabel setTextAlignment:NSTextAlignmentCenter];
        [self.TextLabel setBackgroundColor:[UIColor clearColor]];
        [self.TextLabel setTextColor:[UIColor whiteColor]];
        [self.TextLabel setTextAlignment:NSTextAlignmentCenter];
        [self.TextLabel setFont:[UIFont systemFontOfSize:13.5f]];

        [self.TextLabel setText:NSLocalizedStringFromTable(@"slide_up_to_cancel_title", @"RongCloudKit", nil)];
        UIImage *image = [RCKitUtility imageNamed:@"voice_volume0" ofBundle:@"RongCloud.bundle"];
        [self.microPhoneView setImage:image];

        self.contentView.backgroundColor = [UIColor blackColor];
        [self.contentView setAlpha:0.7f];

        self.contentView.layer.cornerRadius = 4;
        self.contentView.layer.masksToBounds = YES;

        _myRecorder = [RCVoiceRecorder defaultVoiceRecorder];
        self.escapeTime = [RCIM sharedRCIM].maxVoiceDuration;
        self.seconds = 0;
        self.isStopped = NO;

        [self createCancelView];
        self.recordCancelView.hidden = YES;
    }
    return self;
}
- (void)showMsgShortView {
    UIView *msgShortView = [[UIView alloc]initWithFrame:self.contentView.bounds];
    [msgShortView setBackgroundColor:[UIColor blackColor]];
    
    UIImage *_image = [RCKitUtility imageNamed:@"audio_press_short" ofBundle:@"RongCloud.bundle"];
    UIImageView *imageView_ = [[UIImageView alloc]initWithImage:_image];
    CGFloat x = (msgShortView.frame.size.width - _image.size.width)/2 + 10;
    CGFloat y = (msgShortView.frame.size.height - _image.size.height)/2 + 10;
    [imageView_ setCenter:CGPointMake(x, y)];

    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 110, 150, 30)];
    
    [textLabel setText:NSLocalizedStringFromTable(@"message_too_short", @"RongCloudKit", nil)];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setFont:[UIFont systemFontOfSize:13.5f]];
    
    textLabel.layer.cornerRadius = 4;
    textLabel.layer.masksToBounds = YES;
    
    [msgShortView addSubview:imageView_];
    [msgShortView addSubview:textLabel];
    
    [self.contentView addSubview:msgShortView];
}
- (void)showCancelView {
    self.recordCancelView.hidden = NO;
}
- (void)hideCancelView
{
    self.recordCancelView.hidden = YES;
}
- (void)createCancelView {
    self.recordCancelView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    [self.recordCancelView setBackgroundColor:[UIColor blackColor]];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50.0f, 10.0f, 60.0f, 60.0f)];
    imageView.image = [RCKitUtility imageNamed:@"voice_record_cancel" ofBundle:@"RongCloud.bundle"];
    //[UIImage imageNamed:@"voice_record_cancel"];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 110, 150, 30)];

    [textLabel setText:NSLocalizedStringFromTable(@"release_to_cancel_title", @"RongCloudKit", nil)];
    [textLabel setFont:[UIFont systemFontOfSize:13.5f]];
    [textLabel setBackgroundColor:[UIColor redColor]];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];

    textLabel.layer.cornerRadius = 4;
    textLabel.layer.masksToBounds = YES;

    [_recordCancelView addSubview:imageView];
    [_recordCancelView addSubview:textLabel];

    [self.contentView addSubview:_recordCancelView];
}

- (void)setSeconds:(double)seconds {
    _seconds = seconds;
    
    int leftTime = ceil(self.escapeTime - self.seconds);
    if (leftTime <= 10) {
        [self.escapeTimeLabel setText:[NSString stringWithFormat:@"%d", leftTime]];
        self.escapeTimeLabel.hidden = NO;
    } else {
        self.escapeTimeLabel.hidden = YES;
    }
    
    if (self.escapeTime < self.seconds) {
        if ([self.delegate respondsToSelector:@selector(RCVoiceCaptureControlTimeout:)]) {
            [self.delegate RCVoiceCaptureControlTimeout:self.escapeTime];
        }
    }
    if ([self.delegate respondsToSelector:@selector(RCVoiceCaptureControlTimeUpdate:)]) {
        [self.delegate RCVoiceCaptureControlTimeUpdate:_seconds];
    }
}

- (void)setVoiceVolume {
}

- (void)startRecord {

    //判断是否有麦克风权限
    __block BOOL bCanRecord = NO;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending) {

        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:)
                               withObject:^(BOOL granted) {
                                 if (granted) {
                                     bCanRecord = YES;
                                 } else {
                                     bCanRecord = NO;
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                       UIAlertView *alertView = [[UIAlertView alloc]
                                                                 initWithTitle:NSLocalizedStringFromTable(@"AccessRightTitle", @"RongCloudKit", nil)

                                                     message:NSLocalizedStringFromTable(@"speakerAccessRight",
                                                                                        @"RongCloudKit", nil)
                                                    delegate:nil
                                           cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @"RongCloudKit", nil)
                                           otherButtonTitles:nil, nil];
                                       [alertView show];
                                     });
                                 }
                               }];
        }
    }
    //如果没有权限则跳出方法
    if (!bCanRecord) {

        return;
    }

    //显示UI
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];

    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                                  target:self
                                                selector:@selector(scheduleOperarion)
                                                userInfo:nil
                                                 repeats:YES];
    [self.myRecorder startRecordWithObserver:self];
    self.seconds = 0;
    [self.timer fire];
}

- (void)cancelRecord {
    [self.myRecorder cancelRecord];
    [self.timer invalidate];
    self.timer = nil;
    [self removeFromSuperview];
}

- (NSData *)stopRecord {
    if (self.isStopped) {
        return nil;
    } else {
        [self.timer invalidate];
        self.timer = nil;
        __block NSData *_wavData = nil;
        __block NSTimeInterval ses = 0.0f;
        [self.myRecorder stopRecord:^(NSData *wavData, NSTimeInterval secs) {
            _wavData = wavData;
            ses = secs;
        }];
        if (self.escapeTime < self.seconds) {
            _duration = self.escapeTime;
        } else {
            _duration = ses;
        }
        _wavAudioData = _wavData;
        self.isStopped = YES;
        return _wavData;
    }
}

- (void)RCVoiceAudioRecorderDidFinishRecording:(BOOL)success {
    DebugLog(@"%s: %d", __FUNCTION__, success);
}

- (void)RCVoiceAudioRecorderEncodeErrorDidOccur:(NSError *)error {
    DebugLog(@"%s", __FUNCTION__);
}

- (void)scheduleOperarion {
    self.seconds += 0.02;
    float volume = [_myRecorder updateMeters];
    // DebugLog(@"volume>>> %f", volume);
    if (volume > 0.1f && volume < 0.70f) {
        UIImage *image = [RCKitUtility imageNamed:@"voice_volume0" ofBundle:@"RongCloud.bundle"];
        [self.microPhoneView setImage:image];
    } else if (volume >= 0.70f && volume < 0.75f) {
        UIImage *image = [RCKitUtility imageNamed:@"voice_volume1" ofBundle:@"RongCloud.bundle"];
        [self.microPhoneView setImage:image];
    } else if (volume >= 0.75f && volume < 0.80f) {
        UIImage *image = [RCKitUtility imageNamed:@"voice_volume2" ofBundle:@"RongCloud.bundle"];
        [self.microPhoneView setImage:image];
    } else if (volume >= 0.80f && volume < 0.90f) {
        UIImage *image = [RCKitUtility imageNamed:@"voice_volume3" ofBundle:@"RongCloud.bundle"];
        [self.microPhoneView setImage:image];
    } else if (volume >= 0.90f && volume <= 1.0f) {
        UIImage *image = [RCKitUtility imageNamed:@"voice_volume4" ofBundle:@"RongCloud.bundle"];
        [self.microPhoneView setImage:image];
    }
}

-(void)handleAppSuspend
{
    [self cancelRecord];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

@end
