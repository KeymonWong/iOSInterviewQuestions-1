//
//  ViewController.m
//  InterviewQuestions
//
//  Created by YJHou on 2017/6/8.
//  Copyright © 2017年 houmanager@hotmail.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self GCDTest];
    
}

- (void)GCDTest{
    
    /**
     performSelector:withObject:afterDelay: Invokes a method of the receiver on the current thread using the default mode after a delay. This method sets up a timer to perform the aSelector message on the current thread’s run loop. The timer is configured to run in the default mode (NSDefaultRunLoopMode). When the timer fires, the thread attempts to dequeue the message from the run loop and perform the selector. It succeeds if the run loop is running and in the default mode; otherwise, the timer waits until the run loop is in the default mode.
     
     意思是：模式是NSDefaultRunLoopMode，当前线程上的任务优先
     
     */
    [self performSelector:@selector(test1) withObject:nil afterDelay:0];
    
    /** 当为NO时，队列尾部执行，当为YES时，最先执行 */
    [self performSelectorOnMainThread:@selector(test2) withObject:nil waitUntilDone:NO];
    
    /**
     Enqueue a block for execution at the specified time. This function waits until the specified time and then asynchronously adds block to the specified queue.
     
     意思是：当前时刻在 主队列尾部 添加一个block，所以它会在主队列任务队列尾部执行
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"-->%@", @"3");
    });
    
    /**
     其作用就是在主队列async添加一个block，等级和dispatch_after时间为0时一个级别，所以它和dispatch_after谁在前谁先
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"-->%@", @"4");
    });

    /**
     Sends a specified message to the receiver and returns the result of the message.
     
     意思是：相当于[self test7]
     */
    [self performSelector:@selector(test5)];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^ {
        NSLog(@"-->%@", @"6");
    });
    
    [self test7];
    
}

- (void)test1{
    NSLog(@"-->%@", @"1");
}

- (void)test2{
    NSLog(@"-->%@", @"2");
}

- (void)test5{
    NSLog(@"-->%@", @"5");
}

- (void)test7{
    NSLog(@"-->%@", @"7");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
