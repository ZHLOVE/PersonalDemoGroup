//
//  MainTabBarController.m
//  Weibo
//
//  Created by qiang on 4/22/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "MainTabBarController.h"

#import "ProfileViewController.h"
#import "DiscoverViewController.h"
#import "MessageViewController.h"
#import "HomeViewController.h"

@implementation MainTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1. 设置当前控制器下的tabBar的颜色
    self.tabBar.tintColor = [UIColor orangeColor];

    // 2. 添加子视图控制器
    [self addChildViewControllers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 3. 添加中间按钮
    [self addComposeBtn];
}

// 添加子视图控制器
- (void)addChildViewControllers
{
    // 改成读取JSON,根据JSON数据动态创建视图控制器
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MainVCSettings" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if(data != nil)
    {
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        for(NSDictionary *dict in arr)
        {
            [self addChildViewController:dict[@"vcName"] title:dict[@"title"] imageName:dict[@"imageName"]];
        }
    }
    else
    {
        [self addChildViewController:@"HomeViewController" title:@"首页" imageName:@"tabbar_home"];
        [self addChildViewController:@"MessageViewController" title:@"消息" imageName:@"tabbar_message_center"];
        [self addChildViewController:@"UIViewController" title:@"" imageName:@""];
        [self addChildViewController:@"DiscoverViewController" title:@"发现" imageName:@"tabbar_discover"];
        [self addChildViewController:@"ProfileViewController" title:@"我" imageName:@"tabbar_profile"];
    }
    
}

// 封装
- (void)addChildViewController:(NSString *)vcName
                         title:(NSString *)title
                     imageName:(NSString *)imageName
{
    
    // 1. 根据类名字符串创建对象
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];

    // 2. 设置其tabbarItem上的图标
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:[imageName stringByAppendingString:@"_highlighted"]];
    // 2. 设置其tabbarItem上的文字
//    vc.tabBarItem.title = title;
    // 3. 将其嵌入到一个导航栏控制器中
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    // 4. 设置导航栏上的标题
//    vc.navigationItem.title = title;
    // 注: 2. 和 4. 如果一样的，可以用以下一行替代
    vc.title = title;

    // 5. 将导航栏控制器添加到tabBarController
    [self addChildViewController:navi];
}

// 添加中间的按钮
- (void)addComposeBtn
{
    UIButton *btn = [[UIButton alloc] init];
    // 1. 图片
    [btn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    // 2. 背景图片
    [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
    // 3. 设置尺寸位置
    int width = [UIScreen mainScreen].bounds.size.width / self.viewControllers.count;// 按钮宽度 = 屏幕宽度 / TabBar按钮数量
    btn.frame = CGRectMake(width * 2 , 0, width, 49);
    // 4. 为按钮添加事件处理
    [btn addTarget:self action:@selector(composeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    // 5. 添加到 tabbar上
    [self.tabBar addSubview:btn];
}

#pragma mark - 控件事件处理
- (void)composeBtnPressed
{
    NSLog(@"%s",__func__);
}

@end
