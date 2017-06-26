//
//  UIViewAnimationViewController.m
//  Animations例子
//
//  Created by student on 16/3/18.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "UIViewAnimationViewController.h"

@interface UIViewAnimationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *plane;

@end

@implementation UIViewAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //UIView隐式动画
    //方式1
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:NSNotFound];
    //    // 中止值
    CGPoint center = self.plane.center;
    center.x += 100;
    center.y += 100;
    self.plane.center = center;
    [UIView commitAnimations];
    //方式2 block方式
//    [UIView animateWithDuration:5   // 动画持续时间
//                          delay:0   // 延迟执行动画的时间
//         usingSpringWithDamping:0.3 // 阻尼系数(阻力),数值越小阻力越小，弹簧效果越明显
//          initialSpringVelocity:5  // 初始速度
//                        options:UIViewAnimationOptionCurveLinear
//                     animations:
//     ^{
//         CGPoint center = self.plane.center;
//         center.x += 100;
//         center.y += 200;
//         self.plane.center = center;
//     }completion:^(BOOL finished)
//                     {
//                         // 动画执行完之后，执行的代码
//                         
//                     }];
}

@end
