//
//  CaptureImageVC.m
//  WingsBurning
//
//  Created by MBP on 16/8/23.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "CaptureImageVC.h"
#import "RegisterVC.h"
#import "M80AttributedLabel.h"
#import "UIImage+Rotate.h"

@interface CaptureImageVC ()

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIImageView *photoImageView;
@property (nonatomic,strong) UIView *bottomBar;
@property (nonatomic,strong) UIButton *checkBtn;

@property (nonatomic,strong) CAGradientLayer *gradientLayer;
@property (nonatomic,strong) UIVisualEffectView *blurEffView;

@property (nonatomic,strong) M80AttributedLabel *resultLabel;
@property (nonatomic,strong) M80AttributedLabel *resultLabel2;
@property (nonatomic,strong) M80AttributedLabel *resultLabel3;
@property (nonatomic,strong) M80AttributedLabel *resultLabel4;


//@property (nonatomic,assign) CLLocationCoordinate2D wgsLocation;


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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self showAnimation];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


#pragma mark 动画效果
- (void)showAnimation{
    __weak typeof(self) weakSelf = self;
    CGRect frame = self.blurEffView.frame;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.resultLabel.frame = CGRectMake(18 * ratio, frame.origin.y, frame.size.width, frame.size.height);
        weakSelf.resultLabel.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakSelf.resultLabel2.frame = CGRectMake(18 * ratio, frame.origin.y + 25*ratio, frame.size.width, frame.size.height);
            weakSelf.resultLabel2.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.resultLabel3.frame = CGRectMake(18 * ratio, frame.origin.y + 50*ratio, frame.size.width, frame.size.height);
                weakSelf.resultLabel3.alpha = 1.0f;
            } completion:^(BOOL finished) {
                if ([_faceResutltArray containsObject:@(0)]) {
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        weakSelf.resultLabel4.frame = CGRectMake(18 * ratio, frame.origin.y + 75*ratio, frame.size.width, frame.size.height);
                        weakSelf.resultLabel4.alpha = 1.0f;
                    } completion:nil];
                }
                [UIView animateWithDuration:0.3 animations:^{
                    self.checkBtn.alpha = 1.0f;
                    self.checkBtn.enabled = YES;
                    if (self.checkBtn.tag == 9002 && !self.changeFace) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if (self.checkBtn.enabled) {
                                [self checkBtnPressed];
                            }
                        });
                    }
                }];
            }];
        }];
    }];
}


- (void)setUpUI{
    self.view.backgroundColor = [UIColor blackColor];
    if (self.changeFace) {
        self.navigationItem.title = @"更换头像";
    }else{
        self.navigationItem.title = @"人脸信息采集";
    }
    __weak typeof (self) weakSelf = self;
    [self.view addSubview:self.photoImageView];
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(667 * ratio);
    }];


    [self.view addSubview:self.blurEffView];
    [self.view addSubview:self.resultLabel];
    [self.view addSubview:self.resultLabel2];
    [self.view addSubview:self.resultLabel3];
    [self.view addSubview:self.resultLabel4];
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


/**人脸检测通过时*/
- (void)checkBtnPressed{
    self.checkBtn.enabled = NO;
    if (self.firstPunch) {
        RegisterVC *revc = [[RegisterVC alloc]init];
        NSString *phoneType = [Verify getPhoneType];
        //imageSize 720 * 1280
        //iphone7/7p  1080*1920
        if ([phoneType rangeOfString:@"iPhone 7"].length > 0) {
            revc.userImage = [[self.image subImageWithRect:CGRectMake(0, 0, 900*1.5, 720*1.5)]rotate:UIImageOrientationRightMirrored];
        }else{
            revc.userImage = [[self.image subImageWithRect:CGRectMake(0, 0, 900, 720)]rotate:UIImageOrientationRightMirrored];
        }
        [self.navigationController pushViewController:revc animated:YES];
    }
    if (self.changeFace) {
        [self changeFaceImage];
    }
}

