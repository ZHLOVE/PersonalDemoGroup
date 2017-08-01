//
//  HiTVRemoteControlViewController.m
//  HiTV
//
//  Created by yy on 15/9/8.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "SJRemoteControlViewController.h"
#import "PopoverButton.h"
#import "TPIMContentModel.h"
#import "HiTVDeviceInfo.h"
#import "ScreenManager.h"
#import "TogetherManager.h"
#import "CustomIOSAlertView.h"
#import "QRCodeController.h"
#import "SJLoginViewController.h"
#import "SJAdViewModel.h"

typedef NS_ENUM(NSInteger, RemoteButtonTag)
{
    RemoteButtonTagBack = 1,  //返回
    RemoteButtonTagHome = 2,      //首页
    RemoteButtonTagMenu = 3,      //菜单
    RemoteButtonTagVolumeUp = 4,  //音量加
    RemoteButtonTagMute = 5,        //静音
    RemoteButtonTagVolumeDown = 6,//音量减
    RemoteButtonTagSetting = 7,   //设置
    RemoteButtonTagLeft = 8,      //左
    RemoteButtonTagRight = 9,     //右
    RemoteButtonTagUp = 10,        //上
    RemoteButtonTagDown = 11,      //下
    RemoteButtonTagGame = 12,      //游戏
    RemoteButtonTagOK = 13,        //确认
    RemoteButtonTagVolume = 14,        //恢复音量

};

@interface SJRemoteControlViewController ()<PopoverButtonDelegate>

@property (nonatomic, retain) TRTopNavgationView *naviView;
@property (nonatomic, retain) IBOutlet UIView          *navView;
@property (nonatomic, retain) IBOutlet UIView          *mainView;
@property (nonatomic, retain) IBOutlet UIView          *bottomView;
@property (nonatomic, retain) IBOutlet UIButton        *backButton;
@property (nonatomic, retain) IBOutlet UIButton        *settingButton;
@property (nonatomic, retain) IBOutlet PopoverButton *connectedBtn;
@property (nonatomic, strong) NSString                 *result;
@property (nonatomic, retain) NSArray                  *deviceList;

@property (nonatomic, strong) ScreenManager *screenManager;

@property (nonatomic, strong) HiTVDeviceInfo* connectedDevice;

@property (nonatomic, assign) BOOL hasScan;

@property (nonatomic, strong) SJAdViewModel *adViewModel;

@end

@implementation SJRemoteControlViewController

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.adViewModel = [[SJAdViewModel alloc] initWithActiveController:self];
        
        __weak __typeof(self)weakSelf = self;
        
        [self.adViewModel setLoadAdFailedBlock:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
           [strongSelf showAlert:@"获取北京移动互联网电视机顶盒，可致电10086"];
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_refreshAfterTVLogin:)
                                                 name:kNotification_TVLOGIN
                                               object:nil];
    self.connectedDevice = [TogetherManager sharedInstance].connectedDevice;
    
    [self getConnectedDevice];
    
    self.mainView.backgroundColor = [UIColor whiteColor];
    self.navView.backgroundColor = [UIColor whiteColor];

    [self.settingButton setImage:[ UIImage imageNamed : @"扫一扫black" ] forState:UIControlStateNormal];
    [self.settingButton setTitle:nil forState:UIControlStateNormal];
    
    
    
    [[TogetherManager sharedInstance]getDeviceDetectionRequestForCompletion:^(NSArray *devices,NSString *error){
    }];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   /* if (self.hasScan) {
        [[TogetherManager sharedInstance]getDeviceDetectionRequestForCompletion:^(NSArray *devices,NSString *error){
            self.connectedDevice = [TogetherManager sharedInstance].connectedDevice;
            [self showConnectedDevice];
        }];
    }*/
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [TogetherManager sharedInstance].connectedDevice = self.connectedDevice;
}
-(void)p_refreshAfterTVLogin:(NSNotification*)notification
{
    /*self.connectedDevice = [TogetherManager sharedInstance].connectedDevice;
    [self showConnectedDevice];*/
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [[TogetherManager sharedInstance]getDeviceDetectionRequestForCompletion:^(NSArray *devices,NSString *error){
            self.connectedDevice = [TogetherManager sharedInstance].connectedDevice;
            [self showConnectedDevice];
        }];
        
    });
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - data
-(void)getConnectedDevice
{
    self.mainView.userInteractionEnabled = YES;
    self.navView.userInteractionEnabled = YES;
    self.bottomView.userInteractionEnabled = YES;
    
    //获取已连接的设备
    if ([TogetherManager sharedInstance].connectedDevice) {
        
        //已连接盒子/影棒
        [self showConnectedDevice];
    }else{
        
        //未连接，开始搜索
        self.connectedBtn.title = @"没有关联设备";
        self.connectedBtn.upArrowImage = nil;
        self.connectedBtn.downArrowImage = nil;
        /*
         NSString *allString = [NSString stringWithFormat:@"tel:10086"];
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
         */
        //[self showAlert:@"需要关联家庭设备后使用遥控器" withDelegate:nil];
        //[self showAlert:@"获取北京移动互联网电视机顶盒，可致电10086"];
        [self.adViewModel start];
    }
}

