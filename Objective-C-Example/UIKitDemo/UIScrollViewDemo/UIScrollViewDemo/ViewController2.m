//
//  ViewController2.m
//  UIScrollViewDemo
//
//  Created by niit on 16/2/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,weak) UIImageView *imgView;
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 为scrollView添加图片视图
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.scrollView addSubview:imageView];
    // 设定scrollView的内容尺寸
    self.scrollView.contentSize = image.size;
    
    // 设置tag
    imageView.tag = 101;
    // 用属性保存一下指针地址，方便再次访问
    self.imgView = imageView;
    
    // 设置最大缩放几倍
    self.scrollView.maximumZoomScale = 2;
    self.scrollView.minimumZoomScale = 0.2;
    
    // 设置代理人,谁为scorllView提供事件处理
    self.scrollView.delegate = self;
}

#pragma mark
// 注意:重写方法，方法名、参数、返回值，必须根据父类或协议定义的一致，否则不一致的话，便是自定义方法，不是重写了!

// 1.要实现缩放必须重写以下方法
// 返回scorllView中要根据手势缩放的视图
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
//    NSLog(@"%s",__func__);
//    return nil;// 返回空，则缩放无效果

    // 找到界面中对象的几种方式:
    // 1. 通过层级结构:通过子视图数组里第一个元素可以找到这个UIImageView
//    return self.scrollView.subviews[0];
    // 2. 通过Tag找到(之前创建的时候后要设置Tag)
//    UIImageView *imageView = [scrollView viewWithTag:101];
    // 3. 通过属性(之前创建的时候，需要用属性保存)
    return self.imgView;
    
}


@end
