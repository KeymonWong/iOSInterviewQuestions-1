# 教你深刻理解Runtime机制

## 什么是Runtime？

### 概念
Objective-C是基于C语言加入面向对象特性和消息转发机制的动态语言，这就是说它不仅需要一个编译器，还需要Runtime系统动态的创建类和对象，进行消息发送和转发。关于Runtime概念众说纷纭。理解Runtime，我们从源码开始.... [源码介绍](https://opensource.apple.com/tarballs/objc4/) Runtime在实际开发中，其实就是一组C语言函数。

官方介绍：[官方文档](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Introduction/Introduction.html)
`
The Objective-C language defers as many decisions as it can from compile time and link time to runtime. Whenever possible, it does things dynamically. This means that the language requires not just a compiler, but also a runtime system to execute the compiled code. The runtime system acts as a kind of operating system for the Objective-C language; it’s what makes the language work.
`

怎么理解这句话呢？尽量将决定放到运行的时候，而不是在编译和链接过程...如图所示
![9fLXqO.png](https://s1.ax1x.com/2018/03/13/9fLXqO.png)

### Clang 是什么鬼？

Clang是一个C语言、C++、Objective-C、Objective-C++语言的轻量级编译器。

官方介绍：[官方文档](http://clang.llvm.org/docs/CommandGuide/clang.html)

`clang is a C, C++, and Objective-C compiler which encompasses preprocessing, parsing, optimization, code generation, assembly, and linking.`

源代码：main.m

```objc
//
//  main.m
//  YJDoctor
//
//  Created by YJHou on 2015/10/25.
//  Copyright © 2015年 houmanager@hotmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSObject *obj = [[NSObject alloc] init];
        NSLog(@"-->%@", obj);
    }
    return 0;
}
```

编译器：

```bash
clang -rewrite-objc main.m
```
生成了mian.cpp文件，打开查看源码：

```objc
int main(int argc, const char * argv[]) {
    /* @autoreleasepool */ { __AtAutoreleasePool __autoreleasepool; 

        NSObject *obj = ((NSObject *(*)(id, SEL))(void *)objc_msgSend)((id)((NSObject *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("NSObject"), sel_registerName("alloc")), sel_registerName("init"));
        NSLog((NSString *)&__NSConstantStringImpl__var_folders_dr_k2drvnh548q5293brg9wmgzc0000gn_T_main_2a142f_mi_0, obj);
    }
    return 0;
}
```
似乎看到了Runtime的影子：objc_msgSend、objc_getClass、sel_registerName...

### 寻找Runtime的来源

打开资源地址：/usr/include/objc 会发现如下文件：

![9fX2HU.png](https://s1.ax1x.com/2018/03/13/9fX2HU.png)


### 综上来看

在 Cocoa 中大量 好看好用的API，初学时只知道简单的查文档和调用。把 [receiver message] 当成简单的方法调用，而无视了`发送消息`这句话的深刻含义。其实 [receiver message] 会被编译器转化为：

```objc
objc_msgSend(receiver, selector)
// 或者含有参数时
objc_msgSend(receiver, selector, arg1, arg2, ...)

```

如果消息的接收者能够找到对应的 selector，那么就相当于直接执行了接收者这个对象的特定方法；否则，消息要么被转发，或是临时向接收者动态添加这个 selector 对应的实现内容，要么就干脆玩完崩溃掉。

现在可以看出 [receiver message] 真的不是一个简简单单的方法调用。因为这只是在编译阶段确定了要向接收者发送 message 这条消息，而 receive 将要如何响应这条消息，那就要看运行时发生的情况来决定了。

Objective-C 的 Runtime 铸就了它动态语言的特性，这些深层次的知识虽然平时写代码用的少一些，但是却是每个 Objc 程序员需要了解的。

## 为什么要熟悉掌握Runtime机制？

Runtime 在实际开发中，会经常用到吗？这个答案是肯定的。但是Runtime用的好不好在于理解程度，理解的好代码质量高效实用；用的不好，容易自己造坑。在实际开发中，我并不是推荐大家熟悉灵活的运用底层的东西，而是熟悉知道底层的运行机制。要不已经封装好看又好用的API干啥使。

Runtime 具体都干啥使用？

比如：`动态添加属性、动态添加方法、方法交换、字典模型转换`

`面试经历: 曾经一次面试，面试官说类别能不能设置属性？咋一听，条件反射类别还能设置属性，什么鬼，后来一想面试官问的是怎么给类别添加属性吧，用词准确很重要，添加和设置概念是不同的。面试官马上更正是添加不是设置。`



## 深刻理解Runtime的底层原理是什么样子的？

### 首先了解Runtime的数据结构

打开runtime.h会看到数据结构如图所示：

![9hCZwt.png](https://s1.ax1x.com/2018/03/13/9hCZwt.png)

- id : typedef struct objc_object *id;
- SEL : typedef struct objc_selector *SEL;
- Class : Class 也有一个 isa 指针，指向其所属的元类（meta）。
- super_class：指向其超类 (指向该类的父类, 如果该类已经是最顶层的根类(如 NSObject 或 NSProxy),那么 super_class 就为 NULL.)。
- name：是类名。
- version：是类的版本信息 默认是0。
- info：是类的详情 运行时的一些标志位。
- instance_size：是该类对象的实例对象的大小。
- ivars：指向该类的成员变量列表。
- methodLists：指向该类的实例方法列表，它将方法选择器和方法实现地址联系起来。methodLists 是指向 ·objc_method_list 指针的指针，也就是说可以动态修改 
- methodLists 的值来添加成员方法，这也是 Category 实现的原理，同样解释了 Category 不能添加属性的原因。
- cache：Runtime 系统会把被调用的方法存到 cache 中（理论上讲一个方法如果被调用，那么它有可能今后还会被调用），下次查找的时候效率更高。
- protocols：指向该类的协议列表(对象方法列表的扩展)。

#### SEL

`objc_msgSend`函数第二个参数类型为SEL，它是selector在Objc中的表示类型（Swift中是Selector类。selector是方法选择器，可以理解为区分方法的 ID，而这个 ID 的数据结构是SEL:

```objc
typedef struct objc_selector *SEL;
```
其实它就是个映射到方法的C字符串，你可以用 Objc 编译器命令 @selector() 或者 Runtime 系统的 sel_registerName 函数来获得一个 SEL 类型的方法选择器。

不同类中相同名字的方法所对应的方法选择器是相同的，即使方法名字相同而变量类型不同也会导致它们具有相同的方法选择器，于是 Objc 中方法命名有时会带上参数类型(NSNumber 一堆抽象工厂方法)。

#### id

`objc_msgSend` 第一个参数类型为id，大家对它都不陌生，它是一个指向类实例的指针：

```objc
typedef struct objc_object *id;
```

那objc_object又是啥呢，参考 objc-private.h 文件部分源码：

```objc
struct objc_object {
private:
    isa_t isa;

public:

    // ISA() assumes this is NOT a tagged pointer object
    Class ISA();

    // getIsa() allows this to be a tagged pointer object
    Class getIsa();
    ... 此处省略其他方法声明
}
```

objc_object 结构体包含一个 isa 指针，类型为 isa_t 联合体。根据 isa 就可以顺藤摸瓜找到对象所属的类。isa 这里还涉及到 tagged pointer 等概念。因为 isa_t 使用 union 实现，所以可能表示多种形态，既可以当成是指针，也可以存储标志位。有关 isa_t 联合体的更多内容可以查看 Objective-C 引用计数原理。

PS: isa 指针不总是指向实例对象所属的类，不能依靠它来确定类型，而是应该用 class 方法来确定实例对象的类。因为KVO的实现机理就是将被观察对象的 isa 指针指向一个中间类而不是真实的类，这是一种叫做 isa-swizzling 的技术，[详见官方文档](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/KeyValueObserving/Articles/KVOImplementation.html)

#### Class

Class 其实是一个指向 objc_class 结构体的指针：

```objc
typedef struct objc_class *Class;
```

而 objc_class 包含很多方法，主要都为围绕它的几个成员做文章：

```objc
struct objc_class : objc_object {
    // Class ISA;
    Class superclass;
    cache_t cache;             // formerly cache pointer and vtable
    class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags
    class_rw_t *data() { 
        return bits.data();
    }
    ... 省略其他方法
}
```

objc_class 继承于 objc_object，也就是说一个 ObjC 类本身同时也是一个对象，为了处理类和对象的关系，runtime 库创建了一种叫做元类 (Meta Class) 的东西，类对象所属类型就叫做元类，它用来表述类对象本身所具备的元数据。类方法就定义于此处，因为这些方法可以理解成类对象的实例方法。每个类仅有一个类对象，而每个类对象仅有一个与之相关的元类。当你发出一个类似 [NSObject alloc] 的消息时，你事实上是把这个消息发给了一个类对象 (Class Object) ，这个类对象必须是一个元类的实例，而这个元类同时也是一个根元类 (root meta class) 的实例。所有的元类最终都指向根元类为其超类。所有的元类的方法列表都有能够响应消息的类方法。所以当 [NSObject alloc] 这条消息发给类对象的时候，objc_msgSend() 会去它的元类里面去查找能够响应消息的方法，如果找到了，然后对这个类对象执行方法调用。

可以看到运行时一个类还关联了它的超类指针，类名，成员变量，方法，缓存，还有附属的协议。

cache_t

```objc
struct cache_t {
    struct bucket_t *_buckets;
    mask_t _mask;
    mask_t _occupied;
    ... 省略其他方法
}
```

_buckets 存储 IMP，_mask 和 _occupied 对应 vtable。

cache 为方法调用的性能进行优化，通俗地讲，每当实例对象接收到一个消息时，它不会直接在isa指向的类的方法列表中遍历查找能够响应消息的方法，因为这样效率太低了，而是优先在 cache 中查找。Runtime 系统会把被调用的方法存到 cache 中（理论上讲一个方法如果被调用，那么它有可能今后还会被调用），下次查找的时候效率更高。

bucket_t 中存储了指针与 IMP 的键值对：

```objc
struct bucket_t {
private:
    cache_key_t _key;
    IMP _imp;

public:
    inline cache_key_t key() const { return _key; }
    inline IMP imp() const { return (IMP)_imp; }
    inline void setKey(cache_key_t newKey) { _key = newKey; }
    inline void setImp(IMP newImp) { _imp = newImp; }

    void set(cache_key_t newKey, IMP newImp);
};
```

有关缓存的实现细节，可以查看 objc-cache.mm 文件。

class_data_bits_t
objc_class 中最复杂的是 bits，class_data_bits_t 结构体所包含的信息太多了，主要包含 class_rw_t, retain/release/autorelease/retainCount 和 alloc 等信息，很多存取方法也是围绕它展开。查看 objc-runtime-new.h 源码如下：

```objc
struct class_data_bits_t {

	// Values are the FAST_ flags above.
	uintptr_t bits;
	class_rw_t* data() {
	   return (class_rw_t *)(bits & FAST_DATA_MASK);
	}
... 省略其他方法
}
```

注意 objc_class 的 data 方法直接将 class_data_bits_t 的data 方法返回，最终是返回 class_rw_t，保了好几层。

可以看到 class_data_bits_t 里又包了一个 bits，这个指针跟不同的 FAST_ 前缀的 flag 掩码做按位与操作，就可以获取不同的数据。bits 在内存中每个位的含义有三种排列顺序：

![9hsDvq.png](https://s1.ax1x.com/2018/03/14/9hsDvq.png)

其中 64 位不兼容版每个宏对应的含义如下：

```objc
// class is a Swift class
#define FAST_IS_SWIFT           (1UL<<0)
// class's instances requires raw isa
#define FAST_REQUIRES_RAW_ISA   (1UL<<1)
// class or superclass has .cxx_destruct implementation
//   This bit is aligned with isa_t->hasCxxDtor to save an instruction.
#define FAST_HAS_CXX_DTOR       (1UL<<2)
// data pointer
#define FAST_DATA_MASK          0x00007ffffffffff8UL
// class or superclass has .cxx_construct implementation
#define FAST_HAS_CXX_CTOR       (1UL<<47)
// class or superclass has default alloc/allocWithZone: implementation
// Note this is is stored in the metaclass.
#define FAST_HAS_DEFAULT_AWZ    (1UL<<48)
// class or superclass has default retain/release/autorelease/retainCount/
//   _tryRetain/_isDeallocating/retainWeakReference/allowsWeakReference
#define FAST_HAS_DEFAULT_RR     (1UL<<49)
// summary bit for fast alloc path: !hasCxxCtor and 
//   !instancesRequireRawIsa and instanceSize fits into shiftedSize
#define FAST_ALLOC              (1UL<<50)
// instance size in units of 16 bytes
//   or 0 if the instance size is too big in this field
//   This field must be LAST
#define FAST_SHIFTED_SIZE_SHIFT 51
```
.... 

### 理解底层原理要从这三张图说起：

Messaging [官方介绍](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtHowMessagingWorks.html#//apple_ref/doc/uid/TP40008048-CH104-SW1)

![9fz4Z6.png](https://s1.ax1x.com/2018/03/13/9fz4Z6.png)

1. 刚开始clang mian.m文件可以看出，Runtime System 会将方法调用转化为消息发送(objc_msgSend), 并把方法的调用者和方法选择器当做参数传递。
2. 此时，方法调用者会通过isa指针来找到其所属的类，然后在cache或者methodLists中查找该方法，如果能找到就跳到对应的方法(IMP)中执行。
3. 如果在类中没有找到该方法，会检查本类是否有动态加载的方法来处理该消息，如果还是没有，通过super_class网上一级父类查找, 如果一直到NSObject都没找到该方法的话，这种情况，就该消息转发上场了。
4. 从数据结构中看到，methodLists 指向该类的实例方法列表，那么类方法在哪里？类方法存储在元类中，Class通过isa指针即可找到所属的元类。

Dynamic Method Resolution [官方介绍](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtDynamicResolution.html#//apple_ref/doc/uid/TP40008048-CH102-SW1)

![9h9cRg.png](https://s1.ax1x.com/2018/03/13/9h9cRg.png)

上图实线是 superclass 指针，虚线是isa指针。 有趣的是根元类的超类是 NSObject，而 isa 指向了自己，而 NSObject 的超类为 nil，也就是它没有超类。

从有图可以看出，ObjC 类本身同时也是一个对象，为了处理类和对象的关系，runtime 库创建了一种叫做元类 (Meta Class) 的东西，类对象所属类型就叫做元类，它用来表述类对象本身所具备的元数据。类方法就定义于此处，因为这些方法可以理解成类对象的实例方法。

 每个类仅有一个类对象，而每个类对象仅有一个与之相关的元类。当你发出一个类似 [NSObject alloc] 的消息时，你事实上是把这个消息发给了一个类对象 (Class Object) ，这个类对象必须是一个元类的实例，而这个元类同时也是一个根元类 (root meta class) 的实例。所有的元类最终都指向根元类为其超类。所有的元类的方法列表都有能够响应消息的类方法。所以当 [NSObject alloc] 这条消息发给类对象的时候，objc_msgSend() 会去它的元类里面去查找能够响应消息的方法，如果找到了，然后对这个类对象执行方法调用。
     
在Runtime System没有在本类的method_lists没有找到匹配的实现方法时，我们可以动态的添加一个方法，这是开始进行消息转发（messaging forward）前的第一阶段，例如我们用@dynamic关键字在类的实现文件中修饰一个属性：这表明我们会为这个属性动态提供存取方法，编译器不会默认为我们生成setPropertyName:和propertyName方法，而需要我们动态提供。


同样我们可以通过分别重载resolveInstanceMethod:和resolveClassMethod:方法分别添加实例方法实现和类方法实现。因为当 Runtime 系统在Cache和方法分发表中来给程序员一次动态添加方法实现的机会。我们需要用class_addMethod函数完成向特定类添加特定方法实现的操作：

Message Forwarding [官方介绍]()

![9h9TiT.jpg](https://s1.ax1x.com/2018/03/13/9h9TiT.jpg)

消息转发分为两大阶段。

- 第一阶段先征询接收者，所属的类，看其是否能动态添加方法，以处理当前这个“未知的选择子”，这叫做“动态方法解析”。
- 第二阶段涉及“完整的消息转发机制（full forwarding mechanism）”如果运行期系统已经执行完第一阶段，此时，运行期系统会请求我接收者以其它手段来处理消息。可以细分3小步。

 1.首先查找有没有replacement receiver进行处理。若无;
 
 2.运行期系统把Selector相关信息封装到NSInvocation对象中;
 
 3.再给一次机会，若依旧未处理则让NSObject调用doNotReconizeSelector：
 
具体步骤：

1. 检测这个 selector 是不是要忽略的。比如有了垃圾回收就不理会 retain, release 这些函数了。
2. 检测这个 target 是不是 nil 对象。ObjC 的特性是允许对一个 nil 对象执行任何一个方法不会 Crash，因为会被忽略掉。
3. 如果上面两个都过了，那就开始查找这个类的 IMP，先从 cache 里面找，完了找得到就跳到对应的函数去执行。
4. 如果 cache 找不到就找一下方法分发表。
5. 如果分发表找不到就到超类的分发表去找，一直找，直到找到NSObject类为止。
6. 如果还找不到就要开始进入动态方法解析：
	- 是否实现了 resolveInstanceMethod，是则执行这里定位的方法
	- 是否实现了 forwardingTargetForSelector，是则执行这里定位的方法
	- 是否实现了 forwardInvocation，是则执行这里定位的方法
	- 都没有实现，返回 message not handle 消息。


`其中: self 为方法中的隐含参数，self 是在方法运行时被偷偷的动态传入的。
当objc_msgSend找到方法对应的实现时，它将直接调用该方法实现，
并将消息中所有的参数都传递给方法实现,同时,它还将传递两个隐藏的参数:
- 接收消息的对象：即 self 指向的内容
- 方法选择器：即 _cmd 指向的内容 
`
#### 具体看代码所示：

[![9hAfL4.md.png](https://s1.ax1x.com/2018/03/13/9hAfL4.md.png)](https://imgchr.com/i/9hAfL4)

![9hA4eJ.png](https://s1.ax1x.com/2018/03/13/9hA4eJ.png)


由此我们可以看到，object_getClass返回的其实是class的metaClass，即Class这个类对象的类，这个概念有点绕。梳理一下：Person这么一个类(0x1000f53c8)，它的isa指针指向其元类(地址0x1000f53f0)，这个元类的isa指针指向基类NSObject的元类，即根元类(0x1a7919ec8)，再递进一层可以发现，根元类的isa指针指向自己，这样就形成了一个完整的闭环。

#### 另外objc_getClass 是什么鬼？

[![9hECfP.md.png](https://s1.ax1x.com/2018/03/13/9hECfP.md.png)](https://imgchr.com/i/9hECfP)

![9hEFl8.png](https://s1.ax1x.com/2018/03/13/9hEFl8.png)

由此可知objc_getClass方法只是单纯地返回了Class，而非isa指针指向的Class。


## Runtime的应用场景有什么？

- 实现第一个场景：跟踪程序每个ViewController展示给用户的次数，可以通过Method Swizzling替换ViewDidAppear初始方法。创建一个UIViewController的分类，重写自定义的ViewDidAppear方法，并在其+load方法中实现ViewDidAppear方法的交换
- 开发中常需要在不改变某个类的前提下为其添加一个新的属性，尤其是为系统的类添加新的属性，这个时候就可以利用Runtime的关联对象（Associated Objects）来为分类添加新的属性了
- 三实现字典的模型和自动转换，优秀的JSON转模型第三方库JSONModel、YYModel等都利用runtime对属性进行获取，赋值等操作，要比KVC进行模型转换更加强大，更有效率。阅读YYModel的源码可以看出，YY大神对NSObject的内容进行了又一次封装，添加了许多描述内容。其中YYClassInfo是对Class进行了再次封装，而YYClassIvarInfo、YYClassMethodInfo、YYClPropertyInfo分别是对Class的Ivar、Method和property进行了封装和描述。在提取Class的相关信息时都运用了Runtime。
- JSPatch替换已有的OC方法实行，具体内容请参看相关文档。

## 延伸

### 转发与继承的区别与联系

#### 联系 
Objective-C没有多继承，利用消息转发可以实现多继承。

比如： A 继承了 B 和 C，（A : B , C）那么 A 就同时拥有了 B 和 C 中的方法。
A 将消息转发给 B 和 C 也能实现同样的功能。 一个对象把消息转发出去，就好似它把另一个对象中的方法借过来或是“继承”过来一样。这样就可以实现多继承。

#### 区别：
像 respondsToSelector: 和 isKindOfClass: 这类方法只会考虑继承体系，不会考虑转发链。

Objective-C Associated Objects

在 OS X 10.6 之后，Runtime系统让Objc支持向对象动态添加变量。涉及到的函数有以下三个：

```objc
    void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
    id objc_getAssociatedObject(id object, const void *key);
    void objc_removeAssociatedObjects(id object);
```

其中关联政策是一组枚举常量, 这些常量对应着引用关联值的政策，也就是 Objc 内存管理的引用计数机制。

```objc
    enum {
       OBJC_ASSOCIATION_ASSIGN  = 0,
       OBJC_ASSOCIATION_RETAIN_NONATOMIC  = 1,
       OBJC_ASSOCIATION_COPY_NONATOMIC  = 3,
       OBJC_ASSOCIATION_RETAIN  = 01401,
       OBJC_ASSOCIATION_COPY  = 01403
    };
```

### 版本问题

Runtime其实有两个版本: “modern” 和 “legacy”。我们现在用的 Objective-C 2.0 采用的是现行 (Modern) 版的 Runtime 系统，只能运行在 iOS 和 macOS 10.5 之后的 64 位程序中。而 maxOS 较老的32位程序仍采用 Objective-C 1 中的（早期）Legacy 版本的 Runtime 系统。这两个版本最大的区别在于当你更改一个类的实例变量的布局时，在早期版本中你需要重新编译它的子类，而现行版就不需要。

[参考](http://yulingtianxia.com/blog/2014/11/05/objective-c-runtime/index.html)