/**人脸检测未通过时*/
- (void)checkBtnPressedWithFaceFail{
    NSArray *array = self.navigationController.viewControllers;
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: (array.count - 2)] animated:YES];
}

/**
 *  更新人脸头像
 */
- (void)changeFaceImage{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
    NSString *phoneType = [Verify getPhoneType];
    //imageSize 720 * 1280
    //iphone7/7p  1080*1920
    UIImage *mirroredImg = [[UIImage alloc]init];
    if ([phoneType rangeOfString:@"iPhone 7"].length > 0) {
        mirroredImg = [[self.image subImageWithRect:CGRectMake(0, 0, 900*1.5, 720*1.5)]rotate:UIImageOrientationRightMirrored];
    }else{
        mirroredImg = [[self.image subImageWithRect:CGRectMake(0, 0, 900, 720)]rotate:UIImageOrientationRightMirrored];
    }
    NSData *imgData = UIImageJPEGRepresentation(mirroredImg, 0.2);
    EmployeePunches *model = [[EmployeePunches alloc]init];
    EmployeeM *employee = [Verify getEmployeeFromSandBox];
    model.imageHash = [SHA1 getSHA1:imgData];
    TokensM *tokens = [Verify getTokenFromSanBox];
    /**传图到七牛*/
    BOOL isHttps = TRUE;
    QNZone * httpsZone = [[QNAutoZone alloc] initWithHttps:isHttps dns:nil];
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = httpsZone;
    }];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    QNUploadOption *option = [[QNUploadOption alloc]initWithMime:@"jpeg" progressHandler:nil params:nil checkCrc:false cancellationSignal:nil];
    [Networking xiuGaiGuYuanTouXiang:employee.ID token:tokens successBlock:^(EmployeeM *employee, ImageUploadToken *imgUpTokens) {
        /**传图到七牛*/
        [upManager putData:imgData key:imgUpTokens.key token:imgUpTokens.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            DLog(@"修改成功返回信息%@", resp);
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"修改成功";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                //上传成功后头像做本地存储
                [Verify saveEmployeeImage:imgData];
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        } option:option];
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        NSString *str = [NSString stringWithFormat:@"网络错误"];
        hud.label.text = str;
        [hud hideAnimated:YES afterDelay:1.5];
    }];
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
        /**包含0表示未通过*/
        if ([_faceResutltArray containsObject:@(0)]) {
            [_checkBtn setImage:[UIImage imageNamed:@"button_shutter"] forState:UIControlStateNormal];
            _checkBtn.contentMode = UIViewContentModeScaleToFill;
            [_checkBtn addTarget:self action:@selector(checkBtnPressedWithFaceFail) forControlEvents:UIControlEventTouchUpInside];
            _checkBtn.tag = 9001;
        }else{
            [_checkBtn setImage:[UIImage imageNamed:@"button_check"] forState:UIControlStateNormal];
            _checkBtn.contentMode = UIViewContentModeScaleToFill;
            [_checkBtn addTarget:self action:@selector(checkBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            _checkBtn.tag = 9002;
        }
        _checkBtn.alpha = 0.0f;
        _checkBtn.enabled = NO;
    }
    return _checkBtn;
}

/**渐变透明毛玻璃*/
- (UIVisualEffectView *)blurEffView{
    if (_blurEffView == nil) {
        _blurEffView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _blurEffView.frame = CGRectMake(0, screenHeight-247*ratio-64, screenWidth, 129 * ratio);
        _blurEffView.alpha = 1.0f;
        _blurEffView.backgroundColor = [UIColor clearColor];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = _blurEffView.bounds;
        gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                                 (__bridge id)[UIColor whiteColor].CGColor,
                                 (__bridge id)[UIColor colorWithHexString:@"#000000"].CGColor];
        gradientLayer.locations = @[@(0.0),@(1.0)];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        _blurEffView.layer.mask = gradientLayer;
    }
    return _blurEffView;
}



