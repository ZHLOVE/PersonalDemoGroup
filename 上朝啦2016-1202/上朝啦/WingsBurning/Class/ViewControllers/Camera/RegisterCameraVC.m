//
//  CameraVC.m
//  WingsBurning
//
//  Created by MBP on 16/8/23.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "RegisterCameraVC.h"
#import "LLSimpleCamera.h"
#import "CaptureImageVC.h"

#import "JYManager.h"
@interface RegisterCameraVC ()

@property(nonatomic,strong) UIImageView *guideLine;
@property(nonatomic,strong) UIView *bottomBar;
@property(nonatomic,strong) UIButton *snapButton;
@property(nonatomic,strong) LLSimpleCamera *camera;
@property(nonatomic,strong) UILabel *errorLabel;

@property(nonatomic,weak) JYManager *jyManager;

@end

@implementation RegisterCameraVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self setCamera];
    self.jyManager = [JYManager sharedInstance];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.camera start];
    self.camera.dataOutPutBlock  = ^(CMSampleBufferRef sampleBuffer){
        
    };
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
        make.centerY.mas_equalTo(weakSelf.view.mas_centerY).offset(-50 * ratio);
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
            [weakSelf checkPictureWithImage:mirroredImg];
        }
        else {
            NSLog(@"拍照出错:%@", error);
        }
    } exactSeenImage:YES];
}

/**
 *  检查图片
 */
- (void)checkPictureWithImage:(UIImage *)image{
    /**传入算法*/
    int faceCount = [self.jyManager renLianShu:image];
    int count[8];
    int points88[176];
    int pose[3];
    int l = 1;
    int *light = &l;


    /**算法运算结果*/
    if (faceCount == 1) {
        [self.jyManager renLianQuYuZuoBiao:count];
        [self.jyManager renLianZiTai:pose];
        [self.jyManager renLian88Points:points88];
        [self.jyManager renLianGuangZhao:light];
    }

    BOOL facePose = YES;
    BOOL faceRect = YES;
    BOOL faceCenter = YES;
    BOOL faceLight = YES;
    CGPoint rightTop = CGPointMake(screenWidth - count[2] * screenWidth/540, count[3] * screenHeight/960 - 64);
    CGPoint leftBottom = CGPointMake(screenWidth - count[4] * screenWidth/540, count[5] * screenHeight/960 - 64);
    /**判定偏转角度*/
    for (int i=0; i<3; i++) {
        switch (i) {
            case 0:
                if (pose[i] > 30 || pose[i] < -30) {
                    facePose = NO;
                }break;
            case 1:
                if (pose[i] > 25 || pose[i] < -25) {
                    facePose = NO;
                }break;
            case 2:
                if (pose[i] > 10 || pose[i] < -10) {
                    facePose = NO;
                }break;
            default:
                break;
        }
    }


    /**判定脸部大小,32400引导匡大小*/
    CGSize size = CGSizeMake((leftBottom.x - rightTop.x), (leftBottom.y - rightTop.y));
    CGFloat mianJiCha = size.width * size.height - 32400;
    if (fabs(mianJiCha) > 16000*ratio){
        faceRect = NO;
    }

    /**判定脸部中心点*/
    CGPoint center = CGPointMake((leftBottom.x + rightTop.x)/2, (leftBottom.y + rightTop.y)/2);
    if (center.x < 130*ratio || center.x > 210*ratio || center.y < 140*ratio || center.y > 230*ratio) {
        faceCenter = NO ;
    }

    

    /**判定光照*/
    if (l < 70) {
        faceLight = NO;
    }
    DLog(@"%f,%f,%f",center.x,center.y,mianJiCha);
    NSArray *array = @[@(faceCenter & faceRect),@(facePose),@(faceLight)];
    CaptureImageVC *capVC = [[CaptureImageVC alloc] initWithImage:image];
    capVC.firstPunch = self.firstPunch;
    capVC.changeFace = self.changeFace;
    capVC.faceResutltArray = array;
    [self.navigationController pushViewController:capVC animated:YES];
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
