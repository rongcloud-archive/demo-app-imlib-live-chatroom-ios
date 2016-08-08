//
//  RCDLiveAttributedLabel.h
//  iOS-IMKit
//
//  Created by YangZigang on 14/10/29.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  RCDLiveAttributedLabelClickedTextInfo
 */
@interface RCDLiveAttributedLabelClickedTextInfo : NSObject
/**
 *  NSTextCheckingType
 */
@property(nonatomic, assign) NSTextCheckingType textCheckingType;
/**
 *  text
 */
@property(nonatomic, strong) NSString *text;

@end

/**
 *  RCDLiveAttributedDataSource
 */
@protocol RCDLiveAttributedDataSource <NSObject>
/**
 *  attributeDictionaryForTextType
 *
 *  @param textType textType
 *
 *  @return return NSDictionary
 */
- (NSDictionary *)attributeDictionaryForTextType:(NSTextCheckingTypes)textType;
/**
 *  highlightedAttributeDictionaryForTextType
 *
 *  @param textType textType
 *
 *  @return NSDictionary
 */
- (NSDictionary *)highlightedAttributeDictionaryForTextType:(NSTextCheckingType)textType;

@end

@protocol RCDLiveAttributedLabelDelegate;

/**
 *  Override UILabel @property to accept both NSString and NSAttributedString
 */
@protocol RCDLiveAttributedLabel <NSObject>

/**
 *  text
 */
@property (nonatomic, copy) id text;

@end
/**
 *  RCDLiveAttributedLabel
 */
@interface RCDLiveAttributedLabel : UILabel <RCDLiveAttributedDataSource,UIGestureRecognizerDelegate>
/**
 * 可以通过设置attributeDataSource或者attributeDictionary、highlightedAttributeDictionary来自定义不同文本的字体颜色
 */
@property(nonatomic, strong) id<RCDLiveAttributedDataSource> attributeDataSource;
/**
 * 可以通过设置attributedStrings可以给一些字符添加点击事件等，例如在实现的会话列表里修改文本消息内容
 *  -(void)willDisplayConversationTableCell:(RCDLiveMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
 *
 *   if ([cell isKindOfClass:[RCDLiveTextMessageCell class]]) {
 *      RCDLiveTextMessageCell *newCell = (RCDLiveTextMessageCell *)cell;
 *      if (newCell.textLabel.text.length>3) {
 *          NSTextCheckingResult *textCheckingResult = [NSTextCheckingResult linkCheckingResultWithRange:(NSMakeRange(0, 3)) URL:[NSURL URLWithString:@"http://www.baidu.com"]];
 *          [newCell.textLabel.attributedStrings addObject:textCheckingResult];
 *          [newCell.textLabel setTextHighlighted:YES atPoint:CGPointMake(0, 3)];
 *       }
 *    }
 *}
 *
 */
@property(nonatomic, strong) NSMutableArray *attributedStrings;
/*!
 点击回调
 */
@property (nonatomic, assign) id <RCDLiveAttributedLabelDelegate> delegate;
/**
 *  attributeDictionary
 */
@property(nonatomic, strong) NSDictionary *attributeDictionary;
/**
 *  highlightedAttributeDictionary
 */
@property(nonatomic, strong) NSDictionary *highlightedAttributeDictionary;
/**
 *  NSTextCheckingTypes 格式类型
 */
@property(nonatomic, assign) NSTextCheckingTypes textCheckingTypes;
/**
 *  NSTextCheckingTypes current格式类型
 */
@property(nonatomic, readonly, assign) NSTextCheckingType currentTextCheckingType;
/**
 *  setTextdataDetectorEnabled
 *
 *  @param text                text
 *  @param dataDetectorEnabled dataDetectorEnabled
 */
- (void)setText:(NSString *)text dataDetectorEnabled:(BOOL)dataDetectorEnabled;
/**
 *  textInfoAtPoint
 *
 *  @param point point
 *
 *  @return RCDLiveAttributedLabelClickedTextInfo
 */
- (RCDLiveAttributedLabelClickedTextInfo *)textInfoAtPoint:(CGPoint)point;
/**
 *  setTextHighlighted
 *
 *  @param highlighted highlighted
 *  @param point       point
 */
- (void)setTextHighlighted:(BOOL)highlighted atPoint:(CGPoint)point;

@end

/*!
 RCDLiveAttributedLabel点击回调
 */
@protocol RCDLiveAttributedLabelDelegate <NSObject>
@optional

/*!
 点击URL的回调
 
 @param label 当前Label
 @param url   点击的URL
 */
- (void)attributedLabel:(RCDLiveAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url;

/*!
 点击电话号码的回调
 
 @param label       当前Label
 @param phoneNumber 点击的URL
 */
- (void)attributedLabel:(RCDLiveAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber;

/*!
 点击Label的回调
 
 @param label   当前Label
 @param content 点击的内容
 */
- (void)attributedLabel:(RCDLiveAttributedLabel *)label didTapLabel:(NSString *)content;

@end

