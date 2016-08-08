//
//  RCEmotionButton.h
//  RongIMKit
//
//  Created by 杜立召 on 15/11/20.
//  Copyright © 2015年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCEmotionModel.h"



@interface RCEmotionButton : UIButton
// 表情实体
@property(nonatomic,strong) RCEmotionModel * emotionModel;
@end


