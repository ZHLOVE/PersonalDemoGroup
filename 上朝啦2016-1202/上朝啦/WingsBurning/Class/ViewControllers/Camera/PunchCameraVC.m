//
//  PunchCameraVC.m
//  WingsBurning
//
//  Created by MBP on 16/9/5.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "PunchCameraVC.h"
#import "LLSimpleCamera.h"
#import "PunchImageVC.h"

#import "DrawView.h"
#import "JYManager.h"

@interface PunchCameraVC()

@property(nonatomic,strong) UIImageView *guideLine;
@property(nonatomic,strong) UIImageView *webLine;
@property(nonatomic,strong) UIView *bottomBar;
@property(nonatomic,strong) LLSimpleCamera *camera;
@property(nonatomic,strong) UILabel *errorLabel;
@property(nonatomic,strong) UILabel *testLabel;
@property(nonatomic,strong) UILabel *faceRectLabel;
@property(nonatomic,strong) UILabel *faceLightLabel;
@property(nonatomic,strong) UILabel *facePoseLabel;
@property(nonatomic,strong) UILabel *faceEyeLabel;
@property(nonatomic,strong) JYManager *jyManager;
@property(nonatomic,strong) DrawView *drawView;
@property(nonatomic,assign) int count;
@end


int count[8];//人脸区域
int keypt[18];//人脸关键点坐标
int pose[3];//人脸姿态
int l = 1;
int *light = &l;//人脸光照
int eyeMouth[6];//眼睛嘴巴开合度
int flagNumber = 10;//连续检测多少帧照片才让过
int flagEye = 6;//眨眼队列存放值个数
int punchFlag = 0; //记录连续多少帧的标记位，初始0
int averageNum = 35;
static NSMutableArray *fcArray;

@implementation PunchCameraVC


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getLocation];
        self.jyManager = [JYManager sharedInstance];
        [self setFlagNumberAndFlagEye];
        fcArray = [NSMutableArray array];
    }
    return self;
}

//**设置连续检测帧数量*/
- (void)setFlagNumberAndFlagEye{
    NSString *phoneType = [Verify getPhoneType];
    DLog(@"%@",phoneType);
    if ([phoneType hasPrefix:@"iPhone 6"]) {
        flagNumber = 10;
        flagEye = 6;
        averageNum = 35;
    }

    if ([phoneType hasPrefix:@"iPhone 6s"]) {
        flagNumber = 12;
        flagEye = 9;
        averageNum = 35;
    }

    if ([phoneType hasPrefix:@"iPhone 7"]) {
        flagNumber = 15;
        flagEye = 10;
        averageNum = 40;
    }

    if ([phoneType hasPrefix:@"iPhone 7 Plus"]) {
        flagNumber = 16;
        flagEye = 12;
        averageNum = 40;
    }

    if ([phoneType hasPrefix:@"iPhone 5"]) {
        flagNumber = 5;
        punchFlag = 3;
        flagEye = 4;
    }
}

/**
 *  获取经纬度
 */
- (void)getLocation{
    CCLocationManager *manager = [CCLocationManager shareLocation];
    [manager getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        DLog(@"经度%0.3f",locationCorrrdinate.longitude);
        DLog(@"纬度%0.3f",locationCorrrdinate.latitude);
    }];
}

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
    [self startFaceRecognition];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    punchFlag = 0;
    [self.camera stop];
}

