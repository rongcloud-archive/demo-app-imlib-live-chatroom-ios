//
//  RCEmojinContainerView.h
//  RongIMKit
//
//  Created by 杜立召 on 15/11/11.
//  Copyright © 2015年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCEmotionPackageModel.h"
#import "RCEmotionModel.h"

@class RCEmojiBoardView;
@class RCEmojiPageControl;


/**
 *  RCEmojiViewDelegate 此代理在RCEmojiBoardView 设置并实现， 注：emoji 指字符表情，emotion 指贴纸表情
 */
@protocol RCEmojiImageViewDelegate <NSObject>
@optional
/**
 *  点击emoji表情时触发
 *
 *  @param emojiView emojiView
 *  @param string    string
 */
//- (void)didTouchEmojiView:(NSString *)string;

/**
 *  点击贴纸表情时触发
 *
 *  @param emojiView emojiView
 *  @param string    string
 */
- (void)didTouchEmotionView:(RCEmotionModel *)emotion;

@end

@interface RCEmotionContainerView : UIView <UIScrollViewDelegate>

/**
 *  表情容器，所有的表情放到这个scrollview 里
 */
@property(nonatomic, strong) UIScrollView *emojiBackgroundView;
//是否初始化，避免每次都重新画表情
@property(nonatomic, assign) BOOL isInitEmotion;
//表情页码
@property(nonatomic, strong) RCEmojiPageControl *pageCtrl;
//表情页数
@property(nonatomic, assign) int totalPage;
//表情类型 暂时以 emoji  和emotion 两种区分
@property(nonatomic, assign) RCEmotionType emotionType;
//表情包
@property(nonatomic, strong) RCEmotionPackageModel *emotionPackage;
/**
 *  RCEmojiViewDelegate
 */
@property(nonatomic, assign) id<RCEmojiImageViewDelegate> delegate;
//加载表情
-(void)loadEmotionView;
//滚动表情到第几页
-(void)scrollToPage:(int)page;
@end
