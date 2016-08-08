//
//  RCMessageCommonCell.m
//  RongIMKit
//
//  Created by xugang on 15/1/28.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDLiveMessageCell.h"
#import "RCDLiveKitUtility.h"
#import "RCDLiveTipLabel.h"
#import "RCDLiveKitUtility.h"
#import "RCDLiveKitCommonDefine.h"
#import <RongIMLib/RongIMLib.h>
#import "RCDLive.h"

@interface RCDLiveMessageCell ()
//- (void) configure;
- (void)setCellAutoLayout;

@end

// static int indexCell = 1;

@implementation RCDLiveMessageCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupMessageCellView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMessageCellView];
    }
    return self;
}
- (void)setupMessageCellView
{
    _isDisplayNickname = NO;
    self.delegate = nil;
    self.messageContentView = [[RCDLiveContentView alloc] initWithFrame:CGRectZero];
    self.statusContentView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.nicknameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nicknameLabel.backgroundColor = [UIColor clearColor];
    [self.nicknameLabel setFont:[UIFont systemFontOfSize:16]];
//    [self.nicknameLabel setTextColor:RCDLive_HEXCOLOR(0xe2e2e2)];
    self.bubbleBackgroundView = [[RCDLiveContentView alloc] initWithFrame:CGRectZero];
    [self.bubbleBackgroundView addSubview:self.messageContentView];
    [self.baseContentView addSubview:self.statusContentView];
    [self.bubbleBackgroundView addSubview:self.nicknameLabel];
    [self.baseContentView addSubview:self.bubbleBackgroundView];
    
    self.statusContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    _statusContentView.backgroundColor = [UIColor clearColor];
    [self.baseContentView addSubview:_statusContentView];
    
    __weak typeof(&*self) __blockself = self;
    [self.bubbleBackgroundView registerFrameChangedEvent:^(CGRect frame) {
        if (__blockself.model) {
            if (__blockself.model.messageDirection == MessageDirection_SEND) {
                __blockself.statusContentView.frame = CGRectMake(
                                                                 frame.size.width +10 , frame.origin.y + (frame.size.height - 25) / 2.0f, 25, 25);
            } else {
                __blockself.statusContentView.frame = CGRectZero;
            }
        }
        
    }];
    
    self.messageFailedStatusView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [_messageFailedStatusView
     setImage:[RCDLiveKitUtility imageNamed:@"message_send_fail_status" ofBundle:@"RongCloud.bundle"]
     forState:UIControlStateNormal];
    [self.statusContentView addSubview:_messageFailedStatusView];
    _messageFailedStatusView.hidden = YES;
    [_messageFailedStatusView addTarget:self
                                 action:@selector(didclickMsgFailedView:)
                       forControlEvents:UIControlEventTouchUpInside];
    
    self.messageActivityIndicatorView =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.statusContentView addSubview:_messageActivityIndicatorView];
    _messageActivityIndicatorView.hidden = YES;

}
//- (void)prepareForReuse
//{
//    [super prepareForReuse];
//
//}

- (void)setDataModel:(RCDLiveMessageModel *)model {
    [super setDataModel:model];
    self.nicknameLabel.text = @"";
    self.messageSendSuccessStatusView.hidden = YES;
    self.messageHasReadStatusView.hidden = YES;

    _isDisplayNickname = model.isDisplayNickname;
    if(model.content.senderUserInfo)
    {
        
        model.userInfo = model.content.senderUserInfo;
//        [self.portraitImageView setImageURL:[NSURL URLWithString:model.content.senderUserInfo.portraitUri]];
        [self.nicknameLabel setText:[NSString stringWithFormat:@"%@:" ,model.content.senderUserInfo.name]];
    }
    [self setCellAutoLayout];
}
- (void)setCellAutoLayout {

    _messageContentViewWidth = 200;
    // receiver
    CGFloat messageContentViewY = 8;
    CGFloat messageContentViewX = 6;
    self.nicknameLabel.frame = CGRectMake(messageContentViewX ,2, 200, 17);
    self.messageContentView.frame = CGRectMake(0,messageContentViewY,0,0);
    [self updateStatusContentView:self.model];
}

