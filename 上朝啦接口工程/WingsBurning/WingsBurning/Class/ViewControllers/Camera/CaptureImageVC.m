//
//  CaptureImageVC.m
//  WingsBurning
//
//  Created by MBP on 16/8/23.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "CaptureImageVC.h"
#import "RegisterVC.h"
@interface CaptureImageVC ()

@property(nonatomic,strong) UIImage *image;
@property(nonatomic,strong) UIImageView *photoImageView;
@property(nonatomic,strong) UIView *bottomBar;
@property(nonatomic,strong) UIButton *checkBtn;


@end

@implementation CaptureImageVC

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        _image = image;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpUI];
}

- (void)setUpUI{
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"人脸信息采集";
    __weak typeof (self) weakSelf = self;

    [self.view addSubview:self.photoImageView];
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(667 * ratio);
    }];
    [self.view addSubview:self.bottomBar];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(133 * ratio);
    }];
    [self.bottomBar addSubview:self.checkBtn];
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.bottomBar.center);
        make.height.width.mas_equalTo(80 * ratio);
    }];

}

- (void)checkBtnPressed{
    RegisterVC *revc = [[RegisterVC alloc]initWithImage:self.image];
    [self.navigationController pushViewController:revc animated:YES];
}


#pragma mark-控件设置

- (UIImageView *)photoImageView{
    if (_photoImageView == nil) {
        _photoImageView = [[UIImageView alloc]initWithImage:_image];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _photoImageView;
}

- (UIView *)bottomBar{
    if (_bottomBar == nil) {
        _bottomBar = [[UIView alloc]init];
        _bottomBar.backgroundColor = [UIColor whiteColor];
    }
    return _bottomBar;
}

- (UIButton *)checkBtn{
    if (_checkBtn == nil) {
        _checkBtn = [[UIButton alloc]init];
        [_checkBtn setImage:[UIImage imageNamed:@"button_check"] forState:UIControlStateNormal];
        _checkBtn.contentMode = UIViewContentModeScaleToFill;
        [_checkBtn addTarget:self action:@selector(checkBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBtn;
}



@end
