//
//  LCVODDownloadManager.h
//  LECPlayerSDK
//
//  Created by 侯迪 on 10/26/15.
//  Copyright © 2015 letv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LECVODDownloadItem.h"

@class LCVODDownloadManager;

typedef NS_ENUM(int, LCVODDownloadManagerDefaultCodeSelectType) {
    LCVODDownloadManagerDefaultCodeSelectTypeHightest = 0,
    LCVODDownloadManagerDefaultCodeSelectTypeLowest = 1,
//    LCVODDownloadManagerDefaultCodeSelectTypeMiddle = 2
};

@protocol LCVODDownloadManagerDelegate <NSObject>

- (void) vodDownloadManager:(LCVODDownloadManager *) downloadManager didBeginDownloadVODDownloadItem:(LECVODDownloadItem *) vodDownloadItem;
- (void) vodDownloadManager:(LCVODDownloadManager *) downloadManager downloadingVODDownloadItem:(LECVODDownloadItem *) vodDownloadItem downloadedBytes:(long long) downloadedBytes totalBytes:(long long) totalBytes speed:(float) speed;
- (void) vodDownloadManager:(LCVODDownloadManager *) downloadManager didFinishDownloadVODDownloadItem:(LECVODDownloadItem *) vodDownloadItem;
- (void) vodDownloadManager:(LCVODDownloadManager *) downloadManager didFailDownloadVODDownloadItem:(LECVODDownloadItem *) vodDownloadItem withErrorCode:(NSString *) errorCode withErrorDesc:(NSString *) errorDesc;

@end

@interface LCVODDownloadManager : NSObject

@property (nonatomic, readonly) NSArray <LECVODDownloadItem *>*vodItemsList;
@property (nonatomic, weak) id<LCVODDownloadManagerDelegate> delegate;
@property (nonatomic, assign) LCVODDownloadManagerDefaultCodeSelectType defaultCodeSelectType;  //没有传入下载码率的下载任务会根据该值选择一个默认码率进行下载；默认选择的码率如果已经存在会直接报错，不会引起恢复的操作

+ (id) sharedManager;

- (LECVODDownloadItem *) createVODDownloadItemWithUu:(NSString *) uu
                                              withVu:(NSString *) vu
                                            userInfo:(NSDictionary *) dict
                             withExpectVideoCodeType:(NSString *) videoCodeType;    //如果传入nil，则会根据defaultCodeSelectType选择默认码率

- (LECVODDownloadItem *) createVODDownloadItemWithUu:(NSString *) uu
                                              withVu:(NSString *) vu
                                            userInfo:(NSDictionary *) dict
                             withExpectVideoCodeType:(NSString *) videoCodeType
                                    withPayCheckCode:(NSString *) payCheckCode
                                     withPayUserName:(NSString *) payUserName;

- (BOOL) startDownloadWithVODItem:(LECVODDownloadItem *) downloadItem;          //如果存在相同码率，则会返回错误
- (void) pauseDownloadWithVODItem:(LECVODDownloadItem *) downloadItem;
- (void) cleanDownloadWithVODItem:(LECVODDownloadItem *) downloadItem;
- (NSArray *) vodItemsListWithUu:(NSString *) uu vu:(NSString *) vu;

@end
