//
//  LCActivityLiveItem.h
//  LECPlayerSDK
//
//  Created by 侯迪 on 10/11/15.
//  Copyright (c) 2015 letv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCActivityItem.h"

typedef NS_ENUM(NSInteger, LCActivityLiveStatus) {
    LCActivityLiveStatusUnknown = -1,
    LCActivityLiveStatusUnused = 0,
    LCActivityLiveStatusUsing = 1,
    LCActivityLiveStatusEnd = 3
};

@interface LCActivityLiveItem : NSObject

@property (nonatomic, assign) NSInteger livePositionNumber;
@property (nonatomic, assign) LCActivityLiveStatus status;
@property (nonatomic, strong) NSString *liveId;
@property (nonatomic, strong) NSString *previewStreamId;
@property (nonatomic, strong) NSString *previewRTMPUrl;

- (id) initWithDict:(NSDictionary *) dict;

@end
