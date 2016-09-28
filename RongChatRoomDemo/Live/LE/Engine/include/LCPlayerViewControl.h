//
//  LCPlayerViewControl.h
//  NetRequestDemo
//
//  Created by CC on 15/9/16.
//  Copyright (c) 2015年 CC. All rights reserved.
//

#import "LCPlayerControl.h"



typedef NS_ENUM(int, LCPlayerMediaType) {
    LCPlayerMediaTypeRTMP,
    LCPlayerMediaTypeHLS,
    LCPlayerMediaTypeFLV
};


@interface LCPlayerViewControl : LCPlayerControl

@property (nonatomic, assign) BOOL enableVODResumePlay;//是否启用续播功能,Default is NO;
@property (nonatomic, assign) BOOL enableDownload;//是否启用下载,Default is YES,在注册播放器前设置;

//播放器视图初始化创建
- (UIView *)createPlayerWithOwner:(id)owner
                            frame:(CGRect)frame;

//注册直播播放器,播放直播ID
- (BOOL)registerLivePlayerWithId:(NSString *)pId
                       mediaType:(LCPlayerMediaType)mediaType;

- (BOOL)registerLivePlayerWithId:(NSString *)pId
                       mediaType:(LCPlayerMediaType)mediaType
                          option:(LCPlayerOption *)option;//业务信息,可以为nil

//注册直播播放器播放StreamID
- (BOOL)registerLivePlayerWithStreamId:(NSString *)pId
                             mediaType:(LCPlayerMediaType)mediaType;

- (BOOL)registerLivePlayerWithStreamId:(NSString *)pId
                             mediaType:(LCPlayerMediaType)mediaType
                                option:(LCPlayerOption *)option;//业务信息,可以为nil


//注册点播播放器
- (BOOL)registerVodPlayerWithUU:(NSString *)uu
                             vu:(NSString *)vu;

- (BOOL)registerVodPlayerWithUU:(NSString *)uu
                             vu:(NSString *)vu
                         option:(LCPlayerOption *)option;//业务信息,如业务线p=xxx

@end
