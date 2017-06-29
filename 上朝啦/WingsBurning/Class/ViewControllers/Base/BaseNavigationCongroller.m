//
//  BaseNavigationCongroller.m
//  WingsBurning
//
//  Created by MBP on 2016/11/8.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "BaseNavigationCongroller.h"
#define ratio  [UIScreen mainScreen].bounds.size.height / 667
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
@interface BaseNavigationCongroller ()

@end

@implementation BaseNavigationCongroller

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self.navigationBar setBackgroundImage:[UIImage makeImage:CGSizeMake(screenWidth, 64)]forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.tintColor = [UIColor whiteColor];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    [self.navigationBar setTitleTextAttributes:textAttrs];

    if (self.childViewControllers.count > 0) { // 非根控制器
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnPressed)];
        viewController.navigationItem.leftBarButtonItem = item;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)backBtnPressed
{
    [self popViewControllerAnimated:YES];
}

@end
