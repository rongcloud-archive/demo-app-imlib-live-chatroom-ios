//
//  ChatRoomHalfViewController.h
//  RongChatRoomDemo
//
//  Created by Sin on 16/8/9.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#ifndef __ChatRoomHalfViewController
#define __ChatRoomHalfViewController
#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "RCMessageBaseCell.h"
#import "RCMessageModel.h"
#import <RongIMToolKit/RongIMToolKit.h>

///输入栏扩展输入的唯一标示
#define PLUGIN_BOARD_ITEM_ALBUM_TAG    1001
#define PLUGIN_BOARD_ITEM_CAMERA_TAG   1002
#define PLUGIN_BOARD_ITEM_LOCATION_TAG 1003
#if RC_VOIP_ENABLE
#define PLUGIN_BOARD_ITEM_VOIP_TAG     1004
#endif

/*!
 聊天界面类，只半屏显示直播页面
 */
@interface RCDLiveChatRoomHalfViewController : UIViewController


#pragma mark - 会话属性

/*!
 当前会话的会话类型
 */
@property(nonatomic) RCConversationType conversationType;

/*!
 目标会话ID
 */
@property(nonatomic, strong) NSString *targetId;

/*!
 是否全屏模式
 */
//@property(nonatomic, assign) BOOL isFullScreen;

/*!
 播放内容地址
 */
@property(nonatomic, strong) NSString *contentURL;

#pragma mark - 聊天界面属性

/*!
 聊天内容的消息Cell数据模型的数据源
 
 @discussion 数据源中存放的元素为消息Cell的数据模型，即RCMessageModel对象。
 */
@property(nonatomic, strong) NSMutableArray<RCMessageModel *> *conversationDataRepository;

/*!
 消息列表CollectionView和输入框都在这个view里
 */
@property(nonatomic, strong) UIView *contentView;

/*!
 聊天界面的CollectionView
 */
@property(nonatomic, strong) UICollectionView *conversationMessageCollectionView;

#pragma mark - 输入工具栏

@property(nonatomic,strong) RCTKInputBarControl *inputBar;

#pragma mark - 显示设置
/*!
 设置进入聊天室需要获取的历史消息数量（仅在当前会话为聊天室时生效）
 
 @discussion 此属性需要在viewDidLoad之前进行设置。
 -1表示不获取任何历史消息，0表示不特殊设置而使用SDK默认的设置（默认为获取10条），0<messageCount<=50为具体获取的消息数量,最大值为50。
 */
@property(nonatomic, assign) int defaultHistoryMessageCountOfChatRoom;
@end
#endif