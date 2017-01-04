//
//  RCDLiveInputBar.m
//  RongChatRoomDemo
//
//  Created by 杜立召 on 16/8/3.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import "RCDLiveInputBar.h"
#import "RCDLiveInputView.h"
#import "RCDLiveKitUtility.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>

#define Height_EmojBoardView 220.0f
#define Height_PluginBoardView 220.0f

@interface RCDLiveInputBar ()<RCDLiveInputBarDelegate,UISplitViewControllerDelegate,RCDLiveEmojiViewDelegate>
@property(nonatomic) CGRect KeyboardFrame; //记录键盘区域frame
@property(nonatomic) CGRect originalFrame; //初始状态frame
@property(nonatomic) CGRect currentFrame; //当前frame ，键盘弹起，收回，表情等状态切换时frame
@property(nonatomic,assign)BOOL isClickAddButton;
@property(nonatomic,assign)BOOL isClickEmojiButton;
@property(nonatomic, strong)UITapGestureRecognizer *resetBottomTapGesture;
@property(nonatomic)BOOL isIgnoreKeyboardHide;
@property(nonatomic, strong)UIViewController *parentViewController;
@property(nonatomic,strong)UIImagePickerController *curPicker;
@property(nonatomic, assign) BOOL isAudioRecoderTimeOut;
@property(nonatomic) float currentInputBarHeight;
/*!
 会话页面下方的输入工具栏
 */
@property(nonatomic, strong) RCDLiveInputView *chatSessionInputBarControl;

/*!
 当前输入框状态
 */
@property(nonatomic) RCDLiveBottomBarStatus currentBottomBarStatus;

/**
 *自定义扩展区域，此区域和表情以及加号扩展区域高度相同都为220
 */
@property(nonatomic) UIView *customExpansionView;

/*!
 展示扩展区域
 */
-(void)showCustomExpansionView;

/*!
 隐藏扩展区域
 */
-(void)hideCustomExpansionView;
@end

@implementation RCDLiveInputBar

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.KeyboardFrame =  CGRectZero;
        _chatSessionInputBarControl = [[RCDLiveInputView alloc]
                                       initWithFrame:CGRectMake(0, 0,
                                                                self.bounds.size.width,
                                                                frame.size.height)];

        _chatSessionInputBarControl.delegate = self;
        [self addSubview:_chatSessionInputBarControl];
        self.originalFrame = frame;
        [self addSubview:_chatSessionInputBarControl];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}


//表情区域控件
- (RCDLiveEmojiBoardView *)emojiBoardView {
    if (!_emojiBoardView) {
        _emojiBoardView = [[RCDLiveEmojiBoardView alloc] initWithFrame:
                           CGRectMake(0,0,
                                      self.bounds.size.width, Height_EmojBoardView)];
        _emojiBoardView.delegate = self;
    }
    return _emojiBoardView;
}

//自定义扩展区域控件
- (UIView *)customExpansionView {
    if (!_customExpansionView) {
        _customExpansionView = [[UIView alloc] initWithFrame:
                                CGRectMake(0,0,
                                           self.bounds.size.width, Height_EmojBoardView)];
    }
    return _customExpansionView;
}
/**
 *  设置输入框初始状态
 *
 *  @param Status
 */
-(void)setInputBarStatus:(RCDLiveBottomBarStatus)Status{
    [self animationLayoutBottomBarWithStatus:Status animated:YES];
}

-(void)changeInputBarFrame:(CGRect)frame{
    self.originalFrame = frame;
    [self setFrame:frame];
    [self setInputBarStatus:RCDLiveBottomBarDefaultStatus];
    [self.chatSessionInputBarControl setFrame:CGRectMake(0, 0,
                                                         self.bounds.size.width,
                                                         frame.size.height)];
    _emojiBoardView = [[RCDLiveEmojiBoardView alloc] initWithFrame:
                       CGRectMake(0,0,
                                  self.bounds.size.width, Height_EmojBoardView)];
    _emojiBoardView.delegate = self;
    [self.chatSessionInputBarControl resetInputBar];
}
/*!
 展示扩展区域
 */
-(void)showCustomExpansionView{
    [self.chatSessionInputBarControl.inputTextView becomeFirstResponder];
    self.chatSessionInputBarControl.inputTextView.inputView = [self customExpansionView];
    CGRect chatInputBarRect = self.chatSessionInputBarControl.frame;
    float bottomY = 0;
    chatInputBarRect.origin.y =
    bottomY - self.chatSessionInputBarControl.bounds.size.height -
    self.customExpansionView.bounds.size.height;
    _chatSessionInputBarControl.originalPositionY =
    self.bounds.size.height -
    (Height_ChatSessionInputBar)-Height_EmojBoardView;
    [self.chatSessionInputBarControl.inputTextView reloadInputViews];
}

