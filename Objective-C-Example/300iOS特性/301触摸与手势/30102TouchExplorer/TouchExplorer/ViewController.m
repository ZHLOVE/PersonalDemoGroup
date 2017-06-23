//
//  ViewController.m
//  TouchExplorer
//
//  Created by niit on 16/3/17.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

// 练习:
// 1. 修改当前代码，让moveView在你去拖动它的时候时候再跟着移动,如果手指在它之外移动，不要让他跟着移动。
// 2. 并且触摸时手指按在moveView的哪位置，移动时也就保持这个位置拖动。比如你一开始拖动的是moveView的左下角，移动时，保持这个偏移。

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@property (nonatomic,strong) UIView *moveView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.moveView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    self.moveView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.moveView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 1. 触摸事件类型
    self.label1.text = @"触摸开始";
    // 2. 触摸手指数量
    self.label2.text = [NSString stringWithFormat:@"数量:%lu",(unsigned long)touches.count];
    // 3. 触摸点坐标
    UITouch *touch = touches.anyObject;// 得到触摸对象
    CGPoint  p = [touch locationInView:self.view];// 得到触摸点在self.view中的坐标
    self.label3.text = [NSString stringWithFormat:@"坐标%@",NSStringFromCGPoint(p)];
    // 4 触摸连击次数
    self.label4.text = [NSString stringWithFormat:@"连击次数:%lu",(unsigned long)touch.tapCount];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    self.label1.text = @"触摸移动";

    UITouch *touch = touches.anyObject;
    CGPoint  p = [touch locationInView:self.view];
    self.moveView.center = p;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    self.label1.text = @"触摸结束";
    
}

@end
