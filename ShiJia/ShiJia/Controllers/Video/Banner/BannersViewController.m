//
//  BannersViewController.m
//  HiTV
//
//  created by iSwift on 3/7/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "BannersViewController.h"
#import "MBProgressHUD.h"
#import "VideoDataProvider.h"
#import "BannerViewController.h"

@interface BannersViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageControlWidthConstraint;
@property (strong, nonatomic) NSArray* controllers;
@property (strong, nonatomic) NSTimer* timer;

@end

@implementation BannersViewController


- (void)setRecommends:(NSArray *)recommends{
    _recommends = recommends;
    [self p_reloadData];
}

- (void)p_reloadData{
    [self p_allocBannerControllersWithCount:self.recommends.count];
    for (int index = 0; index < self.recommends.count; index++) {
        BannerViewController* controller = self.controllers[index];
        controller.view.frame = CGRectMake(index* W, 0, W, BannerHeight);
        controller.video = self.recommends[index];
    }
    
    self.scrollView.contentSize = CGSizeMake(W * self.recommends.count, self.scrollView.frame.size.height);
    self.pageControl.numberOfPages = self.recommends.count;
    self.pageControl.hidden = NO;
    [self.view setNeedsLayout];
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
    }
}

- (void)p_allocBannerControllersWithCount:(NSUInteger)count{
    if (count > self.controllers.count) {
        NSMutableArray* controllers = [self.controllers mutableCopy];
        if (controllers == nil) {
            controllers = [[NSMutableArray alloc] init];
        }
        for (NSUInteger index = self.controllers.count; index < count; index ++) {
            BannerViewController* controller = [[BannerViewController alloc] init];
            controller.view.frame = CGRectMake(0, 0, W, BannerHeight);

            [controllers addObject:controller];
            [self.scrollView addSubview:controller.view];
        }
        self.controllers = controllers;
    }else if (count < self.controllers.count){
        for (NSUInteger index = count; index < self.controllers.count; index ++) {
            BannerViewController* controller = self.controllers[index];
            controller.view.frame = CGRectMake(0, 0, W, BannerHeight);
            [controller.view removeFromSuperview];
        }
        self.controllers = [self.controllers subarrayWithRange:NSMakeRange(0, count)];
    }
    
}

- (void)viewWillLayoutSubviews{
    self.pageControlWidthConstraint.constant = 16*(self.pageControl.numberOfPages+1);
}

#pragma mark - Actions

- (IBAction)pageControlValueChanged:(id)sender{
    CGFloat width = W - self.scrollView.contentInset.left - self.scrollView.contentInset.right;
    [self.scrollView setContentOffset:CGPointMake(self.pageControl.currentPage * width, 0) animated:YES];
}

#pragma mark - NSTimer
-(void)scrollToNextPage:(id)sender
{
    CGFloat pageWidth = W;
    CGFloat pageheight = self.scrollView.frame.size.height;

    NSInteger pageNum=_pageControl.currentPage;
    CGRect rect=CGRectMake((pageNum+1)*pageWidth, 0, pageWidth, pageheight);
    
    [self.scrollView scrollRectToVisible:rect animated:YES];
    pageNum++;
    if (pageNum==self.recommends.count) {
        CGRect newRect=CGRectMake(0, 0, pageWidth, pageheight);
        [self.scrollView scrollRectToVisible:newRect animated:YES];
    }
    
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int pageNumber = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = pageNumber;
    
    BannerViewController* controller = self.controllers[pageNumber];
    [controller viewWillAppear:YES];
}
@end
