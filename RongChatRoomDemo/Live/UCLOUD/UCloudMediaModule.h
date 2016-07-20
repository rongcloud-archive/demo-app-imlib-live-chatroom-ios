//
//  UCloudMediaModule.h
//

#import <Foundation/Foundation.h>

@interface UCloudMediaModule : NSObject

+ (UCloudMediaModule *)sharedModule;
//用户可以使用该值来控制播放器全局锁屏开/关
@property(atomic, getter=isAppIdleTimerDisabled)            BOOL appIdleTimerDisabled;
//播放器内部使用，禁止外部操作
@property(atomic, getter=isMediaModuleIdleTimerDisabled)    BOOL mediaModuleIdleTimerDisabled;

@end
