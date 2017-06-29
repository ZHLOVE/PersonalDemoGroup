//
//  PunchImageVC.m
//  WingsBurning
//
//  Created by MBP on 2016/11/14.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "PunchImageVC.h"
#import "RegisterVC.h"
#import "M80AttributedLabel.h"
#import "UIImage+Rotate.h"
#import "MainVC.h"
#import "BaseNavigationCongroller.h"
#import "Record.h"
#import "JPUSHService.h"
@interface PunchImageVC ()

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIImageView *photoImageView;
@property (nonatomic,strong) UIView *bottomBar;
@property (nonatomic,strong) UIButton *checkBtn;
@property(nonatomic,strong) UIBarButtonItem *finashBtn;

@property (nonatomic,strong) CAGradientLayer *gradientLayer;
@property (nonatomic,strong) UIVisualEffectView *blurEffView;
@property (nonatomic,strong) M80AttributedLabel *resultLabel;
@property (nonatomic,strong) M80AttributedLabel *resultLabel2;
@property (nonatomic,strong) M80AttributedLabel *resultLabel3;
@property (nonatomic,strong) M80AttributedLabel *resultLabel4;

@property(nonatomic,strong) UILabel *psLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) MBProgressHUD *myHud;
@property(nonatomic,strong) NSString *punchTime;

@end

@implementation PunchImageVC



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
    // 注册极光自定义消息用于实时比对
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkDidReceiveMessage:)
                                                 name:kJPFNetworkDidReceiveMessageNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self checkBtnPressed];
    [self showAnimation];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidReceiveMessageNotification object:nil];
}


#pragma mark 动画效果
- (void)showAnimation{
    __weak typeof(self) weakSelf = self;
    CGRect frame = CGRectMake(self.blurEffView.frame.origin.x, self.blurEffView.frame.origin.y, self.blurEffView.frame.size.width, self.blurEffView.frame.size.height);
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
            }];
        }];
    }];
}

//**显示打卡成功信息，时间*/
- (void)showSuccessResult:(NSString *)time{
    self.psLabel.text = @"打卡完成";
    self.psLabel.textColor = [UIColor colorWithHexString:@"#02ca72"];
    NSString *tempStr = [time substringFromIndex:10];
    NSString *subStr = [tempStr substringToIndex:9];
    self.timeLabel.text = [NSString stringWithFormat:@"打卡时间为%@",subStr];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)showFailResult:(NSString *)str upLoadImgSuccess:(BOOL) upFlag{
    if ([str isEqualToString:@"人脸信息无效"]) {
        self.psLabel.text = @"人脸信息无效,打卡失败";
        self.timeLabel.text = @"请重新打卡";
    }else{
        self.psLabel.text = @"打卡失败";
        self.timeLabel.text = str;
    }
    self.psLabel.textColor = [UIColor colorWithHexString:@"#f55723"];
    self.navigationItem.rightBarButtonItem.enabled = upFlag;
}

- (void)setUpUI{
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = self.naviTitle;
    self.navigationItem.rightBarButtonItem = self.finashBtn;
    self.navigationItem.rightBarButtonItem.enabled = NO;
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

    [self.bottomBar addSubview:self.psLabel];
    [self.psLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.bottomBar.mas_top).offset(16 * ratio);
        make.centerX.mas_equalTo(weakSelf.bottomBar.mas_centerX);
        make.height.mas_equalTo(20 * ratio);
        make.width.mas_equalTo(200 * ratio);
    }];
    [self.bottomBar addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.psLabel.mas_bottom).offset(16 * ratio);
        make.centerX.mas_equalTo(weakSelf.bottomBar.mas_centerX);
        make.height.mas_equalTo(20 * ratio);
        make.width.mas_equalTo(200 * ratio);
    }];
}


/**人脸检测通过时*/
- (void)checkBtnPressed{
    DLog(@"%@",self.otherEmployeeID);
    if (self.otherEmployeeID != nil) {
        [self upLoadOtherPunchRecord];
    }else{
        [self upLoadPunchRecord];
    }
}

/**人脸检测未通过时*/
- (void)checkBtnPressedWithFaceFail{
    NSArray *array = self.navigationController.viewControllers;
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: (array.count - 2)] animated:YES];
}