- (void)showConnectedDevice
{
    HiTVDeviceInfo *connectedDevice = [TogetherManager sharedInstance].connectedDevice;
    if (connectedDevice.state==nil) {
       // [self showAlert:@"该家庭没有关联设备,无法使用遥控器" sureText:@"知道了"];
        [OMGToast showWithText:@"该家庭没有关联设备,无法使用遥控器"];

    }
    else if([connectedDevice.state isEqualToString:@"UNTOGETHER_ONLINE"]||[connectedDevice.state isEqualToString:@"UNTOGETHER_OFFLINE"]){
      
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您当前选择的设备不在线，请切换设备或确认该家庭设备是否在线。" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        
        [alert show];
  
    }
    NSMutableDictionary *deviceDic = [NSUserDefaultsManager getObjectForKey:DEVICESDIC];
    NSString *tvName = [deviceDic objectForKey:connectedDevice.userId];
    if (tvName) {
        self.connectedBtn.title = tvName;
    }
    else{
        self.connectedBtn.title = connectedDevice.tvName;
    }
    //self.connectedBtn.title = connectedDevice.tvName;
    self.connectedBtn.buttonEventType = ButtonEventType_ShowList;
    self.connectedBtn.list = [TogetherManager sharedInstance].detectedDevices;
    self.connectedBtn.selectedDevice = [TogetherManager sharedInstance].connectedDevice;
    self.deviceList = [NSArray arrayWithArray:[TogetherManager sharedInstance].detectedDevices];
    [self setRemoteControlsEnabled:YES];
}

//未连接机顶盒时subviews的状态
- (void)updateSubviewsInUnconnectedState
{
    self.connectedBtn.list = [TogetherManager sharedInstance].detectedDevices;
    self.deviceList = [NSArray arrayWithArray:[TogetherManager sharedInstance].detectedDevices];
    self.connectedBtn.selectState = PopoverButtonSelectState_SelectNone;
    [self setRemoteControlsEnabled:NO];
    
}

- (void)setRemoteControlsEnabled:(BOOL)enbled
{
    self.mainView.userInteractionEnabled = enbled;
    self.bottomView.userInteractionEnabled = enbled;
    //    self.backButton.enabled = YES;
    self.settingButton.enabled = enbled;
    
}

