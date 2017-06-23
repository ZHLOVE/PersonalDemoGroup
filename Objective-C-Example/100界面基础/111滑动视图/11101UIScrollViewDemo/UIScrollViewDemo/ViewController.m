//
//  ViewController.m
//  UIScrollViewDemo
//
//  Created by niit on 16/2/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  
    // 一、storyboard创建scrollView(上方的)
    // delegate 和 tag 在storyboadr中设置好了
    // 设定scrollView的内容尺寸
    self.scrollView.contentSize = CGSizeMake(380, 239);
    self.scrollView.backgroundColor = [UIColor orangeColor];
    
    // 二、代码创建的scrollView(下方)
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, 320, 320)];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    view1.backgroundColor = [UIColor redColor];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 320, 320)];
    view2.backgroundColor = [UIColor greenColor];
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(320*2, 0, 320, 320)];
    view3.backgroundColor = [UIColor blueColor];
    [scrollView addSubview:view1];
    [scrollView addSubview:view2];
    [scrollView addSubview:view3];
    
    // 1. 内容的尺寸
    scrollView.contentSize = CGSizeMake(320*3, 0);
    // 2. 是否反弹
    scrollView.bounces = YES;
    // 3. 滑动条样式
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    // 4. 关闭滑动条
//    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.showsVerticalScrollIndicator = NO;
    // 5. 分页
    scrollView.pagingEnabled = YES;
    // 6. 留边
//    scrollView.contentInset = UIEdgeInsetsMake(0, 50, 0, 50);
//    scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 50, 0, 50);
    scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scrollView];
    // 7. 代理人 (告诉scorllView 代理人是谁，谁为他处理事件)
    scrollView.delegate = self;
    // 8. 设置tag
    scrollView.tag = 1001;
    
    // 三、分页控件
    // 设置pageControl
    [self.view addSubview:self.pageControl];// 将拖入的分页控件前置到最前
    // 1. 总共有几页内容
    self.pageControl.numberOfPages = 3;
    // 2. 当前显示哪一页
    self.pageControl.currentPage = 0;
    // 3. 颜色
    self.pageControl.pageIndicatorTintColor = [UIColor yellowColor];
    self.pageControl.currentPageIndicatorTintColor= [UIColor redColor];
}

#pragma mark - 为scrollView提供各种状态的事件处理

// 注意:界面中的2个scrollView都设定了当前控制器为他们的代理人,在滑动的时候，都会调用以下代理方法,我们可以通过给他们设定tag，判断哪个对象触发了方法,做出不同的处理

// 已经滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%i:%s",scrollView.tag,__func__);
    
    // 如果是下方哪个scrollView，根据他的偏移计算分页的当前页码，否则则不处理
    if(scrollView.tag == 1001)
    {
        // 根据当前内容偏移的位置,计算当前是第几页
        // 显示内容坐上角偏移的位置:contentOffset
        self.pageControl.currentPage = scrollView.contentOffset.x/320;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 将要开始拖动
    NSLog(@"%i:%s",scrollView.tag,__func__);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    // 将要结束拖动
    NSLog(@"%i:%s",scrollView.tag,__func__);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 已经结束拖动
    NSLog(@"%i:%s",scrollView.tag,__func__);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;   // called on finger up as we are moving
{
    // 将要开始减速
    NSLog(@"%i:%s",scrollView.tag,__func__);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
{
    // 已经结束减速
    NSLog(@"%i:%s",scrollView.tag,__func__);
}

@end
