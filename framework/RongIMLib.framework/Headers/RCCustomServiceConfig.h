//
//  RCCustomServiceConfig.h
//  RongIMLib
//
//  Created by litao on 16/2/25.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

//onResult:(void(^)(int isSuccess, NSString *errMsg))resultBlock
//onBlocked:(void(^)(void))blockedBlock
//onCompanyInfo:(void(^)(NSString *companyName, NSString *companyUrl))companyInfoBlockInfo
//onKeyboardType:(void(^)(RCCSInputType keyboardType))keyboardTypeBlock
//onQuit:(void(^)(NSString *quitMsg))quitBlock;

@interface RCCustomServiceConfig : NSObject
@property (nonatomic)BOOL isBlack;
@property (nonatomic, strong)NSString *companyName;
@property (nonatomic, strong)NSString *companyUrl;
//@property (nonatomic, assign)BOOL supportVoice;
//@property (nonatomic, assign)BOOL supportLocation;
@end
