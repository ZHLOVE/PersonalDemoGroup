//
//  GuideVC.m
//  WingsBurning
//
//  Created by MBP on 16/9/28.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "GuideVC.h"
#import "GuideView.h"
#import "TAPageControl.h"
#import "Login.h"
#import "RegisterCameraVC.h"
@interface GuideVC ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) TAPageControl *pageControl;

@property(nonatomic,strong) UIButton *enterBtn;

@end

@implementation GuideVC




- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self scrollViewSubView];
}

- (void)scrollViewSubView{
    NSArray *picNameArr = @[@"picture1",@"picture2",@"picture3"];
    NSArray *firStrArr = @[@"手机一键打卡",@"查看你的考勤记录",@"借我打一下卡"];
    NSArray *secStrArr = @[@"只需要手机和脸 打卡再也不用排队",@"再也不用为莫名其妙的迟到找HR扯皮了",@"忘带手机没关系 借他打卡更贴心"];
    for (int i=0; i<3; i++) {
        GuideView *gv = [[GuideView alloc]initWithFrame:CGRectMake(screenWidth * i, 0, screenWidth, screenHeight - 143 * ratio)];
        gv.imageName = picNameArr[i];
        gv.firstStr = firStrArr[i];
        gv.secondStr = secStrArr[i];
        [self.scrollView addSubview:gv];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark -事件

//进入App
- (void)enterAppBtnPressed{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)setUpUI{
    //加背景渐变
    self.view=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithHexString:@"#02ca72"] CGColor], (id)[[UIColor colorWithHexString:@"#10e26f"] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    __weak typeof(self) weakSelf = self;
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.scrollView.mas_bottom).offset(-142 * ratio);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    [self.scrollView addSubview:self.enterBtn];
}

#pragma mark -ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageControl.currentPage = scrollView.contentOffset.x/screenWidth;

}

#pragma mark -懒加载
- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 0,screenWidth,screenHeight);
        _scrollView.contentSize = CGSizeMake(screenWidth * 3, screenHeight);
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate =self;
    }
    return _scrollView;
}

- (TAPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[TAPageControl alloc]init];
        _pageControl.numberOfPages = 3;
        _pageControl.currentPage = 0;
        _pageControl.currentDotImage = [UIImage imageNamed:@"control_current"];
        _pageControl.dotImage = [UIImage imageNamed:@"control_default"];
    }
    return _pageControl;
}




- (UIButton *)enterBtn{
    if (_enterBtn == nil) {
        _enterBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth * 2.5  - 100 * ratio, screenHeight - 112 * ratio, 200 * ratio, 42 * ratio)];
        [_enterBtn setTitle:@"进入上朝啦" forState:UIControlStateNormal];
        _enterBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_enterBtn setBackgroundColor:[UIColor clearColor]];
        _enterBtn.layer.cornerRadius = 21 * ratio;
        _enterBtn.layer.borderWidth = 1.0f;
        _enterBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_enterBtn addTarget:self action:@selector(enterAppBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterBtn;
}

@end
























