//
//  TCReportEngine.h
//  TCCloudPlayerSDK
//
//  Created by  on 15/9/10.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCReportItem;

@interface TCReportEngine : NSObject


+ (TCReportEngine *)sharedEngine;

// isTest : YES测试数据  NO正式数据 默认值 为正试环境
- (void)setEnv:(BOOL)isTest;

// 必须配置 appid
- (void)configAppId:(NSString *)appid;

//// 切换logid, 用于测试
//- (void)switchToLogid:(NSString *)logig;

// 以Get方式上报
- (void)getReport:(TCReportItem *)item;

// 以Post方式上报
- (void)postReport:(TCReportItem *)item;

@end
