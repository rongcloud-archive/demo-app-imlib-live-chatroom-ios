//
//  VoiceCaptureView.h
//  iOS-IMKit
//
//  Created by xugang on 7/4/14.
//  Copyright (c) 2014 Heq.Shinoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RCVoiceRecorder.h"

@protocol RCVoiceCaptureControlDelegate <NSObject>

- (void)RCVoiceCaptureControlTimeout:(double)duration;

@optional

-(void)RCVoiceCaptureControlTimeUpdate:(double)duration;

@end

@interface RCVoiceCaptureControl : UIView

@property(nonatomic, weak) id<RCVoiceCaptureControlDelegate> delegate;

@property(nonatomic, readonly, copy) NSData *stopRecord;
@property(nonatomic, readonly, assign) double duration;

- (void)startRecord;
- (void)cancelRecord;
- (void)showCancelView;
- (void)hideCancelView;
- (void)showMsgShortView;
@end
