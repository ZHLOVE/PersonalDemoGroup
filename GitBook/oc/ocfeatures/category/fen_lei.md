# 分类

##分类:可以为某个类增加一些额外的方法

```
@interface ViewController(HighClass)
- (void)run;
@end

@implementation ViewController(HighClass
- (void)run
{
    NSLog(@"run");
}
```

##类扩展(延展):可以为某个类增加一些额外属性和方法
可以放在.h和.m文件中

作用:存放类的私有属性
```objc
@interface ViewController()
- (void)run;
@end
```