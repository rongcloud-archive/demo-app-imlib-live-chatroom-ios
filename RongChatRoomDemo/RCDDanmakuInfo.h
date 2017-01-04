//
//  RCDDanmakuInfo.h
//  DanMuDemo
//
//  Created by Sin on 16/9/26.
//  Copyright © 2016年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCDDanmaku;

@interface RCDDanmakuInfo : NSObject
/**
 *  显示弹幕内容的label
 */
@property(nonatomic, weak) UILabel  *playLabel;

/**
 *  弹幕的剩余时间
 */
@property(nonatomic, assign) NSTimeInterval leftTime;

/**
 *  弹幕对象
 */
@property(nonatomic, strong) RCDDanmaku* danmaku;

/**
 *  弹道位置
 */
@property(nonatomic, assign) NSInteger lineCount;
@end
