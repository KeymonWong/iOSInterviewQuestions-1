#多线程编程中, 常见的问题有

##死锁Deadlock

死锁指的是由于两个或多个执行单元之间相互等待对方结束而引起阻塞的情况。每个线程都拥有其他线程所需要的资源，同时又等待其他线程已经拥有的资源，并且每个线程在获取所有需要资源之前都不会释放自己已经拥有的资源。

## 优先级翻转/倒置/逆转 Priority inversion

当一个高优先级任务通过信号量机制访问共享资源时，该信号量已被一低优先级任务占有，而这个低优先级任务在访问共享资源时可能又被其它一些中等优先级任务抢先，因此造成高优先级任务被许多具有较低优先级任务阻塞，实时性难以得到保证。

## 数据竞争Race condition

Data Race是指多个线程在没有正确加锁的情况下，同时访问同一块数据，并且至少有一个线程是写操作，对数据的读取和修改产生了竞争，从而导致各种不可预计的问题。

从Xcode8.0已经发布了一个新的调试工具，称为Thread Sanitizer(又叫TSan)，可以帮助在运行时检测多线程中的数据竞争问题. 没了解过的小朋友可以参看官方视频[WWDC 2016 Session 412](https://developer.apple.com/videos/play/wwdc2016/412/)

如何解决这种Data race问题呢? 将共享变量的 read和write放在同一个DispatchQueue中. 采用什么样的DispatchQueue, 这里有2种方法:

采用串行的DispatchQueue, 所有的read/write都是串行的, 所以不会出现Data race的问题; 但是效率比较低,即使所有的操作都是read, 也必须排队一个一个的读.

采用并行的DispatchQueue, 所有的read都可以并行进行, 所有的write都必须"独占"(barrier)的进行: 我write的时候, 任何人不允许read或者write.如下图:

![](https://mmbiz.qpic.cn/mmbiz_jpg/foPACGrddJ2mUtkr9IywsL5ibRjYxtxsnXV6clJ2YsNe4TllBib9rJdlyarnKgUzMTxNYIlDsMKjtKJx9pWm5HGA/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1)
