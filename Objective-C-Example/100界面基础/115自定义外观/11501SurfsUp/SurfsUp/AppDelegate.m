//
//  AppDelegate.m
//  SurfsUp
//
//  Created by niit on 16/3/10.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // 修改类的样式
    [self customizeApperacne];
    
    return YES;
}

- (void)customizeApperacne
{

//    UIImage *minImage = [[UIImage imageNamed:@"slider_minimum"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//    UIImage *maxImage = [[UIImage imageNamed:@"slider_maximum"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
//    UIImage *thumbImage = [UIImage imageNamed:@"thumb"];
//    
//    [[UISlider appearance] setMinimumTrackImage:minImage forState:UIControlStateNormal];
//    [[UISlider appearance] setMaximumTrackImage:maxImage forState:UIControlStateNormal];
//    [[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateNormal];
    
    
    //竖屏
    UIImage *image44 = [[UIImage imageNamed:@"surf_gradient_textured_44"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UINavigationBar appearance] setBackgroundImage:image44 forBarMetrics:UIBarMetricsDefault];
    
    //横屏
    UIImage *gradientImage32 = [[UIImage imageNamed:@"surf_gradient_textured_32"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UINavigationBar appearance] setBackgroundImage:gradientImage32
                                       forBarMetrics:UIBarMetricsLandscapePhone];
    
    //导航栏底部阴影图片
    //    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"navBarShadow"]];
    
    
    UIImage *button30 = [[UIImage imageNamed:@"button_textured_30"]
                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *button24 = [[UIImage imageNamed:@"button_textured_24"]
                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [[UIBarButtonItem appearance] setBackgroundImage:button30 forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:button24 forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsLandscapePhone];
    
    //设置导航栏右按钮字体样式
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor],UITextAttributeTextColor,[UIFont fontWithName:@"AmericanTypewriter" size:0.0],UITextAttributeFont, nil] forState:UIControlStateNormal];
    
    //设置导航栏返回按钮样式
    UIImage *buttonBack30 = [[UIImage imageNamed:@"button_back_textured_30"]
                             resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
    UIImage *buttonBack24 = [[UIImage imageNamed:@"button_back_textured_24"]
                             resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 5)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:buttonBack30
                                                      forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:buttonBack24
                                                      forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
    
    //设置Tab的样式
    UIImage *tabBackground = [[UIImage imageNamed:@"tab_bg"]
                              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UITabBar appearance] setBackgroundImage:tabBackground];
    [[UITabBar appearance] setSelectionIndicatorImage:
     [UIImage imageNamed:@"tab_select_indicator"]];
    
    //自定义UISegmentControl
    UIImage *segmentSelected =
    [[UIImage imageNamed:@"segcontrol_sel.png"]
     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    UIImage *segmentUnselected =
    [[UIImage imageNamed:@"segcontrol_uns.png"]
     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    UIImage *segmentSelectedUnselected =
    [UIImage imageNamed:@"segcontrol_sel-uns.png"];
    UIImage *segUnselectedSelected =
    [UIImage imageNamed:@"segcontrol_uns-sel.png"];
    UIImage *segmentUnselectedUnselected =
    [UIImage imageNamed:@"segcontrol_uns-uns.png"];
    
    [[UISegmentedControl appearance] setBackgroundImage:segmentUnselected
                                               forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setBackgroundImage:segmentSelected
                                               forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setDividerImage:segmentUnselectedUnselected
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:segmentSelectedUnselected
                                 forLeftSegmentState:UIControlStateSelected
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance]
     setDividerImage:segUnselectedSelected
     forLeftSegmentState:UIControlStateNormal
     rightSegmentState:UIControlStateSelected
     barMetrics:UIBarMetricsDefault];
    
    
    //自定义UISwitch
    [[UISwitch appearance] setOnTintColor:[UIColor colorWithRed:0 green:175.0/255.0 blue:176.0/255.0 alpha:1.0]];
    [[UISwitch appearance] setTintColor:[UIColor colorWithRed:1.000 green:0.989 blue:0.753 alpha:1.000]];
    [[UISwitch appearance] setThumbTintColor:[UIColor yellowColor]];
    
    [[UISwitch appearance] setOnImage:[UIImage imageNamed:@"yesSwitch"]];
    [[UISwitch appearance] setOffImage:[UIImage imageNamed:@"noSwitch"]];
    
    //自定义UIStepper
    [[UIStepper appearance] setTintColor:[UIColor colorWithRed:0 green:175.0/255.0 blue:176.0/255.0 alpha:1.0]];
    [[UIStepper appearance] setIncrementImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    [[UIStepper appearance] setDecrementImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    
    //自定义UIProgressView
    [[UIProgressView appearance] setProgressTintColor:[UIColor colorWithRed:0 green:175.0/255.0 blue:176.0/255.0 alpha:1.0]];
    [[UIProgressView appearance] setTrackTintColor:[UIColor colorWithRed:0.996 green:0.788 blue:0.180 alpha:1.000]];
    
    //自定义UIPageControl
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:[UIColor colorWithRed:0 green:175.0/255.0 blue:176.0/255.0 alpha:1.0]];
    [[UIPageControl appearance] setPageIndicatorTintColor:[UIColor colorWithRed:0.996 green:0.788 blue:0.180 alpha:1.000]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
