# 创建基本项目

##1 程序启动流程
1. 从main()启动
2. 执行UIApplicationMain()函数
    1. 创建应用程序类对象(UIApplication)
    2. 创建应用程序代理类对象(AppDelegate),并设置为应用程序类对象的代理
3. 如果设置了Main Interface
    1. 创建应用窗体(UIWindow)
    2. 从Storyboard起始页面创建视图控制器对象，
    3. 将控制器作为应用窗体的根控制器，这样视图控制器控制的视图就会加载到窗体上

##2 iPhone程序的生命周期(见子页)

##3 UIApplication
得到应用程序对象的方法:


```objc
UIApplication *app = [UIApplication sharedApplication];

```


##4 AppDelegate

得到应用程序代理类对象的方法:
```objc
UIApplication *app = [UIApplication sharedApplication];
AppDelegate *appDelegate = app.delegate;

```

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

##storyboard文件的认识
* 用来描述软件界面
* 默认情况下,程序一旦启动就会加载Main.storyboard
* 记载storyboard时,会首先创建和显示箭头所指的控制器界面
