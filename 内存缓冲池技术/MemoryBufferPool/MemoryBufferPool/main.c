//
//  main.c
//  MemoryBufferPool
//
//  Created by YJHou on 2018/4/25.
//  Copyright © 2018年 YJ. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>

// 下面这段代码执行后，内存有增无减，增加了200M，iOS平台200M不能接受了
// STL 集合类
void test1() {
    list<int> mList;
    for (int i=0; i<1000000; i++) {
        mList.push_back(i);
    }
    mList.clear();
}
// mList 作用域 {} 内，stack 上的变量由编译器出了 } 自动释放



// STL 底层是用 new/delete 分配内存的，new/delete 是基于 malloc/free 分配的，malloc/free 又是基于各个操作系统统一封装，于是我写了下面的测试代码
// 申请 100w 个 100byte 的空间，再释放掉
void test2() {
    char **ptr = (char **)malloc(1000000 * sizeof(char *));
    for (int i=0; i<1000000; i++) {
        *(ptr + i) = (char *)malloc(100 * sizeof(char));
    }
    for (int i=0; i<1000000; i++) {
        free(*(ptr + i));
    }
    free(ptr);
}

/**
 内存依然去到了300M，无减少。 原因：
 
 Windows 平台调用free，内存会马上降回来。
 
 Linux 平台调用free，内存不会释放回OS，而是释放回系统的内存缓冲池，进程退出时才释放回OS。（ps：Linux下谷歌有个 tcmalloc 能做到立刻释放到OS，或者malloc_trim(0)）
 
 iOS 平台调用 free 后，也只是释放到系统的内存缓冲池里，进程退出才释放回OS。
 
 查了一下，iOS用不了谷歌的tcmalloc，malloc_trim也用不了，只能用 malloc_zone_t 自定义一个缓存区，用完自己销毁，就能够释放内存。如下面这段代码，就能把内存释放会 OS 了。
 
 
 
 现在能搞定的是通过创建 zone 内的 malloc/free 能控制内存释放回 OS，又有一个问题来了，STL C++的类不能用 malloc/free，内存依然不能释放会OS，这个问题还在找办法，有人知道麻烦告诉我，thanks。
 
 
 原理
 
 操作系统管理内存的方式进化：段式 -> 页式 -> 段页式。
 
 段式有内存外部碎片，内存利用率低，于是发明了页式，页式有内部碎片。同时页式管理中，进程不一定要全部在内存当中了，不在的部分是虚拟内存，进程的物理空间也不一定连续，虚拟地址通过页表能算出物理地址，不在内存中产生缺页中断。。。等等
 
 页式管理中，一个页为4KB，只能按页为单位拿内存。假设一个对象只有100 byte，为一个对象分配一个页的内存，有3KB多是浪费的，浪费的部分叫做内部碎片。一个进程有几十万个对象，碎片就非常多了利用率低。
 
 于是发明内存缓冲池，假如申请的内存大于一个页的4KB，那么去OS申请。
 
 假如申请的内存都是很小的，几百字节以内的，那么在缓冲池内申请。释放的时候，只释放回缓冲池，预防下次还要申请。也就是从OS拿部分内存自己进程持有，由自己负责分配。
 
 缓冲池内存管理算法：空闲链表，隐式的空闲链表，位图。
 
 经过上面的代码测试，默认缓冲池直接malloc/free，速度 70ms，但内存单调增长。
 
 创建和销毁缓冲池，自己的缓冲池内malloc/free，速度 160ms，但内存不增长。
 
 所以缓冲池的出现体现了时间换空间，空间换时间的计算思维。
 
 缓冲池的好处：
 
 1.不用触发系统调用，速度快，2.减少内存碎片，提高利用率。
 
 如果不适当释放内存，容易导致内存单调增长。

 
 
 iOS 的 OC 对象都是通过 alloc 方法创建的，alloc 方法调用了 allocWithZone，这个 NSZone 底层就是 malloc_zone_t，就是缓冲池。所以给对象分配内存的速度是很快的
 

 */

// 自定义 malloc_zone_t 内申请/释放内存
void test3() {
    
    malloc_zone_t *my_zone = malloc_create_zone(0, 0);      // 创建一个 zone
    
    char **ptr = (char **)my_zone->malloc(my_zone, 1000000 * sizeof(char *));
    
    for (int i = 0; i < 1000000; i++) {
        *(ptr + i) = (char *)my_zone->malloc(my_zone, 104 * sizeof(char));
    }
    for (int i = 0; i < 1000000; i++) {
        my_zone->free(my_zone, *(ptr + i));
    }
    my_zone->free(my_zone, ptr);    // 内存释放回 zone，并不是释放会OS，内存还是占用着
    malloc_destroy_zone(my_zone);   // 内存释放回 os 层，内存占用减少
}

int main(int argc, const char * argv[]) {
    
    test1();
    
    return 0;
}

