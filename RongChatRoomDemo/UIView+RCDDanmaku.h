//
//  UIView+RCDDanmaku.h
//  DanMuDemo
//
//  Created by Sin on 16/9/26.
//  Copyright © 2016年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCDDanmaku;

#define RCDDanmakuLabelTag 111111

/**
 * 所有以“rc_”开头的方法均为私有方法
 */
@interface UIView (RCDanmaku)

/**
 *  发送一个弹幕，根据RCDDanmaku的position属性来控制是从右往左出现还是在中间出现
 *  持续时间：
 *      从右往左的弹幕由RCDDanmakuManager的duration控制
 *      中间弹幕由RCDDanmakuManager的centerDuration控制
 *  @param danmaku 弹幕
 */
- (void)sendDanmaku:(RCDDanmaku *)danmaku;

/**
 *  发送一个特定位置的弹幕，根据point来确定弹幕左上角的位置，持续时间由RCDDanmakuManager的specialDuration控制
 *
 *  @param danmaku 弹幕
 *  @param point   弹幕左上角的点
 */
- (void)sendDanmaku:(RCDDanmaku *)danmaku atPoint:(CGPoint)point;

/**
 *  发送一个特定位置的弹幕，根据point来确定弹幕的中心点位置，持续时间由RCDDanmakuManager的specialDuration控制
 *
 *  @param danmaku 弹幕
 *  @param point   弹幕中心点
 */
- (void)sendDanmaku:(RCDDanmaku *)danmaku atCenterPoint:(CGPoint)point;

/**
 *  停止弹幕
 */
- (void)stopDanmaku;


//pauseDanmaku和resumeDanmaku这两个方法配对使用

/**
 *  暂停弹幕
 */
- (void)pauseDanmaku;

/**
 *  重开弹幕
 */
- (void)resumeDanmaku;
@end
