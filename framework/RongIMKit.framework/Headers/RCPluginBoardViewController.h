//
//  RCPluginBoardViewController.h
//  RongIMKit
//
//  Created by 杜立召 on 15/12/25.
//  Copyright © 2015年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCPluginBoardViewController : UICollectionViewController

/*!
 当前所有的扩展项
 */
@property(nonatomic, strong) NSMutableArray *allItems;
/*!
 向扩展功能板中插入扩展项
 
 @param image 扩展项的展示图片
 @param title 扩展项的展示标题
 @param index 需要添加到的索引值
 @param tag   扩展项的唯一标示符
 
 @discussion 您以在RCConversationViewController的viewdidload后，添加自定义的扩展项。
 SDK默认的扩展项的唯一标示符为1XXX，我们建议您在自定义扩展功能时不要选用1XXX，以免与SDK预留的扩展项唯一标示符重复。
 */
- (void)insertItemWithImage:(UIImage*)image title:(NSString*)title atIndex:(NSInteger)index tag:(NSInteger)tag;

/*!
 添加扩展项到扩展功能板，并在显示为最后一项
 
 @param image 扩展项的展示图片
 @param title 扩展项的展示标题
 @param tag   扩展项的唯一标示符
 
 @discussion 您以在RCConversationViewController的viewdidload后，添加自定义的扩展项。
 SDK默认的扩展项的唯一标示符为1XXX，我们建议您在自定义扩展功能时不要选用1XXX，以免与SDK预留的扩展项唯一标示符重复。
 */
-(void)insertItemWithImage:(UIImage*)image title:(NSString*)title tag:(NSInteger)tag;

/*!
 更新指定扩展项
 
 @param index 扩展项的索引值
 @param image 扩展项的展示图片
 @param title 扩展项的展示标题
 */
-(void)updateItemAtIndex:(NSInteger)index image:(UIImage*)image title:(NSString*)title;

/*!
 更新指定扩展项
 
 @param tag   扩展项的唯一标示符
 @param image 扩展项的展示图片
 @param title 扩展项的展示标题
 */
-(void)updateItemWithTag:(NSInteger)tag image:(UIImage*)image title:(NSString*)title;

/*!
 删除扩展功能板中的指定扩展项
 
 @param index 指定扩展项的索引值
 */
- (void)removeItemAtIndex:(NSInteger)index;

/*!
 删除扩展功能板中的指定扩展项
 
 @param tag 指定扩展项的唯一标示符
 */
- (void)removeItemWithTag:(NSInteger)tag;

/*!
 删除扩展功能板中的所有扩展项
 */
- (void)removeAllItems;

@end
