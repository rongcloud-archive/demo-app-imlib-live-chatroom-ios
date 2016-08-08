//
//  RCEmotionPackage.h
//  RongIMKit
//
//  Created by 杜立召 on 16/7/27.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCEmotionContainer.h"

/*!
 表情输入的回调
 */
@protocol RCEmotionViewDelegate <NSObject>



-(UIView *)loadEmotionView:(int)index;
@optional

/*!
 自定义表情区滚动时触发
 
 @param scrollView scrollView
 */
- (void)emotionViewDidEndDecelerating:(UIScrollView *)scrollView;

@end



@interface RCEmotionPackage : NSObject

@property(nonatomic,strong)UIImage *tabImage;

@property(nonatomic)int totalPage;

@property(nonatomic,strong)RCEmotionContainer *emotionContainerView;

@property(nonatomic,weak)id<RCEmotionViewDelegate> delegate;


-(id)initEmotionPackage:(UIImage *)tabImage withTotalCount:(int)pageCount;
@end
