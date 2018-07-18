//
//  YJPushManagerMacro.h
//  YJPushDemo
//
//  Created by EDZ on 2018/7/17.
//  Copyright © 2018年 com.houmanager. All rights reserved.
//

#ifndef YJPushManagerMacro_h
#define YJPushManagerMacro_h

#ifdef __OBJC__
/** 单例 */
// @interface
#define singleton_interface_yj(className) \
+ (className *)sharedInstance;

// @implementation
#define singleton_implementation_yj(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)sharedInstance \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}
#endif


#endif /* YJPushManagerMacro_h */
