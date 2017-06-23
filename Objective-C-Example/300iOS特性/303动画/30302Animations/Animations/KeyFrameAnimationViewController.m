//
//  KeyFrameAnimationViewController.m
//  Animations
//
//  Created by niit on 16/3/18.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "KeyFrameAnimationViewController.h"

@interface KeyFrameAnimationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *plane;

@end

@implementation KeyFrameAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 关键帧
    
//    // 1. 沿着关键路径移动
    CGMutablePathRef planePath = CGPathCreateMutable();
    CGPathMoveToPoint(planePath, NULL, 160.0, 100.0);
    CGPathAddLineToPoint(planePath, NULL, 100.0, 280.0);
    CGPathAddLineToPoint(planePath, NULL, 260.0, 170.0);
    CGPathAddLineToPoint(planePath, NULL, 60.0, 170.0);
    CGPathAddLineToPoint(planePath, NULL, 220.0, 280.0);
    CGPathCloseSubpath(planePath);

    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [anim setPath:planePath];// 设定路径
    anim.duration = 3;
    [self.plane.layer addAnimation:anim forKey:nil];
    
    // 释放
    CFRelease(planePath);// 释放指针指向的地址内存
    planePath = nil;// 指针清空
    
    // 关于CGMutablePathRef 存放了一组路径点信息
    // typedef struct CGPath *CGMutablePathRef;// 是一个结构体指针类型的别名，所以指向的不是对象，是指向的结构体变量
    // CGPathCreateMutable() 返回的应该是一块堆内存的地址.(为什么不放在栈?因为栈内存的变量都是固定大小的,而这个可变路径是变化的)
    // 这个指针指向的内容用完之后需要CFRelease()进行释放，
    
    // 2. 设定关键时间点,及关键时间点对应的值
    CAKeyframeAnimation *anim2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    anim2.duration = 3;
    anim2.keyTimes = @[@.2,@0.4,@0.6,@0.8,@1];//时间点必须从小到大 0~1
    anim2.values = @[@0.25,@1,@0.5,@1,@2];// 对应时间点的值
    [self.plane.layer addAnimation:anim2 forKey:nil];
    
    
}

@end
