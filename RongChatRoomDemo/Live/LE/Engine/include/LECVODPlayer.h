//
//  LECVODPlayer.h
//  LECPlayerSDK
//
//  Created by 侯迪 on 9/13/15.
//  Copyright (c) 2015 letv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LECPlayer.h"

@interface LECVODPlayer : LECPlayer

- (BOOL) registerWithUu:(NSString *) uu
                     vu:(NSString *) vu
             completion:(void (^)(BOOL result))completion;

- (BOOL) registerWithUu:(NSString *) uu
                     vu:(NSString *) vu
           payCheckCode:(NSString *) payCheckCode
            payUserName:(NSString *) payUserName
             completion:(void (^)(BOOL result))completion;

- (BOOL) registerWithUu:(NSString *) uu
                     vu:(NSString *) vu
           payCheckCode:(NSString *) payCheckCode
            payUserName:(NSString *) payUserName
                options:(LCPlayerOption *)options//设置业务相关参数以及用户ID等,没有可以为nil
  onlyLocalVODAvaliable:(BOOL) onlyLocalVODAvaliable
resumeFromLastPlayPosition:(BOOL) resumeFromLastPlayPosition
 resumeFromLastRateType:(BOOL) resumeFromLastRateType
             completion:(void (^)(BOOL result))completion;


@property (nonatomic, readonly) NSString *uu;
@property (nonatomic, readonly) NSString *vu;
@property (nonatomic, readonly) NSString *payCheckCode;
@property (nonatomic, readonly) NSString *payUserName;
@property (nonatomic, readonly) NSString *videoTitle;
@property (nonatomic, readonly) BOOL allowDownload;
@property (nonatomic, readonly) BOOL resumeFromLastPlayPosition;
@property (nonatomic, readonly) BOOL resumeFromLastRateType;
@property (nonatomic, readonly) NSString *loadingIconUrl;
@property (nonatomic, readonly) BOOL isPanorama;

@end
