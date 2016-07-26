//
//  RCInputBarControl.h
//  RongIMToolKit
//
//  Created by 杜立召 on 16/4/11.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTKCommonDefine.h"
#import <CoreLocation/CoreLocation.h>
#import <RongIMLib/RongIMLib.h>

@class RCEmotionViewController;
@class RCPublicServiceMenuItem;
@class RCPublicServiceMenu;
@class RCEmotionPackageModel;
@class RCEmotionModel;
@class RCEmotionPageControl;


#define PLUGIN_BOARD_ITEM_ALBUM_TAG    1001
#define PLUGIN_BOARD_ITEM_CAMERA_TAG   1002
#define PLUGIN_BOARD_ITEM_LOCATION_TAG 1003

/*!
 输入工具栏的点击监听器
 */
@protocol RCInputBarControlDelegate <NSObject>

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

#pragma mark - 加号内plugin区域回调

/*!
 点击加号区域功能Item的回调
 
 @param pluginItemTag 功能项tag
 
 @return 是否覆盖SDK 的方法,默认NO,覆盖SDK的方法
 */
-(BOOL)onTouchPluginItem:(NSInteger)pluginItemTag;

/**
 *  添加扩展项到功能面板的队尾，在会话中，可以在viewdidload后，向RCPluginBoardView添加功能项
 *
 *  @param image 图片
 *  @param title 标题
 *  @param tag   标记，自定义扩展功能时需要注意不能与默认扩展的tag重复。默认tag定义
 */
-(void)insertItemWithImage:(UIImage*)image title:(NSString*)title tag:(NSInteger)tag;

/**
 *  删除已经添加的扩展项
 *
 *  @param index 索引
 */
- (void)removeItemAtIndex:(NSInteger)index;

/**
 *  删除已经添加的扩展项
 *
 *  @param tag 标记
 */
- (void)removeItemWithTag:(NSInteger)tag;


#pragma 相册选择图片之后回调

/**
 *  选择相册图片之后回调
 
 *  @param selectedImages 选择的图片UIImage的数组
 */
-(void)onSelectedImages:(NSArray *)selectedImages;

#pragma 地图定位后的回调

/**
 *  选择完成地图位置之后回调
 
 *  @param location       地理位置信息
 *  @param locationName   地理名称
 *  @param  mapScreenShot 截图
 */
- (void)onSelectedLocationPicker:(CLLocationCoordinate2D)location
                    locationName:(NSString *)locationName
                   mapScreenShot:(UIImage *)mapScreenShot;

#pragma mark - 输入框事件

/**
 *  点击键盘回车或者emoji表情面板的发送按钮执行的方法
 
 *  @param text      输入框的内容
 */
- (void)onTouchSendButton:(NSString *)text;

#pragma 录音结束回调

/**
 *  录音结束之后回调
 
 *  @param voiceData  录音数据
 *  @param duration   录音时长
 */
- (void)onRecordFinished:(NSData *)voiceData Duration:(double)duration;

#pragma 表情和加号按钮点击回调，如果实现这两个方法，则会覆盖SDK中对应的点击的方法，用户需要自己实现对应的逻辑（例如场景：在观看视频时，点击图标可以把当前视频信息作为消息发送出去，等等）
/*!
 表情按钮点击事件，可以重写这个方法实现自己逻辑
 */
- (void)onTouchEmojiButton:(UIButton *)sender;

/*!
 加号按钮点击事件，可以重写这个方法实现自己逻辑
 */
- (void)onTouchAddtionalButton:(UIButton *)sender;
@end


@interface RCInputBarControl : UIView

@property(nonatomic, weak) id<RCInputBarControlDelegate> delegate;

/**
 *  设置默认输入状态，比如默认文字输入或者语音输入
 */
@property(nonatomic) RCChatSessionInputBarInputType defaultInputType;

/**
 *  输入框样式，共9中组合，参考枚举RCChatSessionInputBarControlStyle
 */
@property(nonatomic) RCChatSessionInputBarControlStyle inputBarStyle;


/*!
 初始化输入工具栏
 
 @param frame       显示的Frame
 @param inViewConroller 所处的聊天界面ViewConroller
 @param type        菜单类型
 @defultInputType   输入框的默认输入模式,默认值为RCChatSessionInputBarInputText，即文本输入模式。
 @param style       显示布局
 
 @return            输入工具栏对象
 */
- (id)initWithFrame:(CGRect)frame
    inViewConroller:(UIViewController *)parentViewController;

/*!
 设置输入工具栏状态
 
 @param frame       显示的Frame
 */
-(void)setInputBarStatus:(KBottomBarStatus)Status;

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
