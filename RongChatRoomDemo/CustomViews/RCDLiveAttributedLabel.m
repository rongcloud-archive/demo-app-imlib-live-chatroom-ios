//
//  RCDLiveAttributedLabel.m
//  iOS-IMKit
//
//  Created by YangZigang on 14/10/29.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import "RCDLiveAttributedLabel.h"
#import <CoreText/CoreText.h>
#import "RCDLiveKitCommonDefine.h"

@interface RCDLiveDataDetector : NSDataDetector

@end

@implementation RCDLiveDataDetector

- (NSRegularExpressionOptions)options {
    NSRegularExpressionOptions options = [super options];
    options = options | NSRegularExpressionUseUnicodeWordBoundaries;
    return options;
}

@end

@interface RCDLiveAttributedLabel ()
{
    UITapGestureRecognizer *tapGestureRecognizer;
}

@property(nonatomic, strong) NSString *originalString;
@property(nonatomic, assign) BOOL dataDetectorEnabled;
@property(nonatomic, assign) BOOL needGenerateAttributed;
@property(nonatomic, assign) NSRange rangeOfTextHighlighted;

- (void)generateAttributedStrings;
- (void)generateAttributedString;

@end

@implementation RCDLiveAttributedLabel
@synthesize attributeDataSource = _attributeDataSource;

- (void)setText:(NSString *)text {
    [self setText:text dataDetectorEnabled:YES];
}

- (void)setText:(NSString *)text dataDetectorEnabled:(BOOL)dataDetectorEnabled {
    self.dataDetectorEnabled = dataDetectorEnabled;
    if (self.dataDetectorEnabled == NO) {
        [super setText:text];
        return;
    }
    self.originalString = text;
    //设置内容的时候，先做一次解析，保证准确性
    [super setText:text];
    self.needGenerateAttributed = YES;
    [self generateAttributed];
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapGestureRecognizer setDelegate:self];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)layoutSubviews {
    [self generateAttributed];
    [super layoutSubviews];
}

- (void)setAttributeDictionary:(NSDictionary *)attributeDictionary {
    _attributeDictionary = attributeDictionary;
    self.needGenerateAttributed = YES;
}

- (void)setHighlightedAttributeDictionary:(NSDictionary *)highlightedAttributeDictionary {
    _highlightedAttributeDictionary = highlightedAttributeDictionary;
    self.needGenerateAttributed = YES;
}

- (void)setAttributeDataSource:(id<RCDLiveAttributedDataSource>)attributeDataSource {
    _attributeDataSource = attributeDataSource;
    self.needGenerateAttributed = YES;
}

- (NSString *)text {
    [self generateAttributed];
    return [super text];
}

- (NSAttributedString *)attributedText {
    [self generateAttributed];
    return [super attributedText];
}

- (NSTextCheckingTypes)textCheckingTypes {
    if (_textCheckingTypes) {
        return _textCheckingTypes;
    }
    return NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber;
}

- (void)generateAttributed {
    if (self.dataDetectorEnabled && self.needGenerateAttributed) {
        self.needGenerateAttributed = NO;
        [self generateAttributedStrings];
        [self generateAttributedString];
    }
}

- (void)generateAttributedStrings {
    if (!self.originalString) {
        return;
    }
    NSError *error = nil;
    RCDLiveDataDetector *dataDetector = [[RCDLiveDataDetector alloc] initWithTypes:self.textCheckingTypes error:&error];
    //    NSRegularExpression *dataDetector = [NSRegularExpression
    //    regularExpressionWithPattern:@"(https?\\:\\/\\/(www\\.)?youtu(\\.)?be(\\.com)?\\/.*(\\?v=|\\/v\\/)?[a-zA-Z0-9_\\-]+)|(https?\\:\\/\\/[a-zA-Z0-9\\-\\.]+\\.[a-zA-Z]{2,})|(\\+?\\(?\\d{2,4}\\)?[\\d\\s-]{3,})"
    //    options:NSRegularExpressionCaseInsensitive | NSRegularExpressionUseUnicodeWordBoundaries |
    //    NSRegularExpressionIgnoreMetacharacters error:&error];
    if (error != nil) {
        RCDLive_DebugLog(@"data detector error %@", error.localizedDescription);
        [super setText:self.originalString];
        return;
    }
    self.attributedStrings = [NSMutableArray array];
    
    [dataDetector enumerateMatchesInString:self.originalString
                                   options:kNilOptions
                                     range:NSMakeRange(0, self.originalString.length)
                                usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                  _currentTextCheckingType = result.resultType;
                                  [self.attributedStrings addObject:result];
                                }];
}

