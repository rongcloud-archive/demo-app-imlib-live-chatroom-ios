//
//  TCPlayerView.h
//  TCPlayer
//
//  Created by  on 15/8/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TCPlayerView : TCCorePlayerView<TCPlayerAbleView>
{
@protected
    NSMutableArray *_maskViews;
@private
    BOOL _isDraging;              // 正在拖动
}

@property (nonatomic, readonly) UIView<TCPlayerSubAbleView> *ctrlView;           // 播放控制View
@property (nonatomic, readonly) UIView<TCPlayerSubAbleView> *bottomView;         // 进度条View

@property (nonatomic, readonly) id<TCPlayResAbleItem> videoResItem;              // 播放的资源组合
@property (nonatomic, readonly) id<TCCanPlayAble> playingItem;                   // 当前播放的视频

@property (nonatomic, strong) id<TCPlayerViewActionAble> playAction;

// 用户添加的自定义的蒙层控件
@property (nonatomic, readonly) NSMutableArray *maskViews;

// 是否支持自动隐藏底部状态栏, 默认YES
@property (nonatomic, assign) BOOL isEnableAutoHideBottomView;

// 第三方默认通过此接口设置播放器默认的控制界面，和底部
// cls必须实现TCPlayerSubAbleView协议
+ (void)setPlayerCtrlViewClass:(Class)cls;

// cls 必须实现TCPlayerBottomAbleView
+ (void)setPlayerBottomViewClass:(Class)cls;

// ctrlViewClass 传Nil时，即没有
// bottomViewClass 传Nil时，即没有
- (instancetype)initControlView:(Class)ctrlViewClass bottomView:(Class)bottomViewClass;

- (instancetype)initWithFrame:(CGRect)frame controlView:(Class)ctrlViewClass bottomView:(Class)bottomViewClass;

// 是否全屏
- (BOOL)isFullScreen;

// bottomView是否在显示
- (BOOL)isBottomViewShow;

// isEnableAutoHideBottomView = YES时，当前是否能自动隐藏
// 当底部隐藏或 没有拖动进度条（_isDraging ＝ NO）时，并且当前在播放([self isPlaying])时，才可自动隐藏
- (BOOL)canAutoHideBottomView;



@end
