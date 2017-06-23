//
//  AppDelegate.m
//  MyParse
//
//  Created by niit on 16/4/20.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AppDelegate.h"

#import "MMDrawerController.h"
#import "MainViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    if([d boolForKey:@"logined"])
    {
        [self loadMainController];
    }
    else
    {
        [self loadLoginController];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)loadLoginController
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginVC = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
    UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    self.window.rootViewController = loginNavi;

}

- (void)loadMainController
{
    // 主视图控制器
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController *mainVC = [sb instantiateViewControllerWithIdentifier:@"MainViewController"];
    UINavigationController *mainNavi = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    // 左菜单视图控制器
    LeftViewController *leftVC = [sb instantiateViewControllerWithIdentifier:@"LeftViewController"];
    UINavigationController *leftNavi = [[UINavigationController alloc] initWithRootViewController:leftVC];
    
    // 右侧视图控制器
    RightViewController *rightVC = [sb instantiateViewControllerWithIdentifier:@"RightViewController"];
    UINavigationController *rightNavi = [[UINavigationController alloc] initWithRootViewController:rightVC];
    
    // 侧滑控制器
    MMDrawerController *drawController = [[MMDrawerController alloc] initWithCenterViewController:mainNavi leftDrawerViewController:leftNavi rightDrawerViewController:rightNavi];
    // 设置打开关闭手势类型
    drawController.openDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView ;
    drawController.closeDrawerGestureModeMask = MMCloseDrawerGestureModePanningCenterView;
    
    //MMOpenDrawerGestureMode:
    //MMOpenDrawerGestureModePanningNavigationBar: The user can open the drawer by panning anywhere on the navigation bar.
    //MMOpenDrawerGestureModePanningCenterView: The user can open the drawer by panning anywhere on the center view.
    //MMOpenDrawerGestureModeBezelPanningCenterView: The user can open the drawer by starting a pan anywhere within 20 points of the bezel.
    //MMOpenDrawerGestureModeCustom: The developer can provide a callback block to determine if the gesture should be recognized. More information below.
    //MMCloseDrawerGestureMode:
    //MMCloseDrawerGestureModePanningNavigationBar: The user can close the drawer by panning anywhere on the navigation bar.
    //MMCloseDrawerGestureModePanningCenterView: The user can close the drawer by panning anywhere on the center view.
    //MMCloseDrawerGestureModeBezelPanningCenterView: The user can close the drawer by starting a pan anywhere within the bezel of the center view.
    //MMCloseDrawerGestureModeTapNavigationBar: The user can close the drawer by tapping the navigation bar.
    //MMCloseDrawerGestureModeTapCenterView: The user can close the drawer by tapping the center view.
    //MMCloseDrawerGestureModePanningDrawerView: The user can close the drawer by panning anywhere on the drawer view.
    //MMCloseDrawerGestureModeCustom: The developer can provide a callback block to determine if the gesture should be recognized. More information below.
    
    self.window.rootViewController = drawController;
}


@end
