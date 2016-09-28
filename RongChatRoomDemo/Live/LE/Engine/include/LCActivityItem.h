//
//  LCActivityItem.h
//  LECPlayerSDK
//
//  Created by 侯迪 on 10/11/15.
//  Copyright (c) 2015 letv. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LCActivityStatus) {
    LCActivityStatusUnknown = -1,
    LCActivityStatusUnStarted = 0,
    LCActivityStatusLiving = 1,
    LCActivityStatusSuspending = 2,
    LCActivityStatusEnd = 3
};

@interface LCActivityItem : NSObject

@property (nonatomic, strong) NSString *activityId;
@property (nonatomic, strong) NSString *activityName;
@property (nonatomic, strong) NSString *activityWebUrl;
@property (nonatomic, strong) NSString *activityDesc;
@property (nonatomic, strong) NSString *activityCoverImage;
@property (nonatomic, strong) NSArray *activityLiveItemList;    //ActivityLiveItem
@property (nonatomic, strong) NSString *ark;
@property (nonatomic, assign) LCActivityStatus status;
@property (nonatomic, assign) NSInteger beginTime;
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, strong) NSString *playMode;
@property (nonatomic, assign) BOOL isPanorama;

- (id) initWithDict:(NSDictionary *) dict;
- (id) initWithStatusDict:(NSDictionary *) dict;

@end
