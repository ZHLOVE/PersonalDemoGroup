//
//  NewFeatureViewController.m
//  Weibo
//
//  Created by niit on 16/3/1.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "NewFeatureViewController.h"

#import "AppDelegate.h"

@interface NewFeatureViewController ()

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation NewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.scrollView addSubview:self.scrollViewContentView];
    self.scrollView.contentSize = CGSizeMake(320*4, 568);
    self.scrollView.pagingEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPressed:(id)sender
{
    UIApplication *app = [UIApplication sharedApplication];// 应用程序
    AppDelegate *appDelegate = app.delegate;// 应用程序的代理类对象
    
    // 方式1: 替换根视图
//    [appDelegate loadMainTabBar];
    
    // 方式2: 模态窗口方式弹出
    UITabBarController *tabBarController = [appDelegate mainTabBarController];
    [self presentViewController:tabBarController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
