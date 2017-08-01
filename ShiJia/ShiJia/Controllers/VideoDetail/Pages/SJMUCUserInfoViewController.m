//
//  SJMUCUserInfoViewController.m
//  ShiJia
//
//  Created by yy on 16/9/5.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJMUCUserInfoViewController.h"
#import "SJMyViewController.h"

@interface SJMUCUserInfoViewController ()

@property (nonatomic, strong) TRTopNavgationView *naviView;
@property (nonatomic, weak) IBOutlet UIImageView *headImgView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *phoneLabel;
@property (nonatomic, weak) IBOutlet UIButton *bottomButton;
@property (nonatomic, assign) BOOL isMyFriend;

@end

@implementation SJMUCUserInfoViewController

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"好友资料";
    self.view.backgroundColor = klightGrayColor;
    self.navigationController.navigationBarHidden = YES;
    [self initNavigationView];
    
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 80 / 2.0;
    
    
    self.nameLabel.text = self.userEntity.nickName;
    NSString *tel = self.userEntity.phoneNo;
    self.phoneLabel.text = tel;
    
    [self.headImgView setImageWithURL:[NSURL URLWithString:self.userEntity.faceImg] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
    
    if (![self.userEntity.uid.description isEqualToString:[HiTVGlobals sharedInstance].uid.description]) {
        if (tel.length == 11) {
            tel = [self.userEntity.phoneNo stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        self.phoneLabel.text = tel;
        [self getRelationship];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event
- (IBAction)bottomButtonClicked:(id)sender
{
    if (_isMyFriend) {
        [self unConcernFriend];
    }
    else{
        [self concernFriendRequest];
    }
    
}


- (void)unConcernFriend
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除好友吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - Request
- (void)concernFriendRequest
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:self.userEntity.uid forKey:@"friendUid"];
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BaseAFHTTPManager postRequestOperationForHost:SOCIALHOST forParam:@"/taipan/addUserFriend" forParameters:parameters  completion:^(id responseObject) {
        

        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"code"] intValue] == 0) {
            // add log.
            NSString* content = [NSString stringWithFormat:@"friendphone=%@", isNullString(weakSelf.userEntity.phoneNo)];
            [Utils BDLog:1 module:@"605" action:@"AddFriend" content:content];
            // add log.
        }
        [OMGToast showWithText:[resultDic objectForKey:@"message"]];
        [weakSelf.navigationController popViewControllerAnimated:YES];

        
    }failure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
        [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
        [parameters setValue:self.userEntity.uid forKey:@"friendUid"];
        
        __weak typeof(self) weakSelf = self;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [BaseAFHTTPManager postRequestOperationForHost:SOCIALHOST forParam:@"/taipan/delUserFriend" forParameters:parameters  completion:^(id responseObject) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            if ([[resultDic objectForKey:@"code"] intValue] == 0) {
                [OMGToast showWithText:@"删除好友成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [OMGToast showWithText:[resultDic objectForKey:@"message"]];
            }
        }failure:^(NSString *error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
        }];
    }
}

- (void)getRelationship
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MBProgressHUD showMessag:@"加载中" toView:self.view.window];
    
    [BaseAFHTTPManager postRequestOperationForHost:SOCIALHOST forParam:@"/taipan/getUserFriendList" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"code"] intValue] == 0) {
            //NSMutableArray *resultArray = [NSMutableArray array];
            
            NSArray *usersArray = [resultDic objectForKey:@"users"];
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                       ascending:YES
                                                                        selector:@selector(localizedCaseInsensitiveCompare:)];
            NSArray *descriptors = [NSArray arrayWithObject:descriptor];
            
            NSMutableArray *resultArray = (NSMutableArray *)[usersArray sortedArrayUsingDescriptors:descriptors];
           
            for (NSMutableDictionary *userDic in resultArray) {
                UserEntity *entity = [[UserEntity alloc]initWithDictionary:userDic];
                
                if ([entity.uid.description isEqualToString:self.userEntity.uid.description]) {
                    _isMyFriend = YES;
                    
                    break;
                }
                
            }
            
            self.bottomButton.hidden = NO;
            
            if (_isMyFriend) {
            
                [self.bottomButton setTitle:@"删除好友" forState:UIControlStateNormal];
            }
            else{
                [self.bottomButton setTitle:@"添加好友" forState:UIControlStateNormal];
            }
            
        }
    }failure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        
    }];
}

#pragma mark - Subview
- (void)initNavigationView
{
    _naviView = [TRTopNavgationView navgationView];
    [self.view addSubview:_naviView];
    _naviView.backgroundColor = kColorBlueTheme;
    
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
    UILabel* lbl = [UIHelper createTitleLabel:@"好友资料"];
    lbl.textColor = [UIColor whiteColor];
    [_naviView setTitleView:lbl];
    
    
}

@end