#pragma mark -开始人脸识别
- (void)startFaceRecognition{
    __weak typeof (self) weakSelf = self;
    self.camera.dataOutPutBlock  = ^(CMSampleBufferRef sampleBuffer){
        UIImage *image = [weakSelf imageFromSampleBuffer:sampleBuffer];
        weakSelf.count = [weakSelf.jyManager renLianShu:image];
        if (weakSelf.count == 1) {
            [weakSelf.jyManager renLianQuYuZuoBiao:count];
            [weakSelf.jyManager renLianZiTai:pose];
            [weakSelf.jyManager renLianGuanJianDian:keypt];
            [weakSelf.jyManager renLianGuangZhao:light];
            [weakSelf.jyManager yanJingZuiBaKaiHeDu:eyeMouth];

            //*主线程刷新UI，画框或者画点*/
            dispatch_sync(dispatch_get_main_queue(), ^{
                //*跟踪框坐标计算*/
                CGPoint rightTop = CGPointMake(screenWidth - count[2]*screenWidth/540, count[3]*screenHeight/960 - 64);
                CGPoint leftBottom = CGPointMake(screenWidth - count[4]*screenWidth/540, count[5]*screenHeight/960 - 64);
                //左上，右上，左下，右下，为了左右翻转下  rect[0...7]依次为lefttop_x,lefttop_y,right_top_x,right_top_y,leftbottom_x,leftbottom_y,rightbottom_x,rightbottom_y
                weakSelf.drawView.letfTop = rightTop;
                weakSelf.drawView.rightBottom = leftBottom;
                //*特征点坐标计算*/
                CGPoint facePoint0 = CGPointMake(screenWidth - keypt[0]*screenWidth/540, keypt[1]*screenHeight/960 - 64);
                CGPoint facePoint1 = CGPointMake(screenWidth - keypt[2]*screenWidth/540, keypt[3]*screenHeight/960 - 64);
                CGPoint facePoint16 = CGPointMake(screenWidth - keypt[6]*screenWidth/540, keypt[7]*screenHeight/960 - 64);
                CGPoint facePoint17 = CGPointMake(screenWidth - keypt[8]*screenWidth/540, keypt[9]*screenHeight/960 - 64);
                CGPoint facePoint45 = CGPointMake(screenWidth - keypt[12]*screenWidth/540, keypt[13]*screenHeight/960 - 64);
                CGPoint facePoint46 = CGPointMake(screenWidth - keypt[14]*screenWidth/540, keypt[15]*screenHeight/960 - 64);
                weakSelf.drawView.pointArray = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:facePoint0],[NSValue valueWithCGPoint:facePoint1],[NSValue valueWithCGPoint:facePoint16],[NSValue valueWithCGPoint:facePoint17],[NSValue valueWithCGPoint:facePoint45],[NSValue valueWithCGPoint:facePoint46], nil];
                [weakSelf.drawView setNeedsDisplay];
                [weakSelf showTipsLabelRightTop:rightTop andLeftBottom:leftBottom];
//                weakSelf.testLabel.text = [NSString stringWithFormat:@"内测阶段临时显示人脸个数%d 俯仰角度%d 侧脸角度%d 旋转角度%d 光照%d,左眼睛%d,右眼睛%d,嘴巴%d",weakSelf.count,pose[0],pose[1],pose[2],l,eyeMouth[0],eyeMouth[2],eyeMouth[4]];
            });
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                weakSelf.faceEyeLabel.hidden = YES;
                weakSelf.faceLightLabel.hidden = YES;
                weakSelf.facePoseLabel.hidden = YES;
                weakSelf.faceRectLabel.text = @"框中无人脸";
                weakSelf.faceRectLabel.hidden = NO;
//                weakSelf.testLabel.text = @"内测阶段显示人脸数量不为1";
                [weakSelf.drawView setNeedsDisplay];
            });
        }
    };
}

- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    //获取灰度图像数据
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);

    uint8_t *lumaBuffer  = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    //byt * height
    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer,0);
    size_t width  = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);

    CGColorSpaceRef grayColorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context=CGBitmapContextCreate(lumaBuffer, width, height, 8, bytesPerRow, grayColorSpace,0);
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    UIImage *img = [UIImage imageWithCGImage:cgImage];
    UIImage *image = [img rotate:UIImageOrientationRight];
    CGImageRelease(cgImage);
    CGContextRelease(context);
    CGColorSpaceRelease(grayColorSpace);
    return image;
}

/**
 *  提示信息
 */
- (void)showTipsLabelRightTop:(CGPoint)rightTop andLeftBottom:(CGPoint)leftBottom{
    __weak typeof (self) weakSelf = self;
    BOOL facePose = YES;
    BOOL faceRect = YES;
    BOOL faceCenter = YES;
    BOOL faceLight = YES;
    BOOL faceAlive = NO;

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
                if (pose[i] > 5 || pose[i] < -5) {
                    facePose = NO;
                }break;
            default:
                break;
        }
    }


    /**判定脸部大小,32400引导匡大小*/
    CGSize size = CGSizeMake((leftBottom.x - rightTop.x), (leftBottom.y - rightTop.y));
    CGFloat mianJiCha = size.width * size.height - 32400;
