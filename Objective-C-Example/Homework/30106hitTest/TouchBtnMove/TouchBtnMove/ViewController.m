//
//  ViewController.m
//  TouchBtnMove
//
//  Created by student on 16/3/17.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

#import "MyBtnA.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnB;
@property (strong, nonatomic) IBOutlet UIButton *btnA;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

//    self.btnA = [[MyBtnA alloc]init];
    UIPanGestureRecognizer *panR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDo:)];
//    [self.btnA addGestureRecognizer:panR];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnAPressed:(MyBtnA *)sender {
 
    
//    if(sender.btnB != nil)
//    {
//        [sender.btnB removeFromSuperview];
//    }
//    
//    else
//    {
        NSLog(@"%@",NSStringFromCGRect(sender.bounds));
        
        //    sender.clipsToBounds = YES;// 超出范围是不显示
        
        UIButton *btnB = [[UIButton alloc] init];
        
        // 大小
        btnB.bounds = CGRectMake(0, 0, 200, 200);
        // 中心点
        btnB.center = CGPointMake(100, -100);
        
        [btnB setBackgroundImage:[UIImage imageNamed:@"对话框.png"] forState:UIControlStateNormal];
        [btnB setBackgroundImage:[UIImage imageNamed:@"小孩.png"] forState:UIControlStateHighlighted];
        [sender addSubview:btnB];
        sender.btnB = btnB;
//    }
}

- (void)panDo:(UIPanGestureRecognizer *)g
{
    CGPoint tran = [g translationInView:self.btnB];// 移动了多少距离
    CGPoint center = self.btnA.center;
    center.x += tran.x;
    center.y += tran.y;
    self.btnA.center = center;// => [self.imageView setCenter:center];
    //    self.imageView.center.x += tran.x;//错误的
    // 重置偏移量
    [g setTranslation:CGPointZero inView:self.btnA];
}

@end
