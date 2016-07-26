//
//  RCInputBarTheme.h
//  RongIMToolKit
//
//  Created by 杜立召 on 16/4/29.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RCInputBarTheme : NSObject

#pragma 底部输入框整体
//整体背景颜色
@property(nonatomic,strong)UIColor *inputBarBackGroundColor;

//输入框背景颜色
@property(nonatomic,strong)UIColor *inputTextViewBackGroundColor;

//边框颜色
@property(nonatomic,strong)UIColor *inputBarBorderColor;

#pragma 文本输入框样式
//输入文本框边框颜色
@property(nonatomic,strong)UIColor *inputTextViewBorderColor;

//输入框文字颜色
@property(nonatomic,strong)UIColor *inputTextViewTextColor;


#pragma 表情区域
//表情区下面tab区域颜色
@property(nonatomic,strong)UIColor *emojiTabViewColor;

#pragma 加号扩展区域

#pragma 图片选择区域

#pragma 地理位置选择区域
@end
