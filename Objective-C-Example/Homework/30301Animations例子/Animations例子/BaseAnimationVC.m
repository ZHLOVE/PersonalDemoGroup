//
//  BaseAnimationVC.m
//  Animations例子
//
//  Created by student on 16/3/18.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "BaseAnimationVC.h"

@interface BaseAnimationVC ()

@property (weak, nonatomic) IBOutlet UIImageView *plane;

@end

@implementation BaseAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//CABasicAnimation的属性:
//fromValue
//toValue
//ByValue
//Autoreverses
//Duration
//RemovedOnCompletion
//Speed
//BeginTime
//TimeOffset
//RepeatCount
//RepeatDuration

//animationWithKeyPath的值：
//transform.scale       比例转换
//transform.scale.x     宽的比例转换
//transform.scale.y     高的比例转换
//transform.rotation.z  平面图的旋转
//opacity               透明度
//margin
//zPosition
//backgroundColor       背景颜色
//cornerRadius          圆角
//borderWidth
//bounds
//contents
//contentsRect
//cornerRadius
//frame
//hidden
//mask
//masksToBounds
//opacity
//position
//shadowColor
//shadowOffset
//shadowOpacity
//shadowRadius

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    //    CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"opacity"];// keyPath不能写错
    //    anim1.duration = 2.0; // 动画过程的时间
    //    anim1.fromValue = @1; // 起始值
    //    anim1.toValue = @0;   // 终止值
    //    anim1.repeatCount = 1; // 次数
    //    anim1.fillMode = kCAFillModeForwards; // 保持动画最后的数值 ?
    //    anim1.removedOnCompletion = NO;
    //    [self.plane.layer addAnimation:anim1 forKey:@"animate1"];
    
    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim2.duration = 1.0; // 动画过程的时间
    anim2.fromValue = @0.5; // 起始值
    anim2.toValue = @2;   // 终止值
    anim2.repeatCount = 1; // 次数
    anim2.fillMode = kCAFillModeForwards;
    anim2.removedOnCompletion = NO;
    [self.plane.layer addAnimation:anim2 forKey:@"animate2"];
    
    
    //    CABasicAnimation *anim3 = [CABasicAnimation animationWithKeyPath:@"contents"];
    //    anim3.duration = 1.0; // 动画过程的时间
    //    anim3.fromValue = (id)[UIImage imageNamed:@"clipartPlane"].CGImage;
    //    anim3.toValue = (id)[UIImage imageNamed:@"Icon"].CGImage;;   // 终止值
    //    anim3.repeatCount = 1; // 次数
    //    anim3.fillMode = kCAFillModeForwards;
    //// kCAFillModeForwards  动画结束后保持最后的状态
    //// kCAFillModeBackwards 动画开始之前立即进入初始状态等待动画开始
    //// kCAFillModeBoth      = kCAFillModeForwards + kCAFillModeBackwards
    //// kCAFillModeRemoved   动画开始和结束后对layer没影响(默认值)
    //    anim3.removedOnCompletion = NO; // 如果不设置为NO,fillMode不起作用
    //    [self.plane.layer addAnimation:anim3 forKey:@"animate3"];
    
}

@end
