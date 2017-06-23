//
//  ViewController.m
//  UIView动画和核心动画的区别
//
//  Created by niit on 16/3/21.
//  Copyright © 2016年 NIIT. All rights reserved.
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
    
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    self.redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redView];
    
    self.blueView = [[UIView alloc] initWithFrame:CGRectMake(200, 100, 100, 100)];
    self.blueView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.blueView];
    
    self.redView.layer.position = CGPointMake(0, 100);
    self.redView.layer.anchorPoint = CGPointMake(0, 0);
    self.blueView.layer.position = CGPointMake(200, 100);
    self.blueView.layer.anchorPoint = CGPointMake(0, 0);
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 1. UIView隐式动画
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         NSLog(@"UIView动画开始");
                         [self showRedViewInfo];

                         // 设定动画目标的位置及变换
                         // 位移
//                         self.redView.center = CGPointMake(50, 350);
                         // 缩放
                         self.redView.transform = CGAffineTransformMakeScale(2, 2);
                         
                         
                     } completion:^(BOOL finished) {
                         NSLog(@"UIView动画结束");
                         [self showRedViewInfo];
                     }];
    
    // 2. 核心动画 (不改变对象的frame bounds layer.position) 是假象!
//    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];// 位移动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];// 缩放动画
    anim.duration = 1;
//    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(250, 350)];// 位移 CGPoint -> 对象
    anim.toValue = @2;// 缩放2倍
    anim.removedOnCompletion = NO;// 不移除动画
    anim.fillMode = kCAFillModeForwards;// 保持最后的动画状态
    anim.delegate = self;
//    [self.blueView.layer addAnimation:anim forKey:nil];

}

- (void)animationDidStart:(CAAnimation *)anim
{
     NSLog(@"核心动画开始");
    [self showBlueViewInfo];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
     NSLog(@"核心动画结束");
    [self showBlueViewInfo];
}

- (void)showRedViewInfo
{
    NSLog(@"self.redVeiw.frame:%@",NSStringFromCGRect(self.redView.frame));
    NSLog(@"self.redVeiw.bounds:%@",NSStringFromCGRect(self.redView.bounds));
    NSLog(@"self.redVeiw.layer.position:%@",NSStringFromCGPoint(self.redView.layer.position));
    NSLog(@"self.redVeiw.layer.anchorPoint:%@",NSStringFromCGPoint(self.redView.layer.anchorPoint));
}

- (void)showBlueViewInfo
{
    NSLog(@"self.blueVeiw.frame:%@",NSStringFromCGRect(self.blueView.frame));
    NSLog(@"self.blueVeiw.bounds:%@",NSStringFromCGRect(self.blueView.bounds));
    NSLog(@"self.blueVeiw.layer.position:%@",NSStringFromCGPoint(self.blueView.layer.position));
    NSLog(@"self.blueVeiw.layer.anchorPoint:%@",NSStringFromCGPoint(self.blueView.layer.anchorPoint));
}

// UIView动画 (会改变对象的frame bounds layer.position)
//(transform:会改变frame,bounds不改变)
//2016-03-21 09:50:38.022 UIView动画和核心动画的区别[2184:50738] UIView动画开始
//2016-03-21 09:51:15.583 UIView动画和核心动画的区别[2195:51410] self.redVeiw.frame:{{0, 100}, {100, 100}}
//2016-03-21 09:51:15.584 UIView动画和核心动画的区别[2195:51410] self.redVeiw.bounds:{{0, 0}, {100, 100}}
//2016-03-21 09:51:15.584 UIView动画和核心动画的区别[2195:51410] self.redVeiw.layer.position:{0, 100}
//2016-03-21 09:51:15.584 UIView动画和核心动画的区别[2195:51410] self.redVeiw.layer.anchorPoint:{0, 0}
//2016-03-21 09:50:39.024 UIView动画和核心动画的区别[2184:50738] UIView动画结束
//2016-03-21 09:50:39.024 UIView动画和核心动画的区别[2184:50738] self.redVeiw.frame:{{0, 100}, {200, 200}}
//2016-03-21 09:50:39.025 UIView动画和核心动画的区别[2184:50738] self.redVeiw.bounds:{{0, 0}, {100, 100}}
//2016-03-21 09:50:39.025 UIView动画和核心动画的区别[2184:50738] self.redVeiw.layer.position:{0, 100}
//2016-03-21 09:50:39.025 UIView动画和核心动画的区别[2184:50738] self.redVeiw.layer.anchorPoint:{0, 0}

//核心动画 (不改变对象的frame bounds layer.position) 是假象!
//2016-03-21 09:27:49.440 UIView动画和核心动画的区别[1943:30717] 核心动画开始
//2016-03-21 09:27:49.441 UIView动画和核心动画的区别[1943:30717] self.blueVeiw.frame:{{200, 100}, {100, 100}}
//2016-03-21 09:27:49.441 UIView动画和核心动画的区别[1943:30717] self.blueVeiw.bounds:{{0, 0}, {100, 100}}
//2016-03-21 09:27:49.441 UIView动画和核心动画的区别[1943:30717] self.blueVeiw.layer.position:{250, 150}
//2016-03-21 09:27:49.441 UIView动画和核心动画的区别[1943:30717] self.blueVeiw.layer.anchorPoint:{0.5, 0.5}
//2016-03-21 09:27:50.441 UIView动画和核心动画的区别[1943:30717] 核心动画结束
//2016-03-21 09:27:50.442 UIView动画和核心动画的区别[1943:30717] self.blueVeiw.frame:{{200, 100}, {100, 100}}
//2016-03-21 09:27:50.442 UIView动画和核心动画的区别[1943:30717] self.blueVeiw.bounds:{{0, 0}, {100, 100}}
//2016-03-21 09:27:50.442 UIView动画和核心动画的区别[1943:30717] self.blueVeiw.layer.position:{250, 150}
//2016-03-21 09:27:50.442 UIView动画和核心动画的区别[1943:30717] self.blueVeiw.layer.anchorPoint:{0.5, 0.5}
@end
