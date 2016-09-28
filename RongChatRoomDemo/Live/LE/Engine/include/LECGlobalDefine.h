//
//  LECGlobalDefine.h
//  LECPlayerSDK
//
//  Created by 侯迪 on 9/13/15.
//  Copyright (c) 2015 letv. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(int, LECPlayerMediaType) {
    LECPlayerMediaTypeRTMP,
    LECPlayerMediaTypeHLS,
    LECPlayerMediaTypeFLV
};



typedef NS_ENUM(NSInteger, LECBusinessLine){
    LECBusinessLineDefault = 0,//默认云直播点播服务
    LECBusinessLineSaas = 1//Saas服务
};

