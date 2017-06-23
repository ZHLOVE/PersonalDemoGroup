//
//  TrackViewController.m
//  sample_st_mobile_track_106
//
//  Created by sluin on 16/5/11.
//  Copyright © 2016年 ColorReco. All rights reserved.
//

#import "TrackingViewController.h"

#import "FaceLandTrack.hpp"
#import "UIImage+Rotate.h"
#import "ImageViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CanvasView.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

#define TICK   NSDate *startTime = [NSDate date];
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow]);
@interface TrackingViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    CGFloat _imageOnPreviewScale;
    CGFloat _previewImageWidth;
    CGFloat _previewImageHeight;
    
    //   st_handle_t _hTracker;
}

@property (nonatomic , strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic , strong) AVCaptureDevice *device;
@property(nonatomic,strong) AVCaptureSession *sessionCarmera;
@property (nonatomic , strong) CanvasView *viewCanvas;
@property (nonatomic,strong) UILabel *poseResultLabel;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;



@end

static NSMutableArray *fcArray;
int punchFlag = 0; //记录连续多少帧的标记位，初始0
int flagNumber = 10;//连续检测多少帧照片才让过
BOOL eyeClose;
BOOL eyeOpen;

@implementation TrackingViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化 －－－－－
    fcArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor blackColor];

    int iisok=FaceAlignInit_ColorReco();
    
    if(iisok!=1)
    {
        
        //if (ST_OK != iRet || !_hTracker) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"算法SDK初始化失败，可能是SDK权限过期，与绑定包名不符｀" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        
        // return;
    }
    else if(iisok==1)
    {
        printf("模型初始化成功\n");
        
    }
    
    //  st_mobile_tracker_106_set_facelimit(_hTracker, 1);
    //  st_mobile_tracker_106_set_detectinternal(_hTracker,60);
    
    [self setupAVCapture];

    self.poseResultLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,screenHeight - 100 , self.view.frame.size.width - 30, 30)];
    self.poseResultLabel.textAlignment = NSTextAlignmentCenter;
    self.poseResultLabel.backgroundColor = [UIColor redColor];
    self.poseResultLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:self.poseResultLabel];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.sessionCarmera startRunning];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.sessionCarmera stopRunning];
    punchFlag = 0;
}

- (void)dealloc
{
    //st_mobile_tracker_106_destroy(_hTracker);
}



typedef enum {
    CR_CLOCKWISE_ROTATE_0 = 0,	///< 图像不需要转向
    CR_CLOCKWISE_ROTATE_90 = 1,	///< 图像需要顺时针旋转90度
    CR_CLOCKWISE_ROTATE_180 = 2,	///< 图像需要顺时针旋转180度
    CR_CLOCKWISE_ROTATE_270 = 3	///< 图像需要顺时针旋转270度
} cr_rotate_type;



//initReadModel();
static BOOL  initflag = FALSE;
static bool  isok = true;
static float landmark[68*2];


float GetFaceBoxFromLandmarkXX(float *shape,int *facearea)
{
    int len=68;
    shape=shape;
    int topx,topy,botx,boty;
    topx=shape[0];
    botx=shape[0];
    topy=shape[1];
    boty=shape[1];
    
    for(int i=0;i<len;i++)
    {
        if(shape[2*i]<topx)
        {
            topx=shape[2*i];
        }
        if(shape[2*i]>botx)
        {
            botx=shape[2*i];
        }
        if(shape[2*i+1]<topy)
        {
            topy=shape[2*i+1];
        }
        if(shape[2*i+1]>boty)
        {
            boty=shape[2*i+1];
        }
    }
    
    
    float  hxx=boty-topy;
    float cenx=(shape[31*2]+shape[35*2])/2;
    topx=cenx-hxx/2;
    botx=cenx+hxx/2;
    
    
    facearea[0]=topx;
    facearea[1]=topy;
    facearea[2]=botx-topx;
    facearea[3]=boty-topy;
    
    return   0.0f;
}


