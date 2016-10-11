//
//  RCDLiveInputView.m
//  RongChatRoomDemo
//
//  Created by 杜立召 on 16/8/3.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import "RCDLiveInputView.h"
#import "RCDLiveKitUtility.h"
#import "RCDLiveKitCommonDefine.h"
#import <RongIMLib/RongIMLib.h>
// NSString * const RCChatKeyboardNotificationKeyboardDidChangeFrame =
// @"RCChatKeyboardNotificationKeyboardDidChangeFrame";
// NSString * const RCChatKeyboardUserInfoKeyKeyboardDidChangeFrame  =
// @"RCChatKeyboardUserInfoKeyKeyboardDidChangeFrame";

#define RC_PUBLIC_SERVICE_MENU_BUTTON_FONT_SIZE 16 //systemFontOfSize:RC_PUBLIC_SERVICE_MENU_ITEM_FONT_SIZE]
#define RC_PUBLIC_SERVICE_MENU_ICON_GAP 3
#define RC_PUBLIC_SERVICE_MENU_SEPARATE_WIDTH 1
#define RC_PUBLIC_SERVICE_SUBMENU_PADDING 6
typedef void (^RCTKAnimationCompletionBlock)(BOOL finished);

@interface RCDLiveInputView () <UITextViewDelegate>

@property(nonatomic, strong) NSMutableArray *inputContainerSubViewConstraints;


- (void)setAutoLayoutForSubViews;

- (void)switchInputBoxOrRecord;

- (void)voiceRecordButtonTouchDown:(UIButton *)sender;
- (void)voiceRecordButtonTouchUpInside:(UIButton *)sender;
- (void)voiceRecordButtonTouchDragExit:(UIButton *)sender;
- (void)voiceRecordButtonTouchDragEnter:(UIButton *)sender;
- (void)voiceRecordButtonTouchUpOutside:(UIButton *)sender;

- (void)rcInputBar_registerForNotifications;
- (void)rcInputBar_unregisterForNotifications;
- (void)rcInputBar_didReceiveKeyboardWillShowNotification:(NSNotification *)notification;
- (void)rcInputBar_didReceiveKeyboardWillHideNotification:(NSNotification *)notification;

@end

@implementation RCDLiveInputView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.inputContainerSubViewConstraints = [[NSMutableArray alloc] init];
        [self resetInputBar];
        self.currentPositionY = frame.origin.y;
        self.originalPositionY = frame.origin.y;
        
        self.inputTextview_height=36.0f;
        self.backgroundColor = RCDLive_HEXCOLOR(0xf4f4f6);;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = RCDLive_HEXCOLOR(0xdbdbdd).CGColor;
        
    }
    return self;
}

- (void)resetInputBar {
    if (self.inputContainerSubViewConstraints.count > 0) {
        [self.inputContainerView removeConstraints:_inputContainerSubViewConstraints];
        [_inputContainerSubViewConstraints removeAllObjects];
    }
    
    if (self.switchButton) {
        [self.switchButton removeFromSuperview];
        self.switchButton = nil;
    }
    
    if (self.inputTextView) {
        [self.inputTextView removeFromSuperview];
        self.inputTextView = nil;
    }
    if (self.emojiButton) {
        [self.emojiButton removeFromSuperview];
        self.emojiButton = nil;
    }
    
    if (self.inputContainerView) {
        [self.inputContainerView removeFromSuperview];
        self.inputContainerView = nil;
    }
    
    self.inputContainerView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_inputContainerView];
    
    [self configInputContainerView];
    [self setAutoLayoutForSubViews];
    [self rcInputBar_registerForNotifications];
}

- (void)configInputContainerView {
    
    self.switchButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_switchButton setImage:RCDLive_IMAGE_BY_NAMED(@"chat_setmode_voice_btn_normal") forState:UIControlStateNormal];
    [_switchButton addTarget:self
                      action:@selector(switchInputBoxOrRecord)
            forControlEvents:UIControlEventTouchUpInside];
    [_switchButton setExclusiveTouch:YES];
    [self.inputContainerView addSubview:_switchButton];
    self.emojiButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_emojiButton setImage:RCDLive_IMAGE_BY_NAMED(@"chatting_biaoqing_btn_normal") forState:UIControlStateNormal];
    [_emojiButton setImage:RCDLive_IMAGE_BY_NAMED(@"chatting_biaoqing_btn_selected") forState:UIControlStateSelected];
    [_emojiButton setExclusiveTouch:YES];
    [_emojiButton addTarget:self action:@selector(didTouchEmojiDown:) forControlEvents:UIControlEventTouchUpInside];
    
    self.inputContainerView.backgroundColor = [UIColor clearColor];
    [self.inputContainerView addSubview:_emojiButton];
    self.inputTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    _inputTextView.delegate = self;
    [_inputTextView setExclusiveTouch:YES];
    [_inputTextView setTextColor:[UIColor blackColor]];
    [_inputTextView setFont:[UIFont systemFontOfSize:16]];
    [_inputTextView setReturnKeyType:UIReturnKeySend];
    _inputTextView.backgroundColor = [UIColor colorWithRed:248 / 255.f green:248 / 255.f blue:248 / 255.f alpha:1];
    _inputTextView.enablesReturnKeyAutomatically = YES;
    _inputTextView.layer.cornerRadius = 4;
    _inputTextView.layer.masksToBounds = YES;
    _inputTextView.layer.borderWidth = 0.3f;
    _inputTextView.layer.borderColor = RCDLive_HEXCOLOR(0xA4A4A4).CGColor;
    [_inputTextView setAccessibilityLabel:@"chat_input_textView"];
    if (RCDLive_IOS_FSystenVersion >= 7.0) {
        _inputTextView.layoutManager.allowsNonContiguousLayout = NO;
    }
    [self.inputContainerView addSubview:_inputTextView];
}

