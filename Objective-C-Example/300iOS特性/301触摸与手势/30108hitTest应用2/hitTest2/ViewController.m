//
//  ViewController.m
//  hitTest2
//
//  Created by niit on 16/3/17.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "MyButton.h"

@interface ViewController ()
//{
//    BOOL bMove;
//    CGPoint pointXY;// 距离中心点的偏移
//}

@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIView *moveView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveV:)];
//    [self.btn addGestureRecognizer:pan];
    
}
- (IBAction)btnPressed:(MyButton *)sender
{
    
    if(sender.addBtn != nil)
    {
        [sender.addBtn removeFromSuperview];
    }
    
    else
    {
        NSLog(@"%@",NSStringFromCGRect(sender.bounds));
        
        //    sender.clipsToBounds = YES;// 超出bounds范围的子视图不显示
        
        UIButton *btn = [[UIButton alloc] init];
        
        // 大小
        btn.bounds = CGRectMake(0, 0, 200, 200);
        // 中心点
        btn.center = CGPointMake(100, -100);
        
        [btn setBackgroundImage:[UIImage imageNamed:@"对话框.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"小孩.png"] forState:UIControlStateHighlighted];
        
        [sender addSubview:btn];
        
        sender.addBtn = btn;
    }
    
}

//// 方法2:手势
//- (void)moveV:(UIPanGestureRecognizer *)g
//{
//    // 偏移多少
////    CGPoint tran = [g translationInView:self.moveView];
//    CGPoint tran = [g translationInView:self.btn];    
//    
//    // 加上偏移
////    self.moveView.center = CGPointMake(self.moveView.center.x+tran.x, self.moveView.center.y+tran.y);
//    self.btn.center = CGPointMake(self.btn.center.x+tran.x, self.btn.center.y+tran.y);
//    
//    // 重置偏移量
////    [g setTranslation:CGPointZero inView:self.moveView];
//    [g setTranslation:CGPointZero inView:self.btn];
//}

// 方法1:touches
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"%s",__func__);
//    
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self.view];
//    
//    // 1. 得到触摸点是否在moveView范围内
//    bMove = CGRectContainsPoint(self.moveView.frame, point);
//    
//    if(bMove)
//    {
//        // 计算触摸点距离中心点的偏移
//        pointXY = CGPointMake(point.x - self.moveView.center.x, point.y - self.moveView.center.y);
//    }
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    if(bMove)
//    {
//        UITouch *touch = [touches anyObject];
//        CGPoint point = [touch locationInView:self.view];
//        
//        // 2. 移动它
//        // 触摸点-偏移
//        self.moveView.center = CGPointMake(point.x - pointXY.x, point.y - pointXY.y);
//    }
//    
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    // 3. 结束移动
//    bMove = NO;
//}

@end
