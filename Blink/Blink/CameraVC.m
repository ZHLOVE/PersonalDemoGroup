//
//  CameraVC.m
//  Blink
//
//  Created by MBP on 2016/12/28.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "CameraVC.h"
#import "LLSimpleCamera.h"
#import "JYManager.h"
#import "DrawView.h"
#import "ImageViewController.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
@interface CameraVC ()

@property(nonatomic,strong) UIImageView *guideLine;
@property(nonatomic,strong) UITextView *bottomBar;
@property(nonatomic,strong) LLSimpleCamera *camera;
@property(nonatomic,strong) UILabel *errorLabel;
@property(nonatomic,strong) JYManager *jyManager;
@property(nonatomic,strong) DrawView *drawView;
@property(nonatomic,assign) int count;
@property(nonatomic,copy) NSDictionary *faceDict;


@end

BOOL canSnapCamera;
BOOL isIPhone5;
int count[8];//人脸区域
int keypt[18];//人脸关键点坐标
int pose[3];//人脸姿态
int l = 1;
int *light = &l;//人脸光照
int eyeMouth[6];//眼睛嘴巴开合度
int flagNumber = 10;//连续检测多少帧照片才让过
int flagEye = 6;//眨眼队列存放值个数
int punchFlag = 0; //记录连续多少帧的标记位，初始0
int averageNum = 35; //平均值偏差
int avFcSum = 0; //检测到的方差
int eyeOpenFangCha = 4300;//开合度方差
int yShangXian = 230;//y上限
int yXiaXian = 140;//y下限
int xXiaXian = 130;//x下限
int xShangXian = 210;//x上限
int fuYangJD = 30;//俯仰角度
int zuoYouJD = 15;//左右角度
int xuanZhuanJD = 5;//旋转角度
int renLianGaoDY = 160;//人脸高大于
int renLianGaoXY = 600;//人脸高小于
CGPoint center;

static NSMutableArray *fcArray;


@implementation CameraVC

BOOL canSnapCamera;

- (instancetype)initWithCanShu:(NSDictionary *)canShu
{
    self = [super init];
    if (self) {
        self.jyManager = [JYManager sharedInstance];
        self.faceDict = canShu;
        fcArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self setCamera];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    canSnapCamera = NO;
    [self.camera start];
    [self startFaceRecognition];
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5];
}

- (void)delayMethod{
    canSnapCamera = YES;
}

- (void)setUpUI{
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.camera attachToViewController:self withFrame:frame];
    [self.view addSubview:self.guideLine];
    [self.view addSubview:self.drawView];
    self.drawView.frame = frame;
    [self.view addSubview:self.bottomBar];
}

