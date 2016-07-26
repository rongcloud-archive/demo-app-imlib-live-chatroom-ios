//
//  RCEmotionImageView.h
//  RongIMToolKit
//
//  Created by 杜立召 on 16/2/19.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCEmotionImageViewDelegate;

@interface RCEmotionImageView : UIImageView {
@private
    NSURL* imageURL;
    UIImage* placeholderImage;
    id<RCEmotionImageViewDelegate> delegate;
}

- (instancetype)initWithPlaceholderImage:(UIImage*)anImage; // delegate:nil
- (instancetype)initWithPlaceholderImage:(UIImage*)anImage delegate:(id<RCEmotionImageViewDelegate>)aDelegate;

- (void)cancelImageLoad;

@property(nonatomic,retain) NSURL* imageURL;
@property(nonatomic,retain) UIImage* placeholderImage;
@property(nonatomic,assign) id<RCEmotionImageViewDelegate> delegate;

-(void)setPlaceholderImage:(UIImage *)__placeholderImage;

@end

@protocol RCEmotionImageViewDelegate<NSObject>
@optional
- (void)imageViewLoadedImage:(RCEmotionImageView*)imageView;
- (void)imageViewFailedToLoadImage:(RCEmotionImageView*)imageView error:(NSError*)error;
@end
