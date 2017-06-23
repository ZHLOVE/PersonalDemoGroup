##RunLoop


###RunLoop资料
* 苹果官方文档

<https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Multithreading/RunLoopManagement/RunLoopManagement.html>



* CFRunLoopRef 是开源的

<http://opensource.apple.com/source/CF/CF-1151.16/>



###显示NSRunLoop信息
```
//1. 显示NSRunLoop信息

NSLog(@"%@",[NSRunLoop currentRunLoop]);// 当前线程的RunLoop
NSLog(@"%@",[NSRunLoop mainRunLoop]);// 主线程的RunLoop

CFRunLoopRef runLoopRef = CFRunLoopGetCurrent();// 当前线程的RunLoop
CFRunLoopRef mainRunLoopRef = CFRunLoopGetMain();// 主线程的RunLoop
NSLog(@"%@ %@",runLoopRef,mainRunLoopRef);

```

###运行模式 CFRunLoopModeRef

* kCFRunLoopDefaultMode：App的默认Mode，通常主线程是在这个Mode下运行
* UITrackingRunLoopMode：界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响
* UIInitializationRunLoopMode: 在刚启动 App 时第进入的第一个 Mode，启动完成后就不再使用
* GSEventReceiveRunLoopMode: 接受系统事件的内部 Mode，通常用不到
* kCFRunLoopCommonModes: 这是一个占位用的Mode，不是一种真正的Mode

###事件源 CFRunLoopRef

#####基于Source的分类
* Port-Based Sources 其他线程、系统内核发来的消息 (包含触摸事件)
* Custom Input Sources 自定义输入源
* Cocoa Perform Selector Sources (performSelector的方法

#####基于函数调用栈分类
* Source0:非基于Port
* Source1:基于Port的,通过内核和其他线程通信、接收、分发系统事件

###面试题
1. 什么是RunLoop?
	* 从字面看:运行循环、跑圈
	* 其实它内部是一个do-while循环,内部循环不断地处理各种任务(比如:Source0\Source1、Timer、Observer)
	* 一个线程对应一个RunLoop，主线程的RunLoop默认已启动,子线程RunLoop得手动启动(调用run方法)
	* RunLoop只能选择一个Mode启动,如果当前Mode中没有Source,Timer，那就直接退出

2. 自动释放池什么时候释放?
	* 通过Observer监听RunLoop的状态,一旦监听到RunLoop进入睡眠或者等待状态,就是自动释放池(kCFRunLoopBeforeWaiting)

###参考资料
iOS Runloop学习(易懂)
<http://www.cocoachina.com/ios/20160307/15590.html>

<http://blog.chinaunix.net/uid-24862988-id-3411921.html>
<http://www.hrchen.com/2013/06/multi-threading-programming-of-ios-part-1/>


###参考例子
hrchen's blogging的例子
<https://github.com/hrchen/ExamplesForBlog>
官方例子
<https://developer.apple.com/library/ios/samplecode/SimpleURLConnections/Listings/Read_Me_About_SimpleURLConnections_txt.html>