//
//  UIViewAnimations2ViewController.m
//  Animations
//
//  Created by niit on 16/3/18.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "UIViewAnimations2ViewController.h"

@interface UIViewAnimations2ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *plane;

@end

@implementation UIViewAnimations2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

// 2. UIView 隐式动画
// 创建视图内视图对象的动画效果的简单方式
// 可修改的属性:
// * 位置、尺寸大小
// * 透明度
// * transform变换(位移、旋转)

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // UIView 隐式动画
    
    // 方式1
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
////    [UIView setAnimationRepeatAutoreverses:YES];
//    [UIView setAnimationRepeatCount:NSNotFound];
//    
//    // 中止值
//    CGPoint center = self.plane.center;
//    center.x += 100;
//    center.y += 100;
//    self.plane.center = center;
//    
//    [UIView commitAnimations];
    
    // 方式2 block方式
    [UIView animateWithDuration:5    // 动画持续时间
                          delay:0.5    // 延迟执行动画的时间
         usingSpringWithDamping:0.01 // 阻尼系数(阻力),数值越小阻力越小，弹簧效果越明显
          initialSpringVelocity:5    // 初始速度
                        options:UIViewAnimationOptionCurveLinear // 多参数通过 | 隔开
                     animations:
     ^{
         CGPoint center = self.plane.center;
         center.x += 100;
         center.y += 200;
         self.plane.center = center;
     } completion:^(BOOL finished)
    {
        // 动画执行完之后，执行的代码
                         
    }];
}

@end