//将坐标系转回去
void UpdatePostionForShow(float *src,int type,int width,int height)
{
    float lan[68*2];
    
    for(int i=0;i<68;i++)
    {
        lan[2*i]=src[2*i+1];
        lan[2*i+1]=height-src[2*i];
    }
    //mem
    
    for(int i=0;i<68;i++)
    {
        src[2*i]=lan[2*i];
        
        src[2*i+1]=lan[2*i+1];
    }
    
}


//顺时针旋转90度
//M N 分别代表宽和高
void Matrix_Rotate_90(uint8_t *src,uint8_t *dst,int M ,int N)
{
    for(int i=0;i<M;i++)
        for(int j=0;j<N;j++)
        {
            dst[i*N+j]=src[(N-1-j)*M+i];
        }
}


//顺时针旋转90度
//M N 分别代表宽和高
void Matrix_Rotate_270(uint8_t *src,uint8_t *dst,int M ,int N)
{
    for(int i=0;i<M;i++)
        for(int j=0;j<N;j++)
        {
            // dst[i*N+j]=src[(N-1-j)*M+i];
            //dst[i*N+j]=src[(j)*M+(M-1-i)];
            dst[i*N+j]=src[(j)*M+(M-1-i)];
        }
}


- (void)setupAVCapture
{
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    self.sessionCarmera = session;
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];

    //初始化设备输出对象，用于获得输出数据
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    [self.stillImageOutput setOutputSettings:outputSettings];//输出设置


    // Set the camera preview size
    session.sessionPreset = AVCaptureSessionPreset640x480;
    CGFloat imageWidth = 480;
    CGFloat imageHeight = 640;
    
    // Get the preview frame size.
    self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    self.captureVideoPreviewLayer.frame = self.view.bounds;
    CGFloat previewWidth = self.captureVideoPreviewLayer.frame.size.width;
    CGFloat previewHeight = self.captureVideoPreviewLayer.frame.size.height;
    [self.captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.view.layer addSublayer:self.captureVideoPreviewLayer];
    
    // Calculate the width, height and scale rate to display the preview image
    _imageOnPreviewScale = MAX(previewHeight/imageHeight, previewWidth/imageWidth);
    _previewImageWidth = imageWidth * _imageOnPreviewScale;
    _previewImageHeight = imageHeight * _imageOnPreviewScale;
    
    self.viewCanvas = [[CanvasView alloc] initWithFrame:CGRectMake(0., 0., _previewImageWidth, _previewImageHeight)];
    self.viewCanvas.center = self.view.center;
    self.viewCanvas.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.viewCanvas];
    

    
    AVCaptureDevice *deviceFront;
    
    NSArray *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices)
    {
        
        if ([device hasMediaType:AVMediaTypeVideo])
        {
            
            if ([device position] == AVCaptureDevicePositionFront)
            {
                deviceFront = device;
            }
        }
    }
    self.device = deviceFront;
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:deviceFront error:&error];

    //将设备输入添加到会话中
    if ([session canAddInput:input]) {
        [session addInput:input];
    }

    //将设备输出添加到会话中
    if ([session canAddOutput:self.stillImageOutput]) {
        [session addOutput:self.stillImageOutput];
    }


    if (!input)
    {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    AVCaptureVideoDataOutput * dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    [dataOutput setAlwaysDiscardsLateVideoFrames:YES];
    
    [dataOutput setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)}];
    
    //[dataOutput setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)}];
    
    dispatch_queue_t queue = dispatch_queue_create("dataOutputQueue", NULL);
    [dataOutput setSampleBufferDelegate:self queue:queue];
    
    [session beginConfiguration];
    
    if ([session canAddInput:input])
    {
        [session addInput:input];
    }
    
    if ([session canAddOutput:dataOutput])
    {
        [session addOutput:dataOutput];
    }
    [session commitConfiguration];
    
    [session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    
    CVImageBufferRef imageBufferRef=CMSampleBufferGetImageBuffer(sampleBuffer);
    NSLog(@"Code %x", (unsigned int)CVPixelBufferGetPixelFormatType(imageBufferRef));
    CVPixelBufferLockBaseAddress(imageBufferRef, 0);

    unsigned char *ptr_image=CVPixelBufferGetBaseAddressOfPlane(imageBufferRef, 0);
    
    unsigned char* grayImg = (unsigned char *)malloc(sizeof(unsigned char) * 640 * 480 * 4);
    
    Matrix_Rotate_90(ptr_image,grayImg,640,480);
    static int t = 0;
    if (t == 50) {
        NSData *data = [NSData dataWithBytes:ptr_image length:960 * 540];
        NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *filePath = [docPath stringByAppendingPathComponent:@"gray.text"];
        NSLog(@"存储位置:%@",filePath);
        [data writeToFile:filePath atomically:YES];
    }
    t++;

    float pose[3];
    int facebox[100];
    
    bool isok=FaceLandTrack_ColorReco(grayImg,480,640,facebox,landmark,pose);
    float eye[10];
    float eye_s=0.0f;
    float mouse=0.0f;
    if(isok)
    {
        eye_s= GetEyeStatus(grayImg,480,640,landmark,eye);
        
        mouse=GetMouseStatus(landmark);
    }
    
    free(grayImg);
    
    
    UIDeviceOrientation iDeviceOrientation = [[UIDevice currentDevice]orientation];
    
    BOOL isMirror = self.device.position == AVCaptureDevicePositionFront;
    
    
    if (isok==false)
    {
        
        // NSLog(@"tracking failed. %d and image width is %d and image height is %d\n" , iRet,iWidth,iHeight);
        //return;
        memset(landmark,0,sizeof(float)*68*2);
        
    }
    
    if (isok ==true)
    {
        
        // NSLog(@"tracking success is %d  %d  %d\n" ,1,480,640);
        
        
        int facere[10];
        UpdatePostionForShow(landmark,1,640,480);
        
        GetFaceBoxFromLandmarkXX(landmark,facere);
        
        NSMutableArray *arrPersons = [NSMutableArray array];
        {
            
            
            NSMutableArray *arrStrPoints = [NSMutableArray array];
            CGRect rectFace = CGRectZero;
            
            // st_pointf_t *facialPoints = stFace.points_array;
            
            for(int i = 0; i < 68; i ++)
            {
                
                CGPoint point;
                if (isMirror)
                {
                    point.x = _imageOnPreviewScale * landmark[2*i+1];
                    point.y = _imageOnPreviewScale * landmark[2*i];
                }
                else
                {
                    point.x = _previewImageWidth - _imageOnPreviewScale * landmark[2*i];
                    point.y = _imageOnPreviewScale* landmark[2*i+1];
                }
                [arrStrPoints addObject:[NSValue valueWithCGPoint:point]];
            }
            
            //            st_rect_t rect = stFace.rect;
            
            if (isMirror)
            {
                //  _imageOnPreviewScale=1/_imageOnPreviewScale;
                rectFace = CGRectMake(_imageOnPreviewScale * facere[1],
                                      _imageOnPreviewScale * facere[0],
                                      _imageOnPreviewScale * facere[3],
                                      _imageOnPreviewScale * facere[2]);
                //   printf("********************\n");
                
            }
            else
            {
                rectFace = CGRectMake(_previewImageWidth - _imageOnPreviewScale * facere[1] ,
                                      _imageOnPreviewScale * facere[0],
                                      _imageOnPreviewScale * facere[3],
                                      _imageOnPreviewScale * facere[2]);
                // printf("--------------\n");
            }
            
            NSMutableDictionary *dicPerson = [NSMutableDictionary dictionary];
            [dicPerson setObject:arrStrPoints forKey:POINTS_KEY];
            [dicPerson setObject:[NSValue valueWithCGRect:rectFace] forKey:RECT_KEY];
            
            [arrPersons addObject:dicPerson];
            
        }
        
        //   st_mobile_106_t stFace = pFaceArray[iFaceCount - 1];
        
        NSString *strLastFacePose = [NSString stringWithFormat:@"yaw=%d %d %d,eye_dist=%d and mouse is %d",
                                     (int)pose[0] ,
                                     (int)pose[1] ,
                                     (int)pose[2] ,
                                     (int)(eye_s>-0.6f),
                                    (int)mouse>0];

        dispatch_async(dispatch_get_main_queue(), ^{
            self.poseResultLabel.hidden = NO;
            self.poseResultLabel.text = strLastFacePose;
            [self showFaceLandmarksAndFaceRectWithPersonsArray:arrPersons];
        } );
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.poseResultLabel.hidden = YES;
            self.poseResultLabel.text = @"";
            [self hideFace];
        } );
    }
    
    // st_mobile_tracker_106_release_result(pFaceArray, iFaceCount);
    
    CVPixelBufferUnlockBaseAddress(imageBufferRef, 0);

    BOOL facePose = YES;

    /**判定偏转角度*/
    for (int i=0; i<3; i++) {
        switch (i) {
            case 0:
                if (pose[i] > 10 || pose[i] < -10) {
                    facePose = NO;
                }break;
            case 1:
                if (pose[i] > 15 || pose[i] < -15) {
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

    /**判定眼睛开合*/
    int eyeOCO = (int)(eye_s>-0.6f);
    NSLog(@"%d",eyeOCO);
    [fcArray addObject:@(eyeOCO)];
    if (fcArray.count > 8) {
        NSLog(@"%@",fcArray);
        eyeClose =  [fcArray containsObject:@(0)] & [[fcArray objectAtIndex:8] intValue];
        eyeOpen = [fcArray containsObject:@(1)] & [[fcArray objectAtIndex:7] intValue];
        [fcArray removeObjectAtIndex:0];
    }



//    int sum = 0;
//    int avSum = 0;
//    int fcSum = 0;
//    int avFcSum = 0;
//    int flagEye = 6;
//
//    int leftEye = (eye[0] + 2) * 200;
//    int rightEye = (eye[0] + 2) * 200;
//
//    [fcArray addObject:@(leftEye)];
//    [fcArray addObject:@(rightEye)];
//
//    if (fcArray.count > flagEye) {
//        [fcArray removeObjectAtIndex:0];
//        [fcArray removeObjectAtIndex:1];
//    }
//
//    for (NSNumber *num in fcArray) {
//        sum += [num intValue];
//    }
//    avSum = sum / flagEye;
//    for (NSNumber *num in fcArray) {
//        NSInteger intNum = [num intValue] - avSum;
//        double fNum = powf(intNum, 2);
//        fcSum = fcSum + fNum;
//    }
//    avFcSum = fcSum / flagEye;  //方差
//    NSLog(@"方差%d",avFcSum);

    if (isok & facePose) {
        punchFlag ++;
        if (punchFlag > 8) {
            if (eyeClose & eyeOpen) {
                [self snapShoot];
            }
        }
    }else{
        punchFlag = 0;
    }
}

- (void)snapShoot{
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection=[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    //根据连接取得设备输出的数据
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if(!error) {
            if (imageDataSampleBuffer) {
                NSData *imageData=[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                UIImage *image=[UIImage imageWithData:imageData];
                UIImage *mirroredImg = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationLeftMirrored];
                ImageViewController *capVC = [[ImageViewController alloc] initWithImage:mirroredImg];
                [self.navigationController pushViewController:capVC animated:YES];
            }
        }else{
            NSLog(@"拍照出错:%@", error);
        }
    }];
}

-(AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

- (void)showFaceLandmarksAndFaceRectWithPersonsArray:(NSMutableArray *)arrPersons
{
    if (self.viewCanvas.hidden)
    {
        self.viewCanvas.hidden = NO;
    }
    self.viewCanvas.arrPersons = arrPersons;
    [self.viewCanvas setNeedsDisplay];
}

- (void)hideFace
{
    if (!self.viewCanvas.hidden)
    {
        self.viewCanvas.hidden = YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
