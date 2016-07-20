//
//  RCKitCommonDefine.h
//  RongIMKit
//
//  Created by xugang on 15/1/22.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#ifndef RongIMKit_RCKitCommonDefine_h
#define RongIMKit_RCKitCommonDefine_h

#define USE_BUNDLE_RESOUCE 1

#define RONGCLOUD_IM_APPKEY @"e5t4ouvptkm2a"
#define RONGCLOUD_IM_APPSECRET @"vB4FakXm8f68"


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
#define IMAGE_BY_NAMED(value) [RCKitUtility imageNamed:(value)ofBundle:@"RongCloud.bundle"]
#else
#define IMAGE_BY_NAMED(value) [UIImage imageNamed:NSLocalizedString((value), nil)]
#endif // USE_BUNDLE_RESOUCE
#define TIME_LABEL_HEIGHT 20
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

#ifdef DEBUG
#define DebugLog( s, ... ) NSLog( @"[%@:(%d)] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DebugLog( s, ... )
#endif
#endif

