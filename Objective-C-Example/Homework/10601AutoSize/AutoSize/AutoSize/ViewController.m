//
//  ViewController.m
//  AutoSize
//
//  Created by student on 16/3/2.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //    UIViewAutoresizingNone                 = 0,
    //    UIViewAutoresizingFlexibleLeftMargin   = 1 << 0,  Flexible 弹性的意思
    //    UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
    //    UIViewAutoresizingFlexibleTopMargin    = 1 << 3,
    //    UIViewAutoresizingFlexibleBottomMargin = 1 << 5
    
    //    UIViewAutoresizingFlexibleWidth        = 1 << 1,
    //    UIViewAutoresizingFlexibleHeight       = 1 << 4,
    
    //
    
    //label1 左边固定 上边固定
    //(右边弹性 下方弹性 本身的宽弹性 本身高弹性)
    self.label1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.label2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.label3.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.label4.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.label5.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.label6.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 页面级别，只和当前视图控制器相关
// 1. 设置当前视图控制器是否支持旋转
- (BOOL)shouldAutorotate{
    return YES;
}

// 2. 设置支持旋转的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

// 3. 旋转时触发的事件
// 过时方法:


//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//    
//     NSLog(@"1 将要旋转到方向%i",toInterfaceOrientation);
//}

// 新的方法:
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    NSLog(@"2 将要旋转到的尺寸%@",NSStringFromCGSize(size));
}


@end





