#pragma mark -  button click
- (IBAction)backButtonClicked:(id)sender
{
    if (!self.navigationController){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];

    }
    
}
#pragma mark -  投屏
- (ScreenManager *)screenManager
{
    return [ScreenManager sharedInstance];
}
//投屏操作
- (void)ScreenProjectionOperation:(NSString *)keyEvent {
    
    TPIMContentModel *content = [[TPIMContentModel alloc]init];
    content.keyEvent = keyEvent;

    [self.screenManager remoteControlContentModel:content];
    
    
}
- (IBAction)r_buttonClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case RemoteButtonTagBack:
            //遥控器返回
            [self ScreenProjectionOperation:@"back"];
            break;
            
        case RemoteButtonTagHome:
            //遥控器首页
            [self ScreenProjectionOperation:@"home"];
            break;
            
        case RemoteButtonTagMenu:
            //遥控器菜单
            [self ScreenProjectionOperation:@"menu"];
            break;
            
        case RemoteButtonTagVolumeUp:
            //遥控器音量加
            [self ScreenProjectionOperation:@"volAdd"];
            break;
            
        case RemoteButtonTagVolumeDown:
            //遥控器音量减
            [self ScreenProjectionOperation:@"volDel"];
            break;
            
        case RemoteButtonTagSetting:
            //遥控器设置
        {
            [self scan];
            
         /*NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];           [[UIApplication sharedApplication] openURL:url];
                
            }*/
        }
            break;
            
        case RemoteButtonTagLeft:
            //遥控器左
            [self ScreenProjectionOperation:@"left"];
            break;
        case RemoteButtonTagMute:
            //静音
            [self ScreenProjectionOperation:@"mute"];
            break;
            
        case RemoteButtonTagRight:
            //遥控器右
            [self ScreenProjectionOperation:@"right"];
            break;
            
        case RemoteButtonTagUp:
            //遥控器上
            [self ScreenProjectionOperation:@"up"];
            break;
            
        case RemoteButtonTagDown:
            //遥控器下
            [self ScreenProjectionOperation:@"down"];
            break;
            
        case RemoteButtonTagGame:
            //游戏
            break;
            
        case RemoteButtonTagOK:
            //遥控器确认
            [self ScreenProjectionOperation:@"center"];
            break;
        case RemoteButtonTagVolume:
            //恢复音量
            [self ScreenProjectionOperation:@"unMute"];
            break;
        default:
            break;
    }
}

#pragma mark - popover button delegate
- (void)popoverButton:(PopoverButton *)sender didSelectItemAtIndex:(NSInteger)index
{
    HiTVDeviceInfo *deviceInfo = self.deviceList[index];
    [self.connectedBtn setTitle:deviceInfo.tvName];
    
    //设置默认家庭
    [TogetherManager sharedInstance].connectedDevice = deviceInfo;
    
}

#pragma mark - Subview
- (void)initNavigationView
{
    _naviView = [TRTopNavgationView navgationView];
    [self.view addSubview:_naviView];
    _navView.backgroundColor = kColorBlueTheme;
    
    // back button
    UIButton* backBt = [UIHelper createBtnfromSize:kBackButtonSize
                                             image:[UIImage imageNamed:@"white_back_btn"]
                                      highlightImg:[UIImage imageNamed:@"white_back_btn"]
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
    _connectedBtn = [[PopoverButton alloc] init];
    [_naviView setTitleView:_connectedBtn];
    
    // delete button
    UIButton* rightBt = [UIHelper createRightButtonWithTitle:@"设置"];
    [[rightBt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        
        
    }];
    [_naviView setRightView:rightBt];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self scan];
    }
}
-(void)showAlert:(NSString *)message{
    // Here we need to pass a full frame
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您的遥控器未关联任何电视设备，请点击右上方“扫一扫” ，快速关联电视吧。" message:message delegate:self cancelButtonTitle:@"前往扫一扫" otherButtonTitles:@"取消", nil];
    [alert show];
    
}
-(void)scan{
    if ([HiTVGlobals sharedInstance].isLogin) {
        self.hidesBottomBarWhenPushed = YES;
        QRCodeController *qrVC = [[QRCodeController alloc]init];
        qrVC.type = @"2";
        [self.navigationController pushViewController:qrVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
        self.hasScan = YES;
    }
    else{
        
        SJLoginViewController *sjVC = [[SJLoginViewController alloc]init];
        [self.navigationController presentViewController:sjVC animated:YES completion:nil];
        return;
    }
}
@end
