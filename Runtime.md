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
- super_class：指向其超类。
- name：是类名。
- version：是类的版本信息。
- info：是类的详情。
- instance_size：是该类的实例对象的大小。
- ivars：指向该类的成员变量列表。
- methodLists：指向该类的实例方法列表，它将方法选择器和方法实现地址联系起来。methodLists 是指向 ·objc_method_list 指针的指针，也就是说可以动态修改 
- methodLists 的值来添加成员方法，这也是 Category 实现的原理，同样解释了 Category 不能添加属性的原因。
- cache：Runtime 系统会把被调用的方法存到 cache 中（理论上讲一个方法如果被调用，那么它有可能今后还会被调用），下次查找的时候效率更高。
- protocols：指向该类的协议列表(对象方法列表的扩展)。

### 理解底层原理要从这三张图说起：

Messaging [官方介绍](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtHowMessagingWorks.html#//apple_ref/doc/uid/TP40008048-CH104-SW1)

![9fz4Z6.png](https://s1.ax1x.com/2018/03/13/9fz4Z6.png)

1. 刚开始clang mian.m文件可以看出，Runtime System 会将方法调用转化为消息发送(objc_msgSend), 并把方法的调用者和方法选择器当做参数传递。
2. 此时，方法调用者会通过isa指针来找到其所属的类，然后在cache或者methodLists中查找该方法，如果能找到就跳到对应的方法(IMP)中执行。
3. 如果在类中没有找到该方法，会检查本类是否有动态加载的方法来处理该消息，如果还是没有，通过super_class网上一级父类查找, 如果一直到NSObject都没找到该方法的话，这种情况，就该消息转发上场了。
4. 从数据结构中看到，methodLists 指向该类的实例方法列表，那么类方法在哪里？类方法存储在元类中，Class通过isa指针即可找到所属的元类。

Dynamic Method Resolution [官方介绍](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtDynamicResolution.html#//apple_ref/doc/uid/TP40008048-CH102-SW1)

![9h9cRg.png](https://s1.ax1x.com/2018/03/13/9h9cRg.png)

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
