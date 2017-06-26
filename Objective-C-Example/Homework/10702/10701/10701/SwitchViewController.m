//
//  SwitchViewController.m
//  10701
//
//  Created by student on 16/2/22.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "SwitchViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"


@interface SwitchViewController ()

@property(nonatomic,strong) SecondViewController *secondVC;
@property(nonatomic,strong) ThirdViewController *thirdVC;
@end

@implementation SwitchViewController


// 懒加载 节省内存
// 重写getter方法
// 第一次用到的时候去创建它
- (SecondViewController *)secondVC
{
    if(_secondVC == nil)
    {
        _secondVC = [[SecondViewController alloc] init];
    }
    return _secondVC;
}

- (ThirdViewController *)thirdVC
{
    if(!_thirdVC)
    {
        _thirdVC = [[ThirdViewController alloc] init];
    }
    return _thirdVC;
}



- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)animationNextPage{
    // 动画效果 (UIView 简单切换动画)

    [UIView beginAnimations:@"ViewFlip" context:nil];
    [UIView setAnimationDuration:1.25];// 动画的时间
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];// 运动方式
    // 动画的样式
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [UIView commitAnimations];// 动画开始播放

}

- (void)animationLastPage{
    // 动画效果 (UIView 简单切换动画)
    
    [UIView beginAnimations:@"ViewFlip" context:nil];
    [UIView setAnimationDuration:1.25];// 动画的时间
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];// 运动方式
    // 动画的样式
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    [UIView commitAnimations];// 动画开始播放
    
}

- (IBAction)firstViewBtnPressed:(UIBarButtonItem *)sender {
    
}

- (IBAction)secondViewBtnPressed:(UIBarButtonItem *)sender {


//    [self.view addSubview:self.secondVC.view];
//    [self.view insertSubview:self.secondVC.view aboveSubview:self.view];
    [self animationNextPage];
}

- (IBAction)thirdViewBtnPressed:(UIBarButtonItem *)sender {
//    [self.view insertSubview:self.thirdVC.view aboveSubview:0];
    [self.view removeFromSuperview];
    [self animationLastPage];
}
@end