#pragma mark -开始人脸识别
- (void)startFaceRecognition{
    __weak typeof (self) weakSelf = self;
    self.camera.dataOutPutBlock = ^(CMSampleBufferRef sampleBuffer){
        UIImage *image = [weakSelf imageFromSampleBuffer:sampleBuffer];
        weakSelf.count = [weakSelf.jyManager renLianShu:image];
        if (weakSelf.count == 1) {
            [weakSelf.jyManager renLianQuYuZuoBiao:count];
            [weakSelf.jyManager renLianZiTai:pose];
            [weakSelf.jyManager renLianGuanJianDian:keypt];
            if (!isIPhone5) {
                [weakSelf.jyManager renLianGuangZhao:light];
            }
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
                [weakSelf judgeFaceImage:rightTop andLeftBottom:leftBottom];
            });
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
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

- (void)judgeFaceImage:(CGPoint)rightTop andLeftBottom:(CGPoint)leftBottom{
    __weak typeof (self) weakSelf = self;
    BOOL facePose = YES;
    BOOL faceRect = YES;
    BOOL faceCenter = YES;
    BOOL faceLight = YES;
    BOOL faceAlive = NO;

    /**判定脸部大小,170高度*/
    CGFloat faceHeight = leftBottom.y - rightTop.y;

    NSString *str = [NSString stringWithFormat:@"人脸个数%d \n俯仰角%02d 侧脸角%02d 旋转角%02d \n光照%03d,左眼睛%03d,右眼睛%03d 脸高%03.0f \n实时方差%05d,中点x%03.0f,中点y%03.0f",weakSelf.count,pose[0],pose[1],pose[2],l,eyeMouth[0],eyeMouth[2],faceHeight,avFcSum,center.x,center.y];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, str.length)];


    /**判定偏转角度*/
    for (int i=0; i<3; i++) {
        switch (i) {
            case 0:
                if (pose[i] > fuYangJD || pose[i] < -fuYangJD) {
                    facePose = NO;
                    [attStr addAttribute:NSForegroundColorAttributeName
                                   value:[UIColor redColor]
                                   range:NSMakeRange(7, 5)];
                }break;
            case 1:
                if (pose[i] > zuoYouJD || pose[i] < -zuoYouJD) {
                    facePose = NO;
                    [attStr addAttribute:NSForegroundColorAttributeName
                                   value:[UIColor redColor]
                                   range:NSMakeRange(12, 5)];
                }break;
            case 2:
                if (pose[i] > xuanZhuanJD || pose[i] < -xuanZhuanJD) {
                    facePose = NO;
                    [attStr addAttribute:NSForegroundColorAttributeName
                                   value:[UIColor redColor]
                                   range:NSMakeRange(18, 5)];
                }break;
            default:
                break;
        }
    }

        //    NSlog(@"脸部高度%3.0f",faceHeight);
    if (faceHeight < renLianGaoDY) {
        faceRect = NO;
        [attStr addAttribute:NSForegroundColorAttributeName
                       value:[UIColor redColor]
                       range:NSMakeRange(45, 5)];
    }
    /**判定脸部中心点*/
    center = CGPointMake((leftBottom.x + rightTop.x)/2, (leftBottom.y + rightTop.y)/2);
    if (center.x < xXiaXian || center.x > xShangXian || center.y < yXiaXian || center.y > yShangXian) {
        faceCenter = NO ;
        [attStr addAttribute:NSForegroundColorAttributeName
                       value:[UIColor redColor]
                       range:NSMakeRange(63, 12)];
    }
    /**判定光照,暂时不设,之前设70*/
    //    NSlog(@"光照%d",l);
    if (isIPhone5) {
        faceLight = YES;
    }else{
        if (l < 40) {
            faceLight = NO;
            [attStr addAttribute:NSForegroundColorAttributeName
                           value:[UIColor redColor]
                           range:NSMakeRange(24, 5)];
        }
    }



    /**判定眼睛开合*/
    int sum = 0;
    int avSum = 0;
    int fcSum = 0;
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
    int judegNum = avSum + averageNum;
    if ((avFcSum > eyeOpenFangCha && avFcSum < 12000)&&(eyeMouth[0]>judegNum)&&(eyeMouth[2]>judegNum)) {
        faceAlive = YES;

    }else{
        [attStr addAttribute:NSForegroundColorAttributeName
                       value:[UIColor redColor]
                       range:NSMakeRange(51, 12)];
    }
    if (facePose && faceRect && faceCenter && faceLight) {

        if (((punchFlag * faceAlive) > flagNumber) & canSnapCamera) {

            [weakSelf snapBtnPressed];
            punchFlag = -2;
        }else{
            punchFlag++;
        }
    }else{
        punchFlag = 0;
        faceAlive = NO;
    }


    weakSelf.bottomBar.attributedText = attStr;
}



/**
 *  拍照
 */
- (void)snapBtnPressed{
    __weak typeof (self) weakSelf = self;
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if(!error) {
            UIImage *mirroredImg = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationLeftMirrored];
//            NSArray *array = @[@(1),@(1),@(1)];//DLog(@"姿态%i ,面积%i ,中心%i,光照%i",facePose,faceRect,faceCenter,faceLight);
            ImageViewController *capVC = [[ImageViewController alloc] initWithImage:mirroredImg];
            [weakSelf.navigationController pushViewController:capVC animated:YES];
        }
        else {
            NSLog(@"拍照出错:%@", error);
        }
    } exactSeenImage:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (LLSimpleCamera *)camera{
    if (_camera == nil) {
        _camera = [[LLSimpleCamera alloc]initWithQuality:AVCaptureSessionPresetHigh position:CameraPositionFront videoEnabled:NO];
    }
    return _camera;
}

- (UIImageView *)guideLine{
    if (_guideLine == nil) {
        _guideLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"subline"]];
        _guideLine.frame = CGRectMake(screenWidth/2 - 96, screenHeight/2 -96 -50, 192, 192);
    }
    return _guideLine;
}

- (DrawView *)drawView{
    if (_drawView == nil) {
        _drawView = [[DrawView alloc]init];
    }
    return _drawView;
}

- (UITextView *)bottomBar{
    if (_bottomBar == nil) {
        _bottomBar = [[UITextView alloc]initWithFrame:CGRectMake(0, screenHeight - 133, screenWidth, 133)];
        _bottomBar.backgroundColor = [UIColor whiteColor];
        _bottomBar.editable = NO;
    }
    return _bottomBar;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}
@end
