//
//  CustomView.m
//  GCDDemo
//
//  Created by YJHou on 2018/4/13.
//  Copyright © 2018年 houmanager@hotmail.com. All rights reserved.
//

#import "CustomView.h"
#import "CustomLayer.h"

@implementation CustomView

- (instancetype)init{
    self = [super init];
    if (self) {
        NSLog(@"-->%@", @"CustomView init");
    }
    return self;
}

+ (Class)layerClass{
    return [CustomLayer class];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}
- (void)setCenter:(CGPoint)center{
    [super setCenter:center];
}
- (void)setBounds:(CGRect)bounds{
    [super setBounds:bounds];
}

- (void)drawRect:(CGRect)rect{
    
    if (![@"123" isEqualToString:@""]) {
        NSLog(@"-->%@", @"123");
    }
    NSLog(@"-->%@", @"drawRect: --");
}

@end
