//
//  AppDelegate.m
//  YJPushDemo
//
//  Created by YJ on 2017/3/12.
//  Copyright © 2017年 com.houmanager. All rights reserved.
//

#import "AppDelegate.h"
#import "YJPushManager.h"
#import "YJBackgroundTask.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate () <
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
UNUserNotificationCenterDelegate
#endif
>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSDictionary *remoteDict = (NSDictionary *)[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"launchOptions-->%@", remoteDict);
    // 如果是点击通知时会有值
    if (launchOptions) {
        [[NSUserDefaults standardUserDefaults] setObject:remoteDict forKey:@"launchOptions"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [YJPushManager registerRemoteNotificationDeletate:self completion:^(BOOL granted, NSError *error) {
        
    }];
    
    
    return YES;
}

// 注册远程推送获得 deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString *deviceTokenString = [YJPushManager getDeviceTokenString:deviceToken];
    
    NSLog(@"-->%@", deviceTokenString);
}

// 注册远程推送 失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"-->%@", error);
}

// 这个方法在实现了下面的方法不执行
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{}

#pragma mark - APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送
/** APP已经接收到“远程”通知(推送) - 透传推送消息  (前台或者后台时)静默推送
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    /**     aps =     {
     alert = "Testing.. (16)";
     badge = 1;
     "content-available" = 1;
     sound = default;
     };
     */
    
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"didReceiveRemoteNotification"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    if (@available(iOS 10.0, *)) {
        
    }else{
        
        if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive){ // 不在前台
            
            // 处理推送逻辑
            
        }
    }
    
    
    NSLog(@"iOS 10以下-->%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - iOS 10中收到推送消息
//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    
    NSLog(@"iOS 10 前台--willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSLog(@"iOS 10点击通知打开--didReceiveNotification：%@", userInfo);
    
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive){ // 不在前台
        
        // 处理推送逻辑
        
    }
    
    
    completionHandler();
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[YJBackgroundTask sharedInstance] beginBackgroundTaskWithLastTime:5 completion:^{
        NSLog(@"-->%@", @"7之前是10分钟，7之后是3分钟，后台结束了");
    }];

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
