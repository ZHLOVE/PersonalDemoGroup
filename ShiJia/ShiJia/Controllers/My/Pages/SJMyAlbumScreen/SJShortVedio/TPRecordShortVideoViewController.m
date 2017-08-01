//
//  YYShootVideoViewController.m
//  ChatDemo
//
//  Created by yy on 15/10/21.
//  Copyright © 2015年 yy. All rights reserved.
//

@import Photos;
#import <AVFoundation/AVFoundation.h>
#import "TPRecordShortVideoViewController.h"
#import "AAPLPreviewView.h"
#import "TPEditVideoViewController.h"
#import "TPShortVideoProgressView.h"
#import "Masonry.h"
#import "TPFileOperation.h"

#define LightButtonBackgroundColor [UIColor colorWithRed:60/255.0 green:162/255.0 blue:221/255.0 alpha:1.0]
#define DarkButtonBackgroundColor [UIColor colorWithRed:44/255.0 green:106/255.0 blue:145/255.0 alpha:1.0]

#define LightOnBackgroundColor [UIColor colorWithRed:68/255.0 green:163/255.0 blue:219/255.0 alpha:1.0]
#define LightOffBackgroundColor [UIColor colorWithRed:224/255.0 green:226/255.0 blue:226/255.0 alpha:1.0]

static void * CapturingStillImageContext = &CapturingStillImageContext;
static void * SessionRunningContext = &SessionRunningContext;

typedef NS_ENUM(NSInteger, AVCamSetupResult) {
    AVCamSetupResultSuccess,
    AVCamSetupResultCameraNotAuthorized,
    AVCamSetupResultSessionConfigurationFailed
};

@interface TPRecordShortVideoViewController ()<AVCaptureFileOutputRecordingDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) IBOutlet UIView *topView;
@property (nonatomic, strong) IBOutlet AAPLPreviewView *previewView;
@property (nonatomic, strong) IBOutlet UIButton *cameraButton;
@property (nonatomic, strong) IBOutlet UIButton *shootButton;
@property (nonatomic, strong) IBOutlet TPShortVideoProgressView *progressView;
@property (nonatomic, strong) IBOutlet UIView *bottomView;
@property (nonatomic, strong) IBOutlet UIImageView *lightImgView;
@property (nonatomic, strong) IBOutlet UILabel *durationLabel;

// Session management
@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) AVCaptureSession* session;
@property (nonatomic, strong) AVCaptureDeviceInput* videoDeviceInput;
@property (nonatomic, strong) AVCaptureMovieFileOutput* movieFileOutput;
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;

@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioDataOutput;

// Utilities
@property (nonatomic, assign) AVCamSetupResult setupResult;
@property (nonatomic, getter=isSessionRunning) BOOL sessionRunning;
@property (nonatomic, strong) AVAssetWriter *videoWriter;
@property (nonatomic, strong) AVAssetWriterInput *videoWriterInput;
@property (nonatomic, strong) AVAssetWriterInput *audioWriterInput;
@property (nonatomic, strong) NSURL *videoURL;

@property (nonatomic) BOOL isStart;

@end

@implementation TPRecordShortVideoViewController
{
    dispatch_source_t _timer;
}

#pragma mark - view
- (void)viewDidLoad
{
    [super viewDidLoad];

    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogoutNotification:) name:TPXMPPOfflineNotification object:nil];

    //add subviews
    [self.view addSubview:self.previewView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.shootButton];
    [self.bottomView addSubview:self.progressView];
    [self.bottomView addSubview:self.lightImgView];
    [self.bottomView addSubview:self.durationLabel];

    //setup session
    [self setupCaptureSession];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = YES;

    //set autolayout
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(120);
    }];

    //    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.view).with.offset(0);
    //        make.left.equalTo(self.view).with.offset(0);
    //        make.right.equalTo(self.view).with.offset(0);
    //        make.bottom.equalTo(self.view).with.offset(0);
    //    }];

    [self.shootButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView).with.offset(0);
        make.bottom.equalTo(self.bottomView).with.offset(-5);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];

    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.bottomView).with.offset(10);
        make.right.equalTo(self.bottomView).with.offset(-10);
        make.top.equalTo(self.bottomView).with.offset(10);
        make.height.mas_equalTo(6);
    }];

    self.lightImgView.backgroundColor = LightOffBackgroundColor;
    [self.lightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView.mas_bottom).with.offset(5);
        make.centerX.equalTo(self.bottomView).with.offset(0);
        make.width.mas_equalTo(4);
        make.height.mas_equalTo(4);
    }];

    self.durationLabel.text = @"10秒";
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lightImgView.mas_bottom).with.offset(2);
        make.centerX.equalTo(self.bottomView).with.offset(0);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];

    UIImageView *backImgView = [[UIImageView alloc] init];
    backImgView.backgroundColor = [UIColor blackColor];
    backImgView.alpha = 0.6;
    [self.bottomView addSubview:backImgView];
    [self.bottomView sendSubviewToBack:backImgView];
    [backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    [self.progressView setProgress:0 animated:NO];
    [self handleSetupResult];
}

