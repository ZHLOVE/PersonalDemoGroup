//
//  MSCameraViewController_OC.m
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 29/10/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import "MSCameraViewController_OC.h"
#import "ViewUtils.h"

@interface MSCameraViewController_OC ()
@property (strong, nonatomic) UILabel *errorLabel;

@property (strong, nonatomic) UIView *topBar;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *flashButton;
@property (strong, nonatomic) UIImageView *guideLine;
@property (strong, nonatomic) UIView *tipsBar;
@property (strong, nonatomic) UILabel *tipsLabel;
@property (strong, nonatomic) UIView *bottomBar;
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *albumButton;
@property (strong, nonatomic) UIButton *backButton;

@property (strong,nonatomic) NSTimer *tipsTimer;
@end

@implementation MSCameraViewController_OC {
    int tipIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    // ----- initialize camera -------- //
    
    // create camera vc
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh
                                                 position:CameraPositionBack];
    
    // attach to a view controller
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    
    // read: http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
    // you probably will want to set this to YES, if you are going view the image outside iOS.
    self.camera.fixOrientationAfterCapture = NO;
    
    // take the required actions on a device change
    __weak typeof(self) weakSelf = self;
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
        // device changed, check if flash is available
        weakSelf.flashButton.hidden = ![camera isFlashAvailable];
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission ||
               error.code == LLSimpleCameraErrorCodeMicrophonePermission) {
                
                if(weakSelf.errorLabel) {
                    [weakSelf.errorLabel removeFromSuperview];
                }
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, (screenRect.size.height / 2.0f)-30, screenRect.size.width-20, 100)];
                label.text = NSLocalizedString(@"It looks like your privacy settings are preventing us from accessing your camera. You can fix this by going to the Settings app, touch Privacy, and turn camera on.", comment:"");
                label.numberOfLines = 0;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0f];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                [label sizeToFit];
                label.center = CGPointMake(screenRect.size.width / 2.0f, screenRect.size.height / 2.0f);
                weakSelf.errorLabel = label;
                [weakSelf.view addSubview:weakSelf.errorLabel];
            }
        }
    }];
    
    // ----- camera buttons -------- //
    
    //顶部条状物
    self.topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    self.topBar.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.3f];
    [self.view addSubview:self.topBar];
    
    //闪光灯
    self.flashButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.flashButton.frame = CGRectMake(0, 0, 50.0f, 50.0f);
    self.flashButton.tintColor = [UIColor whiteColor];
    [self.flashButton setImage:[UIImage imageNamed:@"camera_flash_off"] forState:UIControlStateNormal];
    [self.flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBar addSubview:self.flashButton];
    
    //切换摄像头
    self.switchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.switchButton.frame = CGRectMake(0, 0, 50.0f, 50.0f);
    self.switchButton.tintColor = [UIColor whiteColor];
    [self.switchButton setImage:[UIImage imageNamed:@"camera_flip"] forState:UIControlStateNormal];
    [self.switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBar addSubview:self.switchButton];
    
    //辅助线4:3
    self.guideLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50.0f, self.view.width, self.view.width / 3.0f * 4.0f)];
    self.guideLine.image = [UIImage imageNamed:@"guideline_4_3"];
    [self.view addSubview:self.guideLine];
    
    //tips条状物
    self.tipsBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tipsBar.backgroundColor = [[UIColor alloc] initWithRed:224.0f / 255.0f green:224.0f / 255.0f blue:224.0f / 255.0f alpha:0.6f];
    self.tipsBar.layer.cornerRadius = 10.0f;
    [self.view addSubview:self.tipsBar];
    
    //tips
    self.tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tipsLabel.text = @"";
    self.tipsLabel.textColor = [UIColor whiteColor];
    self.tipsLabel.numberOfLines = 0;
    self.tipsLabel.font = [UIFont systemFontOfSize:12];
    self.tipsLabel.backgroundColor = [UIColor clearColor];
    [self.tipsBar addSubview:self.tipsLabel];
    
    //底部条状物
    self.bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 69)];
    self.bottomBar.backgroundColor = [[UIColor alloc] initWithRed:33.0f / 255.0f green:33.0f / 255.0f blue:33.0f / 255.0f alpha:1.0f];
    [self.view addSubview:self.bottomBar];
    
    //拍摄按钮
    self.snapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56.0f, 56.0f)];
    [self.snapButton setImage:[UIImage imageNamed:@"camera_shutter"] forState:UIControlStateNormal];
    self.snapButton.contentMode = UIViewContentModeScaleToFill;
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar addSubview:self.snapButton];
    
    //相册按钮
    self.albumButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 60.0f)];
    [self.albumButton setImage:[UIImage imageNamed:@"camera_gallery"] forState:UIControlStateNormal];
    self.albumButton.contentMode = UIViewContentModeScaleToFill;
    [self.albumButton addTarget:self action:@selector(albumButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar addSubview:self.albumButton];
    
    //返回按钮
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 60.0f)];
    [self.backButton setImage:[UIImage imageNamed:@"camera_back"] forState:UIControlStateNormal];
    self.backButton.contentMode = UIViewContentModeScaleToFill;
    [self.backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar addSubview:self.backButton];
    
    // ----- other things -------- //
    
    //打开计时器
    tipIndex = 0;
    [self refreshTips];
    [self setTipsTimer:[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(refreshTips) userInfo:nil repeats:YES]];
    
    //调整控件位置
    [self reSize];
    
    //替换对焦框
    [self addZiDingYiFocusBox];
}

