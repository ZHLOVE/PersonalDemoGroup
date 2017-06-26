# 160128星期四

##  1 文档
#####1. 使用GitBox下载
https://git.oschina.net/ruik2080/Apple-Development-Handbook.git
下载时，注意下载到目录的位置

#####2. 打开gitBook的软件
(这是一个编辑文档的工具)
(注册一下https://www.gitbook.com，可用github.com账号)

#####3. 导入
gitBook里点import导入刚才下载的目录

## 2 程序启动流程
1. 从main()启动
2. 执行UIApplicationMain()函数
    1. 创建应用程序类对象(UIApplication)
    2. 创建应用程序代理类对象(AppDelegate),并设置为应用程序类对象的代理
3. 如果设置了Main Interface
    1. 创建应用窗体(UIWindow)
    2. 从Storyboard起始页面创建视图控制器对象，
    3. 将控制器作为应用窗体的根控制器，这样视图控制器控制的视图就会加载到窗体上

## 3 AppDelegate 应用程序代理类
应用程序代理类对象负责处理应用程序生命周期里的各种事件


```objc
@implementation AppDelegate

// 常用的代理方法
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@"程序已经完成载入");
    
    // 我们可以在这里:
    // 1 自定义设置
    // 2 载入界面
    // 3 读取用户配置信息
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    NSLog(@"程序要进入暂停状态");
    
    // 1 暂停正在执行的任务
    // 2 暂停定时器
    // 3 降低OpenGL帧率
    // 4 暂停游戏
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"程序已经进入后台状态");
    
    // 1 释放共享资源
    // 2 存储状态
    // 3 要支持后台运行，这里要写相应代码
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"程序将要进入前台");
    // 恢复之前程序的运行
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"程序已经进入重新激活状态");
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSLog(@"程序将要退出");
    
    // 保存设置和状态
}

@end
```

## 4 Storyboard
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