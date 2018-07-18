//
//  ViewController.m
//  YJPushDemo
//
//  Created by YJ on 2017/3/12.
//  Copyright © 2017年 com.houmanager. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"launchOptions"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dict.description delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"-->%@", dict);
    
    MainViewController *vc = [[MainViewController alloc] init];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"didReceiveRemoteNotification"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dict.description delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"-->%@", dict);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
