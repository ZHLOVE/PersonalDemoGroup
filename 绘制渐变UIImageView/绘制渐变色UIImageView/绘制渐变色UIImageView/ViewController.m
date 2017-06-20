//
//  ViewController.m
//  绘制渐变色UIImageView
//
//  Created by MBP on 2017/3/16.
//  Copyright © 2017年 leqi. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+HexColor.h"

#define ratio  [UIScreen mainScreen].bounds.size.height / 667
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imgView = [[UIImageView alloc]initWithImage:[self makeImage:CGSizeMake(200, 64)]];
    imgView.frame = CGRectMake(0, 0, screenWidth,64);

    [self.view addSubview:imgView];


}

- (UIImage *)makeImage:(CGSize)size{
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGFloat locations[2] = {0, 1};
    //点数量:count为locations数量,size_t类型
//    NSArray *colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"10e26f"].CGColor, (id)[UIColor colorWithHexString:@"#06d171"].CGColor, nil];
    NSArray *colors = [NSArray arrayWithObjects:(id)[UIColor lightGrayColor].CGColor, (id)[UIColor colorWithHexString:@"#06d171"].CGColor, nil];

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, locations);
    CGPoint startPoint = CGPointMake(0,0);
    CGPoint endPoint = CGPointMake((screenWidth * 64)/(200 * ratio + 64), 64);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);

    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();//将上下文转为一个UIImage对象。
    UIGraphicsEndImageContext();
    return theImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
