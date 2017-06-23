//
//  ViewController.m
//  UIViewAndCoreAnimation
//
//  Created by qiang on 16/3/20.
//  Copyright © 2016年 Qiangtech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong) UIView *redView;
@property (nonatomic,strong) UIView *blueView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    self.redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redView];
    
    self.blueView = [[UIView alloc] initWithFrame:CGRectMake(150, 100, 50, 50)];
    self.blueView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.blueView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 1. UIView动画
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                    animations:^{
        [self showInfo1];
        //self.redView.center = CGPointMake(125, 250);
        self.redView.transform = CGAffineTransformMakeScale(2, 2);
    } completion:^(BOOL finished){
        [self showInfo1];
//        self.redView.center = CGPointMake(125, 125);
    }];
    
    // 2. 核心动画
//    CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"position"];
//    anim1.duration = 1;
//    anim1.toValue = [NSValue valueWithCGPoint:CGPointMake(175, 250)];
//    anim1.delegate = self;
//    anim1.removedOnCompletion = NO;
//    anim1.fillMode = kCAFillModeForwards;
//    [self.blueView.layer addAnimation:anim1 forKey:nil];
    
    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim2.duration = 1;
    anim2.toValue = @2;
    anim2.delegate = self;
    anim2.removedOnCompletion = NO;
    anim2.fillMode = kCAFillModeForwards;
    [self.blueView.layer addAnimation:anim2 forKey:nil];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"%s",__func__);
    
    [self showInfo2];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"%s",__func__);
    
    [self showInfo2];
}

- (void)showInfo1
{
    NSLog(@"redView.frame = %@",NSStringFromCGRect(self.redView.frame));
    NSLog(@"redView.bounds = %@",NSStringFromCGRect(self.redView.bounds));
    NSLog(@"redView.layer position = %@",NSStringFromCGPoint(self.redView.layer.position));
    NSLog(@"redView.layer anchorPoint = %@",NSStringFromCGPoint(self.redView.layer.anchorPoint));
}

- (void)showInfo2
{
    NSLog(@"blueView.frame = %@",NSStringFromCGRect(self.blueView.frame));
    NSLog(@"blueView.bounds = %@",NSStringFromCGRect(self.blueView.bounds));
    NSLog(@"blueView.layer position = %@",NSStringFromCGPoint(self.blueView.layer.position));
    NSLog(@"blueView.layer anchorPoint = %@",NSStringFromCGPoint(self.blueView.layer.anchorPoint));
}

@end
