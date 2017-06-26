//
//  MQLImageUIScrollView.m
//  Demo
//
//  Created by 马千里 on 16/2/29.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "MQLImageUIScrollView.h"

@interface MQLImageUIScrollView()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
@implementation MQLImageUIScrollView

- (void)setImageNames:(NSArray *)imageNames{
    _imageNames = imageNames;
    // 设定scrollView
    CGFloat imageWidth = self.scrollView.bounds.size.width;
    CGFloat imageHeigth = self.scrollView.bounds.size.height;
    for (int i= 0; i<imageNames.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageWidth*i, 0, imageWidth, imageHeigth)];
        imageView.image = [UIImage imageNamed:imageNames[i]];
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.contentSize = CGSizeMake(imageWidth*self.imageNames.count, 0);
    //pageControl
    self.pageControl.numberOfPages = self.imageNames.count;
}

- (void)setOtherColor:(UIColor *)otherColor{
    _otherColor = otherColor;
    self.pageControl.pageIndicatorTintColor = otherColor;
}
- (void)setCurColor:(UIColor *)curColor{
    _curColor = curColor;
    self.pageControl.currentPageIndicatorTintColor = curColor;
}
// 第一步: 创建对象
// 方式1: 在initWithFrame中创建对象，不需要
// 方式2: 用懒加载
// init -> 也会调用 initWithFrame
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //1 创建scrollView
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        // scrollView 被加入到当前视图，作为当前视图的子视图
        [self addSubview:scrollView];
        self.scrollView.pagingEnabled = YES;//分页
        
        self.scrollView.delegate = self;//设自己为代理
        //2 创建pageControll
        UIPageControl *pageControl = [[UIPageControl alloc]init];
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}
// 父视图一旦被设定frame,就会调用该方法
// 第二步: 设定位置和尺寸
- (void)layoutSubviews{
    [super layoutSubviews];
    //当前视图的尺寸 self.bounds
    // 设定scorllView的位置和尺寸
    self.scrollView.frame = self.bounds;
    // 调制里面图片视图的大小
    CGFloat imageWidth = self.scrollView.bounds.size.width;
    CGFloat imageHeigth = self.scrollView.bounds.size.height;
    for (int i = 0; i<self.imageNames.count; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        imageView.frame = CGRectMake(imageWidth * i, 0, imageWidth, imageHeigth);
//        CGSizeMake(imageWidth * self.imageNames.count, 0);
    }
    self.scrollView.contentSize = CGSizeMake(imageWidth * self.imageNames.count, 0);
    // 设定pageControl的位置和尺寸
    CGFloat pageW = 100;
    CGFloat pageH = 20;
    CGFloat pageX = self.bounds.size.width/2 - pageW/2;
    CGFloat pageY = self.bounds.size.height - pageH;
    self.pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);

}
// 第三步:设定对应的数据模型对象
// 当前不需要数据模型，不需要进行设置
#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / 320;
}





































@end
