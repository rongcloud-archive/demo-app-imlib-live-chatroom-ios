//
//  LCActivityPlayerViewControl.h
//  LECPlayerSDKDemo
//
//  Created by CC on 15/10/13.
//  Copyright © 2015年 letv. All rights reserved.
//

#import "LCPlayerControl.h"



@interface LCActivityPlayerViewControl : LCPlayerControl


//播放器视图初始化创建
- (UIView *)createPlayerWithOwner:(id)owner
                            frame:(CGRect)frame;

//注册活动直播播放器
- (BOOL)registerActivityLivePlayerWithId:(NSString *)pId;

- (BOOL)registerActivityLivePlayerWithId:(NSString *)pId
                                  option:(LCPlayerOption *)option;//业务信息,可以为nil

@end
