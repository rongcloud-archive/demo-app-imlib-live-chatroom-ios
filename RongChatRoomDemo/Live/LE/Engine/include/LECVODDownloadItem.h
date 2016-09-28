//
//  LECVODDownloadItem.h
//  LeClouldLivingPlayer
//
//  Created by 侯迪 on 3/26/15.
//  Copyright (c) 2015 letv. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LECVODDownloadItemStatus) {
    LECVODDownloadItemStatusInit            = 0,
    LECVODDownloadItemStatusWaitting        = 1,
    LECVODDownloadItemStatusDownloading     = 2,
    LECVODDownloadItemStatusDownloadFinish  = 3,
    LECVODDownloadItemStatusDownloadPause   = 4,
    LECVODDownloadItemStatusDownloadFail    = 5
};

@interface LECVODDownloadItem : NSObject

@property (nonatomic, readonly) int64_t downloadedSize;
@property (nonatomic, readonly) int64_t totalSize;
@property (nonatomic, readonly) float percent;
@property (nonatomic, readonly) float speed;
@property (nonatomic, readonly) LECVODDownloadItemStatus status;
@property (nonatomic, strong) NSString *rateType;
@property (nonatomic, strong) NSString * uu;
@property (nonatomic, strong) NSString * vu;
@property (nonatomic, strong) NSString * payCheckCode;
@property (nonatomic, strong) NSString * payUserName;
@property (nonatomic, strong) NSString * videoName;
@property (nonatomic, strong) NSDictionary * userInfo;
@property (nonatomic, readonly) NSString *errorCode;
@property (nonatomic, readonly) NSString *errorDesc;
@property (nonatomic, readonly) BOOL isInterrupted;

@end
