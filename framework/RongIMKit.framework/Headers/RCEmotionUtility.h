//
//  RCEmotionUtility.h
//  RongIMKit
//
//  Created by 杜立召 on 15/11/19.
//  Copyright © 2015年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  RCEmotionModel;
@class  RCEmotionPackageModel;

@interface RCEmotionUtility : NSObject

+ (RCEmotionUtility*)shareInstance;
//获取所有表情
- (NSMutableArray *)getEmotionPackageList;

//根据表情包名称获取表情包
- (RCEmotionPackageModel *)getEmotionPackage:(NSString *)emotionPackageName;

//根据表情包名称和表情名称获取表情
- (RCEmotionModel *)getEmotionInPackage:(NSString *)emotionPackageName andEmotionName :(NSString *)emotionName;

//根据表情包名称获取表情包路径
- (NSString *)getEmotionPackagePath:(NSString *)packageName;

//如果加入了字符串表情包这里将返回字符对应的图片地址的字典
- (NSDictionary *)getStringEmojiMapDic;
- (NSDictionary *)getEmojiStringMapDic;

- (NSString *)getEmojiPathWithStr:(NSString *)emojiStr;

@end