// 接收到通知事件
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(faceTimeOut) object:nil];
    NSDictionary *userInfo = [notification userInfo];
    [self.myHud setMode:MBProgressHUDModeText];
    NSString *str = [userInfo valueForKey:@"content"];
    self.myHud.label.text = str;
    [self.myHud hideAnimated:YES afterDelay:1.5];
    NSDictionary *extrasDict = [userInfo valueForKey:@"extras"];
    int accepted = [[extrasDict valueForKey:@"accepted"]intValue];
    if (accepted) {
        [self showSuccessResult:self.punchTime];
    }else{
        [self showFailResult:@"人脸信息无效" upLoadImgSuccess:YES];
    }
}

/**
 *  比对超时
 */
- (void)faceTimeOut{
    DLog(@"比对超时");
    [self.myHud hideAnimated:YES];
    [self showFailResult:@"网络超时请重试" upLoadImgSuccess:NO];
}

/**
 *  上传本人打卡记录
 */
- (void)upLoadPunchRecord{
    self.myHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIImage *mirroredImg = [self.photoImageView.image rotate:UIImageOrientationRightMirrored];
    NSData *imgData = UIImageJPEGRepresentation(mirroredImg, 0.2);
    EmployeePunches *punchesModel = [[EmployeePunches alloc]init];
    NSString *phoneModel = [Verify getPhoneType];
    punchesModel.phone_model = phoneModel;
    punchesModel.imageHash = [SHA1 getSHA1:imgData];
    NSString *wifiName = [LCGetWiFiSSID getSSID];
    NSString *wifiMac = [LCGetWiFiSSID getBSSID];
    punchesModel.wirelessAp = [NSString stringWithFormat:@"WIFI:%@  MAC:%@",wifiName,wifiMac];
    NSString *appVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    punchesModel.operatingSystem = [NSString stringWithFormat:@"AppVersion:%@  SystemVersion:%@",appVersion,systemVersion];
    punchesModel.longitude = [Verify getLongitude];
    punchesModel.latitude = [Verify getLatitude];
    //    120.270429,31.472969
//    punchesModel.longitude = @(120.270429);
//    punchesModel.latitude = @(31.472969);
    TokensM *tokens = [Verify getTokenFromSanBox];
    /**传图到七牛*/
    BOOL isHttps = TRUE;
    QNZone * httpsZone = [[QNAutoZone alloc] initWithHttps:isHttps dns:nil];
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = httpsZone;
    }];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    QNUploadOption *option = [[QNUploadOption alloc]initWithMime:@"jpeg" progressHandler:nil params:nil checkCrc:false cancellationSignal:nil];
    [Networking daKa:punchesModel token:tokens successBlock:^(PunchesModel *punModel)
     {
         ImageUploadToken *imgToken = punModel.image_upload_token;
         Punch *p = punModel.punch;
         NSString *pTime = p.created_at;
         self.punchTime = pTime;
         [upManager putData:imgData key:imgToken.key token:imgToken.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
             if (info.ok) {
                 int testCompany = [[resp valueForKey:@"test_employer"] intValue];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     if (testCompany) {
                         self.myHud.label.text = @"人脸比对中";
                         [self performSelector:@selector(faceTimeOut) withObject:nil afterDelay:10];
                     }else{
                         [self.myHud hideAnimated:YES];
                         [self showSuccessResult:pTime];
                     }
                 });
             }else{
                 [self.myHud hideAnimated:YES];
                 [self showFailResult:@"网络错误请重试" upLoadImgSuccess:NO];
             }
         } option:option];
     } failBlock:^(NSString *errStr, NSInteger statusCode) {
         self.myHud.mode = MBProgressHUDModeText;
         NSString *str = @" ";
         switch (statusCode) {
             case 422:{
                 str = [NSString stringWithFormat:@"位置偏差太大"];
                 self.myHud.label.text = str;
                 [self.myHud hideAnimated:YES afterDelay:1.5];
             }break;
             case 429:{
                 str = [NSString stringWithFormat:@"打卡间隔太短"];
                 self.myHud.label.text = str;
                 [self.myHud hideAnimated:YES afterDelay:1.5];
             }break;
             default:{
                 str = [NSString stringWithFormat:@"网络错误请重试"];
                 self.myHud.label.text = str;
                 [self.myHud hideAnimated:YES afterDelay:1.5];
             }break;
         }
         [self showFailResult:str upLoadImgSuccess:NO];
     }];
}
/**
 *  上传他人打卡记录
 */