- (void)viewDidDisappear:(BOOL)animated
{

    dispatch_async( self.sessionQueue, ^{
        if ( self.setupResult == AVCamSetupResultSuccess) {
            [self.session stopRunning];
            [self removeObservers];
        }
    });



    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup AVCaptureSession
- (void)setupCaptureSession
{
    // 创建 AVCaptureSession
    self.session = [[AVCaptureSession alloc] init];

    //配置 AAPLPreviewView
    self.previewView.session = self.session;

    //Communicate with the session and other session objects on this queue
    self.sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);

    self.setupResult = AVCamSetupResultSuccess;

    // 检查视频授权状态。Video access is required and audio access is optional
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {

        case AVAuthorizationStatusAuthorized: {
            //已授权

            break;
        }
        case AVAuthorizationStatusNotDetermined: {
            dispatch_suspend(self.sessionQueue);
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                     completionHandler:^(BOOL granted) {
                                         if (!granted) {
                                             self.setupResult = AVCamSetupResultCameraNotAuthorized;
                                         }
                                         dispatch_resume(self.sessionQueue);
                                     }];
            break;
        }

        default: {
            self.setupResult = AVCamSetupResultCameraNotAuthorized;
            break;
        }
    }

    dispatch_async(self.sessionQueue, ^{
        if (self.setupResult != AVCamSetupResultSuccess) {
            return;
        }

        NSError* error = nil;

        AVCaptureDevice* videoDevice = [TPRecordShortVideoViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        AVCaptureDeviceInput* videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];

        if (!videoDeviceInput) {
            DDLogError(@"无法创建video Device Input:%@", error);
        }

        //配置session
        [self.session beginConfiguration];


        AVAudioSession *avSession = [AVAudioSession sharedInstance];

        if ([avSession respondsToSelector:@selector(requestRecordPermission:)]) {

            [avSession requestRecordPermission:^(BOOL available) {

                if (available) {
                    //completionHandler
                    //录制声音
                    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
                    AVCaptureDeviceInput * audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
                    [self.session addInput:audioInput];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *title = [NSString stringWithFormat:@"请在“设置-隐私-麦克风”选项中允许%@访问你的麦克风",CurrentAppName];
                        [[[UIAlertView alloc] initWithTitle:@"无法录音" message:title delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                    });
                }
            }];

        }



        //输入
        if ([self.session canAddInput:videoDeviceInput]) {
            [self.session addInput:videoDeviceInput];
            self.videoDeviceInput = videoDeviceInput;

            dispatch_async(dispatch_get_main_queue(), ^{

                UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
                AVCaptureVideoOrientation initialVideoOrientation = AVCaptureVideoOrientationLandscapeLeft;
                if (statusBarOrientation != UIInterfaceOrientationUnknown) {
                    initialVideoOrientation = (AVCaptureVideoOrientation)statusBarOrientation;
                }

                AVCaptureVideoPreviewLayer* previewLayer = (AVCaptureVideoPreviewLayer*)self.previewView.layer;
                previewLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                previewLayer.masksToBounds = YES;
                CALayer *layer = self.view.layer;
                layer.masksToBounds = YES;
                previewLayer.connection.videoOrientation = initialVideoOrientation;
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

            });
        }
        else {
            DDLogInfo(@"无法添加video Device Input到 session");
            self.setupResult = AVCamSetupResultSessionConfigurationFailed;
        }

        //输出
        AVCaptureMovieFileOutput* movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];

        if ([self.session canAddOutput:movieFileOutput]) {
            [self.session addOutput:movieFileOutput];

            AVCaptureConnection* connection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];

            if (connection.isVideoStabilizationSupported) {
                connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
            }

            self.movieFileOutput = movieFileOutput;
        }
        else {
            DDLogInfo(@"无法添加 movie File Output 到 session");
            self.setupResult = AVCamSetupResultSessionConfigurationFailed;
        }

        //        self.videoDataOutput = [AVCaptureVideoDataOutput new];
        //        NSDictionary *newSettings =
        //        @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA), (NSString *)kCVPixelBufferWidthKey:[NSNumber numberWithInt:[UIScreen mainScreen].bounds.size.width/1],
        //           (NSString *)kCVPixelBufferHeightKey:[NSNumber numberWithInt:([UIScreen mainScreen].bounds.size.height-64-150)/1] };
        //        self.videoDataOutput.videoSettings = newSettings;
        //
        //        // discard if the data output queue is blocked (as we process the still image[videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];)
        //
        //        // create a serial dispatch queue used for the sample buffer delegate as well as when a still image is captured
        //        // a serial dispatch queue must be used to guarantee that video frames will be delivered in order
        //        // see the header doc for setSampleBufferDelegate:queue: for more information
        //        dispatch_queue_t videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
        //        [self.videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];


        //        if ( [self.session canAddOutput:self.videoDataOutput] )
        //            [self.session addOutput:self.videoDataOutput];

        [self.session setSessionPreset:AVCaptureSessionPresetMedium];
        [self.session commitConfiguration];
    });
}

