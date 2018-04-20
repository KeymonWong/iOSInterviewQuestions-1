## 官方介绍

[官方地址](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Notifications/Articles/NotificationCenters.html#//apple_ref/doc/uid/20000216-BAJGDAFC)
In a multithreaded application, notifications are always delivered in the thread in which the notification was posted, which may not be the same thread in which an observer registered itself.

意思就是：在多线程应用中，Notification在哪个线程中post，就在哪个线程中被转发，而不一定是在注册观察者的那个线程中。(Demo中有测试代码)

这样就会有问题，线程不一致导致通信问题。

官方解释：

For example, if an object running in a background thread is listening for notifications from the user interface, such as a window closing, you would like to receive the notifications in the background thread instead of the main thread. In these cases, you must capture the notifications as they are delivered on the default thread and redirect them to the appropriate thread.

一种重定向的实现思路是自定义一个通知队列(注意，不是NSNotificationQueue对象，而是一个数组)，让这个队列去维护那些我们需要重定向的Notification。我们仍然是像平常一样去注册一个通知的观察者，当Notification来了时，先看看post这个Notification的线程是不是我们所期望的线程，如果不是，则将这个Notification存储到我们的队列中，并发送一个信号(signal)到期望的线程中，来告诉这个线程需要处理一个Notification。指定的线程在收到信号后，将Notification从队列中移除，并进行处理。

官方文档已经给出了示例代码，在此借用一下，以测试实际结果：

看[官方Demo](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Notifications/Articles/Threading.html#//apple_ref/doc/uid/20001289-CEGJFDFG)

当然，更好的方法可能是我们自己去子类化一个NSNotificationCenter，或者单独写一个类来处理这种转发。

## NSNotificationCenter的线程安全性

苹果之所以采取通知中心在同一个线程中post和转发同一消息这一策略，应该是出于线程安全的角度来考量的。官方文档告诉我们，NSNotificationCenter是一个线程安全类，我们可以在多线程环境下使用同一个NSNotificationCenter对象而不需要加锁。原文在[Threading Programming Guide](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Multithreading/ThreadSafetySummary/ThreadSafetySummary.html)中，具体如下：

```
The following classes and functions are generally considered to be thread-safe. You can use the same instance from multiple threads without first acquiring a lock.

NSArray
...
NSNotification
NSNotificationCenter
...
```

我们可以在任何线程中添加/删除通知的观察者，也可以在任何线程中post一个通知。

NSNotificationCenter在线程安全性方面已经做了不少工作了，那是否意味着我们可以高枕无忧了呢?

通常实现方式
```
@interface Observer : NSObject

@end

@implementation Observer

- (instancetype)init
{
    self = [super init];

    if (self)
    {
        _poster = [[Poster alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:TEST_NOTIFICATION object:nil]
    }

    return self;
}

- (void)handleNotification:(NSNotification *)notification
{
    NSLog(@"handle notification ");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

// 其它地方
[[NSNotificationCenter defaultCenter] postNotificationName:TEST_NOTIFICATION object:nil];

```

如果dealloc方法和-postNotificationName:方法不在同一个线程中运行时，会出现什么问题呢？

```
#pragma mark - Poster

@interface Poster : NSObject

@end

@implementation Poster

- (instancetype)init
{
    self = [super init];

    if (self)
    {
        [self performSelectorInBackground:@selector(postNotification) withObject:nil];
    }

    return self;
}

- (void)postNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TEST_NOTIFICATION object:nil];
}

@end

#pragma mark - Observer

@interface Observer : NSObject
{
    Poster  *_poster;
}

@property (nonatomic, assign) NSInteger i;

@end

@implementation Observer

- (instancetype)init
{
    self = [super init];

    if (self)
    {
        _poster = [[Poster alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:TEST_NOTIFICATION object:nil];
    }

    return self;
}

- (void)handleNotification:(NSNotification *)notification
{
    NSLog(@"handle notification begin");
    sleep(1);
    NSLog(@"handle notification end");

    self.i = 10;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    NSLog(@"Observer dealloc");
}

@end

#pragma mark - ViewController

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    __autoreleasing Observer *observer = [[Observer alloc] init];
}

@end
```

## 总结

NSNotificationCenter虽然是线程安全的，但不要被这个事实所误导。在涉及到多线程时，我们还是需要多加小心，避免出现上面的线程问题。想进一步了解的话，可以查看[Observers and Thread Safety](http://inessential.com/2013/12/20/observers_and_thread_safety)。

可以再任意线程添加和删除观察者，也可以在任何线程post通知，但是并不代表就可以安全使用了，比如在主线程添加和删除观察者，在其他线程依旧post通知，那么就会出现内存错误，程序崩溃。因为让释放对象处理事件是僵尸对象(使用对象已经挂了)。
