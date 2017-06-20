//
//  AppDelegate.m
//  HelloWorld
//
//  Created by niit on 16/1/28.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarViewController.h"
#import "DataBase.h"
#import "def.h"

// 两个对象
// 1 应用程序
// 2 应用程序代理类对象 AppDelegate

@interface AppDelegate ()

@end

@implementation AppDelegate

// 常用的代理方法
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[MainTabBarViewController alloc] init];
    [self.window makeKeyAndVisible];
    [self isNewUpdate];
    return YES;
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
        [DataBase openDB];
        return NO;
    }
    // 版本不同,是新版本
    // 保存一下
    //创建数据库
    [DataBase createDataBase];
    //初始化测试数据
    [self insertData];
    [[NSUserDefaults standardUserDefaults] setValue:currentVersion forKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

//插入初始数据
- (void)insertData{
   
    [self insertImageWith:@"淡奶油"];
    [self insertImageWith:@"蛋糕粉"];
    [self insertImageWith:@"红豆"];
    [self insertImageWith:@"黄油"];
    [self insertImageWith:@"绿豆"];
    [self insertImageWith:@"面粉"];
    [self insertImageWith:@"抹茶"];
    [self insertImageWith:@"奶酪"];
    
    [DataBase insertDataWithName:@"淡奶油" andImgName:@"淡奶油" andCount:@"2" andDayFrom:@"2016-02-11" andDayTo:@"2016-05-17" andType:@"烘焙"];
    [DataBase insertDataWithName:@"蛋糕粉" andImgName:@"蛋糕粉" andCount:@"2" andDayFrom:@"2016-02-11" andDayTo:@"2016-05-17" andType:@"烘焙"];
    [DataBase insertDataWithName:@"红豆" andImgName:@"红豆" andCount:@"2" andDayFrom:@"2016-02-11" andDayTo:@"2016-05-17" andType:@"烘焙"];
    [DataBase insertDataWithName:@"黄油" andImgName:@"黄油" andCount:@"2" andDayFrom:@"2016-02-11" andDayTo:@"2016-05-17" andType:@"烘焙"];
    [DataBase insertDataWithName:@"绿豆" andImgName:@"绿豆" andCount:@"2" andDayFrom:@"2016-02-11" andDayTo:@"2016-05-17" andType:@"烘焙"];
    [DataBase insertDataWithName:@"面粉" andImgName:@"面粉" andCount:@"2" andDayFrom:@"2016-02-11" andDayTo:@"2016-05-17" andType:@"烘焙"];
    [DataBase insertDataWithName:@"抹茶" andImgName:@"抹茶" andCount:@"2" andDayFrom:@"2016-02-11" andDayTo:@"2016-05-17" andType:@"烘焙"];
    [DataBase insertDataWithName:@"奶酪" andImgName:@"奶酪" andCount:@"2" andDayFrom:@"2016-02-11" andDayTo:@"2016-05-17" andType:@"烘焙"];
}

//插入初始图片到沙盒
- (void)insertImageWith:(NSString *)imgStr{
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:imgStr], 0.8);
    NSString *imagePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imgStr];
    [imageData writeToFile:imagePath atomically:NO];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
//    DLog(@"程序要进入暂停状态");
    
    // 1 暂停正在执行的任务
    // 2 暂停定时器
    // 3 降低OpenGL帧率
    // 4 暂停游戏
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//    DLog(@"程序已经进入后台状态");
    
    // 1 释放共享资源
    // 2 存储状态
    // 3 要支持后台运行，这里要写相应代码
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
//    DLog(@"程序将要进入前台");
    // 恢复之前程序的运行
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
//    DLog(@"程序已经进入重新激活状态");
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
//    DLog(@"程序将要退出");
    
    // 保存设置和状态
}

@end
