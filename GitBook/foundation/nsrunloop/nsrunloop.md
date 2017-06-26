#NSRunLoop
##基本作用
* 保持程序的持续运行
* 处理App的各种事件(触摸事件、定时器事件、Selector事件)
* 节省CPU资源,提高程序性能:(改做事时做事,该休息休息)

##得到RunLoop(如果没有则会创建)

```objc
// 得到当前RunLoop
[NSRunLoop currentRunLoop];
// 得到主线程RunLoop
[NSRunLoop mainRunLoop];

// 得到当前RunLoop
CFRunLoopGetCurrent();
CFRunLoopGetMain();
```
##Core Foundation中关于RunLoop的5个类
* CFRunLoopRef
* CFRunLoopModeRef
* CFRunLoopSourceRef
* CFRunLoopTimerRef
* CFRunLoopObserverRef

##CFRunLoopModeRef
* kCFRunLoopDefaultMode
* UITrackingRunLoopMode
* UIInitializationRunLoopMode
* GSEventReceiveRunLoopMode
* kCFRunLoopCommonModes

##NSTimer与定时器

让定时器在scrollView滑动时和不滑动时都正常工作
```objc
NSTimer *t = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];    
// NSRunLoopCommonModes模式：UITrackingRunLoopMode和kCFRunLoopDefaultMode
[[NSRunLoop currentRunLoop] addTimer:t forMode:NSRunLoopCommonModes];;
```



##参考资料

* <http://www.cocoachina.com/ios/20150601/11970.html>
* <http://www.jianshu.com/p/613916eea37f>
* <http://blog.csdn.net/ztp800201/article/details/9240913>
* <http://www.jianshu.com/p/37ab0397fec7>
* <http://www.dreamingwish.com/frontui/article/default/ios-multithread-program-runloop-the.html>
* <http://mobile.51cto.com/iphone-386596.htm>