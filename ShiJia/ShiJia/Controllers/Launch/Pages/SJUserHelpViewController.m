//
//  SJUserHelpViewController.m
//  ShiJia
//
//  Created by 峰 on 16/7/27.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJUserHelpViewController.h"
#import "SJSetFavoriteViewController.h"
#import "QRCodeController.h"
#import "SJLightViewController.h"

@interface SJUserHelpViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView  *imageView;
@property (nonatomic, strong) UIButton     *scanButton;

@end

@implementation SJUserHelpViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"帮助";
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *jumpTtem = [[UIBarButtonItem alloc]initWithTitle:@"跳过" style:UIBarButtonItemStylePlain
                                                               target:self action:@selector(jumpGuide:)];
    [jumpTtem setTintColor:[UIColor whiteColor]];

    self.navigationItem.rightBarButtonItem = jumpTtem;
    //
    //    UIView *ssview = [UIView new];
    //    self
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    UIView *contentView = [UIView new];
    [self.scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.image = [UIImage imageNamed:@"img_locat_castscreen_intro"];
    [self.scrollView addSubview:_imageView];
    CGSize sizeA = [UIImage imageNamed:@"img_locat_castscreen_intro"].size;
    
    _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _scanButton.backgroundColor = [UIColor whiteColor];
    [_scanButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [_scanButton addTarget:self action:@selector(goScanVC) forControlEvents:UIControlEventTouchUpInside];
    [_scanButton setTitle:@"扫一扫" forState:UIControlStateNormal];
    [self.scrollView addSubview:_scanButton];
    
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView);
        make.top.mas_equalTo(self.scrollView).offset(10);
        make.height.mas_equalTo(sizeA.height);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [_scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageView.mas_bottom).offset(10);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_scanButton.mas_bottom);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)jumpGuide:(id)sender {
    if ([HiTVGlobals sharedInstance].interested) {
        [self showMainViewController];
    }
    else{
        SJLightViewController * favoriteVC = [[SJLightViewController alloc] init];
        [self.navigationController pushViewController:favoriteVC animated:YES];
    }
//#ifdef BeiJing
//    [self showMainViewController];
//#else
//    /*SJSetFavoriteViewController *setFavoriteVC = [[SJSetFavoriteViewController alloc]init];
//     [self.navigationController pushViewController:setFavoriteVC animated:YES];*/
//    SJLightViewController * favoriteVC = [[SJLightViewController alloc] init];
//    [self.navigationController pushViewController:favoriteVC animated:YES];
//    
//#endif

}
-(void)showMainViewController{
    [AppDelegate appDelegate].appdelegateService.SetF = YES;
    [[AppDelegate appDelegate].appdelegateService showMainViewController];
}
- (void)goScanVC{
    QRCodeController *vc = [[QRCodeController alloc]init];
    vc.isGuide = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
