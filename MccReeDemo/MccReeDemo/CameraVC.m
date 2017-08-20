//
//  CameraVC.m
//  Blink
//
//  Created by MBP on 2016/12/28.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "CameraVC.h"
#import "LLSimpleCamera.h"
#import "ImageViewController.h"
#import "UIImage+Rotate.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
@interface CameraVC ()


@property(nonatomic,strong) LLSimpleCamera *camera;

@property(nonatomic,strong) UIImageView *grayImageV;



@end


//存20帧灰度图
static NSMutableArray *mrArray;
//像素
static int pixelNumTemp;



@implementation CameraVC

BOOL canSnapCamera;

- (instancetype)init
{
    self = [super init];
    if (self) {
        mrArray = [[NSMutableArray alloc]init];
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
    [self changeGrayImage];
}



- (void)setUpUI{
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.camera attachToViewController:self withFrame:frame];
    [self.view addSubview:self.grayImageV];
}


/**
 旋转
 */
void Matrix_Rotate_90(uint8_t *src,uint8_t *dst,int M ,int N)
{
    for(int i=0;i<M;i++)
        for(int j=0;j<N;j++)
        {
            dst[i*N+j]=src[(N-1-j)*M+i];
        }
}


/**
 处理成灰度图
 */
- (void)changeGrayImage{
    __weak typeof (self) weakSelf = self;
    self.camera.dataOutPutBlock = ^(CMSampleBufferRef sampleBuffer){
        UIImage *image = [weakSelf newImageFromSampleBuffer:sampleBuffer];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.grayImageV setImage:image];
            [weakSelf.view setNeedsDisplay];
        });
        [mrArray addObject:image];
        if (mrArray.count > 20) {
            [mrArray removeObjectAtIndex:0];
        }
    };
}





/**
 sampleBuffer转UIImage
 */
- (UIImage *)newImageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
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
    UIImage *tempimage = [img rotate:UIImageOrientationRight];//旋转
    UIImage *image = [tempimage flipHorizontal];//镜像翻转
    CGImageRelease(cgImage);
    CGContextRelease(context);
    CGColorSpaceRelease(grayColorSpace);
    return image;
}

/**
 UIImage转灰度图
 */
- (UIImage *)grayImageFromImage:(UIImage *)oriImage
{
    UIImage *image = oriImage;
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        //ABGR
        uint8_t* ptr = (uint8_t*)pCurPtr;
        int B = ptr[1];
        int G = ptr[2];
        int R = ptr[3];
        double Gray = R*0.3+G*0.59+B*0.11;
        ptr[1] = Gray;
        ptr[2] = Gray;
        ptr[3] = Gray;
    }
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight,NULL);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    

    return resultUIImage;
}


- (NSArray *)getGaryArrFromImage:(UIImage *)image{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    int pixelNum = imageWidth * imageHeight;
    pixelNumTemp = pixelNum;
    uint32_t* pCurPtr = rgbImageBuf;
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        //ABGR
        uint8_t* ptr = (uint8_t*)pCurPtr;
        int B = ptr[1];
        int G = ptr[2];
        int R = ptr[3];
        double Gray = R*0.3+G*0.59+B*0.11;
        [tempArr addObject: [NSNumber numberWithDouble:Gray]];
    }
    return tempArr;
}





- (NSArray *)getK:(NSArray *)imgArr{
    int count = (int)imgArr.count;
    int sum = 0;
    double avGrayNum = 0; //像素点均值
    double sdGrayNum = 0; //像素点方差
    double k = 0; //k值
    int fcSum = 0;
    int avFcSum = 0;
    
    
    NSMutableArray *allImageArr = [[NSMutableArray alloc]init];  //所有灰度数据
    NSMutableArray *kArr = [[NSMutableArray alloc]init];
    for (int i=0; i<imgArr.count; i++) {
        allImageArr[i] = [self getGaryArrFromImage:imgArr[i]];
    }
    for (int i=0;i<pixelNumTemp;i++) {
        
        for (int j=0; j<20; j++) {
            NSArray *garyArr = allImageArr[j];
            //均值
            avGrayNum = (avGrayNum + [garyArr[i] doubleValue])/(j+1);
            double f = powf([garyArr[i] floatValue],2);
            //方差
            double adGrayNum = (adGrayNum + f)/(j+1);
            //标准差
            double scNum = sqrt(adGrayNum);
            k = avGrayNum / scNum;
        }
        [kArr addObject:[NSNumber numberWithDouble:k]];
    }
    return kArr;
}


- (UIImage *)imageCreatFromArr:(NSArray *)kArr oriImage:(UIImage *)oriImage{
    UIImage *image = oriImage;
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        //ABGR
        uint8_t* ptr = (uint8_t*)pCurPtr;
        ptr[1] = [kArr[i] doubleValue];
        ptr[2] = [kArr[i] doubleValue];
        ptr[3] = [kArr[i] doubleValue];
    }
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight,NULL);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}







/**
 *  拍照
 */
- (void)snapBtnPressed{
    __weak typeof (self) weakSelf = self;
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if(!error) {
            
            UIImage *img = [weakSelf grayImageFromImage:image];
            UIImage *mirroredImg = [UIImage imageWithCGImage:img.CGImage scale:1.0 orientation:UIImageOrientationLeftMirrored];
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
                
            }
        }
    }];
}



#pragma mark - 懒加载
- (LLSimpleCamera *)camera{
    if (_camera == nil) {
        _camera = [[LLSimpleCamera alloc]initWithQuality:AVCaptureSessionPresetHigh position:CameraPositionFront videoEnabled:NO];
    }
    return _camera;
}



- (UIImageView *)grayImageV{
    if (!_grayImageV) {
        _grayImageV = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth-180, screenHeight-240, 180, 240)];
        _grayImageV.layer.borderWidth = 1;
        _grayImageV.layer.borderColor = [UIColor blackColor].CGColor;
        _grayImageV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _grayImageV;
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self snapBtnPressed];
}
@end


