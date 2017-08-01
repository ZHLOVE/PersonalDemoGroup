//
//  ShareAppViewController.m
//  ShiJia
//
//  Created by 蒋海量 on 2016/12/29.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "ShareAppViewController.h"
#import "SJShareMessage.h"
#import "SJShareManager.h"

@interface ShareAppViewController () <UITextFieldDelegate>
@property (nonatomic, strong) TRTopNavgationView *naviView;
@property (nonatomic, strong) SJShareManager        *shareManager;

@property (nonatomic, strong) UIView *mdmView;
@property (nonatomic, strong) UIImageView *qrCodeImg;
@property (nonatomic, strong) NSString *shareUrl;

@property (weak, nonatomic) IBOutlet UILabel *infoa;
@property (weak, nonatomic) IBOutlet UILabel *infob;
@property (weak, nonatomic) IBOutlet UITextField *input;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ShareAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationView];
    
    _shareUrl = [NSString stringWithFormat:@"%@?userName=%@&imageUrl=%@",[HiTVGlobals sharedInstance].shareUrl,[HiTVGlobals sharedInstance].nickName,[HiTVGlobals sharedInstance].faceImg];
    
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height * 2)];
    
    _btn.layer.cornerRadius = 2.0;
    _btn.layer.masksToBounds = YES;
    
    _input.hidden = NO;
    _btn.backgroundColor = kColorBlueTheme;
    _btn.hidden = NO;
    _infoa.hidden = NO;
    _input.delegate = self;
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGr];
    
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].phoneNo forKey:@"phoneNo"];
    [parameters setValue:@"" forKey:@"extend"];
    
    _input.hidden = YES;
    _btn.hidden = YES;
    _infoa.hidden = YES;
#ifdef BeiJing
    
#else
    NSString* url = [HiTVGlobals sharedInstance].shareServiceHost;// shareServiceHost;
    
    if (url == nil || url.length == 0) {
        url = @"http://192.168.50.160:8008/share-facade";
    }
    [BaseAFHTTPManager postRequestOperationForHost:url forParam:@"/user/share/checkInvitation" forParameters:parameters  completion:^(id responseObject) {
        DDLogInfo(@"%@", responseObject);
        
        if ([@"SHARE-130" isEqualToString:responseObject[@"resultCode"]]) {
            _input.hidden = NO;
            _btn.hidden = NO;
            _infoa.hidden = NO;
            
        } else if ([@"SHARE-120" isEqualToString:responseObject[@"resultCode"]]){
            _input.hidden = YES;
            _btn.hidden = YES;
            _infoa.hidden = NO;
            _infoa.text = @"您已被成功邀请过！";
            _infoa.textColor = kColorBlueTheme;
            
            
        }
    } failure:^(NSString* error) {
        
    }];
