//
//  RCDLiveInputBar.h
//  RongChatRoomDemo
//
//  Created by 杜立召 on 16/8/3.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <RongIMLib/RongIMLib.h>
#import "RCDLiveKitCommonDefine.h"
#import "RCDLiveEmojiBoardView.h"

#define PLUGIN_BOARD_ITEM_ALBUM_TAG    1001
#define PLUGIN_BOARD_ITEM_CAMERA_TAG   1002
#define PLUGIN_BOARD_ITEM_LOCATION_TAG 1003

/*!
 输入工具栏的输入模式
 */
typedef NS_ENUM(NSInteger, RCDLiveBottomBarStatus) {
  /*!
   初始状态
   */
  RCDLiveBottomBarDefaultStatus = 0,
  /*!
   文本输入状态
   */
  RCDLiveBottomBarKeyboardStatus,
  /*!
   表情输入模式
   */
  RCDLiveBottomBarEmojiStatus
};

/*!
 输入工具栏的点击监听器
 */
@protocol RCTKInputBarControlDelegate <NSObject>

@optional
#pragma mark - 输入框及外部区域事件

/*!
 输入工具栏尺寸（高度）发生变化的回调
 
 @param frame 输入工具栏最终需要显示的Frame
 */
- (void)onInputBarControlContentSizeChanged:(CGRect)frame
                      withAnimationDuration:(CGFloat)duration
                          andAnimationCurve:(UIViewAnimationCurve)curve;
/*!
 输入框中内容发生变化的回调
 
 @param inputTextView 文本输入框
 @param range         当前操作的范围
 @param text          插入的文本
 */
- (void)onInputTextView:(UITextView *)inputTextView
shouldChangeTextInRange:(NSRange)range
        replacementText:(NSString *)text;

#pragma mark - 输入框事件

/**
 *  点击键盘回车或者emoji表情面板的发送按钮执行的方法
 
 *  @param text      输入框的内容
 */
- (void)onTouchSendButton:(NSString *)text;

@end


@interface RCDLiveInputBar : UIView

@property(nonatomic, weak) id<RCTKInputBarControlDelegate> delegate;
/*!
 表情View
 */
@property(nonatomic, strong) RCDLiveEmojiBoardView *emojiBoardView;

/*!
 初始化输入工具栏
 
 @param frame       显示的Frame
 @param inViewConroller 所处的会话页面ViewConroller
 @param type        菜单类型
 @defultInputType   输入框的默认输入模式,默认值为RCChatSessionInputBarInputText，即文本输入模式。
 @param style       显示布局
 
 @return            输入工具栏对象
 */
- (id)initWithFrame:(CGRect)frame;

/*!
 设置输入工具栏状态
 
 @param frame       显示的Frame
 */
-(void)setInputBarStatus:(RCDLiveBottomBarStatus)Status;

/*!
 重新调整页面布局时需要调用这个方法来设置输入框的frame
 
 @param frame       显示的Frame
 */
-(void)changeInputBarFrame:(CGRect)frame;

/*!
 清除输入框内容
 */
-(void)clearInputView;


@end
