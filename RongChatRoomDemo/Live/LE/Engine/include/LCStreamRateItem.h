//
//  LEStreamRateItem.h
//  LECPlayerSDK
//
//  Created by 侯迪 on 9/13/15.
//  Copyright (c) 2015 letv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCStreamRateItem : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *subName;    //码率名称详情，如果是本地视频会显示(本地)
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) BOOL isLocal;
@property (nonatomic, assign) BOOL isEnabled;

@end
