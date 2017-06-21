//
//  CameraVC.m
//  WingsBurning
//
//  Created by MBP on 16/8/23.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "CameraVC.h"
#import "LLSimpleCamera.h"
#import "CaptureImageVC.h"
@interface CameraVC ()

@property(nonatomic,strong) UIImageView *guideLine;
@property(nonatomic,strong) UIView *bottomBar;
@property(nonatomic,strong) UIButton *snapButton;
@property(nonatomic,strong) LLSimpleCamera *camera;
@property (strong, nonatomic) UILabel *errorLabel;


@end

@implementation CameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self setCamera];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.camera start];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.camera stop];
}

- (void)setUpUI{
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"人脸信息采集";
    __weak typeof (self) weakSelf = self;
    CGRect frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.camera attachToViewController:self withFrame:frame];
    [self.view addSubview:self.guideLine];
    [self.guideLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.view.mas_centerY).offset(-80 * ratio);
        make.height.with.mas_equalTo(181 * ratio);
    }];
    [self.view addSubview:self.bottomBar];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(133 * ratio);
    }];
    [self.bottomBar addSubview:self.snapButton];
    [self.snapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.bottomBar.center);
        make.height.width.mas_equalTo(80 * ratio);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self snapBtnPressed];
}

/**
 *  相机权限设置
 */
- (void)setCamera{
    __weak typeof (self) weakSelf = self;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        NSLog(@"相机错误: %@", error);

        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission ||
               error.code == LLSimpleCameraErrorCodeMicrophonePermission) {
                if(weakSelf.errorLabel) {
                    [weakSelf.errorLabel removeFromSuperview];
                }
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.text = @"提示:请在系统设置中打开相机权限";
                label.numberOfLines = 2;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0f];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                [label sizeToFit];
                label.center = CGPointMake(screenRect.size.width / 2.0f, screenRect.size.height / 2.0f);
                weakSelf.errorLabel = label;
                [weakSelf.view addSubview:weakSelf.errorLabel];
            }
        }
    }];
}

/**
 *  拍照
 */
- (void)snapBtnPressed{
    __weak typeof (self) weakSelf = self;
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if(!error) {
            UIImage *mirroredImg = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationLeftMirrored];
            CaptureImageVC *capVC = [[CaptureImageVC alloc] initWithImage:mirroredImg];
            [weakSelf.navigationController pushViewController:capVC animated:YES];
        }
        else {
            NSLog(@"拍照出错:%@", error);
        }
    } exactSeenImage:YES];
}

/**
 *  检查图片
 */
- (void)checkPicture{

}




#pragma mark-控件设定
- (LLSimpleCamera *)camera{
    if (_camera == nil) {
        _camera = [[LLSimpleCamera alloc]initWithQuality:AVCaptureSessionPresetHigh position:CameraPositionFront videoEnabled:NO];
    }
    return _camera;
}

- (UIImageView *)guideLine{
    if (_guideLine == nil) {
        _guideLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"subline"]];
    }
    return _guideLine;
}

- (UIView *)bottomBar{
    if (_bottomBar == nil) {
        _bottomBar = [[UIView alloc]init];
        _bottomBar.backgroundColor = [UIColor whiteColor];
    }
    return _bottomBar;
}

- (UIButton *)snapButton{
    if (_snapButton == nil) {
        _snapButton = [[UIButton alloc]init];
        [_snapButton setImage:[UIImage imageNamed:@"button_shutter"] forState:UIControlStateNormal];
        _snapButton.contentMode = UIViewContentModeScaleToFill;
        [_snapButton addTarget:self action:@selector(snapBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _snapButton;
}





























@end
