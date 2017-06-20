//
//  MainTabBarController.m
//  WeiBo
//
//  Created by student on 16/4/22.
//  Copyright © 2016年 BNG. All rights reserved.
//

#import "MainTabBarController.h"

#import "ProfileTableViewController.h"
#import "DiscoverTableViewController.h"
#import "MessageTableViewController.h"
#import "HomeTableViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1设置当前控制器下的tint颜色
    self.tabBar.tintColor = [UIColor orangeColor];
    //2添加子视图控制器
    [self addChildViewControllers];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //3添加中间按钮
    [self addComposeBtn];
}



- (void)addChildViewControllers{
    [self addChildViewController:[[HomeTableViewController alloc]init] title:@"首页" imageName:@"tabbar_home"];
    [self addChildViewController:[[MessageTableViewController alloc]init] title:@"消息" imageName:@"tabbar_message_center"];
    [self addChildViewController:[[HomeTableViewController alloc]init] title:@"" imageName:@""];
    [self addChildViewController:[[DiscoverTableViewController alloc]init] title:@"发现" imageName:@"tabbar_discover"];
    [self addChildViewController:[[ProfileTableViewController alloc]init] title:@"我" imageName:@"tabbar_profile"];
    // 改成读取JSON，根据数据创建视图控制器
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"MainVCSettings" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    
//    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//    
//    for(NSDictionary *dict in arr)
//    {
//        NSLog(@"%@ %@ %@",dict[@"vcName"],dict[@"title"],dict[@"imageName"]);
//        
//        [self addChildViewController:dict[@"vcName"] title:dict[@"title"] imageName:dict[@"imageName"]];
//        
//    }
}

//封装一下
- (void)addChildViewController:(UIViewController *)vc
                         title:(NSString *)title
                     imageName:(NSString *)imageName{
    
        //由类名===>对象
//    NSString *vcName = @"vcName";
//    UIViewController *vc = [[NSClassFromString(vcName) alloc]init];
    
    
    
    //图标
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:[imageName stringByAppendingString:@"_highlighted"]];
    //文字
    //    vc.tabBarItem.title = title;
    //把首页嵌入到一个导航栏控制器中
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
    vc.title = title;
    [self addChildViewController:navi];
}

- (void)addComposeBtn{
    UIButton *btn = [[UIButton alloc]init];
    //设置图片和大小
    [btn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
    int width = [UIScreen mainScreen].bounds.size.width/5;//按钮宽度
    btn.frame = CGRectMake(width*2, 0, width, 49);
    [btn addTarget:self action:@selector(composeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:btn];
}

- (void)composeBtnPressed{
    NSLog(@"被点击了");
}



@end
