//
//  RCLocalNotification.m
//  RongIMKit
//
//  Created by xugang on 15/1/22.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCLocalNotification.h"
#import <UIKit/UIKit.h>

static RCLocalNotification *__rc__LocalNotification = nil;

@interface RCLocalNotification ()

@property(nonatomic, strong) UILocalNotification *localNotification;

@end

@implementation RCLocalNotification

+ (RCLocalNotification *)defaultCenter {
    @synchronized(self) {
        if (nil == __rc__LocalNotification) {
            __rc__LocalNotification = [[[self class] alloc] init];
        }
    }

    return __rc__LocalNotification;
}

- (void)postLocalNotification:(NSString *)formatMessage userInfo:(NSDictionary *)userInfo {
    if (nil == _localNotification) {
        _localNotification = [[UILocalNotification alloc] init];
    }
    NSDate *_fireDate = [NSDate date];
    _localNotification.timeZone = [NSTimeZone defaultTimeZone];
    _localNotification.repeatInterval = kCFCalendarUnitDay;

    _localNotification.alertAction = NSLocalizedStringFromTable(@"LocalNotificationShow", @"RongCloudKit", nil);
    _localNotification.alertBody = formatMessage;
    _localNotification.fireDate = _fireDate;
    _localNotification.userInfo = userInfo;

    [_localNotification setSoundName:UILocalNotificationDefaultSoundName];

    // NSDictionary *dict = @{@"key1": [NSString stringWithFormat:@"%d",RC_KIT_LOCAL_NOTIFICATION_TAG]};
    //[localNotify setUserInfo:dict];
    [[UIApplication sharedApplication] presentLocalNotificationNow:_localNotification];
}
@end