- (void)updateStatusContentView:(RCDLiveMessageModel *)model {
    self.messageSendSuccessStatusView.hidden = YES;
    self.messageHasReadStatusView.hidden = YES;
    if (model.messageDirection == MessageDirection_RECEIVE) {
        self.statusContentView.hidden = YES;
        return;
    } else {
        self.statusContentView.hidden = NO;
    }
    __weak typeof(&*self) __blockSelf = self;

    dispatch_async(dispatch_get_main_queue(), ^{

      if (__blockSelf.model.sentStatus == SentStatus_SENDING) {
          __blockSelf.messageFailedStatusView.hidden = YES;
          __blockSelf.messageHasReadStatusView.hidden = YES;
          __blockSelf.messageSendSuccessStatusView.hidden = YES;
          if (__blockSelf.messageActivityIndicatorView) {
              __blockSelf.messageActivityIndicatorView.hidden = NO;
              if (__blockSelf.messageActivityIndicatorView.isAnimating == NO) {
                  [__blockSelf.messageActivityIndicatorView startAnimating];
              }
          }

      } else if (__blockSelf.model.sentStatus == SentStatus_FAILED) {
          __blockSelf.messageFailedStatusView.hidden = NO;
          __blockSelf.messageHasReadStatusView.hidden = YES;
          __blockSelf.messageSendSuccessStatusView.hidden = YES;
          if (__blockSelf.messageActivityIndicatorView) {
              __blockSelf.messageActivityIndicatorView.hidden = YES;
              if (__blockSelf.messageActivityIndicatorView.isAnimating == YES) {
                  [__blockSelf.messageActivityIndicatorView stopAnimating];
              }
          }
      } else if (__blockSelf.model.sentStatus == SentStatus_SENT) {
          __blockSelf.messageFailedStatusView.hidden = YES;
          if (__blockSelf.messageActivityIndicatorView) {
              __blockSelf.messageActivityIndicatorView.hidden = YES;
              if (__blockSelf.messageActivityIndicatorView.isAnimating == YES) {
                  [__blockSelf.messageActivityIndicatorView stopAnimating];
              }
          }
      }
    });
}

#pragma mark private
- (void)tapUserPortaitEvent:(UIGestureRecognizer *)gestureRecognizer {
    __weak typeof(&*self) weakSelf = self;
    if ([self.delegate respondsToSelector:@selector(didTapCellPortrait:)]) {
        [self.delegate didTapCellPortrait:weakSelf.model.senderUserId];
    }
}

- (void)longPressUserPortaitEvent:(UIGestureRecognizer *)gestureRecognizer {
    __weak typeof(&*self) weakSelf = self;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(didLongPressCellPortrait:)]) {
            [self.delegate didLongPressCellPortrait:weakSelf.model.senderUserId];
        }
    }
}
//-(void)tapBubbleBackgroundViewEvent:(UIGestureRecognizer *)gestureRecognizer
//{
//    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
//        [self.delegate didTapMessageCell:self.model];
//    }
//}

// resend event
//- (void)msgStatusViewTapEventHandler:(id)sender
//{
//    //RCDLive_DebugLog(@"%s", __FUNCTION__);
//
//    //resend the failed message.
//    if ([self.delegate respondsToSelector:@selector(didTapMsgStatusViewForResending:)]) {
//        [self.delegate didTapMsgStatusViewForResending:self.model];
//    }
//
//}
- (void)imageMessageSendProgressing:(NSInteger)progress {
}
- (void)messageCellUpdateSendingStatusEvent:(NSNotification *)notification {

    RCDLiveMessageCellNotificationModel *notifyModel = notification.object;

    if (self.model.messageId == notifyModel.messageId) {
        RCDLive_DebugLog(@"messageCellUpdateSendingStatusEvent >%@ ", notifyModel.actionName);
        if ([notifyModel.actionName isEqualToString:RCDLiveCONVERSATION_CELL_STATUS_SEND_BEGIN]) {
            self.model.sentStatus = SentStatus_SENDING;
            [self updateStatusContentView:self.model];

        } else if ([notifyModel.actionName isEqualToString:RCDLiveCONVERSATION_CELL_STATUS_SEND_FAILED]) {
            self.model.sentStatus = SentStatus_FAILED;
            [self updateStatusContentView:self.model];
        } else if ([notifyModel.actionName isEqualToString:RCDLiveCONVERSATION_CELL_STATUS_SEND_SUCCESS]) {
            if (self.model.sentStatus != SentStatus_READ) {
                self.model.sentStatus = SentStatus_SENT;
                [self updateStatusContentView:self.model];
            }
        } else if ([notifyModel.actionName isEqualToString:RCDLiveCONVERSATION_CELL_STATUS_SEND_PROGRESS]) {
            [self imageMessageSendProgressing:notifyModel.progress];
        }
//        else if ([notifyModel.actionName isEqualToString:RCDLiveCONVERSATION_CELL_STATUS_SEND_HASREAD] && [RCDLive sharedRCDLive].enableReadReceipt) {
//            self.model.sentStatus = SentStatus_READ;
//            [self updateStatusContentView:self.model];
//        }

    }
}

- (void)didclickMsgFailedView:(UIButton *)button {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didTapmessageFailedStatusViewForResend:)]) {
            [self.delegate didTapmessageFailedStatusViewForResend:self.model];
        }
    }
}

@end
