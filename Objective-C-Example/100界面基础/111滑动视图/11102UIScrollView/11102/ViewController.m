//
//  ViewController.m
//  11102
//
//  Created by niit on 16/2/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "NIITImageScrollView.h"
#import "QXHImageScrollView.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 1.
    for(int i=0;i<6;i++)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 160)];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpeg",i+1]];
        [self.scrollView addSubview:imgView];
    }
    self.scrollView.contentSize = CGSizeMake(320*6, 160);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.pageControl.numberOfPages = 6;
    self.pageControl.currentPage = 0;
    
    self.pageControl.pageIndicatorTintColor = [UIColor redColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    
    // 2. 纯代码封装
    NIITImageScrollView *myScrollView = [[NIITImageScrollView alloc] initWithFrame:CGRectMake(0, 200, 320, 160)];
    myScrollView.imageNames = @[@"1.jpeg",@"2.jpeg",@"3.jpeg",@"4.jpeg"];
    myScrollView.curColor = [UIColor blueColor];
    myScrollView.otherColor = [UIColor greenColor];
    [self.view addSubview:myScrollView];
    
    // 3. 使用xib
    
    // loadNibNamed 返回xib文件中视图对象数组
    QXHImageScrollView *myScrollView2 = [QXHImageScrollView imageScrollView];
    myScrollView2.imageNames = @[@"1.jpeg",@"2.jpeg",@"3.jpeg",@"4.jpeg"];
    myScrollView2.frame = CGRectMake(0, 350, 320, 160);
    myScrollView2.curColor = [UIColor blueColor];
    myScrollView2.otherColor = [UIColor greenColor];
    [self.view addSubview:myScrollView2];
    
    
    
}

#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / 320;
}

@end
