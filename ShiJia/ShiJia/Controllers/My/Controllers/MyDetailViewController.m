//
//  MyDetailViewController.m
//  ShiJia
//
//  Created by 蒋海量 on 16/6/28.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "MyDetailViewController.h"
#import "UserDetailTableViewCell.h"
#import "NickSetViewController.h"
#import "HiTVUserQrCode.h"
#import "RelationDeviceController.h"
//#import "UserImageSetVC.h"
#import "BIMSManager.h"
#import "TogetherManager.h"
#import "TPIMUser.h"
#import "NSUserDefaultsManager.h"
#import "UpYun.h"
#import "SJLocailFileScreen.h"
#import "UIImage+Orientation.h"
#import "SJLocailFileResponseModel.h"
#import "JKImagePickerController.h"
#import "SJLoginViewController.h"

/** 调整图片大小 */
UIImage * UIImageScaleToSize(UIImage *img, CGSize size)
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

@interface MyDetailViewController ()<UIImagePickerControllerDelegate,JKImagePickerControllerDelegate>{
    NSData *imageData;
    BOOL hasSelect;
}
@property (nonatomic, strong) NSArray* cellTitles;
@property(nonatomic,weak) IBOutlet UITableView *contentTabView;

@property (nonatomic, strong) NSMutableArray   *assetsArray;

@end

@implementation MyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Do any additional setup after loading the view from its nib.s
    self.contentTabView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);

    self.title = @"我的资料";
    [_userImageView setImageWithURL:[NSURL URLWithString:[HiTVGlobals sharedInstance].faceImg] placeholderImage:[UIImage imageNamed:LIGHTHEADICON]];
    _userImageView.layer.borderColor= [UIColor colorWithRed:20/255.0 green:36/255.0 blue:58/255.0 alpha:1].CGColor;
    
    _userImageView.layer.cornerRadius = _userImageView.frame.size.height/2;
    _userImageView.layer.masksToBounds = YES;
    self.cellTitles = @[
                        @"手机号",
                        @"昵称",
                        @"二维码名片"
                        ];
    imageData = [NSData data];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    _nickNameLabel.text = [HiTVGlobals sharedInstance].nickName;
    [_userImageView setImageWithURL:[NSURL URLWithString:[HiTVGlobals sharedInstance].faceImg] placeholderImage:[UIImage imageNamed:LIGHTHEADICON]];
    [self.contentTabView reloadData];
}

-(IBAction)setUserHeadImg:(id)sender{
    [self composePicAdd];

   /* self.hidesBottomBarWhenPushed = YES;
    UserImageSetVC *userImageSetVC = [[UserImageSetVC alloc] init];
    [self.navigationController pushViewController:userImageSetVC animated:YES];*/
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self sureloginOut];
    }
}
-(IBAction)loginOut:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定要退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

/*
 * sureloginOut
 * 退出登录后清除用户缓存信息
 * 若修改在SJAppdelegateService.m的logoutAccountAndXmpp方法中也要修改
 */
-(void)sureloginOut{
    [HiTVGlobals sharedInstance].isLogin = NO;
    
    [HiTVGlobals sharedInstance].uid = [HiTVGlobals sharedInstance].anonymousUid;
    [HiTVGlobals sharedInstance].nickName = @"游客";
    [HiTVGlobals sharedInstance].phoneNo = @"";
    [HiTVGlobals sharedInstance].faceImg = @"";
    [[BIMSManager sharedInstance].verTimer invalidate];
    [BIMSManager sharedInstance].verTimer = nil;

    [AppDelegate appDelegate].appdelegateService.isConnect = NO;
    [TogetherManager sharedInstance].connectedDevice = nil;
    [[TogetherManager sharedInstance]getDeviceDetectionRequestForCompletion:^(NSArray *devices,NSString *error){
    }];
    //xmpp断开连接
    [TPIMUser logoutWithCompletionHandler:^(id responseObject, NSError *error) {
        
    }];
    [HiTVGlobals sharedInstance].VIP = NO;
    [HiTVGlobals sharedInstance].expireDate = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_Remote object:@"ykq_l"];
    [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_ReloadUser object:@"loginOut"];
    [NSUserDefaultsManager deleteObjectForKey:ISLOGIN];
    [NSUserDefaultsManager deleteObjectForKey:P_UID];
    [NSUserDefaultsManager deleteObjectForKey:USERINFO];
    SJLoginViewController *sjVC = [[SJLoginViewController alloc]init];
    [self.navigationController presentViewController:sjVC animated:YES completion:^{
        [self.navigationController popViewControllerAnimated:NO];
    }];
}
#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellTitles.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"UserDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSUInteger row = indexPath.row;
    if (row == 0) {
        cell.titleDescLabel.text = [HiTVGlobals sharedInstance].phoneNo;
        cell.arrowImageView.hidden = YES;
        
    }else if(row == 1){
        cell.titleDescLabel.text =[HiTVGlobals sharedInstance].nickName;
        
    }else{
        cell.titleDescLabel.hidden = YES;
        
    }
    cell.titleView.adjustsFontSizeToFitWidth = YES;
    cell.titleView.text = [_cellTitles objectAtIndex:row];

    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 1) {
        self.hidesBottomBarWhenPushed = YES;
        NickSetViewController *userNickSetVC = [[NickSetViewController alloc] init];
        [self.navigationController pushViewController:userNickSetVC animated:YES];
    }
    else if(row == 2){
        self.hidesBottomBarWhenPushed = YES;
        HiTVUserQrCode *userQrCodeVC = [[HiTVUserQrCode alloc] init];
        [self.navigationController pushViewController:userQrCodeVC animated:YES];
    }
}


