//
//  UserImageSetVC.m
//  HiTV
//
//  Created by wesley on 15/8/2.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "UserImageSetVC.h"
#import "NSUserDefaultsManager.h"
#import "UpYun.h"
#import "SJLocailFileScreen.h"
#import "UIImage+Orientation.h"
#import "SJLocailFileResponseModel.h"

/** 调整图片大小 */
/*UIImage * UIImageScaleToSize(UIImage *img, CGSize size)
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
}*/

@interface UserImageSetVC (){
    NSData *imageData;
    BOOL hasSelect;
}

@property (nonatomic, strong) NSMutableArray   *assetsArray;


@end

@implementation UserImageSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    imageData = [NSData data];
    
    [self initView];
}

-(void)initView{
    self.title = @"设置头像";
    self.headImg.layer.cornerRadius = self.headImg.frame.size.height/2;
    self.headImg.layer.masksToBounds = YES;

    if([HiTVGlobals sharedInstance].faceImg != nil && ![[HiTVGlobals sharedInstance].faceImg isKindOfClass:[NSNull class]] &&[[HiTVGlobals sharedInstance].faceImg hasPrefix:@"http://"]){
        [self.headImg setImageWithURL:[NSURL URLWithString:[HiTVGlobals sharedInstance].faceImg] placeholderImage:nil];
    }
    self.userNickName.text = [HiTVGlobals sharedInstance].nickName;

//    [self setNavigationRightButtonWithTitle:@"跳过"];
}

-(void)rightBarButtonItemPressed{
    if ([self.navigationController.viewControllers firstObject] == self) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)choosePic:(id)sender {
   // [self composePicAdd];
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
    UIImage *image = self.headImg.image;
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
            if ([self.navigationController.viewControllers firstObject] == self) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
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
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *jsonString = [parameters mj_JSONString];
    
    [dic setObject:jsonString forKey:@"info"];
    [dic setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [dic setObject:@"APP" forKey:@"type"];
    [parameters setObject:BIMS_DOMAIN forKey:@"area"];

    [BaseAFHTTPManager postRequestOperationForHost:MultiHost  forParam:@"/ms_update_phoneInfo" forParameters:dic  completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"code"];
        if (code.intValue == 0) {
            
        }
        
    }failure:^(NSString *error) {
        
    }];
}
/*-(IBAction)sendComplete:(id)sender{
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
        [self.headImg setImage:photoImg];
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
                    [self.headImg setImage:[UIImage imageNamed:@"登录"]];
                    imageData = UIImageJPEGRepresentation(UIImageScaleToSize([UIImage imageNamed:@"默认头像.png"], CGSizeMake(200, 200)), 0.5);

                }else{
                    imageData = UIImageJPEGRepresentation(UIImageScaleToSize(image, CGSizeMake(200, 200)), 0.5);
                    [self.headImg setImage:image];

                }
                
            }failureBlock:^(NSError *error) {
                DDLogInfo(@"error=%@",error);
                [self.headImg setImage:[UIImage imageNamed:@"登录"]];
                imageData = UIImageJPEGRepresentation(UIImageScaleToSize([UIImage imageNamed:@"默认头像.png"], CGSizeMake(200, 200)), 0.5);

            }];
            
            
        }else{
            imageData = UIImageJPEGRepresentation(UIImageScaleToSize([UIImage imageWithCGImage:[[[assets firstObject] defaultRepresentation] fullScreenImage]], CGSizeMake(200, 200)), 0.5);
            [self.headImg setImage:[UIImage imageWithCGImage:[[[assets firstObject] defaultRepresentation] fullScreenImage]]];
            

        }
        
        

    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
*/
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