- (void)handleSetupResult
{
    dispatch_async(self.sessionQueue, ^{
        switch (self.setupResult) {
            case AVCamSetupResultSuccess: {
                [self addObservers];
                [self.session startRunning];
                self.sessionRunning = self.session.isRunning;
                break;
            }

            case AVCamSetupResultCameraNotAuthorized: {

                dispatch_async(dispatch_get_main_queue(), ^{

                    NSString* message = NSLocalizedString(@"AVCam doesn't have permission to use the camera, please change privacy settings", @"Alert message when the user has denied access to the camera");
                    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"Alert OK button") style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:cancelAction];
                    // Provide quick access to Settings.
                    UIAlertAction* settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", @"Alert button to open Settings")
                                                                             style:UIAlertActionStyleDefault
                                                                           handler:^(UIAlertAction* action) {
                                                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                                           }];
                    [alertController addAction:settingsAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
                break;
            }
            case AVCamSetupResultSessionConfigurationFailed: {

                dispatch_async(dispatch_get_main_queue(), ^{

                    NSString* message = NSLocalizedString(@"Unable to capture media", @"Alert message when something goes wrong during capture session configuration");
                    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"Alert OK button") style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
                break;
            }
            default:
                break;
        }
    });
}

- (BOOL)setupWriter
{
    NSError *error = nil;
    _videoWriter = [[AVAssetWriter alloc] initWithURL:_videoURL fileType:AVFileTypeMPEG4
                                                error:&error];
    NSParameterAssert(_videoWriter);


    // Add video input
    NSDictionary *videoCompressionProps = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithDouble:128.0*1024.0], AVVideoAverageBitRateKey,
                                           nil ];

    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:[UIScreen mainScreen].bounds.size.width/1], AVVideoWidthKey,
                                   [NSNumber numberWithInt:([UIScreen mainScreen].bounds.size.height-64-150)/1], AVVideoHeightKey,
                                   videoCompressionProps, AVVideoCompressionPropertiesKey,
                                   nil];

    _videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                           outputSettings:videoSettings];


    NSParameterAssert(_videoWriterInput);
    _videoWriterInput.expectsMediaDataInRealTime = YES;


    // Add the audio input
    AudioChannelLayout acl;
    bzero( &acl, sizeof(acl));
    acl.mChannelLayoutTag = kAudioChannelLayoutTag_Mono;


    NSDictionary* audioOutputSettings = nil;
    // Both type of audio inputs causes output video file to be corrupted.
    //    if( NO ) {
    //        // should work from iphone 3GS on and from ipod 3rd generation
    //        audioOutputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
    //                               [ NSNumber numberWithInt: kAudioFormatMPEG4AAC ], AVFormatIDKey,
    //                               [ NSNumber numberWithInt: 1 ], AVNumberOfChannelsKey,
    //                               [ NSNumber numberWithFloat: 44100.0 ], AVSampleRateKey,
    //                               [ NSNumber numberWithInt: 64000 ], AVEncoderBitRateKey,
    //                               [ NSData dataWithBytes: &acl length: sizeof( acl ) ], AVChannelLayoutKey,
    //                               nil];
    //    } else {
    // should work on any device requires more space
    audioOutputSettings = [ NSDictionary dictionaryWithObjectsAndKeys:
                           [ NSNumber numberWithInt: kAudioFormatAppleLossless ], AVFormatIDKey,
                           [ NSNumber numberWithInt: 16 ], AVEncoderBitDepthHintKey,
                           [ NSNumber numberWithFloat: 44100.0 ], AVSampleRateKey,
                           [ NSNumber numberWithInt: 1 ], AVNumberOfChannelsKey,
                           [ NSData dataWithBytes: &acl length: sizeof( acl ) ], AVChannelLayoutKey,
                           nil ];
    //    }
    _audioWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:audioOutputSettings];
    _audioWriterInput.expectsMediaDataInRealTime = YES;

    // add input
    if ([_videoWriter canAddInput:_videoWriterInput]) {
        [_videoWriter addInput:_videoWriterInput];
    }

    if ([_videoWriter canAddInput:_audioWriterInput]) {
        [_videoWriter addInput:_audioWriterInput];
    }

    return YES;
}