/*!
 隐藏扩展区域
 */
-(void)hideCustomExpansionView{
    [self.chatSessionInputBarControl.inputTextView resignFirstResponder];
    self.chatSessionInputBarControl.inputTextView.inputView = nil;
}

#pragma mark <RCChatSessionInputBarControlDelegate>
- (void) KeyboardWillShow:(NSNotification*)notification {
    CGRect keyboardBounds = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat keyboardHeight = keyboardBounds.size.height;
    CGRect frame = self.frame;
    frame.origin.y = self.originalFrame.origin.y - keyboardBounds.size.height;
    self.KeyboardFrame = keyboardBounds;
    CGFloat animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationDuration animations:^{
        [UIView setAnimationCurve:curve];
        [self setFrame:frame];
        [UIView commitAnimations];
    }];
    frame.size.height += keyboardHeight + (self.chatSessionInputBarControl.frame.size.height - Height_ChatSessionInputBar);
    if ([self.delegate respondsToSelector:@selector(onInputBarControlContentSizeChanged:withAnimationDuration:andAnimationCurve:)]) {
        [self.delegate onInputBarControlContentSizeChanged:frame withAnimationDuration:animationDuration andAnimationCurve:curve];
    }
    
    self.currentFrame = self.frame;
    self.currentInputBarHeight = self.frame.size.height;
    [self chatSessionInputBarControlContentSizeChanged:self.chatSessionInputBarControl.frame];
    
}


- (void)KeyboardWillHide:(NSNotification*)notification {
    if ([self.delegate respondsToSelector:@selector(onInputBarControlContentSizeChanged:withAnimationDuration:andAnimationCurve:)]) {
        CGRect frame = self.originalFrame;
        
        frame.size.height += self.chatSessionInputBarControl.frame.size.height - Height_ChatSessionInputBar;
        [self setFrame:frame];
        [self.delegate onInputBarControlContentSizeChanged:frame withAnimationDuration:0.1 andAnimationCurve:0];
    }
    [self animationLayoutBottomBarWithStatus:RCDLiveBottomBarDefaultStatus animated:YES];
    self.currentFrame = self.frame;
    self.KeyboardFrame = CGRectZero;
    self.currentInputBarHeight = self.frame.size.height;
    [self chatSessionInputBarControlContentSizeChanged:self.chatSessionInputBarControl.frame];
}


- (void)didTouchSwitchButton:(BOOL)switched {
    _isClickAddButton = NO;
    _isClickEmojiButton = NO;
    if (switched) {
        [self animationLayoutBottomBarWithStatus:RCDLiveBottomBarDefaultStatus animated:YES];
        if (_currentBottomBarStatus != RCDLiveBottomBarDefaultStatus) {
            [self.chatSessionInputBarControl.inputTextView resignFirstResponder];
        }
        
    }else{
        [self.chatSessionInputBarControl.inputTextView becomeFirstResponder];
    }
    
}

- (void)didTouchEmojiButton:(UIButton *)sender {
    _isClickAddButton = NO;
    [self.chatSessionInputBarControl.inputTextView becomeFirstResponder];
    if (_isClickEmojiButton) {
        [self.chatSessionInputBarControl.inputTextView becomeFirstResponder];
        [sender setImage:RCDLive_IMAGE_BY_NAMED(@"chatting_biaoqing_btn_normal") forState:UIControlStateNormal];
        _isClickEmojiButton = NO;
        self.chatSessionInputBarControl.inputTextView.inputView = nil;
    }else{
        _isClickEmojiButton = YES;
        [sender setImage:RCDLive_IMAGE_BY_NAMED(@"chat_setmode_key_btn_normal") forState:UIControlStateNormal];
        self.isIgnoreKeyboardHide = YES;
        self.chatSessionInputBarControl.inputTextView.inputView = [self emojiBoardView];
        CGRect chatInputBarRect = self.chatSessionInputBarControl.frame;
        float bottomY =  0;
        chatInputBarRect.origin.y =
        bottomY - self.chatSessionInputBarControl.bounds.size.height -
        self.emojiBoardView.bounds.size.height;
        _chatSessionInputBarControl.originalPositionY =
        self.bounds.size.height -
        (Height_ChatSessionInputBar) - Height_EmojBoardView;
        
    }
    
    [self.chatSessionInputBarControl.inputTextView reloadInputViews];
    
}


