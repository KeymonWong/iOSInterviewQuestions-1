# 一、简介

## 首先提出一些问题:

- 1.dispatch_async 函数如何实现，分发到主队列和全局队列有什么区别，一定会新建线程执行任务么？
- 2.dispatch_sync 函数如何实现，为什么说 GCD 死锁是队列导致的而不是线程，死锁不是操作系统的概念么？
- 3.信号量是如何实现的，有哪些使用场景？
- 4.dispatch_group 的等待与通知、dispatch_once 如何实现？
- 5.dispatch_source 用来做定时器如何实现，有什么优点和用途？
- 6.dispatch_suspend 和 dispatch_resume 如何实现，队列的的暂停和计时器的暂停有区别么？

```
#define DISPATCH_DECL(name) typedef struct name##_s *name##_t
```
比如说非常常见的 DISPATCH_DECL(dispatch_queue);，它的展开形式是:

```
typedef struct dispatch_queue_s *dispatch_queue_t;
```

这行代码定义了一个 dispatch_queue_t 类型的指针，指向一个 dispatch_queue_s 类型的结构体。

## TSD

TSD(Thread-Specific Data) 表示线程私有数据。在 C++ 中，全局变量可以被所有线程访问，局部变量只有函数内部可以访问。而 TSD 的作用就是能够在同一个线程的不同函数中被访问。在不同线程中，虽然名字相同，但是获取到的数据随线程不同而不同。
通常，我们可以利用 POSIX 库提供的 API 来实现 TSD:

```
int pthread_key_create(pthread_key_t *key, void (*destr_function) (void *))

```
这个函数用来创建一个 key，在线程退出时会将 key 对应的数据传入 destr_function 函数中进行清理。

我们分别使用 get/set 方法来访问/修改 key 对应的数据:

```
int  pthread_setspecific(pthread_key_t  key,  const   void  *pointer)

void * pthread_getspecific(pthread_key_t key)
```

在 GCD 中定义了六个 key，根据名字大概能猜出各自的含义:

```
pthread_key_t dispatch_queue_key;

pthread_key_t dispatch_sema4_key;

pthread_key_t dispatch_cache_key;

pthread_key_t dispatch_io_key;

pthread_key_t dispatch_apply_key;

pthread_key_t dispatch_bcounter_key;
```

## fastpath && slowpath

这是定义在 internal.h 中的两个宏:

```
#define fastpath(x) ((typeof(x))__builtin_expect((long)(x), ~0l))

#define slowpath(x) ((typeof(x))__builtin_expect((long)(x), 0l))
```

为了理解所谓的快路径和慢路径，我们需要先学习一点计算机基础知识。比如这段非常简单的代码:

```
if (x)
    return 1;
else
    return 39;
```

由于计算机并非一次只读取一条指令，而是读取多条指令，所以在读到 if 语句时也会把 return 1 读取进来。如果 x 为 0，那么会重新读取 return 39，重读指令相对来说比较耗时。

如过 x 有非常大的概率是 0，那么 return 1 这条指令每次不可避免的会被读取，并且实际上几乎没有机会执行， 造成了不必要的指令重读。当然，最简单的优化就是:

```
if (!x)
    return 39;
else
    return 1;
```

然而对程序员来说，每次都做这样的判断非常烧脑，而且容易出错。于是 GCC 提供了一个内置函数 `__builtin_expect`:

```
long __builtin_expect (long EXP, long C)
```

它的返回值就是整个函数的返回值，参数 C 代表预计的值，表示程序员知道 EXP 的值很可能就是 C。比如上文中的例子可以这样写:

```
if (__builtin_expect(x, 0))
    return 1;
else
    return 39;
```

虽然写法逻辑不变，但是编译器会把汇编代码优化成 if(!x) 的形式。

因此，在苹果定义的两个宏中，fastpath(x) 依然返回 x，只是告诉编译器 x 的值一般不为 0，从而编译器可以进行优化。同理，slowpath(x) 表示 x 的值很可能为 0，希望编译器进行优化。