- (void)generateAttributedString {
    if (!self.originalString) {
        return;
    }
    NSMutableAttributedString *attributedString =
        [[NSMutableAttributedString alloc] initWithString:self.originalString];
    for (NSTextCheckingResult *textCheckingResult in self.attributedStrings) {
        for (int i = 0; i < textCheckingResult.numberOfRanges; i++) {
            NSRange range = [textCheckingResult rangeAtIndex:i];
            NSDictionary *attributeDictionary = [self attributeDictionaryForTextType:textCheckingResult.resultType];

            if (NSEqualRanges(range, self.rangeOfTextHighlighted))
                attributeDictionary = [self highlightedAttributeDictionaryForTextType:textCheckingResult.resultType];
            if (attributeDictionary) {
                if (self.originalString.length >= (range.location + range.length)) {
                    NSAttributedString *subString =
                    [[NSAttributedString alloc] initWithString:[self.originalString substringWithRange:range]
                                                    attributes:attributeDictionary];
                    [attributedString replaceCharactersInRange:range withAttributedString:subString];
                }
               
            }
            
        }
    }
    self.attributedText = attributedString;
}

- (CFIndex)characterIndexAtPoint:(CGPoint)point {

    ////////

    NSMutableAttributedString *optimizedAttributedText = [self.attributedText mutableCopy];

    // use label's font and lineBreakMode properties in case the attributedText does not contain such attributes
    [self.attributedText
        enumerateAttributesInRange:NSMakeRange(0, [self.attributedText length])
                           options:0
                        usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {

                          if (!attrs[(NSString *)kCTFontAttributeName]) {

                              [optimizedAttributedText addAttribute:(NSString *)kCTFontAttributeName
                                                              value:self.font
                                                              range:NSMakeRange(0, [self.attributedText length])];
                          }

                          if (!attrs[(NSString *)kCTParagraphStyleAttributeName]) {

                              NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                              [paragraphStyle setLineBreakMode:self.lineBreakMode];

                              [optimizedAttributedText addAttribute:(NSString *)kCTParagraphStyleAttributeName
                                                              value:paragraphStyle
                                                              range:range];
                          }
                        }];

    // modify kCTLineBreakByTruncatingTail lineBreakMode to kCTLineBreakByWordWrapping
    [optimizedAttributedText
        enumerateAttribute:(NSString *)kCTParagraphStyleAttributeName
                   inRange:NSMakeRange(0, [optimizedAttributedText length])
                   options:0
                usingBlock:^(id value, NSRange range, BOOL *stop) {

                  NSMutableParagraphStyle *paragraphStyle = [value mutableCopy];

                  if ([paragraphStyle lineBreakMode] == kCTLineBreakByTruncatingTail) {
                      [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
                  }

                  [optimizedAttributedText removeAttribute:(NSString *)kCTParagraphStyleAttributeName range:range];
                  [optimizedAttributedText addAttribute:(NSString *)kCTParagraphStyleAttributeName
                                                  value:paragraphStyle
                                                  range:range];
                }];

    ////////

    if (!CGRectContainsPoint(self.bounds, point)) {
        return NSNotFound;
    }

    CGRect textRect = [self textRect];

    if (!CGRectContainsPoint(textRect, point)) {
        return NSNotFound;
    }

    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    point = CGPointMake(point.x, textRect.size.height - point.y);

    //////

    CTFramesetterRef framesetter =
        CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)optimizedAttributedText);

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);

    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.attributedText length]), path, NULL);

    if (frame == NULL) {
        CFRelease(framesetter);
        CFRelease(path);
        return NSNotFound;
    }

    CFArrayRef lines = CTFrameGetLines(frame);

    NSInteger numberOfLines =
        self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);

    // RCDLive_DebugLog(@"num lines: %d", numberOfLines);

    if (numberOfLines == 0) {
        CFRelease(framesetter);
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }

    NSUInteger idx = NSNotFound;

    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);

    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {

        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);

        // Get bounding information of line
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);

        // Check if we've already passed the line
        if (point.y > yMax) {
            break;
        }

        // Check if the point is within this line vertically
        if (point.y >= yMin) {

            // Check if the point is within this line horizontally
            if (point.x >= lineOrigin.x && point.x <= lineOrigin.x + width) {

                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);

                break;
            }
        }
    }

    CFRelease(framesetter);
    CFRelease(frame);
    CFRelease(path);

    return idx;
}

