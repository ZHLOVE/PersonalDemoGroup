# 视图与视图控制器

## 视图控制器的生命周期
![](http://www.qiangtech.com/blog/wp-content/uploads/2016/01/8d84abd5b75e46c4ebff93d364b7805d.jpg)

当一个视图控制器被创建，并在屏幕上显示的时候。 代码的执行顺序

| 流程 | 语句 | 功能 |
|-|-|-|
|1|alloc|创建对象，分配空间|
|2|init(initWithNibName)|初始化对象，初始化数据|
|3|loadView|从nib载入视图，通常这一步不需要去干涉。除非你没有使用xib文件创建视图|
|4|viewDidLoad|载入完成，可以进行自定义数据以及动态创建其他控件|
|5|viewWillAppear|视图将出现在屏幕之前，马上这个视图就会被展现在屏幕上了|
|6|viewDidAppear|视图已在屏幕上渲染完成|

![](http://www.qiangtech.com/blog/wp-content/uploads/2016/01/20130502070330644.jpg)

当一个视图被移除屏幕并且销毁的时候的执行顺序，这个顺序差不多和上面的相反

| 流程 | 语句 | 功能 |
|-|-|-|
|1|viewWillDisappear|视图将被从屏幕上移除之前执行|
|2|viewDidDisappear|视图已经被从屏幕上移除，用户看不到这个视图了
|3|dealloc|视图被销毁，此处需要对你在init和viewDidLoad中创建的对象进行释放|

![](http://www.qiangtech.com/blog/wp-content/uploads/2016/01/2012030520380054.jpg)

关于viewDidUnload ：在发生内存警告的时候如果本视图不是当前屏幕上正在显示的视图的话，  viewDidUnload将会被执行，本视图的所有子视图将被销毁，以释放内存,此时开发者需要手动对viewLoad、viewDidLoad中创建 的对象释放内存。 因为当这个视图再次显示在屏幕上的时候，viewLoad、viewDidLoad 再次被调用，以便再次构造视图。


参考:<http://www.xcoder.cn/?p=650>



## 一个控件看不见有哪些可能？
- 宽度或者高度其实为0
- 位置不对（比如是个负数或者超大的数，已经超出屏幕）
- hidden == YES
- alpha <= 0.01
- 没有设置背景色、没有设置内容
- 可能是文字颜色和背景色一样