//
//  ViewController.m
//  CALayer练习
//
//  Created by student on 16/3/18.
//  Copyright © 2016年 马千里. All rights reserved.
//
//练习:
//1 (touchesBegan中)当双击时，在触摸位置新建的一个随机颜色固定大小的CALayer对象的方块
//2 添加上下左右手势控制这个layer上下左右滑动,比如向右，控制这些新建的CAlayer移动到屏幕最右侧，但不要超出屏幕。
//*3 块之间不能重叠
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong) NSMutableArray *layersArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.layersArray = [NSMutableArray array];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *userTouch = touches.anyObject;
    if (userTouch.tapCount == 2) {
       CGPoint touchPoint = [userTouch locationInView:self.view];
        [self creatSquareWithPoint:touchPoint];
//        NSLog(@"双击点%3.0f,%3.0f",touchPoint.x,touchPoint.y);
    }
}

- (void)creatSquareWithPoint:(CGPoint)touchPoint{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(touchPoint.x, touchPoint.y, 50, 50);
    layer.position = touchPoint;//中心点
    layer.anchorPoint = CGPointMake(0.5,0.5);// 挂载点
    layer.cornerRadius = 10;
    layer.masksToBounds = YES;
    layer.backgroundColor = [UIColor colorWithRed:(arc4random()%256/256.0) green:(arc4random()%256/256.0) blue:(arc4random()%256/256.0) alpha:0.8].CGColor;
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDo:)];
    swipeUp.direction =  UISwipeGestureRecognizerDirectionUp;
    swipeUp.numberOfTouchesRequired = 1;
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDo:)];
    swipeDown.direction =  UISwipeGestureRecognizerDirectionDown;
    swipeDown.numberOfTouchesRequired = 1;
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDo:)];
    swipeLeft.direction =  UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.numberOfTouchesRequired = 1;
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDo:)];
    swipeRight.direction =  UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeUp];
    [self.view addGestureRecognizer:swipeDown];
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    
    [self.view.layer addSublayer:layer];
    [self.layersArray addObject:layer];
}

- (void)swipeDo:(UISwipeGestureRecognizer *)swip
{
    if(swip.direction == UISwipeGestureRecognizerDirectionLeft)
    {
      
        for (CALayer *layer in self.layersArray) {
            layer.position = CGPointMake(25, layer.position.y);
//            NSLog(@"%f,%f",layer.position.x,layer.position.y);
        }
    }
    else if (swip.direction == UISwipeGestureRecognizerDirectionRight)
    {
        for (CALayer *layer in self.layersArray) {
            layer.position = CGPointMake(350, layer.position.y);
        }
    }
    else if (swip.direction == UISwipeGestureRecognizerDirectionUp)
    {
        for (CALayer *layer in self.layersArray) {
         layer.position = CGPointMake(layer.position.x, 20);
        }
    }else if (swip.direction == UISwipeGestureRecognizerDirectionDown)
    {
        for (CALayer *layer in self.layersArray) {
            layer.position = CGPointMake(layer.position.x, 642);
        }
    }

}
@end