- (void)didTouchKeyboardReturnKey:(RCDLiveInputView *)inputControl
                             text:(NSString *)text {
    if([self.delegate respondsToSelector:@selector(onTouchSendButton:)]){
        [self.delegate onTouchSendButton:text];
    }
}


- (void)inputTextView:(UITextView *)inputTextView
shouldChangeTextInRange:(NSRange)range
      replacementText:(NSString *)text {
    
}


- (void)animationLayoutBottomBarWithStatus:(RCDLiveBottomBarStatus)bottomBarStatus animated:(BOOL)animated{
    if (bottomBarStatus == RCDLiveBottomBarDefaultStatus) {
        _isClickEmojiButton = NO;
        _isClickAddButton = NO;
    }
    if (bottomBarStatus != RCDLiveBottomBarEmojiStatus) {
        self.chatSessionInputBarControl.inputTextView.inputView = nil;
        [self.chatSessionInputBarControl.emojiButton setImage:RCDLive_IMAGE_BY_NAMED(@"chatting_biaoqing_btn_normal") forState:UIControlStateNormal];
    }
    if (bottomBarStatus == RCDLiveBottomBarEmojiStatus && !_emojiBoardView) {
        [self emojiBoardView];
    }
    
    if (bottomBarStatus == RCDLiveBottomBarKeyboardStatus) {
        [self.chatSessionInputBarControl.inputTextView becomeFirstResponder];
    }
    if (animated == YES) {
        [UIView beginAnimations:@"Move_bar" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationDelegate:self];
        [self layoutBottomBarWithStatus:bottomBarStatus];
        [UIView commitAnimations];
    }
    else
    {
        [self layoutBottomBarWithStatus:bottomBarStatus];
    }
}

- (void)layoutBottomBarWithStatus:(RCDLiveBottomBarStatus)bottomBarStatus {
    if (bottomBarStatus != RCDLiveBottomBarKeyboardStatus) {
        if (self.chatSessionInputBarControl.inputTextView.isFirstResponder) {
            [self.chatSessionInputBarControl.inputTextView resignFirstResponder];
        }
    }
    
    CGRect chatInputBarRect = self.chatSessionInputBarControl.frame;
    switch (bottomBarStatus) {
        case RCDLiveBottomBarDefaultStatus: {
            CGRect frame = self.originalFrame;
            frame.origin.y = frame.origin.y - self.chatSessionInputBarControl.frame.size.height + Height_ChatSessionInputBar;
            frame.size.height += chatInputBarRect.size.height - Height_ChatSessionInputBar;
            [self setFrame:frame];
        } break;
            //            case RCDLiveBottomBarKeyboardStatus: {
            //                CGRect frame = self.originalFrame;
            //                frame.origin.y = frame.origin.y - self.chatSessionInputBarControl.frame.size.height + Height_ChatSessionInputBar;
            //                frame.size.height += chatInputBarRect.size.height - Height_ChatSessionInputBar;
            //                [self setFrame:frame];
            //
            //
            //            } break;
            
        default:
            break;
    }
    
    [self.chatSessionInputBarControl setFrame:chatInputBarRect];
    self.chatSessionInputBarControl.currentPositionY =
    self.chatSessionInputBarControl.frame.origin.y;
    _currentBottomBarStatus = bottomBarStatus;
    
}


- (void)chatSessionInputBarControlContentSizeChanged:(CGRect)frame {
    CGRect chatInputBarRect = self.chatSessionInputBarControl.frame;
    chatInputBarRect.origin.y = 0;
    [self.chatSessionInputBarControl setFrame:chatInputBarRect];
    CGRect temp = self.currentFrame;
    if (!self.chatSessionInputBarControl.inputTextView.isFirstResponder) {
        temp = self.originalFrame;
    }
    temp.size.height = chatInputBarRect.size.height;
    temp.origin.y = temp.origin.y + Height_ChatSessionInputBar - chatInputBarRect.size.height;
    [self setFrame:temp];
    
    if ([self.delegate respondsToSelector:@selector(onInputBarControlContentSizeChanged:withAnimationDuration:andAnimationCurve:)]) {
        CGRect newframe = self.frame;
        newframe.size.height = self.KeyboardFrame.size.height + frame.size.height;
        if (newframe.size.height == self.currentInputBarHeight) {
            return;
        }
        self.currentInputBarHeight = newframe.size.height;
        [self.delegate onInputBarControlContentSizeChanged:newframe withAnimationDuration:0.1 andAnimationCurve:0];
    }
}

