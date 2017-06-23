//
//  AnimationsGroupViewController.m
//  Animations
//
//  Created by niit on 16/3/18.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "AnimationsGroupViewController.h"

@interface AnimationsGroupViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *plane;
@end

@implementation AnimationsGroupViewController

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 贝塞尔曲线路径
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(10.0, 10.0)];
    [bezierPath addQuadCurveToPoint:CGPointMake(100, 300) controlPoint:CGPointMake(300, 100)];
    
    CAKeyframeAnimation *posAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    posAnim.path = bezierPath.CGPath;
    posAnim.removedOnCompletion = YES;
    
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.fromValue = @0.5;
    scaleAnim.toValue = @2;

    CABasicAnimation *opactiyAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opactiyAnim.fromValue = @0.5;
    opactiyAnim.toValue = @1;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[scaleAnim,opactiyAnim,posAnim];
    group.duration = 1;
    
    [self.plane.layer addAnimation:group forKey:nil];
    
    // 顺序执行
    // 设定beginTime
    
}

@end