#endif

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.3f];
    [self.view setFrame:CGRectMake(0, -180, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}

- (IBAction)btnClicked:(id)sender {
    
    [_input resignFirstResponder];
    if (_input.text == nil || _input.text.length == 0) {
        [self showAlert:@"请填写邀请者工号" withDelegate:nil];
        return;
    }
    //请输入正确的员工号
    
    if ([_input.text numberValue] == nil || _input.text.length != 8) {
        [self showAlert:@"请输入正确的员工号" withDelegate:nil];
        return;
    }
    
    
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].phoneNo forKey:@"phoneNo"];
    [parameters setValue:@"" forKey:@"extend"];
    [parameters setValue:_input.text forKey:@"employeeId"];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    

    NSString* url = [HiTVGlobals sharedInstance].shareServiceHost;// shareServiceHost;
    
    if (url == nil || url.length == 0) {
        url = @"http://192.168.50.160:8008/share-facade";
    }
    [BaseAFHTTPManager postRequestOperationForHost:url forParam:@"/user/share/invite" forParameters:parameters  completion:^(id responseObject) {
        
        DDLogInfo(@"%@", responseObject);
        
        if ([@"000" isEqualToString:responseObject[@"resultCode"]]) {
            _input.hidden = YES;
            _btn.hidden = YES;
            _infoa.hidden = NO;
            _infoa.text = @"您已被成功邀请过！";
            _infoa.textColor = kColorBlueTheme;
            
            [UIView beginAnimations:@"move" context:nil];
            [UIView setAnimationDuration:0.3f];
            [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [UIView commitAnimations];
            
            [_input resignFirstResponder];
        } else {
           

            
        }
        [self showAlert:responseObject[@"resultMessage"] withDelegate:nil];
    } failure:^(NSString* error) {
        [self showAlert:error withDelegate:nil];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    self.navigationController.navigationBarHidden = YES;
}

-(IBAction)momentsClick:(id)sender{
    SJShareMessage *shareMessage = [SJShareMessage new];
    shareMessage.platform = WeChatFriend;
    shareMessage.messageType = ShareMessageTypeUrl;
    shareMessage.messageTitle = SocialShareContent;
    shareMessage.messageContent = @"";
    shareMessage.messageSourceLink = _shareUrl;
    
    shareMessage.messageThumbImage = [UIImage imageNamed:@"share_icon_bj"];

    NSString* content = [NSString stringWithFormat:@"pushtype=%@&result=%@", @"朋友圈", @"%d"];
    [NSUserDefaultsManager saveObject:content forKey:LOG_PUSH_MOMENT];
    
    [HiTVGlobals sharedInstance].shareWay = @"朋友圈";
    [self.shareManager shareObject:shareMessage];
}

-(IBAction)weChatClick:(id)sender{
    SJShareMessage *shareMessage = [SJShareMessage new];
    shareMessage.platform = WeChat;
    shareMessage.messageType = ShareMessageTypeUrl;
    shareMessage.messageTitle = SocialShareContent;
    shareMessage.messageContent = @"";
    shareMessage.messageSourceLink = _shareUrl;

    shareMessage.messageThumbImage = [UIImage imageNamed:AboutImageName];

    NSString* content = [NSString stringWithFormat:@"pushtype=%@&result=%@", @"微信", @"%d"];
    [NSUserDefaultsManager saveObject:content forKey:LOG_PUSH_WECHAT];
    [HiTVGlobals sharedInstance].shareWay = @"微信";

    [self.shareManager shareObject:shareMessage];
}

-(IBAction)mdmClick:(id)sender{
    self.mdmView.hidden = NO;
    
    NSString* content = [NSString stringWithFormat:@"pushtype=%@&result=", @"面对面"];
    [Utils BDLog:1 module:@"605" action:@"Push" content:content];
    [UMengManager event:@"U_Push"];
    
}
-(SJShareManager *)shareManager{
    if(!_shareManager){
        _shareManager = [[SJShareManager alloc]init];
    }
    return _shareManager;
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    self.mdmView.hidden = YES;
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.3f];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
    
    [_input resignFirstResponder];
}

-(UIView *)mdmView{
    if(!_mdmView){
        _mdmView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, W, H)];
        _mdmView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7f];
        
        [self.view addSubview:_mdmView];
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        //tapGr.cancelsTouchesInView = NO;
        
        
        [_mdmView addGestureRecognizer:tapGr];
        
        
        _qrCodeImg = [UIImageView new];
        _qrCodeImg.backgroundColor = [UIColor redColor];
        [_mdmView addSubview:_qrCodeImg];
        
        
        [_qrCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_mdmView);
            make.size.mas_equalTo(CGSizeMake(250, 250));
            
        }];
        
        UILabel *label =[UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = 1;
        label.text = @"请好友扫描二维码，下载客户端";
        label.font = [UIFont systemFontOfSize:17];
        [_mdmView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_qrCodeImg);
            make.height.mas_equalTo(30);
            make.bottom.mas_equalTo(_qrCodeImg.mas_top).offset(-10);
        }];
        
        
        // 1.创建过滤器
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        // 2.恢复默认
        [filter setDefaults];
        // 3.给过滤器添加数据
        NSString *dataString = [HiTVGlobals sharedInstance].phoneApk;
        NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        // 4.通过KVO设置滤镜inputMessage数据
        [filter setValue:data forKeyPath:@"inputMessage"];
        // 4.获取输出的二维码
        CIImage *outputImage = [filter outputImage];
        // 5.将CIImage转换成UIImage，并放大显示
        //_qrCodeImg.image = [UIImage imageWithCIImage:outputImage scale:20.0 orientation:UIImageOrientationUp];
        _qrCodeImg.image=[self createNonInterpolatedUIImageFormCIImage:outputImage withSize:100.0];
        
        UIImageView *logo = [[UIImageView alloc]init];
        logo.backgroundColor = [UIColor clearColor];
        logo.image = [UIImage imageNamed:AppLOGO];
        logo.layer.cornerRadius = 5;
        //logo.layer.borderColor = [UIColor whiteColor].CGColor;
        logo.layer.borderWidth = 1.0f;
        logo.layer.masksToBounds = YES;
        [_qrCodeImg addSubview:logo];
        
        [logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_qrCodeImg);
            make.size.mas_equalTo(CGSizeMake(65, 65));
            
        }];
    }
    return _mdmView;
}
#pragma mark - Subview
- (void)initNavigationView
{
    _naviView = [TRTopNavgationView navgationView];
    [self.view addSubview:_naviView];
    _naviView.backgroundColor = kNavgationBarColor;
    
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
    UILabel* lbl = [UIHelper createTitleLabel:@"推荐有礼"];
    lbl.textColor = kNavTitleColor;
    [_naviView setTitleView:lbl];
    
    
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