- (void)setAutoLayoutForSubViews
{
    self.inputContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    [self setLayoutForInputContainerView];
}

- (void)setLayoutForInputContainerView {
    self.emojiButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.inputTextView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *_bindingViews =
    NSDictionaryOfVariableBindings(_switchButton, _inputTextView, _emojiButton);
    
    NSString *format =  @"H:|-0-[_switchButton(0)]-10-[_inputTextView]-10-[_emojiButton(30)" @"]-10-|";
    [self.inputContainerSubViewConstraints
     addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:_bindingViews]];
    
//    [self.inputContainerSubViewConstraints
//     addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_switchButton(30)]"
//                                                                 options:0
//                                                                 metrics:nil
//                                                                   views:_bindingViews]];
    [self.inputContainerSubViewConstraints
     addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[_inputTextView(36)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:_bindingViews]];
    
    [self.inputContainerSubViewConstraints
     addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_emojiButton(31)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:_bindingViews]];
    
    
    [self.inputContainerView addConstraints:self.inputContainerSubViewConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
//    self.inputTextView.translatesAutoresizingMaskIntoConstraints = YES;
//    CGRect inputRect = CGRectMake(self.recordButton.frame.origin.x, self.recordButton.frame.origin.y,
//                                  self.recordButton.frame.size.width, self.recordButton.frame.size.height);
//    [self.inputTextView setFrame:inputRect];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO; //隐藏系统默认的菜单项
}

#pragma mark - Notifications

- (void)rcInputBar_registerForNotifications {
    [self rcInputBar_unregisterForNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rcInputBar_didReceiveKeyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rcInputBar_didReceiveKeyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)rcInputBar_unregisterForNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)rcInputBar_didReceiveKeyboardWillShowNotification:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardBeginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (!CGRectEqualToRect(keyboardBeginFrame, keyboardEndFrame)) {
        UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        NSInteger animationCurveOption = (animationCurve << 16);
        
        double animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:animationCurveOption
                         animations:^{
                             if ([self.delegate respondsToSelector:@selector(keyboardWillShowWithFrame:)]) {
                                 [self.delegate keyboardWillShowWithFrame:keyboardEndFrame];
                             }
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)rcInputBar_didReceiveKeyboardWillHideNotification:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardBeginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (!CGRectEqualToRect(keyboardBeginFrame, keyboardEndFrame)) {
        UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        NSInteger animationCurveOption = (animationCurve << 16);
        
        double animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:animationCurveOption
                         animations:^{
                             if (!CGRectEqualToRect(keyboardBeginFrame, keyboardEndFrame)) {
                                 if ([self.delegate respondsToSelector:@selector(keyboardWillHide)]) {
                                     [self.delegate keyboardWillHide];
                                 }
                             }
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}


- (void)didTouchEmojiDown:(UIButton *)sender {
    if (self.inputTextView.hidden) {
        [self switchInputBoxOrRecord];
    }
    [self.delegate didTouchEmojiButton:sender];
}

#pragma mark <UITextViewDelegate>
- (void)changeInputViewFrame:(NSString *)text textView:(UITextView *)textView range:(NSRange)range {
    _inputTextview_height = 36.0f;
    if (_inputTextView.contentSize.height < 70 && _inputTextView.contentSize.height > 36.0f) {
        _inputTextview_height = _inputTextView.contentSize.height;
        
    }
    if (_inputTextView.contentSize.height >= 70) {
        _inputTextview_height = 70;
        
    }
    NSString *inputStr = _inputTextView.text;
    CGSize textViewSize=[self TextViewAutoCalculateRectWith:inputStr FontSize:16.0 MaxSize:CGSizeMake(_inputTextView.frame.size.width, 70)];
    
    CGSize textSize=[self TextViewAutoCalculateRectWith:inputStr FontSize:16.0 MaxSize:CGSizeMake(_inputTextView.frame.size.width, 70)];
    if (textViewSize.height<=36.0f&&range.location==0) {
        _inputTextview_height=36.0f;
    }
    else if(textViewSize.height>36.0f&&textViewSize.height<=55.0f)
    {
        _inputTextview_height=55.0f;
    }
    else if (textViewSize.height>55)
    {
        _inputTextview_height=70.0f;
    }
    
    if ([text isEqualToString:@""]&&range.location!=0) {
        if (textSize.width>=_inputTextView.frame.size.width&&range.length==1) {
            if (_inputTextView.contentSize.height < 70 && _inputTextView.contentSize.height > 36.0f) {
                _inputTextview_height = _inputTextView.contentSize.height;
                
            }
            if (_inputTextView.contentSize.height >= 70) {
                _inputTextview_height = 70;
                
            }
        }
        
        else
        {
            NSString *headString=[inputStr substringToIndex:range.location];
            NSString *lastString=[inputStr substringFromIndex:range.location+range.length];
            
            CGSize locationSize=[self TextViewAutoCalculateRectWith:[NSString stringWithFormat:@"%@%@",headString,lastString] FontSize:16.0 MaxSize:CGSizeMake(_inputTextView.frame.size.width, 70)];
            if (locationSize.height<=36.0) {
                _inputTextview_height=36.0;
                
            }
            if (locationSize.height>36.0&&locationSize.height<=55.0) {
                _inputTextview_height= 55.0;
                
            }
            if (locationSize.height>55.0) {
                _inputTextview_height=70.0;
                
            }
            
        }
        
    }
    float animateDuration = 0.5;
    [UIView animateWithDuration:animateDuration
                     animations:^{
//                         CGRect intputTextRect = self.inputTextView.frame;
//                         intputTextRect.size.height = _inputTextview_height;
//                         intputTextRect.origin.y = 7;
//                         [self.inputTextView setFrame:intputTextRect];
//                         self.inputTextview_height =
//                         _inputTextview_height;
//                         
//                         CGRect vRect = self.frame;
//                         vRect.size.height =
//                         50 + (_inputTextview_height - 36);
//                         vRect.origin.y = self.originalPositionY -
//                         (_inputTextview_height - 36
//                          );
//                         self.frame = vRect;
//                         self.currentPositionY = vRect.origin.y;

                     }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    [self.delegate inputTextView:textView shouldChangeTextInRange:range replacementText:text];
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didTouchKeyboardReturnKey:text:)]) {
            NSString *_needToSendText = textView.text;
            NSString *_formatString =
            [_needToSendText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (0 == [_formatString length]) {
                //                UIAlertView *notAllowSendSpace = [[UIAlertView alloc]
                //                        initWithTitle:nil
                //                              message:NSLocalizedStringFromTable(@"whiteSpaceMessage", @"RongCloudKit", nil)
                //                             delegate:self
                //                    cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @"RongCloudKit", nil)
                //                    otherButtonTitles:nil, nil];
                //                [notAllowSendSpace show];
            } else {
                [self.delegate didTouchKeyboardReturnKey:self text:[_needToSendText copy]];
            }
        }
        
        return NO;
    }
    
    [self changeInputViewFrame:text textView:textView range:range];
    return YES;
}