-(void)rightBarButtonItemPressed{
    if ([self.navigationController.viewControllers firstObject] == self) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)choosePic:(id)sender {
    [self composePicAdd];
}



/**
 *  用户头像
 */
-(void)userUpdateUserImage
{
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = UPaiYunKey1;
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = UPaiYunKey2;
    [UPYUNConfig sharedInstance].FormAPIDomain = BIMS_CLOUD_ALBUMS_UPLOAD_URL;
    UpYun *uy = [[UpYun alloc] init];
    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
        //TODO
        SJLocailFileResponseModel *model = [SJLocailFileResponseModel mj_objectWithKeyValues:responseData];
        NSString *url = [NSString stringWithFormat:@"%@%@",CLOUD_SERVER,model.url];
        [HiTVGlobals sharedInstance].faceImg = url;
        
        [self updateBasicRequest:url];
        
    };
    uy.failBlocker = ^(NSError * error) {
        //TODO
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [OMGToast showWithText:@"修改失败"];
    };
    uy.progressBlocker = ^(CGFloat percent,long long requestDidSendBytes) {
        //TODO
    };
    
    //[uy.params setObject:@"value" forKey:@"key"];
    uy.uploadMethod = UPFormUpload;
    UIImage *image = _userImageView.image;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [uy uploadFile:[image imageRotate:image rotation:UIImageOrientationUp] saveKey:[[SJLocailFileScreen new]getSaveKeyWith:@"png" ]];
    
}
-(void)updateBasicRequest:(NSString *)url{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:url forKey:@"faceImg"];
    
    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN forParam:@"/userservice/update/userinfo" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"code"];
        if (code.intValue == 0) {
            /*if ([self.navigationController.viewControllers firstObject] == self) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }*/
            [self uploadUserInfoRequest];
        }
        else{
            
        }
        [OMGToast showWithText:[responseDic objectForKey:@"message"]];
        
    }failure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [OMGToast showWithText:@"修改失败"];
        
    }];
}
/**
 *  上报社交系统
 */
