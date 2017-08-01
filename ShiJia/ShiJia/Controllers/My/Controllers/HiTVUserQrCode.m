//
//  HiTVUserQrCode.m
//  HiTV
//
//  Created by wesley on 15/8/9.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//
#import "HiTVUserQrCode.h"

@interface HiTVUserQrCode ()
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@end

@implementation HiTVUserQrCode

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = klightGrayColor;
    self.title = @"二维码名片";
//    [self getUserInfo];
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUserInfo];


}

//获取用户信息
-(void)getUserInfo
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"userid"];
    [parameters setValue:@"220" forKey:@"width"];
    [parameters setValue:@"220" forKey:@"height"];
    [parameters setValue:@"http://www.ysten.com/" forKey:@"url"];
    
    [parameters setValue: @"hezi" forKey:@"devicename"];
    [parameters setValue:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] forKey:@"datapoint"];
    [parameters setObject:[NSNumber numberWithBool:YES]  forKey:@"logo"];
    [parameters setObject:[HiTVGlobals sharedInstance].faceImg  forKey:@"faceImg"];
    [parameters setObject:@"PHONE"  forKey:@"type"];


    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BaseAFHTTPManager postRequestOperationForHost:MultiHost forParam:@"/ms_make_qr_code" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"code"];
        if (code.intValue == 0) {
            if(![[responseDic objectForKey:@"message"] isKindOfClass:[NSNull class]] && [[responseDic objectForKey:@"message"] hasPrefix:@"http://"]){
                [_userQrImageView setImageWithURL:[NSURL URLWithString:[responseDic objectForKey:@"message"]] placeholderImage:[UIImage imageNamed:@""]];
            }
            
        }
        else{
            [self showAlert:[responseDic objectForKey:@"message"] withDelegate:nil];
        }
        
        
        
    }failure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf p_handleNetworkError];
    }];
    
    
    
    self.nickNameLabel.text = [HiTVGlobals sharedInstance].nickName;
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
