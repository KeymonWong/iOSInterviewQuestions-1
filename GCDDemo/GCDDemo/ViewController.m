//
//  ViewController.m
//  GCDDemo
//
//  Created by YJHou on 2014/4/3.
//  Copyright © 2014年 houmanager@hotmail.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self _setGCD];
    
     // 4.1 同步执行 + 并发队列
//    [self syncConcurrent];
    
    // 4.2 异步执行 + 并发队列
//    [self asyncConcurrent];
    
    // 4.3 同步执行 + 串行队列
//    [self syncSerial];
    
    // 4.4 异步执行 + 串行队列
//    [self asyncSerial];
    
    // 4.5.1 同步执行 + 主队列
//    [self syncMain];
    
    // 4.5.2
    // 使用 NSThread 的 detachNewThreadSelector 方法会创建线程，并自动启动线程执行selector 任务
//    [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
    
    // 4.6 异步执行 + 主队列
//    [self asyncMain];
    
    // 5. 线程间通信
//    [self communication];
    
    // 6.1 栅栏方法 dispatch_barrier_async
//    [self barrier];
    
    // 6.2 延时执行方法 dispatch_after
//    [self dispatch_after];
    
    // 6.4 快速迭代方法 dispatch_apply
//    [self dispatch_apply];
    
    // 6.5.1 队列组 dispatch_group_notify
//    [self groupNotify];
    
    // 6.5.2 队列组 dispatch_group_wait
//    [self groupWait];
    
    // 6.5.3 dispatch_group_enter、dispatch_group_leave
    [self groupEnterAndLeave];
}

- (void)_setGCD{
    
    // 串行队列
    dispatch_queue_t derialQueue = dispatch_queue_create("com.houmanager.gcd", DISPATCH_QUEUE_SERIAL);
    
    // 并行队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.houmanager.gcd", DISPATCH_QUEUE_CONCURRENT);
    
    // 获取主队列 添加到主队列的任务 会在主线程执行
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    // 全局并发队列的获取方法
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
//    // 同步执行任务
//    dispatch_sync(mainQueue, ^{
//
//    });
//
//    // 异步执行任务
//    dispatch_async(mainQueue, ^{
//
//    });
    
    
    
    
}

/**
 4.1 同步执行 + 并发队列
 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncConcurrent {
    
    NSLog(@"currentThread-->%@", [NSThread currentThread]);
    NSLog(@"syncConcurrent--->begin");

    dispatch_queue_t queue = dispatch_queue_create("com.houmanager.gcd", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        
        for (int i = 0; i < 2; ++i) {
            // 模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            // 打印当前线程
            NSLog(@"1-->%d---%@", i, [NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        
        for (int i = 0; i < 2; ++i) {
            // 模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            // 打印当前线程
            NSLog(@"2-->%d---%@", i, [NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        
        for (int i = 0; i < 2; ++i) {
            // 模拟耗时操作
            [NSThread sleepForTimeInterval:2];
            // 打印当前线程
            NSLog(@"3-->%d---%@", i, [NSThread currentThread]);
        }
    });
    
    NSLog(@"syncConcurrent---end");
}


/**
 4.2 异步执行 + 并发队列
 特点：可以开启多个线程，任务交替（同时）执行。
 */
- (void)asyncConcurrent {
    
    NSLog(@"currentThread---%@", [NSThread currentThread]);
    NSLog(@"asyncConcurrent---begin");
    dispatch_queue_t queue = dispatch_queue_create("com.houmanager.gcd", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1-->%d---%@", i, [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2-->%d---%@", i, [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3-->%d---%@", i, [NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncConcurrent---end");
}

/**
 * 4.3 同步执行 + 串行队列
 * 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)syncSerial {
    
    NSLog(@"currentThread---%@", [NSThread currentThread]);
    NSLog(@"syncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("com.houmanager.gcd", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1-->%d---%@", i, [NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{

        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2-->%d---%@", i, [NSThread currentThread]);
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3-->%d---%@", i, [NSThread currentThread]);
        }
    });
    
    NSLog(@"syncSerial---end");
}

/**
 * 4.4 异步执行 + 串行队列
 * 特点：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)asyncSerial {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"asyncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("com.houmanager.gcd", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1-->%d---%@", i, [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{

        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2-->%d---%@", i, [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{

        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3-->%d---%@", i, [NSThread currentThread]);
        }
    });

    NSLog(@"asyncSerial---end");
}

/**
 * 4.5.1 同步执行 + 主队列
 * 特点(主线程调用)：互等卡住不执行。会报：Thread 1: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0)
 * 特点(其他线程调用)：不会开启新线程，执行完一个任务，再执行下一个任务。
 */

- (void)syncMain {

    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"syncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();

    dispatch_sync(queue, ^{

        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1-->%d---%@", i, [NSThread currentThread]);
        }
    });

    dispatch_sync(queue, ^{

        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2-->%d---%@", i, [NSThread currentThread]);
        }
    });

    dispatch_sync(queue, ^{
       
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3-->%d---%@", i, [NSThread currentThread]);
        }
    });
 
    NSLog(@"syncMain---end");
}

