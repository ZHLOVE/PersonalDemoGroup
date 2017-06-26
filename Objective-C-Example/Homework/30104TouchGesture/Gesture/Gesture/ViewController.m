//
//  ViewController.m
//  Gesture
//
//  Created by student on 16/3/17.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    double lastDistance;
    
    CGRect originFrame;
}
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   originFrame = self.imageView.frame;
    
    // 创建手势
    
    // 1. 点按手势
    UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDo:)];
    tapR.numberOfTapsRequired = 2;// 连续点击次数
    tapR.numberOfTouchesRequired = 1;// 手指数量
    [self.view1 addGestureRecognizer:tapR];
    
    // 2. 轻扫手势 (四个方向要分别添加)
    UISwipeGestureRecognizer *swipeR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDo:)];
    swipeR.direction = UISwipeGestureRecognizerDirectionRight;
    swipeR.numberOfTouchesRequired = 1;
    [self.view2 addGestureRecognizer:swipeR];
    
    UISwipeGestureRecognizer *swipeLR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDo:)];
    swipeLR.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLR.numberOfTouchesRequired = 1;
    [self.view2 addGestureRecognizer:swipeLR];
    
    // 3. 捏合手势
    UIPinchGestureRecognizer *pinchR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDo:)];
    [self.view3 addGestureRecognizer:pinchR];
    
    // 4. 旋转手势
    UIRotationGestureRecognizer *rotateR = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateDo:)];
    [self.view4 addGestureRecognizer:rotateR];
    
    // 5. 拖动手势 (和轻扫的区别:得到距离)
    UIPanGestureRecognizer *panR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDo:)];
    [self.view5 addGestureRecognizer:panR];
    
    // 6. 长按手势
    UILongPressGestureRecognizer *longR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longDo:)];
    [self.view6 addGestureRecognizer:longR];
    
    
}


#pragma mark - 手势处理
- (void)tapDo:(UITapGestureRecognizer *)g
{
    NSLog(@"检测到点击手势");
}

- (void)swipeDo:(UISwipeGestureRecognizer *)g
{
    NSLog(@"检测到轻扫手势");
    if(g.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        self.imageView.frame = CGRectOffset(self.imageView.frame, -20, 0);
    }
    else
    {
        self.imageView.frame = CGRectOffset(self.imageView.frame, 20, 0);
    }
}

- (void)pinchDo:(UIPinchGestureRecognizer *)g
{
    NSLog(@"检测到捏合手势");
    double scale = g.scale;//缩放的大小
    
    CGRect curFrame = originFrame;//self.imageView.frame;
    self.imageView.frame = CGRectMake(curFrame.origin.x, curFrame.origin.y, curFrame.size.width*scale, curFrame.size.height*scale);
    
}

- (void)rotateDo:(UIRotationGestureRecognizer *)g
{
    double rotation = g.rotation;
    
    self.imageView.transform = CGAffineTransformMakeRotation(rotation);
    
}

- (void)panDo:(UIPanGestureRecognizer *)g
{
    CGPoint tran = [g translationInView:self.view5];// 移动了多少距离
    
    CGPoint center = self.imageView.center;
    center.x += tran.x;
    center.y += tran.y;
    
    self.imageView.center = center;// => [self.imageView setCenter:center];
    
    //    self.imageView.center.x += tran.x;//错误的
    
    // 重置偏移量
    [g setTranslation:CGPointZero inView:self.view5];
}

- (void)longDo:(UILongPressGestureRecognizer *)g
{
    NSLog(@"长按了");
    self.imageView.frame = originFrame;
    
    switch (g.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"手势开始");
            break;
        case UIGestureRecognizerStateChanged:
            NSLog(@"手势Changed");
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"手势Ended");
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"手势Canceled");
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"手势Failed");
            break;
            //        case UIGestureRecognizerStateRecognized:
            //            NSLog(@"手势开始");
            //            break;
        case UIGestureRecognizerStatePossible:
            NSLog(@"手势Possible");
            break;
            
        default:
            break;
    }
    
}


@end