#pragma mark - KVO & notifications
- (void)addObservers
{
    [self.session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:SessionRunningContext];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:self.videoDeviceInput.device];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:self.session];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionWasInterrupted:) name:AVCaptureSessionWasInterruptedNotification object:self.session];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionInterruptionEnded:) name:AVCaptureSessionInterruptionEndedNotification object:self.session];
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.session removeObserver:self forKeyPath:@"running" context:SessionRunningContext];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if (context == SessionRunningContext) {
        BOOL isSessionRunning = [change[NSKeyValueChangeNewKey] boolValue];

        dispatch_async(dispatch_get_main_queue(), ^{
            self.cameraButton.enabled = isSessionRunning && ([AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count > 1);

        });
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)subjectAreaDidChange:(NSNotification*)notification
{
    CGPoint devicePoint = CGPointMake(0.5, 0.5);
    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeAutoExpose atDevicePoint:devicePoint monitorSubjectAreaChange:NO];
}

- (void)sessionRuntimeError:(NSNotification*)notification
{
    NSError* error = notification.userInfo[AVCaptureSessionErrorKey];
    DDLogError(@"Capture session runtime errror:%@", error);

    if (error.code == AVErrorMediaServicesWereReset) {
        dispatch_async(self.sessionQueue, ^{
            if (self.isSessionRunning) {
                [self.session startRunning];
                self.sessionRunning = self.session.isRunning;
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{


                });
            }
        });
    }
    else {

    }
}

- (void)sessionWasInterrupted:(NSNotification*)notification
{

    //录制视频过程中被打断
    //    BOOL showResumeButton = NO;
    //    if (AVCaptureSessionInterruptionReasonKey) {
    //        AVCaptureSessionInterruptionReason reason = [notification.userInfo[AVCaptureSessionInterruptionReasonKey] integerValue];
    //        if (reason == AVCaptureSessionInterruptionReasonVideoDeviceNotAvailableWithMultipleForegroundApps) {
    //            //摄像头不可用
    //        }
    //    }
    //    else {
    //        DDLogInfo(@"Capture session was interrupted");
    //        showResumeButton = ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive);
    //    }
    //
    //    if (showResumeButton) {
    //        //录制视频过程中被打断
    //    }
}

- (void)sessionInterruptionEnded:(NSNotification*)notification
{
    DDLogInfo(@"Capture session interruption ended");
}

- (void)handleLogoutNotification:(NSNotification *)notification
{
    // [self backToMainViewController];
}

