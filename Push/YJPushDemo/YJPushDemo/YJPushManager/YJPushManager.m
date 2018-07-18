//
//  YJPushManager.m
//  YJPushDemo
//
//  Created by YJ on 2017/3/12.
//  Copyright © 2017年 com.houmanager. All rights reserved.
//

#import "YJPushManager.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif


@implementation YJPushManager

+ (void)registerRemoteNotificationDeletate:(id)delegate
                                completion:(void (^)(BOOL granted, NSError *error))completionBlock{
    
    if (@available(iOS 10.0, *)) { // iOS 10 可用
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = delegate;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (completionBlock) {
                completionBlock(granted, error);
            }
        }];
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) { // iOS >= 8.0
        
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

+ (NSString *)getDeviceTokenString:(NSData *)deviceToken{
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    return token;
}

+ (void)unregisterForRemoteNotifications{
    
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}



@end
