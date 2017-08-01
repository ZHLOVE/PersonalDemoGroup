//
//  SJGuideViewController.m
//  ShiJia
//
//  Created by yy on 16/4/25.
//  Copyright © 2016年 Ysten. All rights reserved.
//

#import "SJGuideViewController.h"
#import "SJLoginViewController.h"

#import "SJGuideItemView.h"

@interface SJGuideViewController ()<UIScrollViewDelegate>
{
    IBOutlet UIScrollView  *_scrollView;
    IBOutlet UIPageControl *_pageControl;
    IBOutlet UIButton      *_loginButton;
    IBOutlet UIButton      *_tryButton;
             UIView        *_contentView;
    
    
    NSArray        *_titles;
    NSArray        *_details;
    NSMutableArray *_subviewArray;
}

@end

@implementation SJGuideViewController

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _titles = @[@"个性",@"发现",@"社交"];
        _details = @[@"兴趣节目 定时推荐",@"海量大片 想看就看",@"边聊边看 约片神器"];
        _subviewArray = [[NSMutableArray alloc] init];
        
        _loginButton.layer.cornerRadius = 2.0;
        _loginButton.layer.masksToBounds = YES;
        
        _tryButton.layer.cornerRadius = 2.0;
        _tryButton.layer.masksToBounds = YES;
        
        _contentView = [[UIView alloc] init];
        
        for (int i = 0; i < _titles.count; i++) {
            
            SJGuideItemView *itemview = [[SJGuideItemView alloc] initWithTitle:_titles[i] detailText:_details[i] image:[UIImage imageNamed:[NSString stringWithFormat:@"guide_image_%zd",i]]];
            itemview.tag = i;
            [_contentView addSubview:itemview];
            
            [_subviewArray addObject:itemview];
            
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_scrollView addSubview:_contentView];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat originx = 0;
    
    for (int i = 0; i < _subviewArray.count; i++) {
        
        SJGuideItemView *itemview = _subviewArray[i];
        
        itemview.frame = CGRectMake(originx,
                                    0,
                                    _scrollView.frame.size.width,
                                    _scrollView.frame.size.height);
        
        
        
        originx = itemview.frame.size.width + itemview.frame.origin.x;

    }
    
    _contentView.frame = CGRectMake(0,
                                    0,
                                    originx,
                                    _scrollView.frame.size.height);
    
    _scrollView.contentSize = _contentView.size;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(_scrollView.frame);
    NSInteger page = floor((_scrollView.contentOffset.x - pageWidth / 2 ) / pageWidth ) +1;
    _pageControl.currentPage = page;
}

#pragma mark - Event
- (IBAction)loginButtonClicked:(id)sender
{
    SJLoginViewController *login = [[SJLoginViewController alloc] init];
    [self presentViewController:login animated:YES completion:nil];
}

- (IBAction)tryButtonClicked:(id)sender
{

}

@end