#pragma mark - Actions
- (IBAction)backButtonClicked:(id)sender
{
    self.navigationController.navigationBarHidden = NO;
    //    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeCameraButtonClicked:(id)sender
{
    self.cameraButton.enabled = NO;
    //    self.recordButton.enabled = NO;
    //    self.stillButton.enabled = NO;

    dispatch_async( self.sessionQueue, ^{
        AVCaptureDevice *currentVideoDevice = self.videoDeviceInput.device;
        AVCaptureDevicePosition preferredPosition = AVCaptureDevicePositionUnspecified;
        AVCaptureDevicePosition currentPosition = currentVideoDevice.position;

        switch ( currentPosition )
        {
            case AVCaptureDevicePositionUnspecified:
            case AVCaptureDevicePositionFront:
                preferredPosition = AVCaptureDevicePositionBack;
                break;
            case AVCaptureDevicePositionBack:
                preferredPosition = AVCaptureDevicePositionFront;
                break;
        }

        AVCaptureDevice *videoDevice = [TPRecordShortVideoViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:preferredPosition];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];

        [self.session beginConfiguration];

        // Remove the existing device input first, since using the front and back camera simultaneously is not supported.
        [self.session removeInput:self.videoDeviceInput];

        if ( [self.session canAddInput:videoDeviceInput] ) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentVideoDevice];

            [TPRecordShortVideoViewController setFlashMode:AVCaptureFlashModeAuto forDevice:videoDevice];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:videoDevice];

            [self.session addInput:videoDeviceInput];
            self.videoDeviceInput = videoDeviceInput;
        }
        else {
            [self.session addInput:self.videoDeviceInput];
        }

        AVCaptureConnection *connection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ( connection.isVideoStabilizationSupported ) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }

        [self.session commitConfiguration];

        dispatch_async( dispatch_get_main_queue(), ^{
            self.cameraButton.enabled = YES;
        } );
    } );

}

- (IBAction)takeVideoButtonTouchDown:(UILongPressGestureRecognizer*)gestureRecognizer
{

    if([gestureRecognizer state]==UIGestureRecognizerStateBegan){

        self.lightImgView.backgroundColor = LightOnBackgroundColor;
        self.cameraButton.enabled = NO;
        //    self.recordButton.enabled = NO;

        dispatch_async( self.sessionQueue, ^{
            if ( ! self.movieFileOutput.isRecording ) {
                if ( [UIDevice currentDevice].isMultitaskingSupported ) {
                    // Setup background task. This is needed because the -[captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:]
                    // callback is not received until AVCam returns to the foreground unless you request background execution time.
                    // This also ensures that there will be time to write the file to the photo library when AVCam is backgrounded.
                    // To conclude this background execution, -endBackgroundTask is called in
                    // -[captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:] after the recorded file has been saved.
                    //                self.backgroundRecordingID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
                }

                // Update the orientation on the movie file output video connection before starting recording.
                AVCaptureConnection *connection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
                AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
                connection.videoOrientation = previewLayer.connection.videoOrientation;

                // Turn OFF flash for video recording.
                [TPRecordShortVideoViewController setFlashMode:AVCaptureFlashModeOff forDevice:self.videoDeviceInput.device];

                // Start recording to a temporary file.
                NSString *outputFileName = [NSProcessInfo processInfo].globallyUniqueString;
                //            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                //            NSString *videoPath = [documentsPath stringByAppendingPathComponent:@"Videos"];
                NSString *videoPath = [TPFileOperation getShortVideoFilePath];
                [[NSFileManager defaultManager] createDirectoryAtPath:videoPath withIntermediateDirectories:YES attributes:nil error:nil];
                NSString *outputFilePath = [videoPath stringByAppendingPathComponent:[outputFileName stringByAppendingPathExtension:@"mov"]];
                [self.movieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:outputFilePath] recordingDelegate:self];
                self.videoURL = [NSURL fileURLWithPath:outputFilePath];
                [self setupWriter];
            }
            
        } );

    }
    if([gestureRecognizer state]==UIGestureRecognizerStateEnded){
        if (_timer != nil) {
            dispatch_source_cancel(_timer);
        }
        [self.movieFileOutput stopRecording];
    }
}

- (IBAction)takeVideoButtonTouchUpInside:(id)sender
{
    if (_timer != nil) {
        dispatch_source_cancel(_timer);
    }
    [self.movieFileOutput stopRecording];
    //    [_videoWriterInput markAsFinished];
    //    [_videoWriter endSessionAtSourceTime:lastSampleTime];

    //    [_videoWriter finishWriting];
}

- (IBAction)takeVideoButtonTouchUpOutside:(id)sender
{
    if (_timer != nil) {
        dispatch_source_cancel(_timer);
    }
    [self.movieFileOutput stopRecording];

}

