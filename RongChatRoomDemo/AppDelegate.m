//
//  AppDelegate.m
//  RongChatRoomDemo
//
//  Created by 杜立召 on 16/4/6.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import "AppDelegate.h"
#import "RCDLive.h"
#import "LoginViewController.h"
#import "RCDLiveKitCommonDefine.h"
#import "RCDLiveGiftMessage.h"
#import <RongIMLib/RongIMLib.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[RCDLive sharedRCDLive] initRongCloud:RONGCLOUD_IM_APPKEY];
    //注册自定义消息
    [[RCDLive sharedRCDLive] registerRongCloudMessageType:[RCDLiveGiftMessage class]];
        // 初始化 ViewController。
    LoginViewController *viewController = [[LoginViewController alloc]initWithNibName:nil bundle:nil];
    
    // 初始化 UINavigationController。
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    
    // 设置背景颜色为黑色。
    [nav.navigationBar setBackgroundColor:[UIColor blackColor]];
    [nav setNavigationBarHidden:YES];
    // 初始化 rootViewController。
    self.window.rootViewController = nav;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UIFont *font = [UIFont systemFontOfSize:19.f];
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName : font,
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]
     setBarTintColor:[UIColor colorWithRed:(1 / 255.0f) green:(149 / 255.0f) blue:(255 / 255.0f) alpha:1]];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"RoleList" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    _userList = [[NSMutableArray alloc]init];
    RCUserInfo *user = [self parseUserInfoFormDic:[data objectForKey:@"User1"]];
    [_userList  addObject:user];
    RCUserInfo *user2 = [self parseUserInfoFormDic:[data objectForKey:@"User2"]];
    [_userList  addObject:user2];
    RCUserInfo *user3 = [self parseUserInfoFormDic:[data objectForKey:@"User3"]];
    [_userList  addObject:user3];
    RCUserInfo *user4 = [self parseUserInfoFormDic:[data objectForKey:@"User4"]];
    [_userList  addObject:user4];
    RCUserInfo *user5 = [self parseUserInfoFormDic:[data objectForKey:@"User5"]];
    [_userList  addObject:user5];
    RCUserInfo *user6 = [self parseUserInfoFormDic:[data objectForKey:@"User6"]];
    [_userList  addObject:user6];
    RCUserInfo *user7 = [self parseUserInfoFormDic:[data objectForKey:@"User7"]];
    [_userList  addObject:user7];

    return YES;
}

-(RCUserInfo *)parseUserInfoFormDic:(NSDictionary *)dic{
  RCUserInfo *user = [[RCUserInfo alloc]init];
  user.userId = [dic objectForKey: @"id" ];
  user.name = [dic objectForKey: @"name" ];
  user.portraitUri = [dic objectForKey: @"icon" ];
  return user;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
