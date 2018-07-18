//
//  YJPushManager.h
//  YJPushDemo
//
//  Created by YJ on 2017/3/12.
//  Copyright © 2017年 com.houmanager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJPushManagerMacro.h"

@interface YJPushManager : NSObject

/**
 注册远程推送
 Xcode8的需要手动开启“TARGETS -> Capabilities -> Push Notifications”

 @param delegate UNUserNotificationCenterDelegate
 @param completionBlock iOS 10 以上授权结果的回调
 */
+ (void)registerRemoteNotificationDeletate:(id)delegate
                                completion:(void (^)(BOOL granted, NSError *error))completionBlock;

/**
 解绑远程推送 此时再注册会生成新的 deviceToken
 */
+ (void)unregisterForRemoteNotifications;

/**
 获得去除字符的 DeviceToken

 @param deviceToken Original deviceToken
 @return DeviceToken String
 */
+ (NSString *)getDeviceTokenString:(NSData *)deviceToken;



@end