- (IBAction)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint devicePoint = [(AVCaptureVideoPreviewLayer *)self.previewView.layer captureDevicePointOfInterestForPoint:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeAutoExpose atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

#pragma mark - timer
- (void)startTiming
{
    __block int count = 0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),0.1*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{

        dispatch_async(dispatch_get_main_queue(), ^{

            if (count >= 100) {

                //超过10秒停止录像

                count = 0;
                [self takeVideoButtonTouchUpInside:nil];
                self.durationLabel.text = @"10秒";

            }else{
                count++;
                [self.progressView setProgress:count/100.0 animated:YES];
                self.durationLabel.text = [NSString stringWithFormat:@"%.f秒",count/10.0];
            }

        });

    });
    dispatch_resume(_timer);
}

#pragma mark - File output Recording Delegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    // Enable the Record button to let the user stop the recording.
    dispatch_async( dispatch_get_main_queue(), ^{
        //更新ui

    });

    //开始计时
    [self startTiming];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{

    if (_timer != nil) {
        dispatch_source_cancel(_timer);
    }
    [self.movieFileOutput stopRecording];

    // Note that currentBackgroundRecordingID is used to end the background task associated with this recording.
    // This allows a new recording to be started, associated with a new UIBackgroundTaskIdentifier, once the movie file output's isRecording property
    // is back to NO — which happens sometime after this method returns.
    // Note: Since we use a unique file path for each recording, a new recording will not overwrite a recording currently being saved.
    //    UIBackgroundTaskIdentifier currentBackgroundRecordingID = self.backgroundRecordingID;
    //    self.backgroundRecordingID = UIBackgroundTaskInvalid;

    dispatch_block_t cleanup = ^{
        [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
        //        if ( currentBackgroundRecordingID != UIBackgroundTaskInvalid ) {
        //            [[UIApplication sharedApplication] endBackgroundTask:currentBackgroundRecordingID];
        //        }
    };

    BOOL success = YES;

    if ( error ) {
        DDLogError( @"Movie file finishing error: %@", error );
        success = [error.userInfo[AVErrorRecordingSuccessfullyFinishedKey] boolValue];
    }
    if ( success ) {
        //mov 转 mp4

    }
    else {
        cleanup();
    }

    // Enable the Camera and Record buttons to let the user switch camera and start another recording.
    dispatch_async( dispatch_get_main_queue(), ^{

        // Only enable the ability to change camera if the device has more than one camera.
        self.cameraButton.enabled = ( [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count > 1 );

        //        if (_timer != nil) {
        //            dispatch_source_cancel(_timer);
        //        }
        NSData *data = [NSData dataWithContentsOfURL:outputFileURL];

        if (data != nil) {
            if (![HiTVGlobals sharedInstance].isLogin) {
                [self showAlert:@"请先登录" withDelegate:nil];
                return ;
            }



            TPEditVideoViewController *editVC = [[TPEditVideoViewController alloc] init];
            editVC.videoURL = outputFileURL;
            editVC.AlbumModel = self.AlbumModel;

            [self.navigationController pushViewController:editVC animated:YES];

        }
        else{

            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
            [[UIApplication sharedApplication].keyWindow addSubview:hud];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"视频太短！";
            [hud show:YES];
            [hud hide:YES afterDelay:2];

        }


    });
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{

    static int frame = 0;

    CMTime lastSampleTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);

    if( frame == 0 && _videoWriter.status != AVAssetWriterStatusWriting  )

    {
        [_videoWriter startWriting];

        [_videoWriter startSessionAtSourceTime:lastSampleTime];

    }
    if (captureOutput == _videoDataOutput)

    {
        if( _videoWriter.status > AVAssetWriterStatusWriting )

        {
            DDLogInfo(@"Warning: writer status is %ld", (long)_videoWriter.status);

            if( _videoWriter.status == AVAssetWriterStatusFailed )

                DDLogError(@"Error: %@", _videoWriter.error);

            return;
        }
        if ([_videoWriterInput isReadyForMoreMediaData]){

            if( ![_videoWriterInput appendSampleBuffer:sampleBuffer] ){

                DDLogInfo(@"Unable to write to video input");
            }

            else{

                DDLogInfo(@"already write vidio");

            }
        }

    }
    else if (captureOutput == _audioDataOutput)
    {
        if( _videoWriter.status > AVAssetWriterStatusWriting )

        {
            DDLogInfo(@"Warning: writer status is %ld", (long)_videoWriter.status);

            if( _videoWriter.status == AVAssetWriterStatusFailed )

                DDLogError(@"Error: %@", _videoWriter.error);

            return;

        }

        if ([_audioWriterInput isReadyForMoreMediaData]){

            if( ![_audioWriterInput appendSampleBuffer:sampleBuffer] )

                DDLogInfo(@"Unable to write to audio input");

            else{

                DDLogInfo(@"already write audio");
            }

        }

    }

}

#pragma mark - Device configuration
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
    dispatch_async(self.sessionQueue, ^{
        AVCaptureDevice* device = self.videoDeviceInput.device;
        NSError* error = nil;
        if ([device lockForConfiguration:&error]) {
            if (device.isFocusPointOfInterestSupported && [device isFocusModeSupported:focusMode]) {
                device.focusPointOfInterest = point;
                device.focusMode = focusMode;
            }

            if (device.isExposurePointOfInterestSupported && [device isExposureModeSupported:exposureMode]) {
                device.exposurePointOfInterest = point;
                device.exposureMode = exposureMode;
            }

            device.subjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange;
            [device unlockForConfiguration];
        }
        else {
            DDLogInfo(@"Could not lock device for configuration:%@", error);
        }
    });
}

+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice*)device
{
    if (device.hasFlash && [device isFlashModeSupported:flashMode]) {
        NSError* error = nil;
        if ([device lockForConfiguration:&error]) {
            device.flashMode = flashMode;
            [device unlockForConfiguration];
        }
        else {
            DDLogInfo(@"Could not lock device for configuration:%@", error);
        }
    }
}

