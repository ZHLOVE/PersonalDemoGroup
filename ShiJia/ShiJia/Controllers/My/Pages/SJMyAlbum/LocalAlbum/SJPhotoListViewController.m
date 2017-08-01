//
//  SJPhotoListViewController.m
//  ShiJia
//
//  Created by 峰 on 16/8/30.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJPhotoListViewController.h"
#import "YFViewPager.h"
#import "SJLocalPhotoViewController.h"
#import "SJLocalVideoViewController.h"


@interface SJPhotoListViewController ()
@property (nonatomic, strong) UIView      *topView;
@property (nonatomic, strong) YFViewPager *pageVC;
@property (nonatomic, strong) SJLocalPhotoViewController *localPhotoView;
@property (nonatomic, strong) SJLocalVideoViewController *localVedioView;

@end

@implementation SJPhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.topView];
    [self addSubViewsContrains];
    self.title = @"本地相册";

}
#pragma mark // 本地图片VC

-(SJLocalPhotoViewController *)localPhotoView{
    if (!_localPhotoView) {
        _localPhotoView = [[SJLocalPhotoViewController alloc]init];
        _localPhotoView.superNavgation = self.navigationController;
    }
    return _localPhotoView;
}
#pragma mark // 本地视频VC

-(SJLocalVideoViewController *)localVedioView{
    if (!_localVedioView) {
        _localVedioView = [[SJLocalVideoViewController alloc]init];
        _localVedioView.superNavgation = self.navigationController;
    }
    return _localVedioView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UI part
-(UIView *)topView{
    if (!_topView) {
        _topView = [UIView new];
        _pageVC = [[YFViewPager alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-64)
                                              titles:@[@"照片",@"视频"]
                                               icons:nil
                                       selectedIcons:nil
                                               views:@[self.localPhotoView.view,self.localVedioView.view]];
//        _pageVC.backgroundColor = [UIColor blackColor];
        _pageVC.tabSelectedArrowBgColor = kColorBlueTheme;
        _pageVC.tabSelectedTitleColor = RGB(68, 68, 68, 1);
        _pageVC.tabArrowBgColor = RGB(229, 229, 229, 1);
        _pageVC.tabTitleColor = [UIColor blackColor];
        _pageVC.showVLine = YES;
        _pageVC.backgroundColor = [UIColor clearColor];
        [_topView addSubview:self.pageVC];
        
        
        [_pageVC didSelectedBlock:^(id viewPager, NSInteger index) {
            
        }];
    }
    return _topView;
}

-(void)addSubViewsContrains{
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(self.view);
    }];
}

@end
