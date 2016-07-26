//
//  RCTKCommonDefine.h
//  RongIMToolKit
//
//  Created by 杜立召 on 16/1/20.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#ifndef RCTKCommonDefine_h
#define RCTKCommonDefine_h

#define USE_BUNDLE_RESOUCE 1

//-----------UI-Macro Definination---------//
#define RGBCOLOR(r, g, b) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:1]
#define RGBACOLOR(r, g, b, a) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:(a)]
#define HEXCOLOR(rgbValue)                                                                                             \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0                                               \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0                                                  \
blue:((float)(rgbValue & 0xFF)) / 255.0                                                           \
alpha:1.0]

//当前版本
#define IOS_FSystenVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
#define IOS_DSystenVersion ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define IOS_SSystemVersion ([[UIDevice currentDevice] systemVersion])

#define IMAGENAEM(Value)                                                                                               \
[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(Value, nil) ofType:nil]]

#if USE_BUNDLE_RESOUCE
#define IMAGE_BY_NAMED(value) [RCTKUtility imageNamed:(value)ofBundle:@"RongCloud.bundle"]
#else
#define IMAGE_BY_NAMED(value) [UIImage imageNamed:NSLocalizedString((value), nil)]
#endif // USE_BUNDLE_RESOUCE

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

#define APP_SCREEN_HEIGHT [[UIScreen mainScreen] applicationFrame].size.height
#define APP_SCREEN_WIDTH [[UIScreen mainScreen] applicationFrame].size.width

//当前版本
#define IOS_FSystenVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
#define IOS_DSystenVersion ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define IOS_SSystemVersion ([[UIDevice currentDevice] systemVersion])

//当前语言
#define CURRENTLANGUAGE ([[NSLocale preferredLanguages] objectAtIndex:0])

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define RC_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define RC_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

// 大于等于IOS7
#define RC_MULTILINE_TEXTSIZE_GEIOS7(text, font, maxSize) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;

// 小于IOS7
#define RC_MULTILINE_TEXTSIZE_LIOS7(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;

#define RC_EmojiStringgRegex @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]|\\/+[a-zA-Z0-9\\u4e00-\\u9fa5\\p{P}|’$|’~”$]{1,6}"
#endif

/*!
 输入工具栏的显示布局
 */
typedef NS_ENUM(NSInteger, RCChatSessionInputBarControlStyle) {
    /*!
     录音切换-输入框-扩展
     */
    RC_CHAT_INPUT_BAR_STYLE_SWITCH_CONTAINER_EXTENTION = 0,
    /*!
     扩展-输入框-录音切换
     */
    RC_CHAT_INPUT_BAR_STYLE_EXTENTION_CONTAINER_SWITCH = 1,
    /*!
     输入框-录音切换-扩展
     */
    RC_CHAT_INPUT_BAR_STYLE_CONTAINER_SWITCH_EXTENTION = 2,
    /*!
     输入框-扩展-录音切换
     */
    RC_CHAT_INPUT_BAR_STYLE_CONTAINER_EXTENTION_SWITCH = 3,
    /*!
     录音切换-输入框
     */
    RC_CHAT_INPUT_BAR_STYLE_SWITCH_CONTAINER = 4,
    /*!
     输入框-录音切换
     */
    RC_CHAT_INPUT_BAR_STYLE_CONTAINER_SWITCH = 5,
    /*!
     扩展-输入框
     */
    RC_CHAT_INPUT_BAR_STYLE_EXTENTION_CONTAINER = 6,
    /*!
     输入框-扩展
     */
    RC_CHAT_INPUT_BAR_STYLE_CONTAINER_EXTENTION = 7,
    /*!
     输入框
     */
    RC_CHAT_INPUT_BAR_STYLE_CONTAINER = 8,
   
};

/*!
 输入工具栏的菜单类型
 */
typedef NS_ENUM(NSInteger, RCChatSessionInputBarControlType) {
    /*!
     默认类型，非公众服务
     */
    RCChatSessionInputBarControlDefaultType = 0,
    /*!
     公众服务
     */
    RCChatSessionInputBarControlPubType = 1,
    
    /*!
     客服机器人
     */
    RCChatSessionInputBarControlCSRobotType = 2,
    
    /*!
     客服机器人
     */
    RCChatSessionInputBarControlNoAvailableType = 3
};

/*!
 输入工具栏的输入模式
 */
typedef NS_ENUM(NSInteger, RCChatSessionInputBarInputType) {
    /*!
     文本输入模式
     */
    RCChatSessionInputBarInputText = 0,
    /*!
     语音输入模式
     */
    RCChatSessionInputBarInputVoice = 1,
    /*!
     扩展输入模式
     */
    RCChatSessionInputBarInputExtention = 2
};

/*!
 输入工具栏的输入模式
 */
typedef NS_ENUM(NSInteger, KBottomBarStatus) {
    /*!
     初始状态
     */
    KBottomBarDefaultStatus = 0,
    /*!
     文本输入状态
     */
    KBottomBarKeyboardStatus,
    /*!
     功能板输入模式
     */
    KBottomBarPluginStatus,
    /*!
     表情输入模式
     */
    KBottomBarEmojiStatus,
    /*!
     语音消息输入模式
     */
    KBottomBarRecordStatus
};


