//
//  QRCodeController.m
//  HiTV
//
//  Created by 蒋海量 on 15/7/27.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "QRCodeController.h"
#import "QRView.h"
//#import "JSON.h"
#import "TogetherManager.h"
#import "FriendInfoController.h"
#import "SearchResultController.h"
#import "OMGToast.h"
#import "CCLocationManager.h"
#import "MyFriendsController.h"

#import "SJLightViewController.h"

@interface QRCodeController ()<AVCaptureMetadataOutputObjectsDelegate,QRViewDelegate>
@property (strong, nonatomic) AVCaptureDevice * device;
@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;

@property (nonatomic, strong) TRTopNavgationView *naviView;

@end

@implementation QRCodeController


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)dealloc{
    _input = nil;
    _output = nil;
    _session = nil;
    _preview = nil;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(0, 0, 0, 0.8);
    self.title = @"扫一扫";
    
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    QRView *qrRectView = [[QRView alloc] initWithFrame:screenRect];
    qrRectView.transparentArea = CGSizeMake(200, 200);
    qrRectView.backgroundColor = [UIColor clearColor];
    qrRectView.center = CGPointMake(W / 2, (H) / 2);
    qrRectView.delegate = self;
    [self.view addSubview:qrRectView];
    
    
    //修正扫描区域
    
    CGFloat screenHeight = self.view.frame.size.height-150;
    CGFloat screenWidth = self.view.frame.size.width;
    CGRect cropRect = CGRectMake((screenWidth - qrRectView.transparentArea.width) / 2,
                                 (screenHeight - qrRectView.transparentArea.height) / 2,
                                 qrRectView.transparentArea.width,
                                 qrRectView.transparentArea.height);
    
    [_output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,
                                          cropRect.origin.x / screenWidth,
                                          cropRect.size.height / screenHeight,
                                          cropRect.size.width / screenWidth)];
    
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    lab.center = CGPointMake(W / 2, (H-150+200+60) / 2);
    lab.backgroundColor = [UIColor clearColor];
    lab.text = @"将二维码放入框内，即可自动扫描";
    lab.font = [UIFont systemFontOfSize:16.0];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    //[self.view addSubview:lab];
    
    UIImageView *bellowImg = [[UIImageView alloc]init];

    [self.view addSubview:bellowImg];

    bellowImg.frame = CGRectMake(0, 0, 292, 148);
    bellowImg.center = CGPointMake(W / 2, (H-150+292+80) / 2);
    bellowImg.image = [UIImage imageNamed:@"qrcode_bj"];

    
    [MBProgressHUD loading:@"正在加载..." toView:self.view];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self initQRCode];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    });
    
    [self initNavigationView];

}
-(void)initQRCode{
    if ([self validateCamera]) {
        // Output
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // Input
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        
        _output = [[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        
        // Session
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:self.input])
        {
            [_session addInput:self.input];
        }
        
        if ([_session canAddOutput:self.output])
        {
            [_session addOutput:self.output];
        }
        
        // 条码类型 AVMetadataObjectTypeQRCode
        
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        
        // Preview
        _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
        _preview.videoGravity =AVLayerVideoGravityResize;
        _preview.frame =self.view.layer.bounds;
        [self.view.layer insertSublayer:_preview atIndex:0];
        
        
        
        [_session startRunning];
        
    }else{
        [self showAlert:@"相机权限受限,请进入设置打开相机权限" withDelegate:nil];
    }
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)validateCamera {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        DDLogWarn(@"相机权限受限");
        return NO;
    }
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        if (!metadataObject) {
            return;
        }
        stringValue = metadataObject.stringValue;
        
        NSDictionary *dic = [stringValue mj_JSONObject];
        if (!dic) {
            [self uploadTogetherInfo:stringValue];
            
        }else{
            [self searchFriendsRequest:[dic objectForKey:@"userid"]];
        }
        
        [UMengManager event:@"U_ScanCode"];
    }
    
}
//关注好友
-(void)concernFriendRequest:(UserEntity *)entity{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:entity.uid forKey:@"friendUid"];
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BaseAFHTTPManager postRequestOperationForHost:SOCIALHOST forParam:@"/taipan/addUserFriend" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"code"] intValue] == 0) {
            [OMGToast showWithText:@"添加好友成功"];
            
            // add log.
            NSString* content = [NSString stringWithFormat:@"friendphone=%@", isNullString(entity.phoneNo)];
            [Utils BDLog:1 module:@"605" action:@"AddFriend" content:content];
            // add log.
            [UMengManager event:@"U_AddFriend"];

            MyFriendsController *MyFriendsVC = [[MyFriendsController alloc] init];
            [self.navigationController pushViewController:MyFriendsVC animated:YES];
           // self.hidesBottomBarWhenPushed = NO;
        }
        else{
            [OMGToast showWithText:[resultDic objectForKey:@"message"]];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }failure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
    }];
}
-(void)searchFriendsRequest:(NSString *)uid{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:uid forKey:@"oprUid"];
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN forParam:@"/userservice/taipan/userInfo" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"code"] intValue] == 0) {
            NSDictionary *infoDic = [resultDic objectForKey:@"userInfo"];
            UserEntity *entity = [[UserEntity alloc]initWithDictionary:infoDic];
            /*SearchResultController *searchVC = [[SearchResultController alloc]init];
            searchVC.userEntity = entity;
            [self.navigationController pushViewController:searchVC animated:YES];*/
            [self concernFriendRequest:entity];
            NSString* content = [NSString stringWithFormat:@"scanresult=%d&scantype=%@&codeurl=%@",0, @"添加好友", isNullString(uid)];
            [Utils BDLog:1 module:@"605" action:@"ScanCode" content:content];

        }
        else{
            NSString* content = [NSString stringWithFormat:@"scanresult=%d&scantype=%@&codeurl=%@",-1, @"添加好友", isNullString(uid)];
            [Utils BDLog:1 module:@"605" action:@"ScanCode" content:content];
            [OMGToast showWithText:[resultDic objectForKey:@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }failure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [OMGToast showWithText:@"扫描错误"];
        NSString* content = [NSString stringWithFormat:@"scanresult=%d&scantype=%@&codeurl=%@",-1, @"添加好友", isNullString(uid)];
        [Utils BDLog:1 module:@"605" action:@"ScanCode" content:content];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)uploadTogetherInfo:(NSString *)stringValue{
    NSRange range = [stringValue rangeOfString:@"?"];
    
    if (range.location != NSNotFound) {
        NSString * result = [stringValue substringFromIndex:range.location+1];
        NSArray *array = [result componentsSeparatedByString:@"&"];
        if (array.count>0) {
            NSString *firstStr = [array objectAtIndex:0];
            NSRange range = [firstStr rangeOfString:@"="];
            NSString * uid = [firstStr substringFromIndex:range.location+1];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self uploadDeviceRelationRequest:uid];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    [MBProgressHUD show:@"电视端登录成功" icon:@"img_success" view:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_TVLOGIN object:nil];

                    NSString* content = [NSString stringWithFormat:@"scanresult=%d&scantype=%@&codeurl=%@",0, @"电视关联", isNullString(stringValue)];
                    [Utils BDLog:1 module:@"605" action:@"ScanCode" content:content];
                });
            });
        }
    }
    else{
        [OMGToast showWithText:@"未搜索到结果"];
        
        NSString* content = [NSString stringWithFormat:@"scanresult=%d&scantype=%@&codeurl=%@",-1, @"电视关联", isNullString(stringValue)];
        [Utils BDLog:1 module:@"605" action:@"ScanCode" content:content];
    }
    if (_isGuide) {
        if ([HiTVGlobals sharedInstance].interested) {
            [self showMainViewController];
        }
        else{
            SJLightViewController * favoriteVC = [[SJLightViewController alloc] init];
            [self.navigationController pushViewController:favoriteVC animated:YES];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)uploadDeviceRelationRequest:(NSString *)uid{
    if ([[HiTVGlobals sharedInstance].latitude intValue]==0) {
         [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
         NSString *latitude = [NSString stringWithFormat:@"%f",locationCorrrdinate.latitude];
         NSString *longitude = [NSString stringWithFormat:@"%f",locationCorrrdinate.longitude];
        /* if (!([[HiTVGlobals sharedInstance].latitude isEqualToString:latitude]&&[[HiTVGlobals sharedInstance].longitude isEqualToString:longitude])) {
             
             
            }*/
             [HiTVGlobals sharedInstance].latitude = latitude;
             [HiTVGlobals sharedInstance].longitude = longitude;
             [self startReport:uid];

         }];
    }
    else{
        [self startReport:uid];
    }
}