- (void)dealloc {
    self.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma 点击表情代理
- (void)didTouchEmojiView:(RCDLiveEmojiBoardView *)emojiView
             touchedEmoji:(NSString *)string {
    
    if (nil == string) {
        [self.chatSessionInputBarControl.inputTextView deleteBackward];
        
    } else {
        
        NSString *replaceString = string;
        if (replaceString.length < 5000) {
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:replaceString];
            UIFont *font = [UIFont fontWithName:@"Heiti SC-Bold" size:16];
            [attStr addAttribute:(__bridge NSString*)kCTFontAttributeName value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)font.fontName,
                                                                                                       16,
                                                                                                       NULL)) range:NSMakeRange(0, replaceString.length)];
            
            NSInteger cursorPosition;
            if (self.chatSessionInputBarControl.inputTextView.selectedTextRange) {
                cursorPosition = self.chatSessionInputBarControl.inputTextView.selectedRange.location ;
            } else {
                cursorPosition = 0;
            }
            //获取光标位置
            if(cursorPosition> self.chatSessionInputBarControl.inputTextView.textStorage.length)
                cursorPosition = self.chatSessionInputBarControl.inputTextView.textStorage.length;
            [self.chatSessionInputBarControl.inputTextView.textStorage
             insertAttributedString:attStr  atIndex:cursorPosition];
            
            NSRange range;
            range.location = self.chatSessionInputBarControl.inputTextView.selectedRange.location + string.length;
            range.length = 1;
            
            self.chatSessionInputBarControl.inputTextView.selectedRange = range;
            
            {
                CGFloat _inputTextview_height = 36.0f;
                if (_chatSessionInputBarControl.inputTextView.contentSize.height < 70 &&
                    _chatSessionInputBarControl.inputTextView.contentSize.height >
                    36.0f) {
                    _inputTextview_height =
                    _chatSessionInputBarControl.inputTextView.contentSize.height;
                }
                if (_chatSessionInputBarControl.inputTextView.contentSize.height >=
                    70) {
                    _inputTextview_height = 70;
                }
                
                float animateDuration = 0.5;
                [UIView animateWithDuration:animateDuration
                                 animations:^{
                                     
                                }];
            }
        }
    }
    
    UITextView *textView = self.chatSessionInputBarControl.inputTextView;
    {
        CGRect line =
        [textView caretRectForPosition:textView.selectedTextRange.start];
        CGFloat overflow =
        line.origin.y + line.size.height -
        (textView.contentOffset.y + textView.bounds.size.height -
         textView.contentInset.bottom - textView.contentInset.top);
        if (overflow > 0) {
            // We are at the bottom of the visible text and introduced a line feed,
            // scroll down (iOS 7 does not do it)
            // Scroll caret to visible area
            CGPoint offset = textView.contentOffset;
            offset.y += overflow + 7; // leave 7 pixels margin
            // Cannot animate with setContentOffset:animated: or caret will not appear
            __weak typeof(textView)weakTextView = textView;
            [UIView animateWithDuration:.2
                             animations:^{
                                 [weakTextView setContentOffset:offset];
                             }];
        }
    }
    //输入表情触发文本框变化，更新@信息的range
    if (self.chatSessionInputBarControl.delegate) {
        NSInteger cursorPosition;
        if (self.chatSessionInputBarControl.inputTextView.selectedTextRange) {
            cursorPosition = self.chatSessionInputBarControl.inputTextView.selectedRange.location ;
        } else {
            cursorPosition = 0;
        }
        NSRange range = NSMakeRange(cursorPosition, 0);
        if(string){
            range = NSMakeRange(cursorPosition, string.length);
        }
        
        [self inputTextView:self.chatSessionInputBarControl.inputTextView shouldChangeTextInRange:range replacementText:nil];
    }
    
    if(self.chatSessionInputBarControl.inputTextView.text && self.chatSessionInputBarControl.inputTextView.text.length > 0){
        [self.emojiBoardView enableSendButton:YES];
    }else{
        [self.emojiBoardView enableSendButton:NO];
    }
    
}


- (void)didSendButtonEvent {
    NSString *_sendText = self.chatSessionInputBarControl.inputTextView.text;
    
    NSString *_formatString = [_sendText
                               stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (0 == [_formatString length]) {
        return;
    }
    //    self.chatSessionInputBarControl.inputTextView.text = @"";
    if([self.delegate respondsToSelector:@selector(onTouchSendButton:)]){
        [self.delegate onTouchSendButton:_sendText];
    }
}

-(void)clearInputView{
    [self.chatSessionInputBarControl clearInputText];
}

@end