/**
 * 4.6 异步执行 + 主队列
 * 特点：只在主线程中执行任务，执行完一个任务，再执行下一个任务
 */
- (void)asyncMain {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"asyncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
       
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1-->%d---%@", i, [NSThread currentThread]);
        }
    });
 
    dispatch_async(queue, ^{
   
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2-->%d---%@", i, [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3-->%d---%@", i, [NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncMain---end");
}

/**
 * 5. 线程间通信
 */
- (void)communication {

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();

    dispatch_async(queue, ^{
 
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1-->%d---%@", i, [NSThread currentThread]);
        }

        // 回到主线程
        dispatch_async(mainQueue, ^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2-----%@", [NSThread currentThread]);
        });
    });
}

/**
 * 6.1 栅栏方法 dispatch_barrier_async
 */
- (void)barrier {
    
    // 并发
    dispatch_queue_t queue = dispatch_queue_create("com.houmanager.gcd", DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(queue, ^{
        
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1-->%d---%@", i, [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{

        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2-->%d---%@", i, [NSThread currentThread]);
        }
    });
  
    dispatch_barrier_async(queue, ^{

        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"barrier-->%d---%@", i, [NSThread currentThread]);
        }
    });

    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3-->%d---%@", i, [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"4-->%d---%@", i, [NSThread currentThread]);
        }
    });
}

/**
 * 6.2 延时执行方法 dispatch_after
 */
- (void)dispatch_after {
    
    NSLog(@"currentThread---%@", [NSThread currentThread]);
    
    NSLog(@"dispatch_after---begin");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 2.0秒后异步追加任务代码到主队列，并开始执行
        NSLog(@"after---%@", [NSThread currentThread]);
    });
    
    NSLog(@"dispatch_after---sleep");
    [NSThread sleepForTimeInterval:10];
    NSLog(@"dispatch_after---end");
}

/**
 * 6.3 一次性代码（只执行一次）dispatch_once
 */
- (void)dispatch_once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 只执行1次的代码(这里面默认是线程安全的)
    });
}

/**
 * 6.4 快速迭代方法 dispatch_apply
 */
- (void)dispatch_apply {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    NSLog(@"dispatch_apply---begin");
    dispatch_apply(10, queue, ^(size_t index) {

        NSLog(@"%zd---%@", index, [NSThread currentThread]);
    });
    NSLog(@"apply---end");
}

/**
 * 6.5.1 队列组 dispatch_group_notify
 */
- (void)groupNotify {
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"group---begin");

    dispatch_group_t group =  dispatch_group_create();
 
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1-->%d---%@", i, [NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2-->%d---%@", i, [NSThread currentThread]);
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务1、任务2都执行完毕后，回到主线程执行下边任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3-->%d---%@", i, [NSThread currentThread]);
        }
        NSLog(@"group---end");
    });
}

/**
 * 6.5.2 队列组 dispatch_group_wait
 * 特点：暂停当前线程（阻塞当前线程），等待指定的 group 中的任务执行完成后，才会往下继续执行。
 */
- (void)groupWait {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1-->%d---%@", i, [NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        for (int i = 0; i < 20; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2-->%d---%@", i, [NSThread currentThread]);
        }
    });
    
    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"group---end");
}

/**
 * 6.5.3 dispatch_group_enter、dispatch_group_leave
 * 队列组 dispatch_group_enter、dispatch_group_leave
 */
- (void)groupEnterAndLeave {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"group---begin");
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1-->%d---%@", i, [NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2-->%d---%@", i, [NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        // 等前面的异步操作都执行完毕后，回到主线程.
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3-->%d---%@", i, [NSThread currentThread]);
        }
        NSLog(@"group---end");
        
    });
//        // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
//        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
//        NSLog(@"group---end");
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
