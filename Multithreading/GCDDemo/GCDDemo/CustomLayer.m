//
//  CustomLayer.m
//  GCDDemo
//
//  Created by YJHou on 2018/4/13.
//  Copyright © 2018年 houmanager@hotmail.com. All rights reserved.
//

#import "CustomLayer.h"

@implementation CustomLayer

- (instancetype)init{
    self = [super init];
    if (self) {
        NSLog(@"CustomLayer init");
    }
    return self;
}

+ (Class)layerClass{
    return [CustomLayer class];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

- (void)setPosition:(CGPoint)position{
    [super setPosition:position];
}

- (void)setBounds:(CGRect)bounds{
    [super setBounds:bounds];
}

- (void)display{
    NSLog(@"-->%@", @"display--");
}

@end