+ (AVCaptureDevice*)deviceWithMediaType:(NSString*)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray* devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice* captureDevice = devices.firstObject;

    for (AVCaptureDevice* device in devices) {
        if (device.position == position) {
            captureDevice = device;
            break;
        }
    }
    return captureDevice;
}

#pragma mark - getter
- (AAPLPreviewView *)previewView
{
    if (_previewView == nil) {
        _previewView = [[AAPLPreviewView alloc] init];
        _previewView.backgroundColor = [UIColor blackColor];
    }
    return _previewView;
}

- (UIView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor clearColor];

    }
    return _bottomView;
}

- (UIButton *)shootButton
{
    if (_shootButton == nil) {
        _shootButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shootButton setBackgroundImage:[UIImage imageNamed:@"shortvideo_shoot_btn"] forState:UIControlStateNormal];
        //[_shootButton setImage:[UIImage imageNamed:@"shortvideo_shoot_btn"] forState:UIControlStateNormal];
        //        _shootButton.layer.masksToBounds = YES;
        //        _shootButton.layer.cornerRadius = 30;
        [_shootButton addTarget:self action:@selector(takeVideoButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
//        [_shootButton addTarget:self action:@selector(takeVideoButtonTouchDown:) forControlEvents:UIControlEventTouchDown];

        UILongPressGestureRecognizer*longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(takeVideoButtonTouchDown:)];


        longPress.minimumPressDuration=0.5;//定义按的时间

        
        [_shootButton addGestureRecognizer:longPress];


        [_shootButton addTarget:self action:@selector(takeVideoButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [_shootButton addTarget:self action:@selector(takeVideoButtonTouchUpOutside:) forControlEvents:UIControlEventTouchCancel];

    }
    return _shootButton;
}

- (TPShortVideoProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[TPShortVideoProgressView alloc] init];
        //        _progressView.trackTintColor = [UIColor colorWithRed:55/255.0 green:143/255.0 blue:206/255.0 alpha:1.0];
        //        _progressView.progressTintColor = [UIColor colorWithRed:74/255.0 green:97/255.0 blue:117/255.0 alpha:1.0];
        
    }
    return _progressView;
}

- (UILabel *)durationLabel
{
    if (_durationLabel == nil) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.backgroundColor = [UIColor clearColor];
        _durationLabel.font = [UIFont systemFontOfSize:14.0];
        _durationLabel.textColor = kColorBlueTheme;
        _durationLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _durationLabel;
}

- (UIImageView *)lightImgView
{
    if (_lightImgView == nil) {
        _lightImgView = [[UIImageView alloc] init];
        _lightImgView.backgroundColor = [UIColor colorWithRed:55/255.0 green:145/255.0 blue:209/255.0 alpha:1.0];
        _lightImgView.layer.cornerRadius = 2.0;
        _lightImgView.layer.masksToBounds = YES;
    }
    return _lightImgView;
}
@end
