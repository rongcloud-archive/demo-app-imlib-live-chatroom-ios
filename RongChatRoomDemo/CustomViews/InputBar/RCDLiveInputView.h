//
//  RCDLiveInputView.h
//  RongChatRoomDemo
//
//  Created by 杜立召 on 16/8/3.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCDLiveKitCommonDefine.h"
#define Height_ChatSessionInputBar 50.0f


/*!
 输入工具栏的点击监听器
 */
@protocol RCDLiveInputBarDelegate;

/*!
 输入工具栏
 */
@interface RCDLiveInputView : UIView

/*!
 输入工具栏的点击回调监听
 */
@property(weak, nonatomic) id<RCDLiveInputBarDelegate> delegate;

/*!
 客服机器人转人工切换的按钮
 */
@property(strong, nonatomic) UIButton *switchButton;

/*!
 容器View
 */
@property(strong, nonatomic) UIView *inputContainerView;

/*!
 文本输入框
 */
@property(strong, nonatomic) UITextView *inputTextView;

/*!
 表情的按钮
 */
@property(strong, nonatomic) UIButton *emojiButton;

/*!
 所处的会话页面View
 */
@property(assign, nonatomic, readonly) UIView *contextView;

/*!
 Frame 起点X坐标
 */
@property(assign, nonatomic) float currentPositionY;

/*!
 Frame 起点Y坐标
 */
@property(assign, nonatomic) float originalPositionY;

/*!
 文本输入框的高度
 */
@property(assign, nonatomic) float inputTextview_height;

/*!
 初始化输入工具栏
 
 @param frame       显示的Frame
 @param contextView 所处的会话页面View
 @param type        菜单类型
 @param style       显示布局
 @return            输入工具栏对象
 */
- (id)initWithFrame:(CGRect)frame;

- (void)resetInputBar;

- (void)clearInputText;
@end

/*!
 输入工具栏的点击监听器
 */
@protocol RCDLiveInputBarDelegate <NSObject>

@optional

/*!
 键盘积即将显示的回调
 
 @param keyboardFrame 键盘最终需要显示的Frame
 */
- (void)keyboardWillShowWithFrame:(CGRect)keyboardFrame;

/*!
 键盘即将隐藏的回调
 */
- (void)keyboardWillHide;

/*!
 输入工具栏尺寸（高度）发生变化的回调
 
 @param frame 输入工具栏最终需要显示的Frame
 */
- (void)chatSessionInputBarControlContentSizeChanged:(CGRect)frame;

/*!
 点击键盘Return按钮的回调
 
 @param inputControl 当前输入工具栏
 @param text         当前输入框中国的文本内容
 */
- (void)didTouchKeyboardReturnKey:(RCDLiveInputView *)inputControl text:(NSString *)text;

/*!
 点击表情按钮的回调
 
 @param sender 表情按钮
 */
- (void)didTouchEmojiButton:(UIButton *)sender;
/*!
 输入框中内容发生变化的回调
 
 @param inputTextView 文本输入框
 @param range         当前操作的范围
 @param text          插入的文本
 */
- (void)inputTextView:(UITextView *)inputTextView
shouldChangeTextInRange:(NSRange)range
      replacementText:(NSString *)text;

@end