//    DLog(@"%f,%f",fabs(mianJiCha),16000*ratio);
    if (fabs(mianJiCha) > 16000*ratio){
        faceRect = NO;
    }

    /**判定脸部中心点*/
    CGPoint center = CGPointMake((leftBottom.x + rightTop.x)/2, (leftBottom.y + rightTop.y)/2);
    if (center.x < 130*ratio || center.x > 210*ratio || center.y < 140*ratio || center.y > 230*ratio) {
        faceCenter = NO ;
    }
//    DLog(@"%f,%f",center.x,center.y);
    /**判定光照*/
    if (l < 70) {
        faceLight = NO;
    }

    /**判定眼睛开合*/
    int sum = 0;
    int avSum = 0;
    int fcSum = 0;
    int avFcSum = 0;
    [fcArray addObject:@(eyeMouth[0])];
    [fcArray addObject:@(eyeMouth[2])];

    if (fcArray.count > flagEye) {
        [fcArray removeObjectAtIndex:0];
        [fcArray removeObjectAtIndex:1];
    }
    for (NSNumber *num in fcArray) {
        sum += [num intValue];
    }
    avSum = sum / flagEye;
    for (NSNumber *num in fcArray) {
        NSInteger intNum = [num intValue] - avSum;
        double fNum = powf(intNum, 2);
        fcSum = fcSum + fNum;
    }
    avFcSum = fcSum / flagEye;  //方差
    DLog(@"%d",avFcSum);
    int judegNum = avSum + averageNum;
    if ((avFcSum > 4500 && avFcSum < 12000)&&(eyeMouth[0]>judegNum)&&(eyeMouth[2]>judegNum)) {
        faceAlive = YES;
        weakSelf.faceEyeLabel.hidden = YES;
    }

    if (facePose && faceRect && faceCenter && faceLight) {
        weakSelf.faceRectLabel.hidden = YES;
//        DLog(@"连续第%d帧",punchFlag);
        if ((punchFlag * faceAlive) > flagNumber) {
//            DLog(@"拍照");
            [weakSelf snapBtnPressed];
            punchFlag = -2;
        }else{
            punchFlag++;
        }
    }else{
        weakSelf.faceRectLabel.text = @"请将脸置于框中央";
        weakSelf.faceRectLabel.hidden = NO;
        weakSelf.faceEyeLabel.hidden = NO;
        punchFlag = 0;
        faceAlive = NO;
    }
}


- (void)setUpUI{
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = self.naviTitle;
    __weak typeof (self) weakSelf = self;
    CGRect frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.camera attachToViewController:self withFrame:frame];
    [self.view addSubview:self.guideLine];
    [self.guideLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.view.mas_centerY).offset(-50 * ratio);
        make.height.width.mas_equalTo(192 * ratio);
    }];
    [self.view addSubview:self.webLine];
    [self.webLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.guideLine);
        make.centerY.mas_equalTo(weakSelf.guideLine);
        make.height.width.mas_equalTo(weakSelf.guideLine);
    }];
    [self.view addSubview:self.bottomBar];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(133 * ratio);
    }];
    [self.view addSubview:self.drawView];
    self.drawView.frame = frame;
    [self.bottomBar addSubview:self.testLabel];
    [self.testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.bottomBar.center);
        make.width.mas_equalTo(200 * ratio);
        make.height.mas_equalTo(100 * ratio);
    }];
    [self.view addSubview:self.faceRectLabel];
    [self.faceRectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.guideLine.mas_bottom).offset(70 * ratio);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.height.mas_equalTo(22 * ratio);
        make.width.mas_equalTo(120 * ratio);
    }];
    [self.view addSubview:self.facePoseLabel];
    [self.facePoseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.faceRectLabel.mas_bottom).offset(10 * ratio);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.height.mas_equalTo(22 * ratio);
        make.width.mas_equalTo(130 * ratio);
    }];
    [self.view addSubview:self.faceLightLabel];
    [self.faceLightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.facePoseLabel.mas_bottom).offset(10 * ratio);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.height.mas_equalTo(22 * ratio);
        make.width.mas_equalTo(176 * ratio);
    }];
    [self.view addSubview:self.faceEyeLabel];
    [self.faceEyeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.faceRectLabel.mas_top);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.height.mas_equalTo(22 * ratio);
        make.width.mas_equalTo(120 * ratio);
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
        DLog(@"相机错误: %@", error);
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
            NSArray *array = @[@(1),@(1),@(1)];//DLog(@"姿态%i ,面积%i ,中心%i,光照%i",facePose,faceRect,faceCenter,faceLight);
            PunchImageVC *capVC = [[PunchImageVC alloc] initWithImage:mirroredImg];
            capVC.naviTitle = weakSelf.naviTitle;
            capVC.faceResutltArray = array;
            capVC.otherEmployeeID = weakSelf.otherEmployeeID;
            capVC.punchFlag = YES;
            [weakSelf.navigationController pushViewController:capVC animated:YES];
        }
        else {
            DLog(@"拍照出错:%@", error);
        }
    } exactSeenImage:YES];
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

