//
//  ViewController.m
//  图片的相关处理
//
//  Created by student on 16/4/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

#import "DrawView.h"
@interface ViewController ()
{
    CGPoint clipStartPoint;
    CGPoint clipEndPoint;
}
@property (weak, nonatomic) IBOutlet DrawView *drawView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic,strong) UIView *clipView;

@end

@implementation ViewController

- (UIView *)clipView{
    if (_clipView == nil) {
        _clipView = [[UIView alloc]init];
        [self.imageView addSubview:_clipView];
        _clipView.backgroundColor = [UIColor blackColor];
        _clipView.alpha = 0.5;
    }
    return  _clipView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 截屏
    //    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDo:)];
    //    [self.view addGestureRecognizer:pan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 把视图保存成图片
- (IBAction)btnPressed:(id)sender {
    //一、得到UIImage对象
    //1.创建位图上下文（尺寸,透明 YES 透明 NO 不透明,拉伸）
    UIGraphicsBeginImageContextWithOptions(self.drawView.bounds.size, YES, 1);
    //2得到这个图像的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //3自己添加路径进行绘制
    UIBezierPath *path1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(90, 20, 120, 120)];
    [[UIColor redColor]setFill];
    [path1 addClip];//设置为裁剪路径
    //3.1把视图上的layer绘制到这个图像上下文中
    [self.drawView.layer renderInContext:ctx];
    //4 生成图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //5关闭图像上下文
    UIGraphicsEndImageContext();
    //二、将UIImage存到沙盒中或者相册中
    //1 相册
    //UIImageWriteToSavedPhotosAlbum(img, self, nil, nil);
    
    //2沙盒
    //沙盒路径
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [path stringByAppendingPathComponent:@"guo.jpeg"];
    NSLog(@"%@",filePath);
    
    // 2.1 生成png图片
    //    NSData *imgData = UIImagePNGRepresentation(img);
    //    [imgData writeToFile:filePath atomically:YES];
    // 2.2 jpeg图片(需要设定压缩率0~1范围,数字越小，压缩的文件越小,越相对模糊)
    NSData *imgData = UIImageJPEGRepresentation(img, 0.01);
    [imgData writeToFile:filePath atomically:YES];
}

//绘制图片并保存
- (IBAction)btn2Pressed:(id)sender {
    //一、得到UIImage对象
    //1创建位图上下文（尺寸，透明，拉伸）
    UIGraphicsBeginImageContextWithOptions(self.drawView.bounds.size, YES, 1);
    //2、得到这个图像上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //3 在改图像上下文中绘制
    //3.2自己添加路径进行绘制
    UIBezierPath *path1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(90, 20, 120, 120)];
    [[UIColor redColor]setFill];
    [path1 addClip];//设置为裁剪路径
    //4生成图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //5关闭图像上下文
    UIGraphicsEndImageContext();
    // 二、将UIImage存到沙盒中或者相册中
    // 1. 相册
    //    UIImageWriteToSavedPhotosAlbum(img, self, nil, nil);
    
    // 2. 沙盒
    // 沙盒路径
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [path stringByAppendingPathComponent:@"guo.jpeg"];
    NSLog(@"%@",filePath);
    
    // 2.1 生成png图片
    //    NSData *imgData = UIImagePNGRepresentation(img);
    //    [imgData writeToFile:filePath atomically:YES];
    // 2.2 jpeg图片(需要设定压缩率0~1范围,数字越小，压缩的文件越小,越相对模糊)
    NSData *imgData = UIImageJPEGRepresentation(img, 0.01);
    [imgData writeToFile:filePath atomically:YES];

}

//reset按钮
- (IBAction)btn3Pressed:(id)sender {
    self.imageView.image = [UIImage imageNamed:@"2.jpeg"];
}

//- (void)panDo:(UIPanGestureRecognizer *)g
//{
//    if(g.state == UIGestureRecognizerStateBegan)// 手势开始的时候 touchesBegan
//    {
//        clipStartPoint = [g locationInView:self.imageView];
//    }
//    else if(g.state == UIGestureRecognizerStateChanged) // 手势改变 touchesMoved
//    {
//        clipEndPoint = [g locationInView:self.imageView];
//
//        self.clipView.frame = CGRectMake(clipStartPoint.x, clipStartPoint.y, clipEndPoint.x-clipStartPoint.x, clipEndPoint.y - clipStartPoint.y);
//    }
//    else if(g.state == UIGestureRecognizerStateEnded)// 手势结束 touchesEnded
//    {
////        self.clipView.hidden =
//    }
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    clipStartPoint = [touch locationInView:self.imageView];
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.clipView.hidden = NO;
    UITouch *touch = [touches anyObject];
    clipEndPoint = [touch locationInView:self.imageView];
    self.clipView.frame = CGRectMake(clipStartPoint.x, clipStartPoint.y, clipEndPoint.x-clipStartPoint.x, clipEndPoint.y - clipStartPoint.y);
}

//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    self.clipView.hidden = YES;
//    // 处理一下图片
//
//    // 1. 创建位图上下文 （尺寸,透明 YES 透明 NO 不透明,拉伸）
//    UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, YES, 1);
//
//    // 2. 得到这个图像上下文
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    // 3. 在该图像上下文中绘制
//
//    // 设置一下剪裁的区域留下的区域 (不在这个范围内的就被剪裁了)
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.clipView.frame];
//    [path addClip];
//
//    // 3.1 把视图上的layer绘制这个图像上下文中
//    [self.imageView.layer renderInContext:ctx];
//
//    // 4. 生成图片
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//
//    // 5. 关闭图像上下文(释放内存,不关闭则会一直占用内存)
//    UIGraphicsEndImageContext();
//
//    self.imageView.image = img;
//
//}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.clipView.hidden = YES;
    // 处理一下图片
    
    // 1. 创建位图上下文 （尺寸,透明 YES 透明 NO 不透明,拉伸）
    UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, YES, 1);
    // 2. 得到这个图像上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 3. 在该图像上下文中绘制
    // 3.1 把视图上的layer绘制这个图像上下文中
    [self.imageView.layer renderInContext:ctx];
    // 4. 生成图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    // 5. 关闭图像上下文(释放内存,不关闭则会一直占用内存)
    UIGraphicsEndImageContext();
    
    // 将裁剪的图片再绘制到一个新的图片中
    UIGraphicsBeginImageContextWithOptions(self.clipView.bounds.size, YES, 1);
    CGContextRef ctx2 = UIGraphicsGetCurrentContext();
    [img drawAtPoint:CGPointMake(-self.clipView.frame.origin.x, -self.clipView.frame.origin.y)];
    UIImage *img2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageView.image = img2;
}























@end