-(void)clearInputText{
    self.inputTextView.text = @"";
    
    _inputTextview_height = 36.0f;
    
    CGRect intputTextRect = self.inputTextView.frame;
    intputTextRect.size.height = _inputTextview_height;
    intputTextRect.origin.y = 7;
    [_inputTextView setFrame:intputTextRect];
    
    CGRect vRect = self.frame;
    vRect.size.height = Height_ChatSessionInputBar;
    vRect.origin.y = _originalPositionY;
    _currentPositionY = _originalPositionY;
    
    [self setFrame:vRect];
    
    CGRect rectFrame = self.inputContainerView.frame;
    rectFrame.size.height = vRect.size.height;
    self.inputContainerView.frame = rectFrame;
    
    [self.delegate chatSessionInputBarControlContentSizeChanged:vRect];
}

- (CGSize)TextViewAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize

{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    if (text) {
        CGSize labelSize = CGSizeZero;
        if (RCDLive_IOS_FSystenVersion < 7.0) {
            labelSize = RCDLive_RC_MULTILINE_TEXTSIZE_LIOS7(text, [UIFont systemFontOfSize:fontSize], maxSize, NSLineBreakByTruncatingTail);
        }
        else
        {
            labelSize = RCDLive_RC_MULTILINE_TEXTSIZE_GEIOS7(text, [UIFont systemFontOfSize:fontSize], maxSize);
        }
        //        NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
        //        CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        labelSize.height=ceil(labelSize.height);
        labelSize.width=ceil(labelSize.width);
        return labelSize;
    } else {
        return CGSizeZero;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    // filter the space
}
- (void)textViewDidChange:(UITextView *)textView {
    CGRect line = [textView caretRectForPosition:textView.selectedTextRange.start];
    CGFloat overflow = line.size.height - (textView.contentOffset.y + textView.bounds.size.height -
                                           textView.contentInset.bottom - textView.contentInset.top);
    if (overflow > 0) {
        // We are at the bottom of the visible text and introduced a line feed,
        // scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        //offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2
                         animations:^{
                             [textView setContentOffset:offset];
                         }];
    }
    
    
    NSRange range;
    range.location = self.inputTextView.text.length;
    [self changeInputViewFrame:self.inputTextView.text textView:self.inputTextView range:range];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIView *)newLine {
    UILabel *line = [UILabel new];
    line.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];
    return line;
}
@end
