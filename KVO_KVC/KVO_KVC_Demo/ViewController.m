//
//  ViewController.m
//  KVO_KVC_Demo
//
//  Created by YJHou on 2014/3/27.
//  Copyright © 2014年 houmanager@hotmail.com. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>
#import "Person.h"

@interface ViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _kvoLogMessage];
}

- (void)_kvoLogMessage{
    
    NSLog(@"-->%@", @"before add kvo");

    NSLog(@"tableView_Address-->%p", self.tableView);
    NSLog(@"tableView_class_method-->%@", self.tableView.class);
    NSLog(@"tableView_desc-->%@", self.tableView);
    NSLog(@"runtime-->%@", object_getClass(self.tableView)); // The class object of which object is an instance
    NSLog(@"-->%p-->%p", self.tableView.class, object_getClass(self.tableView));
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    NSLog(@"-->%@", @"after add kvo");
    
    NSLog(@"tableView_Address-->%p", self.tableView);
    NSLog(@"tableView_class_method-->%@", self.tableView.class);
    NSLog(@"tableView_desc-->%@", self.tableView);
    NSLog(@"runtime-->%@", object_getClass(self.tableView));
    NSLog(@"-->%p-->%p", self.tableView.class, object_getClass(self.tableView));
    
    NSLog(@"-->%d", [object_getClass(self.tableView) isSubclassOfClass:[self.tableView class]]);
    NSLog(@"-->%d", [[self.tableView class] isSubclassOfClass:object_getClass(self.tableView)]);
    NSLog(@"-->%d", [object_getClass(self.tableView) isKindOfClass:[self.tableView class]]);
    
    
    // objc_msgSend(self,class) objc_msgSendSuper(self,class)
    // super本质上只是一个编译器指示符
    // 调用super的方法，只是在消息发送的时候，向父类的Method List发送消息，但是从内存上来说接收消息的对象还是self自身。
    NSLog(@"self-->%p", self);
    NSLog(@"self-->%@ super-->%@", self.class, super.class);
    
    
    NSObject *obj = [NSObject new];
    Class cls = object_getClass(obj);
    Class cls2 = [obj class];
    NSLog(@"%p", cls);  // 0x1b5908ea0
    NSLog(@"%p", cls2); // 0x1b5908ea0
    
    Person *person = [Person new];
    Class pCls1 = object_getClass(person);
    Class pCls2 = [person class];
    NSLog(@"-->%p", pCls1);
    NSLog(@"-->%p", pCls2);
    
}

#pragma mark - Lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
