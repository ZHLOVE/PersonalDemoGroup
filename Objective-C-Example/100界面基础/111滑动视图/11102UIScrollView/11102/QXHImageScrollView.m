//
//  QXHImageScrollView.m
//  11102
//
//  Created by niit on 16/2/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "QXHImageScrollView.h"

@interface QXHImageScrollView()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end


@implementation QXHImageScrollView

+ (instancetype)imageScrollView
{
    return [[NSBundle mainBundle] loadNibNamed:@"QXHImageScrollView" owner:nil options:nil][0];
}

- (void)setImageNames:(NSArray *)imageNames
{
    _imageNames = imageNames;
    
    // 清除scrollView里原先的子视图(防止设置2次imageNames)
    for(UIView *v in self.scrollView.subviews)
    {
        [v removeFromSuperview];
    }
    
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
// 方式1: 在initWithFrame中创建对象,不需要指定尺寸位置 (注:一般在initWithFrame中，因为init -> 也会调用 initWithFrame)
// 方式2: 采用懒加载方式创建对象
// 方式3: 采用xib文件初始化对象

// 父视图一旦被设定frame,就会调用该方法调整本视图里子视图的位置
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
    
    [self addSubview:self.pageControl];
}

// 第三步:设定对应的数据模型对象
// 当前不需要数据模型，不需要进行设置


#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / 320;
}


@end
