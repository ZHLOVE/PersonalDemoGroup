//
//  ViewController.m
//  CALayerDemo
//
//  Created by niit on 16/3/18.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (nonatomic,weak) CALayer *layer;

@property (nonatomic,strong) UIView *moveView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    // Do any additional setup after loading the view, typically from a nib.
//    
//    // 1. 设置图片的CALayer
//    // 1) 圆角
//    self.iconImageView.layer.cornerRadius = 50;
//    // 2) 边框
//    // 边框颜色 (图层的颜色是核心绘图框架的颜色类型 CGColor)
////    self.iconImageView.layer.borderColor = [UIColor yellowColor].CGColor; //UIColre -> CGColor
//    // 边框宽度
////    self.iconImageView.layer.borderWidth = 10;
//    // 超出边框的内容裁剪掉(如果有边框且有圆角则需要设置为YES)
//    self.iconImageView.layer.masksToBounds = YES;
//    // 3) 阴影
//    // 阴影颜色
////    self.iconImageView.layer.shadowColor = [UIColor blackColor].CGColor;
////    // 阴影宽度
////    self.iconImageView.layer.shadowRadius = 15;
////    // 阴影位置偏移
//////    self.iconImageView.layer.shadowOffset = CGSizeMake(10, 10);// 向右下偏移(10,10)
////    // 阴影透明度
////    self.iconImageView.layer.shadowOpacity = 0.5f;
//    
//    // (如果既要有圆角,又要有阴影。需要2个layer,一个layer在后面设置阴影)
//    CALayer *backLayer = [CALayer layer];
////    backLayer.frame = self.iconImageView.frame;
//    backLayer.position = self.iconImageView.center;//中心点
//    backLayer.anchorPoint = CGPointMake(0.5,0.5);// 挂载点
//    backLayer.bounds = CGRectMake(0, 0, self.iconImageView.bounds.size.width-30, self.iconImageView.bounds.size.height-30);
//    
//    backLayer.backgroundColor = [UIColor greenColor].CGColor;
//    backLayer.shadowColor = [UIColor yellowColor].CGColor;
//    backLayer.shadowRadius = 20;
//    backLayer.shadowOpacity = 0.8f;
//    [self.view.layer insertSublayer:backLayer below:self.iconImageView.layer];
//    
//    // 2. 新建一个CALayer对象
//    CALayer *layer = [CALayer layer];
//    layer.frame = CGRectMake(100, 150, 80, 80);
//    layer.cornerRadius = 10;
//    layer.masksToBounds = YES;
////    layer.contents = (id)[UIImage imageNamed:@"2.png"].CGImage;// UIImage -> CGIamge
//    // 背景色
//    layer.backgroundColor = [UIColor redColor].CGColor;
//    [self.view.layer addSublayer:layer];

    
    // 3.
    self.moveView = [[UIView alloc] initWithFrame:CGRectMake(100, 150, 80, 80)];
    [self.view addSubview:self.moveView];
    self.layer = self.moveView.layer;
    
    //30302练习:
    //1 (touchesBegan中)当双击时，在触摸位置新建的一个随机颜色固定大小的CALayer对象的方块
    //2 添加上下左右手势控制这个layer上下左右滑动,比如向右，控制这些新建的CAlayer移动到屏幕最右侧，但不要超出屏幕。
    //3 (touchesBegan中)如果点中某个方块，方块设置阴影颜色(亮一点的颜色)、阴影宽度，之前点选的块取消阴影
    //*4 块之间不能重叠
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//arc4random_uniform(255)/255.0 等同于 (arc4random()%255)/255.0
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    
    
    self.layer.position = CGPointMake(arc4random_uniform(winSize.width), arc4random_uniform(winSize.height));
    // 改变layer的位置,他的view的frame也改变
    NSLog(@"self.moveView.layer.position = %@",NSStringFromCGPoint(self.layer.position));
    NSLog(@"self.moveView.center = %@",NSStringFromCGPoint(self.moveView.center));
    NSLog(@"self.moveView.frame = %@",NSStringFromCGRect(self.moveView.frame));// 位置和 看上去尺寸(旋转变换、尺寸会改变)
    NSLog(@"self.moveView.bounds = %@",NSStringFromCGRect(self.moveView.bounds));// 0，0，原始尺寸
    
    self.layer.cornerRadius = arc4random_uniform(1);
    self.layer.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1].CGColor;
    self.layer.borderColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:arc4random_uniform(255)/255.0].CGColor;
    self.layer.borderWidth = arc4random_uniform(1);
    self.layer.transform = CATransform3DMakeRotation(arc4random_uniform(M_PI*2), 1, 0, 0);
    
    [UIView commitAnimations];
}

@end
