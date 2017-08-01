//
//  SearchResultController.m
//  HiTV
//
//  Created by 蒋海量 on 15/7/24.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "SearchResultController.h"
#import "AddFriendsController.h"
#import "MyFriendsController.h"
#import "QRCodeController.h"
#import "OMGToast.h"
#import "SJMyViewController.h"

@interface SearchResultController ()
@property(nonatomic,weak) IBOutlet UIImageView *headImg;
@property(nonatomic,weak) IBOutlet UILabel *nameLab;
@property(nonatomic,weak) IBOutlet UILabel *telLab;

@property(nonatomic,weak) IBOutlet UIButton *concernBtn;

@end

@implementation SearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"搜索结果";
    self.view.backgroundColor = klightGrayColor;

    self.headImg.layer.masksToBounds = YES;
    // 其實就是設定圓角，只是圓角的弧度剛好就是圖片尺寸的一半
    self.headImg.layer.cornerRadius = 80 / 2.0;
    

    self.nameLab.text = self.userEntity.nickName;
    self.telLab.text = self.userEntity.phoneNo;
    [self.headImg setImageWithURL:[NSURL URLWithString:self.userEntity.faceImg] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
    //!!!:没有用到
    //???:
    //NSString *nickname = self.userEntity.name.length == 0 ? self.userEntity.nickName : self.userEntity.name;
}
-(IBAction)concernBtnClick{
    [self concernFriendRequest];
}
-(void)concernFriendRequest{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:self.userEntity.uid forKey:@"friendUid"];
  //  [parameters setValue:self.userEntity.phoneNo forKey:@"nickName"];

    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BaseAFHTTPManager postRequestOperationForHost:SOCIALHOST forParam:@"/taipan/addUserFriend" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"code"] intValue] == 0) {
            
            // add log.
            NSString* content = [NSString stringWithFormat:@"friendphone=%@", isNullString(self.userEntity.phoneNo)];
            [Utils BDLog:1 module:@"605" action:@"AddFriend" content:content];
            // add log.
            
            [UMengManager event:@"U_AddFriend"];
        }
        [OMGToast showWithText:[resultDic objectForKey:@"message"]];
        //[self backButtonTapped];
        
        
        
        MyFriendsController *MyFriendsVC = [[MyFriendsController alloc] init];
        [self.navigationController pushViewController:MyFriendsVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    }failure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                
    }];
}
- (void)p_backButtonTapped{
    [self backButtonTapped];
}
- (void)backButtonTapped{
    BOOL exit = NO;
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[AddFriendsController class]]) {
            exit = YES;
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
        else if ([controller isKindOfClass:[SJMyViewController class]]){
            exit = YES;
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
    if (!exit) {
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        if (index > 1) {
            if ([[self.navigationController.viewControllers objectAtIndex:index-1] isKindOfClass:[QRCodeController class]]) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2] animated:YES];
            }
        }
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //[self.navigationController popViewControllerAnimated:YES];
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
