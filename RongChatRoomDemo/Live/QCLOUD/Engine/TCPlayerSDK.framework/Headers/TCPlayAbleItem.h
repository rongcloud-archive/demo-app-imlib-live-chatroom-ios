//
//  TCCanPlayAble.h
//  TCPlayer
//
//  Created by  on 15/8/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCCanPlayAble <NSObject>

@property (nonatomic, copy) NSString *url;                 // 视频地址

@optional

// 底层调用
// 若不实现默认可以全部播放完
// 限制播放的时间，>0，限制limitSeconds秒, 否则不限制不播
- (NSUInteger)limitSeconds;

@end


@protocol TCPlayResAbleItem <NSObject>

@property (nonatomic, copy) NSString *name;                // 视频标题

@property (nonatomic, strong) NSMutableArray *items;       // 同一视频，不同的TCCanPlayAble资源

@end