- (void)upLoadOtherPunchRecord{
    self.myHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIImage *mirroredImg = [self.photoImageView.image rotate:UIImageOrientationRightMirrored];
    NSData *imgData = UIImageJPEGRepresentation(mirroredImg, 0.2);
    EmployeePunches *punchesModel = [[EmployeePunches alloc]init];
    NSString *phoneModel = [Verify getPhoneType];
    punchesModel.phone_model = phoneModel;
    punchesModel.imageHash = [SHA1 getSHA1:imgData];
    NSString *wifiName = [LCGetWiFiSSID getSSID];
    NSString *wifiMac = [LCGetWiFiSSID getBSSID];
    punchesModel.wirelessAp = [NSString stringWithFormat:@"WIFI:%@  MAC:%@",wifiName,wifiMac];
    NSString *appVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    punchesModel.operatingSystem = [NSString stringWithFormat:@"AppVersion:%@  SystemVersion:%@",appVersion,systemVersion];
    punchesModel.longitude = [Verify getLongitude];
    punchesModel.latitude = [Verify getLatitude];
    TokensM *tokens = [Verify getTokenFromSanBox];
    [Networking tiBieRenDaKa:punchesModel employee_id:self.otherEmployeeID token:tokens successBlock:^(PunchesModel *punModel) {
        ImageUploadToken *imgToken = punModel.image_upload_token;
        Punch *p = punModel.punch;
        NSString *pTime = p.created_at;
        self.punchTime = pTime;
        /**传图到七牛*/
        BOOL isHttps = TRUE;
        QNZone * httpsZone = [[QNAutoZone alloc] initWithHttps:isHttps dns:nil];
        QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
            builder.zone = httpsZone;
        }];
        QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
        QNUploadOption *option = [[QNUploadOption alloc]initWithMime:@"jpeg" progressHandler:nil params:nil checkCrc:false cancellationSignal:nil];
        [upManager putData:imgData key:imgToken.key token:imgToken.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (info.ok) {
                int testCompany = [[resp valueForKey:@"test_employer"] intValue];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (testCompany) {
                        self.myHud.label.text = @"人脸比对中";
                        [self performSelector:@selector(faceTimeOut) withObject:nil afterDelay:20];
                    }else{
                        [self.myHud hideAnimated:YES];
                        [self showSuccessResult:pTime];
                    }
                });
            }else{
                [self.myHud hideAnimated:YES];
                [self showFailResult:@"网络错误请重试" upLoadImgSuccess:NO];
            }
        } option:option];
    } failBlock:^(NSString *errStr, NSInteger statusCode) {
        self.myHud.mode = MBProgressHUDModeText;
        NSString *str = @" ";
        switch (statusCode) {
            case 422:{
                str = [NSString stringWithFormat:@"位置偏差太大"];
                self.myHud.label.text = str;
                [self.myHud hideAnimated:YES afterDelay:1.5];
            }break;
            case 429:{
                str = [NSString stringWithFormat:@"打卡间隔太短"];
                self.myHud.label.text = str;
                [self.myHud hideAnimated:YES afterDelay:1.5];
            }break;
            default:{
                str = [NSString stringWithFormat:@"网络错误请重试"];
                self.myHud.label.text = str;
                [self.myHud hideAnimated:YES afterDelay:1.5];
            }break;
        }
        [self showFailResult:str upLoadImgSuccess:NO];

    }];
}



- (void)finashBtnPressed{
    BaseNavigationCongroller *navi = (BaseNavigationCongroller*)self.mm_drawerController.centerViewController;
    if (self.otherEmployeeID == nil) {
        Record *recordVC = [[Record alloc]init];
        [navi pushViewController:recordVC animated:YES];
    }else{
        self.otherEmployeeID = nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

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
        }else{
            [_checkBtn setImage:[UIImage imageNamed:@"button_check"] forState:UIControlStateNormal];
            _checkBtn.contentMode = UIViewContentModeScaleToFill;
            [_checkBtn addTarget:self action:@selector(checkBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        }

    }
    return _checkBtn;
}

/**渐变透明毛玻璃*/
- (UIVisualEffectView *)blurEffView{
    if (_blurEffView == nil) {
        _blurEffView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _blurEffView.frame = CGRectMake(0, screenHeight -232*ratio-64, screenWidth, 129 * ratio);
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

- (UILabel *)psLabel{
    if (_psLabel == nil) {
        _psLabel = [[UILabel alloc]init];
        _psLabel.font = [UIFont systemFontOfSize:16];
        _psLabel.textAlignment = NSTextAlignmentCenter;

    }
    return _psLabel;
}

- (UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _timeLabel.font = [UIFont systemFontOfSize:16];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}


- (UIBarButtonItem *)finashBtn{
    if (_finashBtn == nil) {
        _finashBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finashBtnPressed)];
    }
    return _finashBtn;
}

@end
