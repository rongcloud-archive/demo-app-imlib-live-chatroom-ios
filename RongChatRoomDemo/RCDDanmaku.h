//
//  RCDDanmaku.h
//  DanMuDemo
//
//  Created by Sin on 16/9/26.
//  Copyright © 2016年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    RCDDanmakuPositionNone = 0,//从右往左
    RCDDanmakuPositionCenterTop,//中间靠上
    RCDDanmakuPositionCenterBottom//中间靠下
} RCDDanmakuPosition;//弹幕动画位置

@interface RCDDanmaku : NSObject

/**
 *  弹幕内容
 */
@property(nonatomic, copy) NSAttributedString* contentStr;

/**
 *  弹幕类型(弹幕所在位置)
 */
@property(nonatomic, assign) RCDDanmakuPosition position;
@end
