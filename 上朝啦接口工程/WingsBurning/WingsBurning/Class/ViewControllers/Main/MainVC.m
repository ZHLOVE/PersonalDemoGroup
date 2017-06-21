//
//  MainVC.m
//  WingsBurning
//
//  Created by MBP on 16/8/24.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "MainVC.h"
#import "AppDelegate.h"
@interface MainVC ()
@property(nonatomic,strong) UIImageView *backImageView;
@property(nonatomic,strong) UIImageView *bottomImageView;
@property(nonatomic,strong) UIBarButtonItem *leftBtn;
@property(nonatomic,strong) UIBarButtonItem *rightBtn;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *dateLabel;
@property(nonatomic,strong) UIButton *punchyBtn;
@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self setNavigation];
}

- (void)viewWillAppear:(BOOL)animated{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)leftBtnPressed{
     AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {

    }];
}

- (void)rightBtnPressed{


}

- (void)goToPunch{

}

- (void)setUpUI{
    __weak typeof (self) weakSelf = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backImageView];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view);
        make.left.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(200 * ratio + 64);
    }];
    [self.view addSubview:self.bottomImageView];
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(135 * ratio);
    }];
    [self.view addSubview:self.punchyBtn];
    [self.punchyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(111 * ratio);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-80 * ratio);
    }];
    [self.view addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view);
        make.centerY.mas_equalTo(weakSelf.backImageView.mas_centerY).offset(20);
        make.width.mas_equalTo(160 * ratio);
        make.height.mas_equalTo(40 * ratio);
    }];
    [self.view addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.timeLabel.mas_bottom).offset(17 * ratio);
        make.width.mas_equalTo(160 * ratio);
        make.height.mas_equalTo(15 * ratio);
    }];

}




- (void)setNavigation{
    self.navigationItem.title = @"打卡";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationItem.leftBarButtonItem = self.leftBtn;
    self.navigationItem.rightBarButtonItem = self.rightBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}















//设置导航条样式
//func setNavigation() {
//    self.navigationController?.setNavigationBarHidden(false, animated: false)
//    self.navigationItem.title = "打卡"
//    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//    //导航条透明
//    self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), forBarMetrics: UIBarMetrics.Default)
//    self.navigationController?.navigationBar.translucent = true
//    self.navigationController?.navigationBar.shadowImage = UIImage.init()
//    //leftBtn
//    self.navigationItem.leftBarButtonItem = self.leftBtn
//    self.navigationItem.rightBarButtonItem = self.rightBtn
//    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
//}



#pragma mark-控件设置
- (UIImageView *)backImageView{
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clockin_topbg"]];
    }
    return _backImageView;
}

- (UIImageView *)bottomImageView{
    if (_bottomImageView == nil) {
        _bottomImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clockin_bg"]];
    }
    return _bottomImageView;
}

- (UIBarButtonItem *)leftBtn{
    if (_leftBtn == nil) {
        _leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"button_more"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnPressed)];
    }
    return _leftBtn;
}

- (UIBarButtonItem *)rightBtn{
    if (_rightBtn == nil) {
        _rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"打卡记录" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnPressed)];
    }
    return _rightBtn;
}

- (UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc]init];
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        format.dateFormat = @"HH:mm";
        NSString *dateString = [format stringFromDate:nowDate];
        _timeLabel.text = dateString;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:44];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UILabel *)dateLabel{
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc]init];
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        format.dateFormat = @"yyyy-MM-dd";
        NSString *dateString = [format stringFromDate:nowDate];
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.font = [UIFont systemFontOfSize:13];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        NSString *weekDay = [Verify weekdayStringFromDate:nowDate];
        NSString *showStr = [NSString stringWithFormat:@"%@   %@",dateString,weekDay];
        _dateLabel.text = showStr;
    }
    return _dateLabel;
}

- (UIButton *)punchyBtn{
    if (_punchyBtn == nil) {
        _punchyBtn = [[UIButton alloc]init];
        [_punchyBtn setBackgroundImage:[UIImage imageNamed:@"button_clockin"] forState:UIControlStateNormal];
        _punchyBtn.layer.cornerRadius = 47.0;
        [_punchyBtn addTarget:self action:@selector(goToPunch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _punchyBtn;
}



@end
