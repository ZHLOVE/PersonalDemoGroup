//
//  ViewController.m
//  HelloWorld
//
//  Created by niit on 16/1/28.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "AppDelegate.h"

// 程序中对象
// 1. 应用程序对象      UIApplication类
// 2. 应用程序代理类对象 AppDelegate类(继承自UIResponder,实现<UIApplicationDelegate>协议)
// 3. 窗口对象         UIWindow类
// 4. 视图控制器对象    ViewController类(继承自UIViewControl)
// 5. 视图对象         UIView类
// 6. 文本标签对象      UILabel类

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 1. 得到应用程序对象的方法
    UIApplication *app = [UIApplication sharedApplication];
    NSLog(@"%@",app);
    
    // 2. 得到AppDelegate对象的方法
    AppDelegate *appDelegate = app.delegate;
    NSLog(@"%@",appDelegate);
    
    // 3. 得到UIWindow对象的方法
    UIWindow *window = [app keyWindow];// 得到当前应用程序的主窗口
    NSLog(@"%@",window);
    NSLog(@"%@",appDelegate.window);
    
    // 4. 当前window的根控制器
    NSLog(@"%@",window.rootViewController);
    NSLog(@"%@",self);
    
#pragma mark - UIApplication的属性和方法
    
#pragma mark 1. applicationIconBadgeNumber 程序提醒数字
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 8.0)
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    app.applicationIconBadgeNumber=12;
    
#pragma mark 2. networkActivityIndicatorVisible 联网无状态指示
    app.networkActivityIndicatorVisible = YES;
    
#pragma mark 3. 管理状态栏
    // 设置程序使用UIApplication管理状态栏:
    // Info.plist中添加View controller-based status bar appearance 设置为 NO
    
    // 隐藏状态栏
    //    app.statusBarHidden = YES;
    // 状态栏样式
    //    [app setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    // 隐藏
    //    [app setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
#pragma mark 4. 打开其他应用
    //    [app openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    
#pragma mark 5. 支持摇动手势
    //    app.applicationSupportsShakeToEdit = YES;// ╮(╯_╰)╭ 现在好像没作用了?
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 运动事件结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if(event.subtype == UIEventSubtypeMotionShake)
    {
        self.view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:arc4random()%255/255.0];
    }
}


@end
