//
//  ViewController.m
//  UIPerformance
//
//  Created by YJHou on 2015/4/26.
//  Copyright © 2015年 YJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 80, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 220, 100, 100)];
    imgView.backgroundColor = [UIColor redColor];
    imgView.image = [UIImage imageNamed:@"001"];
    [self.view addSubview:imgView];
    
    view.opaque = NO;
    view.alpha = 0.3;
    
    imgView.opaque = YES;
    imgView.alpha = 1;
    
    imgView.layer.cornerRadius = 10;
    
    imgView.layer.shouldRasterize = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
