//
//  RongMessageModel.m
//  RongIMKit
//
//  Created by xugang on 15/1/22.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDLiveMessageModel.h"

@implementation RCDLiveMessageModel
- (instancetype)initWithMessage:(RCMessage *)rcMessage {
    self = [super init];
    if (self) {
        self.conversationType = rcMessage.conversationType;
        self.targetId = rcMessage.targetId;
        self.messageId = rcMessage.messageId;
        self.messageDirection = rcMessage.messageDirection;
        self.senderUserId = rcMessage.senderUserId;
        self.receivedStatus = rcMessage.receivedStatus;
        self.sentStatus = rcMessage.sentStatus;
        self.sentTime = rcMessage.sentTime;
        self.objectName = rcMessage.objectName;
        self.content = rcMessage.content;
        self.isDisplayMessageTime = NO;
        self.userInfo = nil;
        self.receivedTime = rcMessage.receivedTime;
        self.extra = rcMessage.extra;
    }

    return self;
}
@end
