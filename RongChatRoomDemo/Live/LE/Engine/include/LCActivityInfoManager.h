//
//  LCActivityInfoManager.h
//  LECPlayerSDK
//
//  Created by 侯迪 on 10/11/15.
//  Copyright (c) 2015 letv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCActivityItem.h"
#import "LCActivityConfigItem.h"
#import "LECPlayer.h"
#import "LECActivityPlayer.h"
#import "LECLivingPlayer.h"
#import "LCActivityItem.h"

typedef NS_ENUM(NSInteger, LCActivityEvent) {
    LCActivityEventActivityConfigUpdate = 0,
    LCActivityEventOnlineAudiencesNumberUpdate = 1,
};

typedef NS_ENUM(NSInteger, LCActivityRegisterStatus) {
    LCActivityRegisterStatusNone = 0,           //未初始化
    LCActivityRegisterStatusRegistering = 1,    //初始化中
    LCActivityRegisterStatusReady = 2           //注册完成
};

typedef void (^ActivityInfoRequestCompletionBlock)(BOOL success);

@class LCActivityInfoManager;

@protocol LCActivityManagerDelegate <NSObject>

@optional
- (void) activityManager:(LCActivityInfoManager *) manager event:(LCActivityEvent) event;

@end

@interface LCActivityInfoManager : NSObject

@property (nonatomic, readonly) NSString *activityId;
@property (nonatomic, readonly) LCActivityItem *activityItem;
@property (nonatomic, readonly) LCActivityConfigItem *activityConfigItem;
@property (nonatomic, readonly) NSInteger onlineAudiencesNumber;
@property (nonatomic, readonly) LCActivityRegisterStatus activityRegisterStatus;
@property (nonatomic, weak) id<LCActivityManagerDelegate> delegate;


+ (id) sharedManager;
- (BOOL)registerActivityWithActivityId:(NSString *) activityId completion:(ActivityInfoRequestCompletionBlock)completion;
- (BOOL)registerActivityWithActivityId:(NSString *) activityId
                                option:(LCPlayerOption *)option
                            completion:(ActivityInfoRequestCompletionBlock)completion;
- (void)releaseActivity;
- (BOOL)requestActivityStatus:(void (^)(BOOL requestSuccess, LCActivityStatus activityStatus))completion;
- (BOOL)reportActivityWithActivityId:(NSString *) activityId completion:(ActivityInfoRequestCompletionBlock)completion;

@end