- (void)addZiDingYiFocusBox {
    CALayer *focusBox = [[CALayer alloc] init];
    focusBox.bounds = CGRectMake(0.0f, 0.0f, 58.0f, 58.0f);
    focusBox.opacity = 0.0f;
    focusBox.contents = (id)[UIImage imageNamed:@"focus"].CGImage;
    [self.view.layer addSublayer:focusBox];
    
    CABasicAnimation *focusBoxAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    focusBoxAnimation.duration = 2;
    focusBoxAnimation.autoreverses = NO;
    focusBoxAnimation.repeatCount = 0.0;
    focusBoxAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    focusBoxAnimation.toValue = [NSNumber numberWithFloat:0.0];
    
    [_camera alterFocusBox:focusBox animation:focusBoxAnimation];
}

- (void)reSize {
    //adjust position
    self.camera.view.frame = CGRectMake(0.0f, 0.0f, self.view.boundsWidth, self.view.boundsHeight);
    
    self.topBar.frame = CGRectMake(0, 0, self.view.width, 50.0f);
    
    self.snapButton.center = CGPointMake(self.view.boundsWidth / 2.0f, self.view.boundsHeight / 2.0f);
    self.snapButton.bottom = self.view.height - 15;
    
    self.switchButton.right = self.view.width;
    self.switchButton.top = 0;
    
    self.flashButton.top = 0;
    self.flashButton.left = 0;
    
    CGFloat bottomHeight = self.view.height - self.guideLine.height - self.topBar.height;
    CGFloat bottomBarHeight = (69 > bottomHeight ? 69 : bottomHeight);
    self.bottomBar.frame = CGRectMake(0, self.view.height - bottomBarHeight, self.view.width, bottomBarHeight);
    
    self.guideLine.frame = CGRectMake(0, 0, self.view.width, self.view.width / 3.0f * 4.0f);
    self.guideLine.center = CGPointMake(self.view.center.x, (self.topBar.bottom + self.bottomBar.top) / 2.0f);
    
    self.snapButton.center = CGPointMake(self.bottomBar.width / 2.0f, self.bottomBar.height / 2.0f);
    
    self.albumButton.center = CGPointMake(40.0f, self.bottomBar.height / 2.0f);
    self.albumButton.left = 10.0f;
    
    self.backButton.center = CGPointMake(40.0f, self.bottomBar.height / 2.0f);
    self.backButton.right = self.bottomBar.right - 10.0f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // start the camera
    [self.camera start];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:true];
    
    if (self.camera.view.width != self.view.width || self.camera.view.height != self.view.height) {
        [self reSize];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // stop the camera
    [self.camera stop];
    
    // 屏蔽后一个界面的返回按钮的文字
    UIBarButtonItem* returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @" ";
    self.navigationItem.backBarButtonItem = returnButtonItem;
}

/* camera button methods */

- (void)switchButtonPressed:(UIButton *)button {
    [self.camera togglePosition];
}

- (void)flashButtonPressed:(UIButton *)button {
    if(self.camera.flash == CameraFlashOff) {
        if([self.camera updateFlashMode:CameraFlashOn]) {
            [self.flashButton setImage:[UIImage imageNamed:@"camera_flash_on"] forState:UIControlStateNormal];
        }
    } else {
        if([self.camera updateFlashMode:CameraFlashOff]) {
            [self.flashButton setImage:[UIImage imageNamed:@"camera_flash_off"] forState:UIControlStateNormal];
        }
    }
}

- (void)snapButtonPressed:(UIButton *)button {
    NSLog(@"请重载拍照按钮!");
}

- (void)albumButtonPressed:(UIButton *)button {
    NSLog(@"请重载相册按钮!");
}

- (void)backButtonPressed:(UIButton *)button {
    NSLog(@"请重载返回按钮!");
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 刷新tips
-(void)refreshTips {
    NSArray *aTips = [[NSArray alloc] initWithObjects:
                      NSLocalizedString(@"Ask someone else to help you take pictures.", comment: ""),
                      NSLocalizedString(@"Make sure there is enough light.", comment: ""),
                      NSLocalizedString(@"Keep yourself in clear contrast to the background.", comment: ""),
                      NSLocalizedString(@"Keep your head straight.", comment: ""),nil];
    NSArray *bTips = [[NSArray alloc] initWithObjects:
                      NSLocalizedString(@"It's better to use the back facing camera.", comment: ""),
                      NSLocalizedString(@"We recommend you to use the back facing camera.", comment: ""),nil];
    
    NSArray *tar = self.camera.position == CameraPositionFront ? bTips : aTips;
    self.tipsLabel.text = tar[(++ tipIndex) % tar.count];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],};
    CGSize textSize = [self.tipsLabel.text boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;;
    [self.tipsLabel setFrame:CGRectMake(10, 6, textSize.width, textSize.height)];
    
    self.tipsBar.top = self.topBar.bottom;
    self.tipsBar.width = textSize.width + 20;
    self.tipsBar.height = textSize.height + 12;
    self.tipsBar.left = (self.view.width - self.tipsBar.width) / 2.0f;
}

//隐藏导航栏
-(void)hideNavigationController {
    
}

@end
