//
//  TrackViewController.m
//  sample_crx_mobile_track_68
//
//  Created by wangsheng on 16/12/5.
//  Copyright © 2016年 ColorReco. All rights reserved.
//

#import "TrackingViewController.h"

#import "FaceLandTrack.hpp"

#import <AVFoundation/AVFoundation.h>
#import "CanvasView.h"


@interface TrackingViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    CGFloat _imageOnPreviewScale;
    CGFloat _previewImageWidth;
    CGFloat _previewImageHeight;
    
    //   st_handle_t _hTracker;
}

@property (nonatomic , strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic , strong) AVCaptureDevice *device;
@property (nonatomic , strong) CanvasView *viewCanvas;
@property (nonatomic,strong) UILabel *poseResultLabel;


@end

@implementation TrackingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化 －－－－－
    self.view.backgroundColor = [UIColor blackColor];
    
    NSString *strModelPath = [[NSBundle mainBundle] pathForResource:@"track" ofType:@"tar"];
    //   st_result_t iRet = st_mobile_tracker_106_create(strModelPath.UTF8String,
    //                                                   ST_MOBILE_TRACKING_DEFAULT_CONFIG,
    //                                                    ST_MOBILE_TRACKING_SINGLE_THREAD,
    //                                                    &_hTracker);
    
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


- (void)setupAVCapture
{
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
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
    
    self.poseResultLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, self.view.frame.size.width - 30, 30)];
    self.poseResultLabel.textAlignment = NSTextAlignmentCenter;
    self.poseResultLabel.backgroundColor = [UIColor redColor];
    self.poseResultLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:self.poseResultLabel];
    
    AVCaptureDevice *deviceFront;
    
    NSArray *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices) {
        
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
    
    if (!input) {
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
    
    /////Set Poriy Model
    
    /*
    AVCaptureConnection *videoConnection = [dataOutput connectionWithMediaType:AVMediaTypeVideo];
    if (videoConnection)
    {
        //Front Caputure
        BOOL mirror =TRUE;
        
        if ([videoConnection isVideoMirroringSupported])
        {
            
            [videoConnection setVideoMirrored:TRUE];
            [videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
        }
    
    }
    */
    
    
    [session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    //CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    //CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    
    CVImageBufferRef imageBufferRef=CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress(imageBufferRef, 0);
    
    unsigned char *ptr_image=CVPixelBufferGetBaseAddressOfPlane(imageBufferRef, 0);
    
    
    
    float pose[3];
    int facebox[100];
    
    
    UIDeviceOrientation iDeviceOrientation = [[UIDevice currentDevice]orientation];
    
    BOOL isMirror = self.device.position == AVCaptureDevicePositionFront;
    
    
    cr_rotate_type crMobileRotate;
    
    switch (iDeviceOrientation)
    {
            
        case UIDeviceOrientationPortrait:
            
            crMobileRotate = CR_CLOCKWISE_ROTATE_90;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            
            crMobileRotate = CR_CLOCKWISE_ROTATE_270;
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            
            crMobileRotate = isMirror ? CR_CLOCKWISE_ROTATE_180 : CR_CLOCKWISE_ROTATE_0;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            
            crMobileRotate = isMirror ? CR_CLOCKWISE_ROTATE_0 : CR_CLOCKWISE_ROTATE_180;
            break;
            
        default:
            
            crMobileRotate = CR_CLOCKWISE_ROTATE_90;
            break;
    }
    
    
    //bool isok=FaceLandTrackCamera_ColorReco(ptr_image,640,480,crMobileRotate,facebox,landmark,pose);
    bool isok=FaceLandTrackCamera_ColorReco(ptr_image,480,640,CR_CLOCKWISE_ROTATE_0,facebox,landmark,pose);
    
    
    for(int h=100;h<200;h++)
    {
        for(int w=0;w<480;w++)
        {
            ptr_image[h*480+w]=255;
        }
    }
    //iRet = st_mobile_tracker_106_track(_hTracker, baseAddress, ST_PIX_FMT_NV12, iWidth, iHeight, ibytesPerRow, stMobileRotate, &pFaceArray, &iFaceCount);
    
    if (isok==false)
    {
        
        NSLog(@"tracking failed. %d and image width is %d and image height is %d\n" , crMobileRotate,0,0);
        //return;
        memset(landmark,0,sizeof(float)*68*2);
        
    }
    
    if (isok ==true)
    {
        
        // NSLog(@"tracking success is %d  %d  %d\n" ,1,480,640);
        
        
        int facere[10];
        UpdatePostionForShow(landmark,crMobileRotate,640,480);
        GetFaceBoxFromLandmarkXX(landmark,facere);
        
        NSMutableArray *arrPersons = [NSMutableArray array];
        
        //for (int i = 0; i < 1; i ++)
        //int i=0;
        {
            
            //st_mobile_106_t stFace = pFaceArray[i];
            
            //printf("ID : %d , eye_dist : %d , roll : %d , pitch : %d , yaw : %d , score : %f\n" ,stFace.ID ,stFace.eye_dist ,stFace.roll ,stFace.pitch ,stFace.yaw ,stFace.score);
            
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
        
        
        NSString *strLastFacePose = [NSString stringWithFormat:@"yaw=%d,pitch=%d,roll=%d,Rotate=%d",
                                     (int)pose[0] ,
                                     (int)pose[1] ,
                                     (int)pose[2] ,
                                     crMobileRotate];
        
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
    [self.navigationController setNavigationBarHidden:![self.navigationController.navigationBar isHidden] animated:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
