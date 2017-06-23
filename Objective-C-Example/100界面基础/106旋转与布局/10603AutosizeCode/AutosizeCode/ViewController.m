//
//  ViewController.m
//  AutosizeCode
//
//  Created by niit on 16/3/2.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
// 竖屏使用
#define W(x) (x * kScreenWidth / 320.0)
#define H(y) (y * kScreenHeight / 568.0)
// 横屏使用
#define WR(y) (y * kScreenHeight / 320.0)
#define HR(x) (x * kScreenWidth / 568.0)

// 根据iPhone5计算
//int width = 20;// iphone5下 屏幕宽是320
//int width2 = 20 * 375 / 320.0;// 23 iphone6下 屏幕款375
//int winth3 = 20 * 414 / 320.0;// 25 iphone6 plus下 屏幕款414

// 使用W(x),H(y),写代码时只需考虑iPhone5下的尺寸即可

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@end

@implementation ViewController

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"1 将要旋转到方向%i",toInterfaceOrientation);
    
    NSLog(@"%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        // 水平方向
        self.label1.frame = CGRectMake(WR(20),HR(20),WR(125),HR(125));
        self.label2.frame = CGRectMake(WR(20),HR(155),WR(125),HR(125));
        self.label3.frame = CGRectMake(WR(177),HR(20), WR(125),HR(125));
        self.label4.frame = CGRectMake(WR(177),HR(155),WR(125),HR(125));
        self.label5.frame = CGRectMake(WR(328),HR(20), WR(125),HR(125));
        self.label6.frame = CGRectMake(WR(328),HR(155), WR(125),HR(125));
    }
    else
    {
        // 垂直方向
        self.label1.frame = CGRectMake(W(20),H(20),W(125),H(125));
        self.label2.frame = CGRectMake(W(172),H(20),W(125),H(125));
        self.label3.frame = CGRectMake(W(20),H(168),W(125),H(125));
        self.label4.frame = CGRectMake(W(175),H(168),W(125),H(125));
        self.label5.frame = CGRectMake(W(20),H(315),W(125),H(125));
        self.label6.frame = CGRectMake(W(175),H(315),W(125),H(125));
    }
}

@end
