//
//  RCEmotionModel.h
//  RongIMKit
//
//  Created by 杜立召 on 15/11/19.
//  Copyright © 2015年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RCEmotionType) {
    /**
     * 普通emji表情
     */
    RCEmotionType_Emoji= 1,
    /**
     * 贴纸表情
     */
    RCEmotionType_Emotion,
    /**
     * 字符转图片表情
     */
    RCEmotionType_StringToEmoji,
};

@interface RCEmotionModel : NSObject

//表情包名称
@property(nonatomic,copy)NSString *packageName;
//表情名称
@property(nonatomic,copy)NSString *emotionName;
//表情类型
@property(nonatomic,assign)RCEmotionType emotionType;
//表情全称（包含后缀名）
@property(nonatomic,copy)NSString *emotionFullName;
//表情小图路径
@property(nonatomic,copy)NSString *smallIconPath;
//表情大图路径
@property(nonatomic,copy)NSString *bigIconPath;
//是否安装 ，如果是yes 说明app内置了表情，发送消息时讲只发送表情名称不发送表情图片，可以节省流量。如果no 将图片发送出去
@property(nonatomic,assign)BOOL isInstall;

@end
