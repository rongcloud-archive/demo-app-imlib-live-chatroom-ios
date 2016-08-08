//
//  RCEmotionPackageModel.h
//  RongIMKit
//
//  Created by 杜立召 on 15/11/19.
//  Copyright © 2015年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCEmotionModel.h"

@interface RCEmotionPackageModel : NSObject

//表情包名称
@property(nonatomic,copy)NSString *packageName;
//表情包路径
@property(nonatomic,copy)NSString *packagePath;
//表情包封面路径
@property(nonatomic,copy)NSString *coverPath;
//表情包Icon路径
@property(nonatomic,copy)NSString *iconPath;
//表情包类型
@property(nonatomic,assign)RCEmotionType emotionType;
//是否安装 ，如果是yes 说明app内置了表情包，发送消息时讲只发送表情名称不发送表情图片，可以节省流量。如果no 将图片发送出去
@property(nonatomic,assign)BOOL isInstall;
//表情列表
@property(nonatomic,copy)NSMutableArray *emotionList;

@end
