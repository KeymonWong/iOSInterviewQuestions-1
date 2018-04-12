
options所包括的内容:

  NSKeyValueObservingOptionNew：change字典包括改变后的值
  NSKeyValueObservingOptionOld:   change字典包括改变前的值
  NSKeyValueObservingOptionInitial:注册后立刻触发KVO通知
  NSKeyValueObservingOptionPrior:值改变前是否也要通知（这个key决定了是否在改变前改变后通知两次）

## 注意点

### KVO和Context
由于Context通常用来区分不同的KVO，所以context的唯一性很重要。通常，我的使用方式是通过在当前.m文件里用静态变量定义。
static void * privateContext = 0;
### KVO与线程
KVO的响应和KVO观察的值变化是在一个线程上的，所以，大多数时候，不要把KVO与多线程混合起来。除非能够保证所有的观察者都能线程安全的处理KVO
### KVO监听变化的值
改变前和改变后分别为
id oldValue = change[NSKeyValueChangeOldKey];
id newValue = change[NSKeyValueChangeNewKey];


## 底层原理

编译器是怎么完成监听这个任务的呢？先来看看苹果文档对于KVO的实现描述：
`Automatic key-value observing is implemented using a technique called isa-swizzling... When an observer is registered for an attribute of an object the isa pointer of the observed object is modified, pointing to an intermediate class rather than at the true class ..
`

简要的来说，在我们对某个对象完成监听的注册后，编译器会修改监听对象的isa指针，让这个指针指向一个新生成的中间类。

```objc
typedef struct objc_class *Class;
typedef struct objc_object {
   Class isa;
} *id;
```

isa是一个Class类型的指针，对象的首地址一般是isa变量，同时isa又保存了对象的类对象的首地址。我们通过object_getClass方法来获取这个对象的元类，即是对象的类对象的类型(正常来说，class方法内部的实现就是获取这个isa保存的对象的类型，在kvo的实现中苹果对被监听对象的class方法进行了重写隐藏了实现)。class方法是获得对象的类型，虽然这两个返回的结果是一样的，但是两个方法在本质上得到的结果不是同一个东西。
在oc中，规定了只要拥有isa指针的变量，通通都属于对象。上面的objc_object表示的是NSObject这个类的结构体表示，因此oc不允许出现非NSObject子类的对象（block是一个特殊的例外）*
当然了，苹果并不想讲述更多的实现细节，但是我们可以通过运行时机制来完成一些有趣的调试。

每一个对象占用的内存中，一部分是父类属性占用的；在父类占用的内存中，又有一部分是父类的父类占用的。前文已经说过isa指针指向的是父类，因此在这个图中，Son的地址从Father开始，Father的地址从NSObject开始，这三个对象内存的地址都是一样的。通过这个，我们可以猜到苹果文档中所提及的中间类就是被监听对象的子类。并且为了隐藏实现，苹果还重写了这个子类的class方法跟description方法来掩人耳目。另外，我们还看到了新类相对于父类添加了一个NSKVONotifying_前缀，添加这个前缀是为了避免多次创建监听子类，节省资源

这里说明一下isa这个指针， isa是一个指向Class类指针（专业术语是指向元类，pointer to the metaclass），用来指向类的类型，我们可以通过object_getClass方法来获取这个值； 正常来说，class方法内部的实现就是获取这个isa指针代表的元类（metaclass），但在kvo机制中苹果注册监听对象后 通过objc_allocateClassPair动态重新创建了一个新类和元类，此时object_getClass()获取的事就不是原来isa指向的元类 而是是新建的元类 参见苹果文档：Creates a new class and metaclass.You can get a pointer to the new metaclass by calling object_getClass(newClass)）。


## 怎么实现类似效果

既然知道了苹果的实现过程，那么我们可以自己动手通过运行时机制来实现KVO。runtime允许我们在程序运行时动态的创建新类、拓展方法、method-swizzling、绑定属性等等这些有趣的事情。
在创建新类之前，我们应该学习苹果的做法，判断当前是否存在这个类，如果不存在我们再进行创建，并且重新实现这个新类的class方法来掩盖具体实现。基于这些原则，我们用下面的方法来获取新类

```objc

- (Class)createKVOClassWithOriginalClassName:(NSString * )className{

    NSString * kvoClassName = [kYJKvoClassPrefix stringByAppendingString:className];
    Class observedClass = NSClassFromString(kvoClassName);
    if (observedClass) { return observedClass; }

    //创建新类，并且添加Observer_为类名新前缀
    Class originalClass = object_getClass(self);
    Class kvoClass = objc_allocateClassPair(originalClass, kvoClassName.UTF8String, 0);

    //获取监听对象的class方法实现代码，然后替换新建类的class实现
    Method classMethod = class_getInstanceMethod(originalClass, @selector(class));
    const char * types = method_getTypeEncoding(classMethod);
    class_addMethod(kvoClass, @selector(class), (IMP)kvo_Class, types);
    objc_registerClassPair(kvoClass);
    return kvoClass;
}
```

