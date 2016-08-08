//
//  RCEmotionViewController.h
//  RongIMKit
//
//  Created by 杜立召 on 15/12/16.
//  Copyright © 2015年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCEmotionPackageModel;
@class RCEmotionModel;
@class RCEmojiPageControl;
@class RCEmojiBoardView;
/**
 *  RCEmojiViewDelegate
 */
@protocol RCEmojiViewDelegate <NSObject>
@optional
/**
 *  点击普通emoji表情触发的方法，直接返回emoji字符串
 *  @param string    string
 */
- (void)didTouchEmojiView:(NSString *)string;

/**
 *  点击普通贴纸表情触发的方法，返回贴纸表情实体
 *  @param RCEmotionModel    emotion
 */
- (void)didTouchEmotionView:(RCEmotionModel *)emotion;

/**
 *  点击表情面板加号添加表情包按钮触发方法
 */
- (void)didTouchAddEmotionPackageButton;

/**
 *  点击表情面板管理表情包按钮触发方法
 */
- (void)didTouchEmotionSettinButton;
/**
 *  点击emoji表情面板的发送按钮执行的方法
 *
 *  @param emojiView  emojiView
 *  @param sendButton send button
 */
- (void)didSendButtonEvent;
@end
/**
 *  表情面板，此View里面展示所有表情包，每个表情包都是一个RCEmojinContainerView
 */
@interface RCEmotionViewController : UIView <UIScrollViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UIInputViewAudioFeedback> {
    /**
     *  RCEmojiPageControl
     */
    RCEmojiPageControl *pageCtrl;
    /**
     *  currentIndex
     */
    NSInteger currentIndex;
}

@property(nonatomic, assign) id<RCEmojiViewDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;
/**
 *  添加表情包
 *
 *  @param RCEmotionPackageModel  emotionPackage  表情包model
 */
-(void)addEmotionContainer:(RCEmotionPackageModel *)emotionPackage;

@end
