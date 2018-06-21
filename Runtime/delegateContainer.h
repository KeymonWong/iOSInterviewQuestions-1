//
//  delegateContainer.h
//  runtime消息转发
//
//  Created by hyj on 15/4/11.
//  Copyright © 2015年 zhn. hyj rights reserved.
//

#import <UIKit/UIKit.h>

@interface delegateContainer : NSObject<UIScrollViewDelegate>

@property (nonatomic,weak) id firstDelegate;

@property (nonatomic,weak) id secondDelegate;

+ (instancetype)containerDelegateWithFirst:(id)firstDelegate second:(id)secondDelegate;

@end
