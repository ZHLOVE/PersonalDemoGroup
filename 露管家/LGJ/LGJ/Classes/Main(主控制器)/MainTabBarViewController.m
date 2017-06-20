//
//  MainTabBarViewController.m
//  Hospital_PTX
//
//  Created by 马千里 on 16/5/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  添加子视图控制器
    [self addChildViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 添加子视图控制器
- (void)addChildViewControllers
{
    // 改成读取JSON,根据JSON数据动态创建视图控制器
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MainVCSettings" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data != nil) {
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        for (NSDictionary *dict in arr) {
            [self addChildViewController:dict[@"vcName"] title:dict[@"title"] imageName:dict[@"imageName"]];
        }
    }else{
//        [self addChildViewController:@"HosViewController" title:@"医院" imageName:nil];
//        [self addChildViewController:@"OtherViewController" title:@"其他" imageName:nil];
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
        vc.tabBarItem.title = title;
    // 3. 将其嵌入到一个导航栏控制器中
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    // 4. 设置导航栏上的标题
//    if ([title isEqualToString:@"城市"]) {
//        vc.navigationItem.title = @"莆田系民营医院所在城市";
//    }else{
        // 注: 2. 和 4. 如果一样的，可以用以下一行替代
        vc.title = title;
//    }
    // 5. 将导航栏控制器添加到tabBarController
    [self addChildViewController:navi];
}


@end
