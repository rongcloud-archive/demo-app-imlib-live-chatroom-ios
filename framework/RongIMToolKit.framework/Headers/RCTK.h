//
//  RCTK.h
//  RongIMToolKit
//
//  Created by 杜立召 on 16/1/20.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCInputBarTheme.h"

@interface RCTK : NSObject
/*!
 语音消息的最大长度
 
 @discussion 默认值是60s，有效值为不小于5秒，不大于60秒
 */
@property(nonatomic, assign) NSUInteger maxVoiceDuration;

@property(nonatomic, strong) RCInputBarTheme *theme;

/*!
 APP是否独占音频
 
 @discussion 默认是NO,录音结束之后会调用AVAudioSession 的 setActive:NO ，
 恢复其他后台APP播放的声音，如果设置成YES,不会调用 setActive:NO，这样不会中断当前APP播放的声音
 (如果当前APP 正在播放音频，这时候如果调用SDK 的录音，可以设置这里为YES)
 */
@property(nonatomic, assign) BOOL isExclusiveSoundPlayer;

+ (instancetype)sharedRCTK;
/**
 初始化 SDK。
 
 @param appKey   从开发者平台申请的应用 appKey。
 @param userId   登录融云的userId。
 */
- (void)initWithAppKey:(NSString *)appKey andUserId:(NSString *)userId;
- (NSString *)getEmotionDocmentsPath;


@end
