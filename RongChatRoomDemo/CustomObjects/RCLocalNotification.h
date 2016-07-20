//
//  RCLocalNotification.h
//  RongIMKit
//
//  Created by xugang on 15/1/22.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCLocalNotification : NSObject

/**
 *  单例设计
 *
 *  @return 实例
 */
+ (RCLocalNotification *)defaultCenter;

- (void)postLocalNotification:(NSString *)formatMessage userInfo:(NSDictionary *)userInfo;
@end