![](https://images2015.cnblogs.com/blog/708266/201609/708266-20160905081233613-27028364.jpg)





## 概念
Grand Central Dispatch 是Apple开发的一个多核编程的较新的的解决办法，它主要用于优化应用程序以支持多核处理器及其他对称多处理系统。她是一个在线程池模式的基础上执行的并发任务。在Mac OS X 10.6 雪豹中首次推出，也可在iOS 4及以上版本使用。

## 为什么要使用GCD？

优点：

- 可用于多核的并行运算
- 自动利用更多的CPU内核
- 自动管理线程的生命周期(创建线程、任务调度、线程销毁)
- 只需要告诉GCD执行什么任务，不需要编写任何线程管理的代码

## GCD 任务和队列

任务：就是执行操作的意思，换句话说就是你在线程中执行的那段代码。在 GCD 中是放在 block 中的。执行任务有两种方式：同步执行（sync）和异步执行（async）。两者的主要区别是：是否等待队列的任务执行结束，以及是否具备开启新线程的能力。

- 同步执行（sync）：

同步添加任务到指定的队列中，在添加的任务执行结束之前，会一直等待，直到队列里面的任务完成之后再继续执行。

只能在当前线程中执行任务，不具备开启新线程的能力。

- 异步执行（async）：

异步添加任务到指定的队列中，它不会做任何等待，可以继续执行任务。

可以在新的线程中执行任务，具备开启新线程的能力。


注意： 异步执行（async） 虽然具有开启新线程的能力，但是并不一定开启新线程。这跟任务所指定的队列类型有关（下面会讲）。

队列（Dispatch Queue）：这里的队列指执行任务的等待队列，即用来存放任务的队列。队列是一种特殊的线性表，采用 FIFO（先进先出）的原则，即新任务总是被插入到队列的末尾，而读取任务的时候总是从队列的头部开始读取。每读取一个任务，则从队列中释放一个任务。

在 GCD 中有两种队列：串行队列和并发队列。两者都符合 FIFO（先进先出）的原则。两者的主要区别是：执行顺序不同，以及开启线程数不同。



串行队列（Serial Dispatch Queue）：

每次只有一个任务被执行。让任务一个接着一个地执行。（只开启一个线程，一个任务执行完毕后，再执行下一个任务）



并发队列（Concurrent Dispatch Queue）：

可以让多个任务并发（同时）执行。（可以开启多个线程，并且同时执行任务）

并发队列 的并发功能只有在异步（dispatch_async）函数下才有效

## GCD 使用

GCD 的使用步骤其实很简单，只有两步。



1.创建一个队列（串行队列或并发队列）

2.将任务追加到任务的等待队列中，然后系统就会根据任务类型执行任务（同步执行或异步执行）


下边来看看 队列的创建方法/获取方法，以及 任务的创建方法。

### 队列的创建方法/获取方法

可以使用dispatch_queue_create来创建队列，需要传入两个参数，第一个参数表示队列的唯一标识符，用于 DEBUG，可为空，Dispatch Queue 的名称推荐使用应用程序 ID 这种逆序全程域名；第二个参数用来识别是串行队列还是并发队列。DISPATCH_QUEUE_SERIAL 表示串行队列，DISPATCH_QUEUE_CONCURRENT 表示并发队列。

```objc
// 串行队列
   dispatch_queue_t derialQueue = dispatch_queue_create("com.houmanager.gcd", DISPATCH_QUEUE_SERIAL);

   // 并行队列
   dispatch_queue_t concurrentQueue = dispatch_queue_create("com.houmanager.gcd", DISPATCH_QUEUE_CONCURRENT);
```

对于串行队列，GCD 提供了的一种特殊的串行队列：主队列（Main Dispatch Queue）。

所有放在主队列中的任务，都会放到主线程中执行。

可使用dispatch_get_main_queue()获得主队列

```objc
// 主队列的获取方法

dispatch_queue_t queue = dispatch_get_main_queue();
```

对于并发队列，GCD 默认提供了全局并发队列（Global Dispatch Queue）。

可以使用dispatch_get_global_queue来获取。需要传入两个参数。第一个参数表示队列优先级，一般用DISPATCH_QUEUE_PRIORITY_DEFAULT。第二个参数暂时没用，用0即可。

```objc
// 全局并发队列的获取方法
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
```

### 任务的创建方法

GCD 提供了同步执行任务的创建方法dispatch_sync和异步执行任务创建方法dispatch_async。

```objc
// 同步执行任务
dispatch_sync(queue, ^{

});

// 异步执行任务
dispatch_async(queue, ^{

});
```

串行和并行 同步和异步 有四种不同的组合方式：

- 1.同步执行 + 串行队列
- 2.同步执行 + 并行队列
- 3.异步执行 + 串行队列
- 4.异步执行 + 并行队列

两种特殊的队列： 全局并发队列、主队列

全局并发队列可以当做普通并发队列使用。主队列不行。。

- 5.同步执行 + 主队列
- 6.异步执行 + 主队列

区别：

区别 | 并发队列 | 串行队列 | 主队列
--- | --- | --- | ---
同步(sync) | 没有开启新线程，串行执行任务 | 没有开启新线程，串行执行任务 | 没有开启新线程，串行执行任务
异步(async) | 有开启新线程，并发执行任务 | 有开启新线程(1条)，串行执行任务 | 没有开启新线程，串行执行任务


## 四、基本使用

### 4.1 同步执行 + 并发队列

```objc
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
```

按顺序执行的原因：虽然并发队列可以开启多个线程，并且同时执行多个任务。但是因为本身不能创建新线程，只有当前线程这一个线程（同步任务不具备开启新线程的能力），所以也就不存在并发。而且当前线程只有等待当前队列中正在执行的任务执行完毕之后，才能继续接着执行下面的操作（同步任务需要等待队列的任务执行结束）。所以任务只能一个接一个按顺序执行，不能同时被执行。

### 4.2 异步执行 + 并发队列

```objc
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
```

### 4.3 同步执行 + 串行队列

```objc
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
```

### 4.4 异步执行 + 串行队列

```objc
/**
 * 4.4 异步执行 + 串行队列
 * 特点：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)asyncSerial {

    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"asyncSerial---begin");

    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);

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
```
### 4.5 同步执行 + 主队列

同步执行 + 主队列在不同线程中调用结果也是不一样，在主线程中调用会出现死锁，而在其他线程中则不会。

#### 4.5.1 在主线程中调用同步执行 + 主队列

```objc
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
```

#### 4.5.2 在其他线程中调用同步执行 + 主队列

```objc
// 4.5.2
    // 使用 NSThread 的 detachNewThreadSelector 方法会创建线程，并自动启动线程执行selector 任务
    [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
```

### 4.6 异步执行 + 主队列

```objc
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
```

## 五、GCD 线程间的通信

```objc
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
```
## 六. GCD 的其他方法

### 6.1 GCD 栅栏方法：dispatch_barrier_async

```objc
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
```

### 6.2 GCD 延时执行方法：dispatch_after

注意：dispatch_after函数并不是在指定时间之后才开始执行处理，而是在指定时间之后将任务追加到主队列中。严格来说，这个时间并不是绝对准确的，但想要大致延迟执行任务，dispatch_after函数是很有效的。

```objc
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
```

### 6.3 GCD 一次性代码（只执行一次）：dispatch_once

即使在多线程的环境下，dispatch_once也可以保证线程安全。

### 6.4 GCD 快速迭代方法：dispatch_apply

```objc
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
```

### 6.5 GCD 的队列组：dispatch_group

- 调用队列组的 dispatch_group_async 先把任务放到队列中，然后将队列放入队列组中。或者使用队列组的 dispatch_group_enter、dispatch_group_leave 组合 来实现dispatch_group_async。

- 调用队列组的 dispatch_group_notify 回到指定线程执行任务。或者使用 dispatch_group_wait 回到当前线程继续向下执行（会阻塞当前线程）。

#### 6.5.1 dispatch_group_notify

```objc
/**
 * 6.5.1 队列组 dispatch_group_notify
 * 特点： 监听 group 中任务的完成状态，当所有的任务都执行完成后，追加任务到 group 中，并执行任务。
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
```

#### 6.5.2 dispatch_group_wait


#### 6.5.3 dispatch_group_enter、dispatch_group_leave

dispatch_group_enter 标志着一个任务追加到 group，执行一次，相当于 group 中未执行完毕任务数+1

dispatch_group_leave 标志着一个任务离开了 group，执行一次，相当于 group 中未执行完毕任务数-1。

当 group 中未执行完毕任务数为0的时候，才会使dispatch_group_wait解除阻塞，以及执行追加到dispatch_group_notify中的任务。

#### 6.6 GCD 信号量：dispatch_semaphore

GCD 中的信号量是指 Dispatch Semaphore，是持有计数的信号。类似于过高速路收费站的栏杆。可以通过时，打开栏杆，不可以通过时，关闭栏杆。在 Dispatch Semaphore 中，使用计数来完成这个功能，计数为0时等待，不可通过。计数为1或大于1时，计数减1且不等待，可通过。Dispatch Semaphore 提供了三个函数。

- dispatch_semaphore_create：创建一个Semaphore并初始化信号的总量

- dispatch_semaphore_signal：发送一个信号，让信号总量加1

- dispatch_semaphore_wait：可以使总信号量减1，当信号总量为0时就会一直等待（阻塞所在线程），否则就可以正常执行。

注意：信号量的使用前提是：想清楚你需要处理哪个线程等待（阻塞），又要哪个线程继续执行，然后使用信号量。

Dispatch Semaphore 在实际开发中主要用于：

- 保持线程同步，将异步执行任务转换为同步执行任务

- 保证线程安全，为线程加锁

##### 6.6.1 Dispatch Semaphore 线程同步

我们在开发中，会遇到这样的需求：异步执行耗时任务，并使用异步执行的结果进行一些额外的操作。换句话说，相当于，将将异步执行任务转换为同步执行任务。比如说：AFNetworking 中 AFURLSessionManager.m 里面的 tasksForKeyPath: 方法。通过引入信号量的方式，等待异步执行任务结果，获取到 tasks，然后再返回该 tasks。

```objc
// AFNetworking
- (NSArray *)tasksForKeyPath:(NSString *)keyPath {

    __block NSArray *tasks = nil;

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {

        if ([keyPath isEqualToString:NSStringFromSelector(@selector(dataTasks))]) {

            tasks = dataTasks;

        } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(uploadTasks))]) {

            tasks = uploadTasks;

        } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(downloadTasks))]) {

            tasks = downloadTasks;

        } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(tasks))]) {

            tasks = [@[dataTasks, uploadTasks, downloadTasks] valueForKeyPath:@"@unionOfArrays.self"];

        }



        dispatch_semaphore_signal(semaphore);

    }];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    return tasks;

}
```

下面，我们来利用 Dispatch Semaphore 实现线程同步，将异步执行任务转换为同步执行任务。

```objc
/**

 * semaphore 线程同步

 */

- (void)semaphoreSync {



    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程

    NSLog(@"semaphore---begin");



    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);



    __block int number = 0;

    dispatch_async(queue, ^{

        // 追加任务1

        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作

        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程



        number = 100;



        dispatch_semaphore_signal(semaphore);

    });



    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    NSLog(@"semaphore---end,number = %zd",number);

}

```

semaphore---end 是在执行完  number = 100; 之后才打印的。而且输出结果 number 为 100。这是因为异步执行不会做任何等待，可以继续执行任务。异步执行将任务1追加到队列之后，不做等待，接着执行dispatch_semaphore_wait方法。此时 semaphore == 0，当前线程进入等待状态。然后，异步任务1开始执行。任务1执行到dispatch_semaphore_signal之后，总信号量，此时 semaphore == 1，dispatch_semaphore_wait方法使总信号量减1，正在被阻塞的线程（主线程）恢复继续执行。最后打印semaphore---end,number = 100。这样就实现了线程同步，将异步执行任务转换为同步执行任务。

##### 6.6.2 Dispatch Semaphore 线程安全和线程同步（为线程加锁）

线程安全：如果你的代码所在的进程中有多个线程在同时运行，而这些线程可能会同时运行这段代码。如果每次运行结果和单线程运行的结果是一样的，而且其他的变量的值也和预期的是一样的，就是线程安全的。

线程同步：可理解为线程 A 和 线程 B 一块配合，A 执行到一定程度时要依靠线程 B 的某个结果，于是停下来，示意 B 运行；B 依言执行，再将结果给 A；A 再继续操作。

###### 6.6.2.1 非线程安全（不使用 semaphore）

先来看看不考虑线程安全的代码：

```objc
/**
 * 非线程安全：不使用 semaphore
 * 初始化火车票数量、卖票窗口(非线程安全)、并开始卖票
 */

- (void)initTicketStatusNotSave {

    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");

    self.ticketSurplusCount = 50;

    // queue1 代表北京火车票售卖窗口

    dispatch_queue_t queue1 = dispatch_queue_create("com.houmananger.gcd", DISPATCH_QUEUE_SERIAL);

    // queue2 代表上海火车票售卖窗口

    dispatch_queue_t queue2 = dispatch_queue_create("com.houmananger.gcd", DISPATCH_QUEUE_SERIAL);


    __weak typeof(self) weakSelf = self;

    dispatch_async(queue1, ^{

        [weakSelf saleTicketNotSafe];

    });

    dispatch_async(queue2, ^{

        [weakSelf saleTicketNotSafe];
    });
}

/**
 * 售卖火车票(非线程安全)
 */

- (void)saleTicketNotSafe {

    while (1) {

        if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖

            self.ticketSurplusCount--;

            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%d 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);

            [NSThread sleepForTimeInterval:0.2];

        } else { //如果已卖完，关闭售票窗口

            NSLog(@"所有火车票均已售完");
            break;
        }
    }
}
```

##### 6.6.2.2 线程安全（使用 semaphore 加锁）

```objc
/**

 * 线程安全：使用 semaphore 加锁

 * 初始化火车票数量、卖票窗口(线程安全)、并开始卖票

 */
- (void)initTicketStatusSave {

    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程

    NSLog(@"semaphore---begin");

    semaphoreLock = dispatch_semaphore_create(1);
    self.ticketSurplusCount = 50;

    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("com.houmananger.gcd", DISPATCH_QUEUE_SERIAL);

    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("com.houmananger.gcd", DISPATCH_QUEUE_SERIAL);

    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{

        [weakSelf saleTicketSafe];
    });

    dispatch_async(queue2, ^{
        [weakSelf saleTicketSafe];
    });
}

/**
 * 售卖火车票(线程安全)
 */
- (void)saleTicketSafe {

    while (1) {

        // 相当于加锁
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖

            self.ticketSurplusCount--;

            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%d 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);

            [NSThread sleepForTimeInterval:0.2];

        } else { //如果已卖完，关闭售票窗口

            NSLog(@"所有火车票均已售完");

            // 相当于解锁
            dispatch_semaphore_signal(semaphoreLock);

            break;

        }

        // 相当于解锁
        dispatch_semaphore_signal(semaphoreLock);
    }
}
```