- (UIImageView *)webLine{
    if (_webLine == nil) {
        _webLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"webline"]];
    }
    return _webLine;
}

- (UIView *)bottomBar{
    if (_bottomBar == nil) {
        _bottomBar = [[UIView alloc]init];
        _bottomBar.backgroundColor = [UIColor whiteColor];
    }
    return _bottomBar;
}



- (UILabel *)testLabel{
    if (_testLabel == nil) {
        _testLabel = [[UILabel alloc]init];
        _testLabel.textColor = [UIColor lightGrayColor];
        _testLabel.textAlignment = NSTextAlignmentCenter;
        _testLabel.font = [UIFont systemFontOfSize:15];
        _testLabel.numberOfLines = 0;
        [_testLabel sizeToFit];
    }
    return _testLabel;
}

- (UILabel *)faceRectLabel{
    if (_faceRectLabel == nil) {
        _faceRectLabel = [[UILabel alloc]init];
        _faceRectLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _faceRectLabel.layer.cornerRadius = 11.0;
        _faceRectLabel.layer.masksToBounds = YES;
        _faceRectLabel.font = [UIFont systemFontOfSize:13 * ratio];
        _faceRectLabel.textColor = [UIColor whiteColor];
        _faceRectLabel.textAlignment = NSTextAlignmentCenter;
        _faceRectLabel.text = @"请将脸置于框中央";
        _faceRectLabel.hidden = YES;
    }
    return _faceRectLabel;
}

- (UILabel *)facePoseLabel{
    if (_facePoseLabel == nil) {
        _facePoseLabel = [[UILabel alloc]init];
        _facePoseLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _facePoseLabel.layer.cornerRadius = 11.0;
        _facePoseLabel.layer.masksToBounds = YES;
        _facePoseLabel.font = [UIFont systemFontOfSize:13 * ratio];
        _facePoseLabel.textColor = [UIColor whiteColor];
        _facePoseLabel.textAlignment = NSTextAlignmentCenter;
        _facePoseLabel.text = @"请将脸部摆正";
        _facePoseLabel.hidden = YES;
    }
    return _facePoseLabel;
}

- (UILabel *)faceLightLabel{
    if (_faceLightLabel == nil) {
        _faceLightLabel = [[UILabel alloc]init];
        _faceLightLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _faceLightLabel.layer.cornerRadius = 11.0;
        _faceLightLabel.layer.masksToBounds = YES;
        _faceLightLabel.font = [UIFont systemFontOfSize:13 * ratio];
        _faceLightLabel.textColor = [UIColor whiteColor];
        _faceLightLabel.textAlignment = NSTextAlignmentCenter;
        _faceLightLabel.text = @"请在光线充足的地方打卡";
        _faceLightLabel.hidden = YES;
    }
    return _faceLightLabel;
}

- (UILabel *)faceEyeLabel{
    if (_faceEyeLabel == nil) {
        _faceEyeLabel = [[UILabel alloc]init];
        _faceEyeLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _faceEyeLabel.layer.cornerRadius = 11.0;
        _faceEyeLabel.layer.masksToBounds = YES;
        _faceEyeLabel.font = [UIFont systemFontOfSize:13 * ratio];
        _faceEyeLabel.textColor = [UIColor whiteColor];
        _faceEyeLabel.textAlignment = NSTextAlignmentCenter;
        _faceEyeLabel.text = @"请眨一下眼";
        _faceEyeLabel.hidden = YES;
    }
    return _faceEyeLabel;
}

- (DrawView *)drawView{
    if (_drawView == nil) {
        _drawView = [[DrawView alloc]init];
    }
    return _drawView;
}
@end


































