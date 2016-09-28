//
//  LECActivityPlayer.h
//  LECPlayerSDK
//
//  Created by 侯迪 on 10/12/15.
//  Copyright (c) 2015 letv. All rights reserved.
//

#import "LECPlayer.h"
#import "LECGlobalDefine.h"

@interface LECActivityPlayer : LECPlayer

- (id) initWithUsingVODMode:(BOOL) usingVodMode;

- (BOOL) registerWithLiveId:(NSString *) liveId
                 completion:(void (^)(BOOL result))completion;

- (BOOL) registerWithStreamId:(NSString *) streamId
                   completion:(void (^)(BOOL result))completion;

- (BOOL) registerWithLiveId:(NSString *) liveId
                isLetvMedia:(BOOL) isLetvMedia
                 options:(LCPlayerOption *)options//设置业务相关参数以及用户ID等,没有可以为nil
                 completion:(void (^)(BOOL result))completion;

- (BOOL) registerWithStreamId:(NSString *) streamId
                  isLetvMedia:(BOOL) isLetvMedia
                   options:(LCPlayerOption *)options//设置业务相关参数以及用户ID等,没有可以为nil
                   completion:(void (^)(BOOL result))completion;

- (BOOL) backToLiveWithCompletion:(void (^)())completion;

@property (nonatomic, readonly) NSInteger currentPlayTimestamp;
@property (nonatomic, readonly) NSInteger serverRealTimestamp;
@property (nonatomic, readonly) NSInteger streamStartTimestamp;
@property (nonatomic, readonly) NSInteger streamEndTimestamp;
@property (nonatomic, readonly) BOOL supportSeekOperation;
@property (nonatomic, readonly,strong) NSString * loadingIconUrl;

@end