- (CGRect)textRect {

    CGRect textRect = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    textRect.origin.y = (self.bounds.size.height - textRect.size.height) / 2;

    if (self.textAlignment == NSTextAlignmentCenter) {
        textRect.origin.x = (self.bounds.size.width - textRect.size.width) / 2;
    }
    if (self.textAlignment == NSTextAlignmentRight) {
        textRect.origin.x = self.bounds.size.width - textRect.size.width;
    }

    return textRect;
}
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self setTextHighlighted:YES atPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self setTextHighlighted:YES atPoint:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self setTextHighlighted:NO atPoint:point];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self setTextHighlighted:NO atPoint:point];
}
*/

#pragma mark -
#pragma mark RCDLiveAttributedDataSource
- (NSDictionary *)attributeDictionaryForTextType:(NSTextCheckingTypes)textType {
    if (self.attributeDictionary) {
        NSNumber *textCheckingTypesNumber = [NSNumber numberWithUnsignedLongLong:textType];
        return [self.attributeDictionary objectForKey:textCheckingTypesNumber];
    }
    if (self.attributeDataSource) {
        return [self.attributeDataSource attributeDictionaryForTextType:textType];
    }
    switch (textType) {
    case NSTextCheckingTypePhoneNumber: {
        _currentTextCheckingType = NSTextCheckingTypePhoneNumber;
        return @{
            NSForegroundColorAttributeName : [UIColor blueColor],
                                  NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                                  NSUnderlineColorAttributeName:[UIColor yellowColor]
        };
    } break;
    case NSTextCheckingTypeLink: {
        _currentTextCheckingType = NSTextCheckingTypeLink;
        return @{
            NSForegroundColorAttributeName : [UIColor blueColor],
                                 NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                                 NSUnderlineColorAttributeName:[UIColor blueColor]
        };
    } break;
    default:
        break;
    }
    return nil;
}

- (NSDictionary *)highlightedAttributeDictionaryForTextType:(NSTextCheckingType)textType {
    if (self.attributeDictionary) {
        NSNumber *textCheckingTypesNumber = [NSNumber numberWithUnsignedLongLong:textType];
        return [self.attributeDictionary objectForKey:textCheckingTypesNumber];
    }
    if (self.attributeDataSource) {
        return [self.attributeDataSource highlightedAttributeDictionaryForTextType:textType];
    }
    switch (textType) {
    case NSTextCheckingTypePhoneNumber: {
        _currentTextCheckingType = NSTextCheckingTypePhoneNumber;
        if (RCDLive_IOS_FSystenVersion <7.0)
        {
            return @{
                     NSForegroundColorAttributeName : [UIColor yellowColor],
                     NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)
                     };
        }else{
            return @{
                     NSForegroundColorAttributeName : [UIColor yellowColor],
                     NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                     NSUnderlineColorAttributeName : [UIColor yellowColor]
            };
        }
    } break;
    case NSTextCheckingTypeLink: {
        _currentTextCheckingType = NSTextCheckingTypeLink;
        if (RCDLive_IOS_FSystenVersion <7.0)
        {
            return @{
                     NSForegroundColorAttributeName : [UIColor greenColor],
                     NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)
                     };
        }else{
            return @{
            NSForegroundColorAttributeName : [UIColor greenColor],
            NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
            NSUnderlineColorAttributeName : [UIColor greenColor]
        };
        }
    } break;
    default:
        break;
    }
    return nil;
}

