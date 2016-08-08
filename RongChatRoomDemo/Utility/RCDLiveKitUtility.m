//
//  RCDLiveKitUtility.m
//  iOS-IMKit
//
//  Created by xugang on 7/7/14.
//  Copyright (c) 2014 Heq.Shinoda. All rights reserved.
//

#import "RCDLiveKitUtility.h"
#import "RCDLive.h"
#import "RCDLiveGiftMessage.h"
#import "RCDLiveKitCommonDefine.h"

@interface RCDLiveWeakRef : NSObject
@property (nonatomic, weak)id weakRef;
+(instancetype)refWithObject:(id)obj;
@end

@implementation RCDLiveWeakRef
+(instancetype)refWithObject:(id)obj {
    RCDLiveWeakRef *ref = [[RCDLiveWeakRef alloc] init];
    ref.weakRef = obj;
    return ref;
}
@end


@interface RCDLiveKitUtility ()

@end

@implementation RCDLiveKitUtility

+ (NSString *)localizedDescription:(RCMessageContent *)messageContent {

    NSString *objectName = [[messageContent class] getObjectName];
    return NSLocalizedStringFromTable(objectName, @"RongCloudKit", nil);
}

+ (NSString *)ConvertMessageTime:(long long)secs {
    NSString *timeText = nil;

    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:secs];

    //    RCDLive_DebugLog(@"messageDate==>%@",messageDate);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    NSString *strMsgDay = [formatter stringFromDate:messageDate];

    NSDate *now = [NSDate date];
    NSString *strToday = [formatter stringFromDate:now];
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-(24 * 60 * 60)];
    NSString *strYesterday = [formatter stringFromDate:yesterday];

    NSString *_yesterday = nil;
    if ([strMsgDay isEqualToString:strToday]) {
        [formatter setDateFormat:@"HH':'mm"];
    } else if ([strMsgDay isEqualToString:strYesterday]) {
        _yesterday = NSLocalizedStringFromTable(@"Yesterday", @"RongCloudKit", nil);
        //[formatter setDateFormat:@"HH:mm"];
    }

    if (nil != _yesterday) {
        timeText = _yesterday; //[_yesterday stringByAppendingFormat:@" %@", timeText];
    } else {
        timeText = [formatter stringFromDate:messageDate];
    }

    return timeText;
}

+ (NSString *)ConvertChatMessageTime:(long long)secs {
    NSString *timeText = nil;

    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:secs];

    //    RCDLive_DebugLog(@"messageDate==>%@",messageDate);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    NSString *strMsgDay = [formatter stringFromDate:messageDate];

    NSDate *now = [NSDate date];
    NSString *strToday = [formatter stringFromDate:now];
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-(24 * 60 * 60)];
    NSString *strYesterday = [formatter stringFromDate:yesterday];

    NSString *_yesterday = nil;
    if ([strMsgDay isEqualToString:strToday]) {
        [formatter setDateFormat:@"HH':'mm"];
    } else if ([strMsgDay isEqualToString:strYesterday]) {
        _yesterday = NSLocalizedStringFromTable(@"Yesterday", @"RongCloudKit", nil);

        [formatter setDateFormat:@"HH:mm"];
    } else {
        [formatter setDateFormat:@"yyyy-MM-dd' 'HH':'mm"];
    }
    
    timeText = [formatter stringFromDate:messageDate];
    
    if (nil != _yesterday) {
        timeText = [_yesterday stringByAppendingFormat:@" %@", timeText];
    }

    return timeText;
}

+ (UIImage *)imageNamed:(NSString *)name ofBundle:(NSString *)bundleName {
    static NSMutableDictionary *loadedObjectDict = nil;
    if (!loadedObjectDict) {
        loadedObjectDict = [[NSMutableDictionary alloc] init];
    }
    
    NSString *keyString = [NSString stringWithFormat:@"%@%@", bundleName, name];
    RCDLiveWeakRef *ref = loadedObjectDict[keyString];
    if (ref.weakRef) {
        return ref.weakRef;
    }
    
    UIImage *image = nil;
    NSString *image_name = [NSString stringWithFormat:@"%@.png", name];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath = [resourcePath stringByAppendingPathComponent:bundleName];
    NSString *image_path = [bundlePath stringByAppendingPathComponent:image_name];

    // NSString* path = [[[[NSBundle mainBundle] resourcePath]
    // stringByAppendingPathComponent:bundleName]stringByAppendingPathComponent:[NSString
    // stringWithFormat:@"%@.png",name]];

    // image = [UIImage imageWithContentsOfFile:image_path];
    image = [[UIImage alloc] initWithContentsOfFile:image_path];
    [loadedObjectDict setObject:[RCDLiveWeakRef refWithObject:image] forKey:keyString];
    
    return image;
}

