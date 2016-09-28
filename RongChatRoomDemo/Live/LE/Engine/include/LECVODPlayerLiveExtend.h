//
//  LECVODPlayerLiveExtend.h
//  LECPlayerSDK
//
//  Created by 侯迪 on 12/15/15.
//  Copyright © 2015 letv. All rights reserved.
//
//  支持乐嗨需求，使用liveId获得已结束直播生成的点播hls

#import "LECVODPlayer.h"

@interface LECVODPlayerLiveExtend : LECVODPlayer

- (BOOL) registerWithLiveId:(NSString *) liveId
                     isLetv:(BOOL) isLetv
                 completion:(void (^)(BOOL result))completion;

@end
