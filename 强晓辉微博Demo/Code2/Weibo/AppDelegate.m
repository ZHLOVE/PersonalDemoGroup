//
//  AppDelegate.m
//  Weibo
//
//  Created by qiang on 4/21/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "AppDelegate.h"

#import "MainTabBarController.h"

#import "OAuthViewController.h"
#import "NewFeatureCollectionViewController.h"
#import "WelcomeViewController.h"
#import "UserAccount.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 1. 创建App窗体
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 2. 设置背景色为白色
    self.window.backgroundColor = [UIColor whiteColor];
    // 3. 创建MainTabBarController,作为窗体的根控制器
    self.window.rootViewController = [self defaultViewController];
    // 4. 设置为可见和设置为keyWindow(注:程序中可以有多个UIWindow对象,keyWidow是活跃的window，即和用户交互的window)
    [self.window makeKeyAndVisible];
    
    // 注册切换Root控制器通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchRootViewController:) name:kNotifiactionRootSwitchViewController object:nil];
    
    // 设置整体控件样式风格
    [self customApperance];
    
    return YES;
}

- (void)customApperance
{
    // 整体风格为橙色
    [UINavigationBar appearance].tintColor = [UIColor orangeColor];
    [UITabBar appearance].tintColor = [UIColor orangeColor];
}

- (void)dealloc
{
    // 注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 判断打开那个控制器
- (UIViewController *)defaultViewController
{
    // 是不是新版本?
    if([self isNewUpdate])
    {
        // 是新版本,则显示新特性页
        return [[NewFeatureCollectionViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    }
    else
    {
        // 判断有没有登录
        if([[UserAccount sharedUserAccount] isLogined])
        {
            // 已登录，显示欢迎页
            return [[WelcomeViewController alloc] init];
        }
        else
        {
            // 没登录,直接显示主TabBarController
            return  [[MainTabBarController alloc] init];
        }
    }
}

// 判断是不是新版本
- (BOOL)isNewUpdate
{
    // 得到当前版本信息
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    NSString *currentVersion = infoDict[@"CFBundleShortVersionString"];
    // 得到保存的版本信息
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundleShortVersionString"];
    
    if(lastVersion != nil && [lastVersion isEqualToString:currentVersion])
    {
        // 版本相同，不是新版本
        return NO;
    }
    
    // 版本不同,是新版本
    
    // 保存一下
    [[NSUserDefaults standardUserDefaults] setValue:currentVersion forKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    return YES;
}

- (void)switchRootViewController:(NSNotification *)n
{
//    n.object    谁发送的通知
//    n.userInfo  字典(通知的参数)
    
    NSDictionary *dict = n.userInfo;
    if([dict[@"VC"] isEqualToString:@"Main"])           // 直接指定跳转MainTabBarController
    {
        self.window.rootViewController = [[MainTabBarController alloc] init];
    }
    else if([dict[@"VC"] isEqualToString:@"Welcome"])   // 直接指定跳转WelcomeViewController
    {
        self.window.rootViewController = [[WelcomeViewController alloc] init];
    }
    else
    {
        self.window.rootViewController = [self defaultViewController];
    }
}
@end