-(void)startReport:(NSString *)uid{
    if ([[HiTVGlobals sharedInstance].latitude intValue] ==0 ) {
        [HiTVGlobals sharedInstance].latitude = @"";
    }
    if ([[HiTVGlobals sharedInstance].longitude intValue] ==0 ) {
        [HiTVGlobals sharedInstance].longitude = @"";
    }
    if ([HiTVGlobals sharedInstance].xmppUserId == nil) {
        [HiTVGlobals sharedInstance].xmppUserId = @"";
    }
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setObject:uid forKey:@"tvAnonymousUid"];
    [parameters setObject:[HiTVGlobals sharedInstance].uid forKey:@"typeId"];
    [parameters setObject:[HiTVGlobals sharedInstance].xmppUserId forKey:@"jId"];
    if (![HiTVGlobals sharedInstance].nickName) {
        [HiTVGlobals sharedInstance].nickName = @"";
    }
    [parameters setObject:[HiTVGlobals sharedInstance].nickName forKey:@"nickName"];
    [parameters setObject:XMPPHOST forKey:@"jIdAddr"];
    [parameters setObject:@"" forKey:@"tvName"];
    if (![HiTVGlobals sharedInstance].faceImg) {
        [HiTVGlobals sharedInstance].faceImg = @"";
    }
    [parameters setObject:[HiTVGlobals sharedInstance].faceImg forKey:@"faceImg"];
    if ([HiTVGlobals sharedInstance].serviceAddrs) {
        [parameters setObject:[HiTVGlobals sharedInstance].serviceAddrs forKey:@"serviceAddr"];
    }
    [TogetherManager sharedInstance].reportType = @"SCANCODE";
    [HiTVGlobals sharedInstance].iniT = @"true";

    [[TogetherManager sharedInstance] uploadDeviceRelationRequest:parameters];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scanTypeConfig:(QRItem *)item
{
}

- (void)initNavigationView
{
    _naviView = [TRTopNavgationView navgationView];
    [self.view addSubview:_naviView];
    _naviView.backgroundColor = [UIColor clearColor];
    
    // back button
    UIButton* backBt = [UIHelper createBtnfromSize:kBackButtonSize
                                             image:[UIImage imageNamed:@"white_back_img"]
                                      highlightImg:[UIImage imageNamed:@"white_back_img"]
                                       selectedImg:nil
                                            target:self
                                          selector:nil];
    __weak __typeof(self)weakSelf = self;
    [[backBt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
    [_naviView setLeftView:backBt];
    
    // title
    UILabel* lbl = [UIHelper createTitleLabel:@"扫一扫"];
    lbl.textColor = [UIColor whiteColor];
    [_naviView setTitleView:lbl];
    
    
}
-(void)showMainViewController{
    [AppDelegate appDelegate].appdelegateService.SetF = YES;
    [[AppDelegate appDelegate].appdelegateService showMainViewController];
}
@end