//导航使用
+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return theImage;
}

+ (NSString *)formatMessage:(RCMessageContent *)messageContent {

    if ([messageContent respondsToSelector:@selector(conversationDigest)]) {
        return [messageContent performSelector:@selector(conversationDigest)];
    }

    if ([messageContent isMemberOfClass:RCTextMessage.class]) {

        RCTextMessage *textMessage = (RCTextMessage *)messageContent;
        return textMessage.content;

    } else if ([messageContent isMemberOfClass:RCInformationNotificationMessage.class]) {
        RCInformationNotificationMessage *informationNotificationMessage =
            (RCInformationNotificationMessage *)messageContent;
        return informationNotificationMessage.message;
    }

    return [RCDLiveKitUtility localizedDescription:messageContent];
}

#pragma mark private method

+ (NSDictionary *)getNotificationUserInfoDictionary:(RCMessage *)message {
    return [RCDLiveKitUtility getNotificationUserInfoDictionary:message.conversationType fromUserId:message.senderUserId targetId:message.targetId objectName:message.objectName messageId:message.messageId];
}

+ (NSDictionary *)getNotificationUserInfoDictionary:(RCConversationType)conversationType fromUserId:(NSString *)fromUserId targetId:(NSString *)targetId objectName:(NSString *)objectName {
    
    return [RCDLiveKitUtility getNotificationUserInfoDictionary:conversationType fromUserId:fromUserId targetId:targetId objectName:objectName messageId:0];
}

+ (NSDictionary *)getNotificationUserInfoDictionary:(RCConversationType)conversationType fromUserId:(NSString *)fromUserId targetId:(NSString *)targetId objectName:(NSString *)objectName messageId:(long)messageId {
    NSString *type = @"PR";
    switch (conversationType) {
        case ConversationType_PRIVATE:
            type = @"PR";
            break;
        case ConversationType_GROUP:
            type = @"GRP";
            break;
        case ConversationType_DISCUSSION:
            type = @"DS";
            break;
        case ConversationType_CUSTOMERSERVICE:
            type = @"CS";
            break;
        case ConversationType_SYSTEM:
            type = @"SYS";
            break;
        case ConversationType_APPSERVICE:
            type = @"MC";
            break;
        case ConversationType_PUBLICSERVICE:
            type = @"MP";
            break;
        case ConversationType_PUSHSERVICE:
            type = @"PH";
            break;
        default:
            return nil;
    }
    return @{@"rc":@{@"cType":type, @"fId":fromUserId, @"oName":objectName, @"tId":targetId, @"mId":[NSString stringWithFormat:@"%ld" ,messageId]}};
}

+ (NSDictionary *)getNotificationUserInfoDictionary:(RCConversationType)conversationType fromUserId:(NSString *)fromUserId targetId:(NSString *)targetId messageContent:(RCMessageContent *)messageContent {
    NSString *type = @"PR";
    switch (conversationType) {
        case ConversationType_PRIVATE:
            type = @"PR";
            break;
        case ConversationType_GROUP:
            type = @"GRP";
            break;
        case ConversationType_DISCUSSION:
            type = @"DS";
            break;
        case ConversationType_CUSTOMERSERVICE:
            type = @"CS";
            break;
        case ConversationType_SYSTEM:
            type = @"SYS";
            break;
        case ConversationType_APPSERVICE:
            type = @"MC";
            break;
        case ConversationType_PUBLICSERVICE:
            type = @"MP";
            break;
        case ConversationType_PUSHSERVICE:
            type = @"PH";
            break;
        default:
            return nil;
    }
    return @{@"rc":@{@"cType":type, @"fId":fromUserId, @"oName":[[messageContent class] getObjectName], @"tId":targetId}};
}


+ (CGSize)getContentSize:(NSString *)content withFrontSize:(int)fontSize withWidth:(CGFloat)width{
    CGSize textSize = CGSizeZero;
    CGSize maxSize = CGSizeMake(width, 8000);
    if (RCDLive_IOS_FSystenVersion < 7.0) {
        textSize = RCDLive_RC_MULTILINE_TEXTSIZE_LIOS7(content, [UIFont systemFontOfSize:fontSize],maxSize , NSLineBreakByTruncatingTail);
    }else{
        textSize = RCDLive_RC_MULTILINE_TEXTSIZE_GEIOS7(content,[UIFont systemFontOfSize:fontSize], maxSize);
    }
    textSize = CGSizeMake(ceilf(textSize.width), ceil(textSize.height));
    return textSize;
}

@end
