//
//  LCLivePlayInfoItem.h
//  LECPlayerSDK
//
//  Created by 侯迪 on 9/16/15.
//  Copyright (c) 2015 letv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCLivePlayInfoItem : NSObject

@property (nonatomic, assign) BOOL supportTimeShift;
@property (nonatomic, strong) NSDate *liveBeginDate;
@property (nonatomic, strong) NSString *liveId;
@property (nonatomic, strong) NSArray *streamItemsList;     //LCLiveStreamPlayInfoItem
@property (nonatomic, strong) NSString *videoTitle;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) long long baseServerTimestamp;
@property (nonatomic, strong) NSString * p;//业务ID

- (id) initWithLivePlayInfoDict:(NSDictionary *) dict;

@end
