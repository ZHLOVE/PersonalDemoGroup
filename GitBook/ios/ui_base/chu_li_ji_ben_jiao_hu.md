# 处理基本交互

##1 Storyboard

#### 常见错误

1. Storyboard没有指定起始页面会提示以下错误:

```
2016-01-28 14:35:06.205 HelloWorld[46615:6660268] Failed to instantiate the default view controller for UIMainStoryboardFile 'Main' - perhaps the designated entry point is not set?
```

2 删除了链接的IBOutlet属性,但是Storyboard没有删除连线

```
2016-01-28 15:20:43.321 HelloWorld[49958:7494446] *** Terminating app due to uncaught exception 'NSUnknownKeyException', reason: '[<ViewController 0x7ff1d8c54b60> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key label.'
*** First throw call stack:
```


##IBAction和IBOutlet
* IBAction
	* 本质就是void
	* 能让方法具备连线的功能
* IBOutlet 
	* 能让属性具备连线的功能
	
##storyboard连线容易出现的问题
* 连接的方法被删掉，但是连线没有去掉
	* 会出现方法找不到的错误 unrecognized selector sent to instance
* 连接的属性被删掉，但是连线没有去掉
	* setValue:forUndefinedKey: this class is not key value coding-compliant for the key
	
##UIViewController(控制器)的认识
* 一个控制器控制一个界面(视图)
* 控制器负责界面的创建、事件处理等
