//
//  AppDelegate.m
//  Weixin
//
//  Created by niit on 16/2/23.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AppDelegate.h"


#import "WeixinViewController.h"
#import "ContactsViewController.h"
#import "DiscoverViewController.h"
#import "MeViewController.h"

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 创建UITabBarController控制的子视图控制器
    WeixinViewController *weixinVC = [[WeixinViewController alloc] init];
    ContactsViewController *contactsVC = [[ContactsViewController alloc] init];
    DiscoverViewController *dicoverVC = [[DiscoverViewController alloc] init];
    MeViewController *meVC = [[MeViewController alloc] init];
    
    // 创建 UITabBarItem
    // 方式一:创建UITabBarItem,并赋值给试图控制器的.tabBarItem属性
//    - (instancetype)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image tag:(NSInteger)tag;
//    - (instancetype)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image selectedImage:(nullable UIImage *)selectedImage NS_AVAILABLE_IOS(7_0);
//    - (instancetype)initWithTabBarSystemItem:(UITabBarSystemItem)systemItem tag:(NSInteger)tag;
    //[[UITabBarItem alloc] initWithTitle:@"微信" image:[UIImage imageNamed:@"tabbar_mainframe"] tag:0];

//    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"微信" image:[UIImage imageNamed:@"tabbar_mainframe"] selectedImage:[UIImage imageNamed:@"tabbar_mainframeHL"]];
//    item.tag = 0;
////    UITabBarItem *item = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
//    weixinVC.tabBarItem = item;
    
    weixinVC.title = @"微信";
    // -> weixinVC.tabBarItem.title = @"微信";
    // -> weixinVC.navigationItem.title = @"微信";
    contactsVC.title = @"联系人";
    dicoverVC.title = @"发现";
    meVC.title = @"我";
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[weixinVC,contactsVC,dicoverVC,meVC];
    
    // 方式二:设置好tabBarController.viewControllers后,再修改标签项
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *item1 = tabBar.items[0];
    UITabBarItem *item2 = tabBar.items[1];
    UITabBarItem *item3 = tabBar.items[2];
    UITabBarItem *item4 = tabBar.items[3];
    
    item1.image = [[UIImage imageNamed:@"tabbar_mainframe"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
//    item1.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0); 调整位置
    item1.selectedImage = [[UIImage imageNamed:@"tabbar_mainframeHL"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"tabbar_contacts"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"tabbar_contactsHL"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"tabbar_discover"]imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [[UIImage imageNamed:@"tabbar_discoverHL"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    item4.image = [[UIImage imageNamed:@"tabbar_me"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    item4.selectedImage = [[UIImage imageNamed:@"tabbar_meHL"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];

    // 颜色(文字及图片)
    tabBarController.tabBar.tintColor = [UIColor greenColor];
//    tabBarController.tabBar.backgroundColor = [UIColor blackColor];
    
    // 当前的选中标签
//    tabBarController.selectedIndex = 3;// 初始选中的是我
    tabBarController.selectedViewController = meVC;
    
    // 右上角标
    item1.badgeValue = @"10";
    
    // 设置tabBarController的代理,有AppDelegate负责他相应代理时间
    tabBarController.delegate = self;
    
    self.window.rootViewController = tabBarController;
    
    return YES;
}

// UITabBarController的代理方法
#pragma mark - UITabBarControllerDelegate Method

// 将要切换到某个视图时触发的方法,返回NO，则禁止用户点那个标签项
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSLog(@"%s",__func__);
    if([viewController isKindOfClass:[MeViewController class]])
    {
        return NO;
    }
    return YES;
}

// 已经切换到某个标签栏
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"%s",__func__);
}

// 改变标签项
//- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
//{
//        NSLog(@"%s",__func__);
//}
//- (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers changed:(BOOL)changed
//{
//        NSLog(@"%s",__func__);
//}
//- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers changed:(BOOL)changed
//{
//        NSLog(@"%s",__func__);
//}

// 屏幕旋转相关
//- (UIInterfaceOrientationMask)tabBarControllerSupportedInterfaceOrientations:(UITabBarController *)tabBarController
//{
//    
//}
//- (UIInterfaceOrientation)tabBarControllerPreferredInterfaceOrientationForPresentation:(UITabBarController *)tabBarController
//{
//    
//}

// 自定义切换的动画
//- (nullable id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController
//                               interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController
//{
//    
//}
//- (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
//                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
//                                                       toViewController:(UIViewController *)toVC
//{
//    
//}

@end
