//
//  RCDLiveKitCommonDefine.h
//  RongIMKit
//
//  Created by xugang on 15/1/22.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#ifndef RongIMKit_RCDLiveKitCommonDefine_h
#define RongIMKit_RCDLiveKitCommonDefine_h

#define USE_BUNDLE_RESOUCE 1

#define RONGCLOUD_IM_APPKEY @"e5t4ouvptkm2a"
#define RONGCLOUD_IM_APPSECRET @"vB4FakXm8f68"


//-----------UI-Macro Definination---------//
#define RCDLive_RGBCOLOR(r, g, b) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:1]
#define RCDLive_HEXCOLOR(rgbValue)                                                                                             \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0                                               \
                    green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0                                                  \
                     blue:((float)(rgbValue & 0xFF)) / 255.0                                                           \
                    alpha:1.0]

//当前版本
#define RCDLive_IOS_FSystenVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#if USE_BUNDLE_RESOUCE
#define RCDLive_IMAGE_BY_NAMED(value) [RCDLiveKitUtility imageNamed:(value)ofBundle:@"RongCloud.bundle"]
#else
#define RCDLive_IMAGE_BY_NAMED(value) [UIImage imageNamed:NSLocalizedString((value), nil)]
#endif // USE_BUNDLE_RESOUCE

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define RCDLive_RC_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define RCDLive_RC_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

// 大于等于IOS7
#define RCDLive_RC_MULTILINE_TEXTSIZE_GEIOS7(text, font, maxSize) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;

// 小于IOS7
#define RCDLive_RC_MULTILINE_TEXTSIZE_LIOS7(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;

#ifdef DEBUG
#define RCDLive_DebugLog( s, ... ) NSLog( @"[%@:(%d)] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define RCDLive_DebugLog( s, ... )
#endif
#endif


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
     表情输入模式
     */
    KBottomBarEmojiStatus
};




