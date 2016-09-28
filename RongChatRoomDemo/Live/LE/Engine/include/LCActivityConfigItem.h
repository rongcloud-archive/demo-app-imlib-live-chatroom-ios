//
//  LCActivityConfigItem.h
//  LECPlayerSDK
//
//  Created by 侯迪 on 10/11/15.
//  Copyright (c) 2015 letv. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WaterMarkPosition) {
    WaterMarkPositionNone = 0,
    WaterMarkPositionLeftTop = 1,
    WaterMarkPositionRightTop = 2,
    WaterMarkPositionRightBottom = 3,
    WaterMarkPositionLeftBottom = 4
};

@interface LCActivityConfigItem : NSObject

@property (nonatomic, assign) WaterMarkPosition waterMarkPosition;
@property (nonatomic, strong) NSString *waterMarkUrl;
@property (nonatomic, assign) BOOL enableLogoDisplay;
@property (nonatomic, assign) BOOL enableShareOptionDisplay;
@property (nonatomic, assign) BOOL enableOnlineAudienceNumberDisplay;
@property (nonatomic, strong) NSString *logoUrl;
@property (nonatomic, assign) BOOL enableLoadingIcon;
@property (nonatomic, strong) NSString *loadingIconUrl;

- (id) initWithDict:(NSDictionary *) dict;

@end
