//
//  RCImageMessageCell.m
//  RongIMKit
//
//  Created by xugang on 15/2/2.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCImageMessageCell.h"
#import "RCKitUtility.h"
#import "RCIM.h"
#import "RCKitCommonDefine.h"

@interface RCImageMessageCell ()

- (void)initialize;

@end

@implementation RCImageMessageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize {
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    self.pictureView = [[UIImageView alloc] initWithFrame:CGRectZero];

    self.pictureView.layer.cornerRadius = 2.0f;
    self.pictureView.layer.masksToBounds = YES;
    [self.bubbleBackgroundView addSubview:self.pictureView];
    
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self.bubbleBackgroundView addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *pictureTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicture:)];
    pictureTap.numberOfTapsRequired = 1;
    pictureTap.numberOfTouchesRequired = 1;
    [self.bubbleBackgroundView addGestureRecognizer:pictureTap];
    self.bubbleBackgroundView.userInteractionEnabled = YES;

    self.progressView = [[RCImageMessageProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    UITapGestureRecognizer *progressViewTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicture:)];
//    progressViewTap.numberOfTapsRequired = 1;
//    progressViewTap.numberOfTouchesRequired = 1;
//    [self.progressView addGestureRecognizer:progressViewTap];
//    self.progressView.userInteractionEnabled = YES;
    
    self.messageActivityIndicatorView = nil;
}
- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)tapPicture:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];

    RCImageMessage *_imageMessage = (RCImageMessage *)model.content;
    if (_imageMessage) {
        self.pictureView.image = _imageMessage.thumbnailImage;

        CGSize imageSize = [RCImageMessageCell getImageMessageCellSize:_imageMessage.thumbnailImage];
        CGRect messageContentViewRect = self.messageContentView.frame;
        if (model.messageDirection == MessageDirection_RECEIVE) {
            messageContentViewRect.size.width = imageSize.width+12;
            messageContentViewRect.size.height = imageSize.height+4;
            self.messageContentView.frame = messageContentViewRect;
            self.bubbleBackgroundView.frame = CGRectMake(0, 0, imageSize.width+4+8, imageSize.height+4);
            self.bubbleBackgroundView.image = [RCKitUtility imageNamed:@"chat_from_bg_normal" ofBundle:@"RongCloud.bundle"];
            UIImage *image = self.bubbleBackgroundView.image;
            self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8,image.size.height * 0.2, image.size.width * 0.2)];
            self.pictureView.frame = CGRectMake(10, 2, imageSize.width, imageSize.height);
            
        } else {
            messageContentViewRect.size.width = imageSize.width+12;
            messageContentViewRect.size.height = imageSize.height+4;
            messageContentViewRect.origin.x =
                self.baseContentView.bounds.size.width -
                (messageContentViewRect.size.width + 8 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10);
            self.messageContentView.frame = messageContentViewRect;
            self.bubbleBackgroundView.frame = CGRectMake(0, 0,imageSize.width+5+8, imageSize.height+4);
            self.bubbleBackgroundView.image = [RCKitUtility imageNamed:@"chat_to_bg_normal" ofBundle:@"RongCloud.bundle"];
            UIImage *image = self.bubbleBackgroundView.image;
            self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.2,image.size.height * 0.2, image.size.width * 0.8)];
            self.pictureView.frame = CGRectMake(2,2, imageSize.width, imageSize.height);
        }

    } else {
//        DebugLog(@"[RongIMKit]: RCMessageModel.content is NOT RCImageMessage object");
    }

    [self setAutoLayout];
    
    [self updateStatusContentView:self.model];
    if (model.sentStatus == SentStatus_SENDING) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pictureView addSubview:_progressView];
            [self.progressView setFrame:self.pictureView.bounds];
            [self.progressView startAnimating];
            self.pictureView.userInteractionEnabled = NO;
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressView removeFromSuperview];
            self.pictureView.userInteractionEnabled = YES;
        });
    }
}

- (void)setAutoLayout {
    // DebugLog(@"image cell set model finish >%@",[NSDate date]);
}

- (void)messageCellUpdateSendingStatusEvent:(NSNotification *)notification {

    RCMessageCellNotificationModel *notifyModel = notification.object;

    NSInteger progress = notifyModel.progress;

    if (self.model.messageId == notifyModel.messageId) {
        if ([notifyModel.actionName isEqualToString:CONVERSATION_CELL_STATUS_SEND_BEGIN]) {
            self.model.sentStatus = SentStatus_SENDING;
            [self updateStatusContentView:self.model];

            dispatch_async(dispatch_get_main_queue(), ^{
              [self.pictureView addSubview:_progressView];
              [self.progressView setFrame:self.pictureView.bounds];
              [self.progressView startAnimating];
              self.pictureView.userInteractionEnabled = NO;
            });

        } else if ([notifyModel.actionName isEqualToString:CONVERSATION_CELL_STATUS_SEND_FAILED]) {
            self.model.sentStatus = SentStatus_FAILED;
            [self updateStatusContentView:self.model];
            dispatch_async(dispatch_get_main_queue(), ^{
              [self.progressView stopAnimating];
              [self.progressView removeFromSuperview];
              self.pictureView.userInteractionEnabled = YES;
            });
        } else if ([notifyModel.actionName isEqualToString:CONVERSATION_CELL_STATUS_SEND_SUCCESS]) {
           if (self.model.sentStatus != SentStatus_READ) {
                self.model.sentStatus = SentStatus_SENT;
                [self updateStatusContentView:self.model];
                dispatch_async(dispatch_get_main_queue(), ^{
                  [self.progressView stopAnimating];
                  [self.progressView removeFromSuperview];
                  self.pictureView.userInteractionEnabled = YES;
                });
           }
        } else if ([notifyModel.actionName isEqualToString:CONVERSATION_CELL_STATUS_SEND_PROGRESS]) {
            dispatch_async(dispatch_get_main_queue(), ^{
              [self.progressView updateProgress:progress];
            });
        }
        else if (self.model.sentStatus == SentStatus_READ && self.isDisplayReadStatus) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressView stopAnimating];
                [self.progressView removeFromSuperview];
                self.pictureView.userInteractionEnabled = YES;
                self.messageHasReadStatusView.hidden = NO;
                self.messageFailedStatusView.hidden = YES;
                self.messageSendSuccessStatusView.hidden = YES;
                self.model.sentStatus = SentStatus_READ;
                [self updateStatusContentView:self.model];
                self.statusContentView.frame = CGRectMake(self.pictureView.frame.origin.x - 20 , self.pictureView.frame.size.height - 18 , 18, 18);

            });
            
        }

    }
}

// override
- (void)msgStatusViewTapEventHandler:(id)sender {
    //[super msgStatusViewTapEventHandler:sender];

    // to do something.
}

- (void)longPressed:(id)sender {
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        DebugLog(@"long press end");
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        [self.delegate didLongTouchMessageCell:self.model inView:self.pictureView];
    }
}
+ (CGSize)getImageMessageCellSize:(UIImage *)image{
    CGSize imageSize = image.size;
    //兼容240
    CGFloat imageWidth = 120;
    CGFloat imageHeight = 120;
    if (imageSize.width > 121 || imageHeight > 121) {
        imageWidth = imageSize.width / 2.0f;
        imageHeight = imageSize.height / 2.0f;
    } else {
        imageWidth = imageSize.width;
        imageHeight = imageSize.height;
    }
    return CGSizeMake(imageWidth, imageHeight);
}
@end
