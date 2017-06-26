//
//  ViewController.m
//  TouchExplorer
//
//  Created by student on 16/3/17.
//  Copyright © 2016年 马千里. All rights reserved.
//
// 练习:
// 1. 修改当前代码，让moveView在你去拖动它的时候时候再跟着移动,如果手指在它之外移动，不要让他跟着移动。
// 2. 并且触摸时手指按在moveView的哪位置，移动时也就保持这个位置拖动。比如你一开始拖动的是moveView的左下角，移动时，保持这个偏移。
#import "ViewController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@property (nonatomic,assign)CGPoint tempPoint;
@property (nonatomic,strong) UIView *moveView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.moveView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    self.moveView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.moveView];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //1.触摸事件类型
    self.label1.text = @"触摸开始";
    //2触摸手指数量
    self.label2.text = [NSString stringWithFormat:@"数量%lu",(unsigned long)touches.count];
    //3 触摸点坐标
    UITouch *touch = touches.anyObject;//得到触摸对象
    CGPoint p = [touch locationInView:self.view];//得到触摸点在self.view中的坐标
    self.label3.text = [NSString stringWithFormat:@"坐标%@",NSStringFromCGPoint(p)];
    //4触摸连击次数
    self.label4.text = [NSString stringWithFormat:@"连击次数%lu",(unsigned long)touch.tapCount];
    
    //计算X,Y与中心点X,Y的距离
    CGFloat distenceX = sqrt(pow(self.moveView.center.x-p.x,2));
    CGFloat distenceY = sqrt(pow(self.moveView.center.y-p.y,2));
     if (distenceX<=25 && distenceY<=25) {
         //存临时相对坐标
         self.tempPoint = CGPointMake(self.moveView.center.x-p.x, self.moveView.center.y-p.y);
     }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.label1.text = @"触摸移动";
    UITouch *touch = touches.anyObject;
    CGPoint touchP = [touch locationInView:self.view];
//    double distance = [self distencePointA:redViewCentP andPointB:touchP];
    CGFloat distenceX = sqrt(pow(self.moveView.center.x-touchP.x,2));
    CGFloat distenceY = sqrt(pow(self.moveView.center.y-touchP.y,2));
    //鼠标移太快会直接移出范围,所以范围给大一些
    if (distenceX<=35 && distenceY<=35) {
        self.moveView.center = CGPointMake(touchP.x+self.tempPoint.x, touchP.y+self.tempPoint.y);
    }
}


- (double)distencePointA:(CGPoint)A andPointB:(CGPoint)B{
    double distance = sqrt(pow(A.x-B.x,2)+pow(A.y-B.y, 2));
    return distance;
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.label1.text = @"触摸结束";
}


@end