- (M80AttributedLabel *)resultLabel{
    if (_resultLabel == nil) {
        CGRect frame = self.blurEffView.frame;
        _resultLabel = [[M80AttributedLabel alloc]initWithFrame:CGRectMake(18 * ratio, frame.origin.y + frame.size.height, frame.size.width,20)];
        _resultLabel.font      = [UIFont systemFontOfSize:14];
        _resultLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _resultLabel.backgroundColor = [UIColor clearColor];
        _resultLabel.alpha = 0.0f;
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:@"未通过"];
        [attributedText m80_setTextColor:[UIColor colorWithHexString:@"#fe916f"]];
        [attributedText m80_setFont:[UIFont systemFontOfSize:14]];

        int num = [_faceResutltArray[0] intValue];
        [_resultLabel appendText:@"人脸检测"];
        if (num < 1) {
            [_resultLabel appendAttributedText:attributedText];
        }else{
            [_resultLabel appendText:@"通过"];
        }
    }
    return _resultLabel;
}

- (M80AttributedLabel *)resultLabel2{
    if (_resultLabel2 == nil) {
        CGRect frame = self.resultLabel.frame;
        _resultLabel2 = [[M80AttributedLabel alloc]initWithFrame:CGRectMake(18 * ratio, frame.origin.y + frame.size.height, frame.size.width,20)];
        _resultLabel2.font      = [UIFont systemFontOfSize:14];
        _resultLabel2.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _resultLabel2.backgroundColor = [UIColor clearColor];
        _resultLabel2.alpha = 0.0f;
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:@"未通过"];
        [attributedText m80_setTextColor:[UIColor colorWithHexString:@"#fe916f"]];
        [attributedText m80_setFont:[UIFont systemFontOfSize:14]];

        int num = [_faceResutltArray[1] intValue];
        [_resultLabel2 appendText:@"姿态检测"];
        if (num < 1) {
            [_resultLabel2 appendAttributedText:attributedText];
        }else{
            [_resultLabel2 appendText:@"通过"];
        }
    }
    return _resultLabel2;
}

- (M80AttributedLabel *)resultLabel3{
    if (_resultLabel3 == nil) {
        CGRect frame = self.resultLabel2.frame;
        _resultLabel3 = [[M80AttributedLabel alloc]initWithFrame:CGRectMake(18 * ratio, frame.origin.y + frame.size.height, frame.size.width, 20)];
        _resultLabel3.font      = [UIFont systemFontOfSize:14];
        _resultLabel3.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _resultLabel3.backgroundColor = [UIColor clearColor];
        _resultLabel3.alpha = 0.0f;
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:@"未通过"];
        [attributedText m80_setTextColor:[UIColor colorWithHexString:@"#fe916f"]];
        [attributedText m80_setFont:[UIFont systemFontOfSize:14]];

        int num = [_faceResutltArray[2] intValue];
        [_resultLabel3 appendText:@"光线检测"];
        if (num < 1) {
            [_resultLabel3 appendAttributedText:attributedText];
        }else{
            [_resultLabel3 appendText:@"通过"];
        }
    }
    return _resultLabel3;
}

- (M80AttributedLabel *)resultLabel4{
    if (_resultLabel4 == nil) {
        CGRect frame = self.resultLabel2.frame;
        _resultLabel4 = [[M80AttributedLabel alloc]initWithFrame:CGRectMake(18 * ratio, frame.origin.y + frame.size.height, frame.size.width, 20)];
        _resultLabel4.font      = [UIFont systemFontOfSize:14];
        _resultLabel4.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _resultLabel4.backgroundColor = [UIColor clearColor];
        _resultLabel4.alpha = 0.0f;
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:@"未通过"];
        [attributedText m80_setTextColor:[UIColor colorWithHexString:@"#fe916f"]];
        [attributedText m80_setFont:[UIFont systemFontOfSize:14]];
        _resultLabel4.text = @"请点击拍照按钮重新拍摄";
    }
    return _resultLabel4;
}



@end