- (RCDLiveAttributedLabelClickedTextInfo *)textInfoAtPoint:(CGPoint)point {
    if (self.dataDetectorEnabled == NO) {
        return nil;
    }
    CFIndex charIndex = [self characterIndexAtPoint:point];
    for (NSTextCheckingResult *textCheckingResult in self.attributedStrings) {
        NSTextCheckingTypes type = textCheckingResult.resultType;
        for (int i = 0; i < textCheckingResult.numberOfRanges; i++) {
            NSRange range = [textCheckingResult rangeAtIndex:i];
            if (NSLocationInRange(charIndex, range)) {
                RCDLiveAttributedLabelClickedTextInfo *textInfo = [[RCDLiveAttributedLabelClickedTextInfo alloc] init];
                textInfo.textCheckingType = type;
                textInfo.text = [self.originalString substringWithRange:range];
                return textInfo;
            }
        }
    }
    return nil;
}

- (NSRange)textRangeAtPoint:(CGPoint)point {
    if (self.dataDetectorEnabled == NO) {
        return NSMakeRange(0, 0);
    }
    CFIndex charIndex = [self characterIndexAtPoint:point];
    for (NSTextCheckingResult *textCheckingResult in self.attributedStrings) {
        for (int i = 0; i < textCheckingResult.numberOfRanges; i++) {
            NSRange range = [textCheckingResult rangeAtIndex:i];
            if (NSLocationInRange(charIndex, range)) {
                return range;
            }
        }
    }
    return NSMakeRange(0, 0);
}

- (void)setTextHighlighted:(BOOL)highlighted atPoint:(CGPoint)point {
    if (highlighted == NO) {
        self.rangeOfTextHighlighted = NSMakeRange(0, 0);
    } else {
        self.rangeOfTextHighlighted = [self textRangeAtPoint:point];
    }
    [self generateAttributedString];
}

                            
#pragma mark - UIGestureRecognizer

                            
- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] != UIGestureRecognizerStateEnded) {
        return;
     }
     NSTextCheckingResult *result = [self linkAtPoint:[gestureRecognizer locationInView:self]];
     if (!result) {
         if (self.delegate!=nil) {
                if ([self.delegate respondsToSelector:@selector(attributedLabel:didTapLabel:)]) {
                    [self.delegate attributedLabel:self didTapLabel:self.originalString ];
                    }
                }
            return;
        }

    switch (result.resultType) {
       case NSTextCheckingTypeLink:
            if ([self.delegate respondsToSelector:@selector(attributedLabel:didSelectLinkWithURL:)]) {
                 [self.delegate attributedLabel:self didSelectLinkWithURL:result.URL ];
             }
              break;
        case NSTextCheckingTypePhoneNumber:
             if ([self.delegate respondsToSelector:@selector(attributedLabel:didSelectLinkWithPhoneNumber:)]) {
                 [self.delegate attributedLabel:self didSelectLinkWithPhoneNumber:result.phoneNumber];
              }
             break;
        default:
            break;
        }
}

- (NSTextCheckingResult *)linkAtCharacterIndex:(CFIndex)idx {
    for (NSTextCheckingResult *result in self.attributedStrings) {
        NSRange range = result.range;
        if ((CFIndex)range.location <= idx && idx <= (CFIndex)(range.location + range.length - 1)) {
            return result;
        }
    }
    
    return nil;
}

- (NSTextCheckingResult *)linkAtPoint:(CGPoint)p {
    CFIndex idx = [self characterIndexAtPoint:p];
    return [self linkAtCharacterIndex:idx];
}

@end

@implementation RCDLiveAttributedLabelClickedTextInfo

@end
