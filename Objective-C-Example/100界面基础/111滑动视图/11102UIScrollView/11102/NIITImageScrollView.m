//
//  ImageScrollView.m
//  11102
//
//  Created by niit on 16/2/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "NIITImageScrollView.h"

@interface NIITImageScrollView()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end


@implementation NIITImageScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setImageNames:(NSArray *)imageNames
{
    _imageNames = imageNames;
    
    // 设定scrollView
    CGFloat imgWidth = self.scrollView.bounds.size.width;
    CGFloat imgHeight = self.scrollView.bounds.size.height;
    for (int i=0; i<imageNames.count; i++)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgWidth*i,0,imgWidth,imgHeight)];
        imgView.image = [UIImage imageNamed:imageNames[i]];
        [self.scrollView addSubview:imgView];
    }
    self.scrollView.contentSize = CGSizeMake(imgWidth * self.imageNames.count, 0);
    
    // pageControl
    self.pageControl.numberOfPages = imageNames.count;
}

- (void)setOtherColor:(UIColor *)otherColor
{
    _otherColor = otherColor;
    self.pageControl.pageIndicatorTintColor = otherColor;
}

- (void)setCurColor:(UIColor *)curColor
{
    _curColor = curColor;
    self.pageControl.currentPageIndicatorTintColor = curColor;
}

// 第一步: 创建对象
// 方式1: 在initWithFrame中创建对象，不需要
// 方式2: 用懒加载
// init -> 也会调用 initWithFrame
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        // 1. 创建scrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self addSubview:scrollView]; // scrollView 被加入到当前视图，作为当前视图的子视图

        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView = scrollView;
        
        self.scrollView.delegate = self;
        
        // 2. 创建pageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.numberOfPages = 6;
        pageControl.currentPage = 0;
        
        pageControl.pageIndicatorTintColor = [UIColor redColor];
        pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}

// 父视图一旦被设定frame,就会调用该方法
// 第二步: 设定位置和尺寸
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //当前视图的尺寸 self.bounds
    
    // 设定scorllView的位置和尺寸
    self.scrollView.frame = self.bounds;
    
    // 调制里面图片视图的大小
    CGFloat imgWidth = self.scrollView.bounds.size.width;
    CGFloat imgHeight = self.scrollView.bounds.size.height;
    for (int i=0; i<self.imageNames.count; i++)
    {
        UIImageView *imgView = self.scrollView.subviews[i];
        imgView.frame = CGRectMake(imgWidth * i, 0, imgWidth, imgHeight);
    }
    self.scrollView.contentSize = CGSizeMake(imgWidth * self.imageNames.count, 0);
    
    // 设定pageControl的位置和尺寸
    CGFloat pageW = 100;
    CGFloat pageH = 20;
    CGFloat pageX = self.bounds.size.width/2 - pageW/2;
    CGFloat pageY = self.bounds.size.height - pageH;
    
    self.pageControl.frame = CGRectMake(pageX,pageY, pageW, pageH);
}


// 第三步:设定对应的数据模型对象
// 当前不需要数据模型，不需要进行设置

#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / 320;
}

@end
