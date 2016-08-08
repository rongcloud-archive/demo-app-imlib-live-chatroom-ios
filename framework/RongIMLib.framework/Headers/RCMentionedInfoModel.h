//
//  RCMentionedInfoModel.h
//  RongIMLib
//
//  Created by 杜立召 on 16/7/6.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCMentionedInfoModel : NSObject

//@类型 1-所有人 2-某些人
@property(nonatomic, assign) NSInteger type;

//@的userId 列表，如果是@所有人传nil
@property(nonatomic,assign)NSArray *userIds;

//推送时显示的内容
@property(nonatomic,assign) NSString *mentionedContent;

/**
 *  初始化@属性
 *
 *  @param type    @类型 1-所有人 2-某些人
 *  @param userIds //@的userId 列表，所有人不用传
 *
 *  @return return value description
 */
+ (instancetype)initWithMentionedType:(NSInteger )type andUserIds:(NSArray *)userIds;
@end