另外，在判断是否需要中间类来完成监听的注册前，我们还要判断监听的属性的有效性。通过获取变量的setter方法名（将首字母大写并加上前缀set），以此来获取setter实现，如果不存在实现代码，则抛出异常使程序崩溃。

```objc
SEL setterSelector = NSSelectorFromString(setterForGetter(key));
Method setterMethod = class_getInstanceMethod([self class], setterSelector);
if (!setterMethod) {
    @throw [NSException exceptionWithName: NSInvalidArgumentException reason: [NSString stringWithFormat: @"unrecognized selector sent to instance %p", self] userInfo: nil];
    return;
}
Class observedClass = object_getClass(self);
NSString * className = NSStringFromClass(observedClass);

//如果被监听者没有Observer_，那么判断是否需要创建新类
if (![className hasPrefix: kYJKvoClassPrefix]) {
    observedClass = [self createKVOClassWithOriginalClassName: className];
    object_setClass(self, observedClass);
}
//重新实现setter方法，使其完成
const char * types = method_getTypeEncoding(setterMethod);
class_addMethod(observedClass, setterSelector, (IMP)KVO_setter, types);
```

在重新实现setter方法的时候，有两个重要的方法：willChangeValueForKey和didChangeValueForKey，分别在赋值前后进行调用。此外，还要遍历所有的回调监听者，然后通知这些监听者：

```objc
static void KVO_setter(id self, SEL _cmd, id newValue){
    NSString * setterName = NSStringFromSelector(_cmd);
    NSString * getterName = getterForSetter(setterName);
    if (!getterName) {
        @throw [NSException exceptionWithName: NSInvalidArgumentException reason: [NSString stringWithFormat: @"unrecognized selector sent to instance %p", self] userInfo: nil];
        return;
    }

    id oldValue = [self valueForKey: getterName];
    struct objc_super superClass = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };

    [self willChangeValueForKey: getterName];
    void (*objc_msgSendSuperKVO)(void *, SEL, id) = (void *)objc_msgSendSuper;
    objc_msgSendSuperKVO(&superClass, _cmd, newValue);
    [self didChangeValueForKey: getterName];

    //获取所有监听回调对象进行回调
    NSMutableArray * observers = objc_getAssociatedObject(self, (__bridge const void *)kLXDkvoAssiociateObserver);
    for (LXD_ObserverInfo * info in observers) {
        if ([info.key isEqualToString: getterName]) {        
            dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            info.handler(self, getterName, oldValue, newValue);
            });
        }
    }
}
```

所有的监听者通过动态绑定的方式将其存储起来，但这样也会产生强引用，所以我们还需要提供释放监听的方法：

```objc
- (void)LXD_removeObserver:(NSObject *)object forKey:(NSString *)key
{
    NSMutableArray * observers = objc_getAssociatedObject(self, (__bridge void *)kLXDkvoAssiociateObserver);

    LXD_ObserverInfo * observerRemoved = nil;
    for (LXD_ObserverInfo * observerInfo in observers) {

        if (observerInfo.observer == object && [observerInfo.key isEqualToString: key]) {

            observerRemoved = observerInfo;
            break;
        }
    }
    [observers removeObject: observerRemoved];
}
```
使用target-action或者block的方式进行回调会比单一的系统回调要全面的多。但kvo真正的实现并没有这么简单，上述代码目前只能实现对象类型的监听，基本类型无法监听，况且还有keyPath可以监听对象的成员对象的属性这种更强大的功能。

## 尾言
对于基本类型的监听，苹果可能是通过void *类型对对象进行桥接转换，然后直接获取内存，通过type encoding我们可以获取所有setter对象的具体类型，虽然实现比较麻烦，但是确实能够达成类似的效果。
钻研kvo的实现可以让我们对苹果的代码实现有更深层次的了解，这些知识涉及到了更深层次的技术，探究它们对我们的开发视野有着很重要的作用。同时，对比其他的回调方式，KVO的实现在创建子类、重写方法等等方面的内存消耗是很巨大的，因此博主更加推荐使用delegate、block等回调方式，甚至直接使用method-swizzling来替换这种重写setter方式也是可行的。
ps:昨天有人问我说为什么kvo不直接通过重写setter方法的方式来进行回调，而要创建一个中间类。诚然，method_swizzling是一个很赞的机制，完全能用它来满足监听需求。但是，如果我们要监听的对象是tableView呢？正常而言，一款应用中远不止一个列表，使用method_swizzling会导致所有的列表都添加了监听回调，先不考虑这可能导致的崩溃风险，所有继承自tableView的视图（包括自身）的setter都受到了影响。而使用中间类却避免了这个问题


另外备注下［self class］和object_getClass(self)可是不一样的，具体什么不一样参考：http://stackoverflow.com/questions/15906130/object-getclassobj-and-obj-class-give-different-results（一个返回的是类，一个是实例，能一样吗？）
