//
//  SwitchViewController.m
//  SwitchView
//
//  Created by niit on 16/2/22.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "SwitchViewController.h"

#import "BlueViewController.h"
#import "YellowViewController.h"

@interface SwitchViewController ()


@property (nonatomic,strong) BlueViewController *blueVC;
@property (nonatomic,strong) YellowViewController *yellowVC;

@property (nonatomic,assign) BOOL curBlue;

@end

@implementation SwitchViewController

// 懒加载 节省内存
// 重写getter方法
// 第一次用到这个对象时候去创建这个对象，如果始终没用到这个对象,则不会创建,节省了内存
- (BlueViewController *)blueVC
{
    if(_blueVC == nil)
    {
        _blueVC = [[BlueViewController alloc] init];
    }
    return _blueVC;
}

- (YellowViewController *)yellowVC
{
    if(!_yellowVC)
    {
        _yellowVC = [[YellowViewController alloc] init];
    }
    return _yellowVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // 采用懒加载，以下两行删除
//    self.blueVC = [[BlueViewController alloc] init];
//    self.yellowVC = [[YellowViewController alloc] init];
    
    // 代码方式创建ToolBar
//    CGRect winSize = [UIScreen mainScreen].bounds;// 得到屏幕尺寸
//    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, winSize.size.height-40, winSize.size.width, 40)];
//    // 工具栏上的按钮
//    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"Switch Views(B)"         // 文字
//                                                              style:UIBarButtonItemStylePlain  // 样式
//                                                             target:self                       // 触发对象
//                                                             action:@selector(switch:)];       // 按钮触发的方法
//    bar.items = @[item1];
//    // 将工具栏添加到self.view
//    [self.view addSubview:bar];
    
    [self switchView:nil];
}

- (IBAction)switchView:(id)sender
{
    // 动画效果 (UIView简单切换动画)
    [UIView beginAnimations:@"ViewFlip" context:nil];
    [UIView setAnimationDuration:1.25];// 动画的时间
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];// 运动方式
//    UIViewAnimationCurveEaseInOut,         // 慢入慢出
//    UIViewAnimationCurveEaseIn,            // 开头逐渐加速
//    UIViewAnimationCurveEaseOut,           // 界面逐渐减速
//    UIViewAnimationCurveLinear             // 匀速
    
    if(self.curBlue)
    {
        [self.view insertSubview:self.yellowVC.view atIndex:0];
        [self.blueVC.view removeFromSuperview];
        
        // 动画的样式
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
//        UIViewAnimationTransitionNone,            无
//        UIViewAnimationTransitionFlipFromLeft,    左侧翻转
//        UIViewAnimationTransitionFlipFromRight,   右侧翻转
//        UIViewAnimationTransitionCurlUp,          上翻页
//        UIViewAnimationTransitionCurlDown,        下翻页
    }
    else
    {
        [self.view insertSubview:self.blueVC.view atIndex:0];
        [self.yellowVC.view removeFromSuperview];
        
        // 动画的样式
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    }
    
    [UIView commitAnimations];// 动画开始播放
    
    self.curBlue = !self.curBlue;
}

@end
