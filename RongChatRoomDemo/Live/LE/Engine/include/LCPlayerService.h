//
//  LCPlayerService.h
//  LECPlayerSDK
//
//  Created by 侯迪 on 12/17/15.
//  Copyright © 2015 letv. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, LCPlayerServiceLogLevel) {
    LCPlayerServiceLogLevelOff = 0,
    LCPlayerServiceLogLevelError = 1,
    LCPlayerServiceLogLevelWarning = 2,
    LCPlayerServiceLogLevelInfo = 3,
    LCPlayerServiceLogLevelDebug = 4,
    LCPlayerServiceLogLevelVerbose = 5
};

@interface LCPlayerService : NSObject

+ (LCPlayerService *) sharedService;

- (void) startService;
- (void) stopService;
- (NSString *) sdkVersion;
- (NSString *) sdkReleaseDate;
+ (NSString *) sdkBuildVersion;

//设置播放器相关控制台日志的级别
- (void)setConsoleLogLevel:(LCPlayerServiceLogLevel)consoleLogLevel;
//设置播放器相关文件日志的级别
- (void)setFileLogLevel:(LCPlayerServiceLogLevel)fileLogLevel;

@end