-(void)uploadUserInfoRequest
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setObject:[HiTVGlobals sharedInstance].longitude forKey:@"longitude"];
    [parameters setObject:[HiTVGlobals sharedInstance].latitude forKey:@"latitude"];
    [parameters setObject:[HiTVGlobals sharedInstance].intranetIp forKey:@"intranetIp"];
    [parameters setObject:[HiTVGlobals sharedInstance].ssid forKey:@"ssid"];
    [parameters setObject:[HiTVGlobals sharedInstance].gateWay forKey:@"gateWay"];
    [parameters setObject:[HiTVGlobals sharedInstance].gateWayMac forKey:@"gateWayMac"];
    [parameters setObject:[HiTVGlobals sharedInstance].uid forKey:@"typeId"];
    [parameters setObject:[HiTVGlobals sharedInstance].xmppUserId forKey:@"jId"];
    if (![HiTVGlobals sharedInstance].nickName) {
        [HiTVGlobals sharedInstance].nickName = @"";
    }
    if (![HiTVGlobals sharedInstance].faceImg) {
        [HiTVGlobals sharedInstance].faceImg = @"";
    }
    [parameters setObject:[HiTVGlobals sharedInstance].nickName forKey:@"nickName"];
    [parameters setObject:XMPPHOST forKey:@"jIdAddr"];
    [parameters setObject:[HiTVGlobals sharedInstance].faceImg forKey:@"faceImg"];
    //[parameters setObject:@"TOGETHER_SAME_NET" forKey:@"state"];
    if ([HiTVGlobals sharedInstance].serviceAddrs) {
        [parameters setObject:[HiTVGlobals sharedInstance].serviceAddrs forKey:@"serviceAddr"];
    }
    [parameters setObject:@"APP" forKey:@"type"];
    [parameters setObject:BIMS_DOMAIN forKey:@"area"];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *jsonString = [parameters mj_JSONString];
    
    [dic setObject:jsonString forKey:@"info"];
    [dic setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [dic setObject:@"APP" forKey:@"type"];
    
    [BaseAFHTTPManager postRequestOperationForHost:MultiHost  forParam:@"/ms_update_phoneInfo" forParameters:dic  completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"code"];
        if (code.intValue == 0) {
            
        }
        
    }failure:^(NSString *error) {
        
    }];
}
-(IBAction)sendComplete:(id)sender{
    if (!hasSelect) {
        [self showAlert:@"请选择图片" withDelegate:nil];
        return;
    }
    [self userUpdateUserImage];
}

- (void)composePicAdd
{
    
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 1;
    imagePickerController.selectedAssetArray = self.assetsArray;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    navigationController.view.backgroundColor = klightGrayColor;
    navigationController.navigationBar.barTintColor = [UIColor clearColor];
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    [navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [HiTVConstants titleColor],
                                                                 NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                                                 NSShadowAttributeName:shadow}];
    navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    UIImage* backgroundImage = [UIImage imageNamed:@"nav-background"];
    //        UIImageView* imageView = [[UIImageView alloc] initWithImage:backgroundImage];
    [navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

-(void)jkImagePickerController:(JKImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        hasSelect = YES;
        UIImage *photoImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        imageData = UIImageJPEGRepresentation(UIImageScaleToSize(photoImg, CGSizeMake(200, 200)), 0.5);
        [_userImageView setImage:photoImg];
        
    }];
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        hasSelect = YES;
        
        if([[assets firstObject] isKindOfClass:[JKAssets class]]){
            
            ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
            
            [assetLibrary assetForURL:[[assets firstObject] assetPropertyURL] resultBlock:^(ALAsset *asset)  {
                
                
                UIImage *image=[UIImage imageWithCGImage:asset.thumbnail];
                if(image == nil){
                    [_userImageView setImage:[UIImage imageNamed:@"登录"]];
                    imageData = UIImageJPEGRepresentation(UIImageScaleToSize([UIImage imageNamed:@"默认头像.png"], CGSizeMake(200, 200)), 0.5);
                    
                }else{
                    imageData = UIImageJPEGRepresentation(UIImageScaleToSize(image, CGSizeMake(200, 200)), 0.5);
                    [_userImageView setImage:image];
                    
                    [self sendComplete:nil];
                }
                
            }failureBlock:^(NSError *error) {
                DDLogInfo(@"error=%@",error);
                [_userImageView setImage:[UIImage imageNamed:@"登录"]];
                imageData = UIImageJPEGRepresentation(UIImageScaleToSize([UIImage imageNamed:@"默认头像.png"], CGSizeMake(200, 200)), 0.5);
                
            }];
            
            
        }else{
            imageData = UIImageJPEGRepresentation(UIImageScaleToSize([UIImage imageWithCGImage:[[[assets firstObject] defaultRepresentation] fullScreenImage]], CGSizeMake(200, 200)), 0.5);
            [_userImageView setImage:[UIImage imageWithCGImage:[[[assets firstObject] defaultRepresentation] fullScreenImage]]];
            
            
        }
        
        
        
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 按照又拍云生成的key
- (NSString * )getSaveKeyWith:(NSString *)suffix {
    
    return [NSString stringWithFormat:@"/%@.%@", [self getDateString], suffix];
    
}

- (NSString *)getDateString {
    NSDate *curDate = [NSDate date];//获取当前日期
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy/MM/dd"];//这里去掉 具体时间 保留日期
    NSString * curTime = [formater stringFromDate:curDate];
    curTime = [NSString stringWithFormat:@"%@/%.0f", curTime, [curDate timeIntervalSince1970]];
    return curTime;
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
