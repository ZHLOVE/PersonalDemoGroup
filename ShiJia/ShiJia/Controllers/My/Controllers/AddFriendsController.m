//
//  AddFriendsController.m
//  HiTV
//
//  Created by 蒋海量 on 15/7/24.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "AddFriendsController.h"
#import <AddressBook/AddressBook.h>
#import "AddressBook.h"
#import "UserEntity.h"
#import "QRCodeController.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "HiTVGlobals.h"
#import "SearchResultController.h"
#import "OMGToast.h"
#import "BIMSManager.h"
#import "AddressBook.h"
#import "FriendInfoController.h"
#import "UIView+DefaultEmptyView.h"
#import "LogInfoVC.h"

@interface AddFriendsController ()<MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *toBeReturned;
    NSMutableDictionary *_addressBookDic;

    NSArray *_keys;

}
@property (nonatomic,strong) NSMutableArray        *addressBookTemp;
@property (nonatomic,strong) NSMutableArray        *searchResultArray;

@property (nonatomic,weak  ) IBOutlet UIView       *emptyView;
@property (nonatomic,weak  ) IBOutlet UITableView  *addBookTabView;
@property (nonatomic,weak  ) IBOutlet UITextField  *textField;
@property (weak, nonatomic ) IBOutlet UIButton     *searchButton;
@property (nonatomic       ) BOOL                   IsSearch;
//推荐添加好友
@property (nonatomic,strong) NSMutableArray        *recommandArray;
@end

@implementation AddFriendsController
-(NSMutableArray *)recommandArray{
    if (!_recommandArray) {
        _recommandArray = [NSMutableArray new];
    }
    return _recommandArray;
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self hiddenKeyBoard];
}
-(void)hiddenKeyBoard
{
    [self.textField resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加好友";
    [self initUI];

    self.view.backgroundColor = klightGrayColor;
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];

    UIBarButtonItem *scanningBtn = [[UIBarButtonItem alloc]initWithImage:[[ UIImage imageNamed : @"扫一扫.png" ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain  target:self action:@selector(scanningBtnClick)];
    [self.navigationItem setRightBarButtonItem:scanningBtn];

    [self.textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self setExtraCellLineHidden:self.addBookTabView];

    [self getAddrBookRequest];

    self.searchButton.layer.cornerRadius = 14.0f;
    // self.searchButton.layer.borderWidth = 1.0f;
    self.searchButton.layer.borderColor = kColorBlueTheme.CGColor;

    self.searchButton.backgroundColor = kColorBlueTheme;
    

    self.mLabel.text = [NSString stringWithFormat:@"%@App未获得通讯录权限，无法获取好友信息，请允许和家庭访问手机通讯录", CurrentAppName ];    


}

#pragma headview
-(void)initUI{
    toBeReturned = [[NSArray alloc]initWithObjects:@"友",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T", @"U",@"V",@"W",@"X",@"Y",@"Z",@"#",nil];
    _addressBookDic = [[NSMutableDictionary alloc]init];

    UIView *view =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, W, 55)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *headLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, W, 55)];
    headLab.backgroundColor = [UIColor whiteColor];
    headLab.textColor = [UIColor blackColor];
    headLab.font = [UIFont boldSystemFontOfSize:16.0f];
    headLab.textAlignment = NSTextAlignmentLeft;
    headLab.text = @"    通讯录好友";
    [view addSubview:headLab];
    [view addSubview:[self seperateViewWithHeight:55]];

    self.addBookTabView.tableHeaderView = view;
    self.addBookTabView.sectionIndexBackgroundColor = [UIColor whiteColor];
    self.addBookTabView.sectionIndexColor = RGB(154, 154, 154, 1.0);
}
//扫描操作
-(void)scanningBtnClick{
    if ([self validateCamera]) {
        self.hidesBottomBarWhenPushed = YES;
        QRCodeController *qrVC = [[QRCodeController alloc]init];
        qrVC.type = @"1";
        [self.navigationController pushViewController:qrVC animated:YES];

    } else {
        [self showAlert:@"没有摄像头或摄像头不可用" withDelegate:nil];
    }

}

- (BOOL)validateCamera {

    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}


-(void)setDictionary{
    _keys = nil;
    [_addressBookDic removeAllObjects];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i<self.addressBookTemp.count; i++) {
        UserEntity *entity = [_addressBookTemp objectAtIndex:i];

        if ([[entity.type description] isEqualToString:@"1"]) {
            [dic setValue:@"友" forKey:entity.phoneNo];
        }else{
            if (entity.name &&entity.phoneNo) {
                NSString *str = [HiTVConstants phonetic:entity.name withLength:1];
                if (![toBeReturned containsObject:str]) {
                    str = @"#";
                }
                [dic setValue:str forKey:entity.phoneNo];
            }
        }
    }

//    if (_recommandArray.count>0) {
//
//        for (int i=0; i<_recommandArray.count; i++) {
//            UserEntity *entity = [_addressBookTemp objectAtIndex:i];
//            [dic setValue:@"友" forKey:entity.phoneNo];
//        }
//    }

    NSArray *array = dic.allValues;
    for (int i = 0; i<array.count; i++) {
        NSString *string = [array objectAtIndex:i];
        [_addressBookDic setValue:[dic allKeysForObject:string] forKey:[array objectAtIndex:i]];
    }
    NSArray *tempArr = [[_addressBookDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *newArr = [NSMutableArray array];

    [newArr addObjectsFromArray:tempArr];

    if ([tempArr containsObject:@"#"]) {
        [newArr removeObject:@"#"];
    }
    if ([tempArr containsObject:@"友"]) {
        [newArr removeObject:@"友"];
    }

    if ([tempArr containsObject:@"#"]) {
        [newArr addObject:@"#"];
    }
    if ([tempArr containsObject:@"友"]) {
        [newArr insertObject:@"友" atIndex:0];
    }
    _keys = [newArr copy];
}
#pragma mark 获取用户通讯录以及匹配结果,如果该用户已经注册则返回手机号对应的用户ID
-(void)getAddrBookRequest{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];

    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessag:@"获取好友" toView:nil];
    [BaseAFHTTPManager postRequestOperationForHost:SOCIALHOST
                                          forParam:@"/taipan/getUserAddrBooksList"
                                     forParameters:parameters
                                        completion:^(id responseObject) {

                                            [MBProgressHUD hideHUD];
                                            NSDictionary *resultDic = (NSDictionary *)responseObject;
                                            if ([[resultDic objectForKey:@"code"] intValue] == 0) {
                                                NSArray *infoArray = [resultDic objectForKey:@"result"];

                                                for (AddressBook *entity in [BIMSManager sharedInstance].addressBookArray) {
                                                    UserEntity *userEntity = [[UserEntity alloc]init];
                                                    NSString* tel = [entity.tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
                                                    userEntity.phoneNo = tel;
                                                    userEntity.name = entity.name;
                                                    userEntity.type = @"2";
                                                    if ((userEntity.phoneNo.length!=11)&&(![userEntity.phoneNo isEqualToString:@"+86"])) {
                                                        continue;
                                                    }

                                                    for (NSMutableDictionary *infoDic in infoArray) {
                                                        if ([infoDic[@"phoneNo"] isEqualToString:userEntity.phoneNo]) {
                                                            UserEntity *model = [[UserEntity alloc]initWithDictionary:infoDic];
                                                            model.uid = infoDic[@"userId"];
                                                            userEntity = model;
                                                        }
                                                    }
                                                    if (userEntity.name) {
                                                        userEntity.enName = [HiTVConstants CHTOEN:userEntity.name];
                                                    }

                                                    if (![[userEntity.phoneNo description] isEqualToString:[HiTVGlobals sharedInstance].phoneNo]) {
                                                        [self.addressBookTemp addObject:userEntity];
                                                    }
                                                }


                                                [self setDictionary];

                                                if (_addressBookDic.allValues.count == 0) {
                                                    if (![self getAddressListPermission]) {
                                                        _emptyView.hidden = NO;
                                                        _addBookTabView.hidden = YES;
                                                    }
                                                }
                                                else{
                                                    _emptyView.hidden = YES;
                                                    _addBookTabView.hidden = NO;
                                                    [self.addBookTabView reloadData];
                                                }

                                            }
                                        }failure:^(NSString *error) {
                                            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                        }];
}
-(IBAction)searchFriendsRequest{
    if ([self.textField.text isEqualToString:[HiTVGlobals sharedInstance].phoneNo]) {
        [OMGToast showWithText:@"无法操作自己"];
    }
    else{
        for (UserEntity *userEntity in [HiTVGlobals sharedInstance].friendsArray) {
            if ([self.textField.text isEqualToString:userEntity.phoneNo]) {
                [OMGToast showWithText:@"你们已经是好友了!"];
                return;
            }
        }
        NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
        [parameters setValue:self.textField.text forKey:@"phoneNo"];

        __weak typeof(self) weakSelf = self;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [BaseAFHTTPManager postRequestOperationForHost:WXSEEN forParam:@"/userservice/taipan/findByPhone" forParameters:parameters  completion:^(id responseObject) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            if ([[resultDic objectForKey:@"code"] intValue] == 0) {
                NSDictionary *infoDic = [resultDic objectForKey:@"userInfo"];
                UserEntity *entity = [[UserEntity alloc]initWithDictionary:infoDic];
                SearchResultController *searchVC = [[SearchResultController alloc]init];
                searchVC.userEntity = entity;


                [self.navigationController pushViewController:searchVC animated:YES];
            }


            [OMGToast showWithText:[resultDic objectForKey:@"message"]];


        }failure:^(NSString *error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [self showAlert:@"搜素失败" withDelegate:nil];
        }];
    }
}
-(void)invitationFriendRequest:(UserEntity *)entity{
    if ([entity.phoneNo isEqualToString:[HiTVGlobals sharedInstance].phoneNo]) {
        [OMGToast showWithText:@"无法操作自己"];
        return;
    }
    if (entity.type.intValue == 1) {
        NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
        [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
        [parameters setValue:entity.uid forKey:@"friendUid"];
        [parameters setValue:entity.name forKey:@"nickName"];

        __weak typeof(self) weakSelf = self;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [BaseAFHTTPManager postRequestOperationForHost:SOCIALHOST forParam:@"/taipan/addUserFriend" forParameters:parameters  completion:^(id responseObject) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            if ([[resultDic objectForKey:@"code"] intValue] == 0) {
                // add log.
                NSString* content = [NSString stringWithFormat:@"friendphone=%@", isNullString(entity.phoneNo)];
                [Utils BDLog:1 module:@"605" action:@"AddFriend" content:content];
                [MBProgressHUD showSuccess:@"添加成功" toView:nil];

                [UMengManager event:@"U_AddFriend"];
                [self.addressBookTemp removeObject:entity];

                [self setDictionary];

                [self.addBookTabView reloadData];
                //刷新列表
                /*
                 [tableview deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                 */

            }
            else{
                [MBProgressHUD showError:@"添加失败" toView:nil];
            }
        }failure:^(NSString *error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];

        }];
    }
    else if (entity.type.intValue == 2){
        
        NSMutableDictionary *parameter =  [NSMutableDictionary dictionary];
        [parameter setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
        [parameter setValue:entity.phoneNo forKey:@"phoneNo"];
        [parameter setValue:T_STBext forKey:@"ability"];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [BaseAFHTTPManager postRequestOperationForHost:HOTSHARE_HOST/*@"http://192.168.50.138:8080/share-facade"*/ forParam:@"/getShortMsgContent" forParameters:parameter  completion:^(id responseObject) {
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            if ([[resultDic objectForKey:@"resultCode"] isEqualToString:@"000"]) {
                NSString *shortMsgContent = [resultDic objectForKey:@"shortMsgContent"];
                 [self openSMS:entity.phoneNo content:shortMsgContent];
            }
            else{
                [self openSMS:entity.phoneNo content:[HiTVGlobals sharedInstance].shareContent];
                //[OMGToast showWithText:[resultDic objectForKey:@"resultMessage"]];
            }
        }failure:^(NSString *error) {
            [self openSMS:entity.phoneNo content:[HiTVGlobals sharedInstance].shareContent];

            //[OMGToast showWithText:@"网络连接失败"];

        }];
        
        NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
        [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
        [parameters setValue:entity.phoneNo forKey:@"phoneNo"];

        __weak typeof(self) weakSelf = self;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [BaseAFHTTPManager postRequestOperationForHost:SOCIALHOST forParam:@"/taipan/inviteFriend" forParameters:parameters  completion:^(id responseObject) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            if ([[resultDic objectForKey:@"code"] intValue] == 0) {
                [MBProgressHUD showSuccess:[resultDic objectForKey:@"message"] toView:nil];
                [UMengManager event:@"U_AddFriend"];
            }
        }failure:^(NSString *error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        }];
    }
    else if (entity.type.intValue == 3){
        FriendInfoController *friendInfoVC= [[FriendInfoController alloc] initWithNibName:@"FriendInfoController" bundle:nil];
        friendInfoVC.userEntity = entity;
        [self.navigationController pushViewController:friendInfoVC animated:YES];
    }

}
-(void)openSMS:(NSString *)phoneNo content:(NSString *)value{
    if([MFMessageComposeViewController canSendText])

    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.delegate = self;
        NSMutableArray *telArray = [[NSMutableArray alloc]init];

        [telArray addObject:phoneNo];
        controller.recipients = telArray;
       
        controller.body = value;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:NO completion:^{
         [[controller navigationBar]setTintColor:kNavgationBarColor];
        }];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:[NSString stringWithFormat:@"%@邀请信息",CurrentAppName]];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://"]];
}

#pragma mark - Permission
- (BOOL)getAddressListPermission
{
    BOOL permission = NO;
    if (&ABAddressBookRequestAccessWithCompletion != NULL) {    //检查是否是iOS6

        ABAddressBookRef abRef = ABAddressBookCreateWithOptions(NULL, NULL);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:NO forKey:kAddressListPermissionKey];

        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            //如果该应用从未申请过权限，申请权限

            [defaults setBool:YES forKey:kAddressListPermissionKey];


            /*UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"程序需要访问您的通讯录，打开通讯录后程序将保存您的通讯录至服务器，确定打开吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
             [alert show];*/
            permission =  YES;

        } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            //如果权限已经被授予

            [defaults setBool:YES forKey:kAddressListPermissionKey];
            permission = YES;
        } else {

            //如果权限被收回，只能提醒用户去系统设置菜单中打开
            [defaults setBool:NO forKey:kAddressListPermissionKey];
            permission = NO;
        }

        [defaults synchronize];

        if(abRef){

            CFRelease(abRef);

        }

    }
    return permission;
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    //    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    //    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    //
    //    hud.mode = MBProgressHUDModeText;


    switch (result) {
        case MessageComposeResultCancelled:
        {
            //            hud.labelText = @"已取消";

            [MBProgressHUD showError:@"已取消" toView:nil];
            [controller dismissViewControllerAnimated:YES completion:nil];

        }
            break;
        case MessageComposeResultSent:
        {

            //            hud.labelText = @"短信发送成功";
            [MBProgressHUD showSuccess:@"短信发送成功" toView:nil];
            [controller dismissViewControllerAnimated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
            break;
        case MessageComposeResultFailed:
        {
            //            hud.labelText = @"短信发送失败";
            [MBProgressHUD showError:@"短信发送失败" toView:nil];
            [controller dismissViewControllerAnimated:YES completion:nil];
        }

            break;

        default:
            break;
    }

    //    [hud show:YES];
    //    [hud hide:YES afterDelay:2.0];

}

- (IBAction)searchFirendInPhone:(id)sender {
    if (self.textField.text == nil ||self.textField.text == nil ||[self.textField.text isEqualToString:@""]) {
        self.IsSearch = NO;
    }
    else{
        self.IsSearch = YES;
        [self.searchResultArray removeAllObjects];
        // 谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",self.textField.text];
        for (UserEntity *entity in self.addressBookTemp) {
            // NSString *enName = [HiTVConstants CHTOEN:entity.name];

            if ([predicate evaluateWithObject:entity.name]) {
                [self.searchResultArray addObject:entity];
            }
            else if ([predicate evaluateWithObject:entity.phoneNo]) {
                [self.searchResultArray addObject:entity];
            }
            else if ([predicate evaluateWithObject:entity.enName]){
                [self.searchResultArray addObject:entity];
            }

        }
    }
    [self.addBookTabView reloadData];
}



#pragma mark - UITextFieldDelegate
- (IBAction)textFieldValueChanged:(UITextField *)textField
{
//    if ([textField.text isEqualToString:@"*#*#"] || [textField.text isEqualToString:@"#*#*"]) {
    if ([textField.text isEqualToString:@"1"] || [textField.text isEqualToString:@"#*#*"]) {
        LogInfoVC *logVC = [[LogInfoVC alloc]init];
        DDLogInfo(@"进入日志页面");
        [self.navigationController pushViewController:logVC animated:YES];
    }
    
    if (textField.text == nil ||self.textField.text == nil ||[self.textField.text isEqualToString:@""]) {
        self.IsSearch = NO;
    }
    else{
        self.IsSearch = YES;
        [self.searchResultArray removeAllObjects];
        // 谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",textField.text];
        for (UserEntity *entity in self.addressBookTemp) {
            // NSString *enName = [HiTVConstants CHTOEN:entity.name];

            if ([predicate evaluateWithObject:entity.name]) {
                [self.searchResultArray addObject:entity];
            }
            else if ([predicate evaluateWithObject:entity.phoneNo]) {
                [self.searchResultArray addObject:entity];
            }
            else if ([predicate evaluateWithObject:entity.enName]){
                [self.searchResultArray addObject:entity];
            }

        }
    }
    [self.addBookTabView reloadData];
}
-(UIView *)seperateViewWithHeight:(float)height{
    UIView *view =  [[UIView alloc] initWithFrame:CGRectMake(0, height-0.5,W, 0.5)];
    view.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    return view;
}
-(NSMutableArray *)addressBookTemp
{
    if (!_addressBookTemp) {
        _addressBookTemp = [NSMutableArray array];
    }
    return _addressBookTemp;
}
-(NSMutableArray *)searchResultArray
{
    if (!_searchResultArray) {
        _searchResultArray = [NSMutableArray array];
    }
    return _searchResultArray;
}

#pragma mark - AddressBookCellDelegate
- (void)invitationFriend:(UserEntity *)entity
{
    [self invitationFriendRequest:entity];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchFriendsRequest];

    return YES;
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return (!self.IsSearch) ? [_keys count] : 1;

}
//右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{

    return toBeReturned;

}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (self.IsSearch) {
        return 0;
    }
    return [_keys indexOfObject:title];

}
//设置_tableView的章、节
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.IsSearch) {
        return @"";
    }
    return [_keys objectAtIndex:section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.IsSearch) {
        return nil;
    }
    UILabel *headLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, W, 30)];
    headLab.backgroundColor = [UIColor whiteColor];
    headLab.textColor = [UIColor blackColor];
    headLab.font = [UIFont systemFontOfSize:12.0f];
    headLab.textAlignment = NSTextAlignmentLeft;
    NSString *title = [_keys objectAtIndex:section];
    if ([title isEqualToString:@"友"]) {
        headLab.text = @"      推荐添加";
    }else{
        headLab.text = [NSString stringWithFormat:@"      %@",[_keys objectAtIndex:section]];
    }
    [headLab addSubview:[self seperateViewWithHeight:30]];
    return headLab;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.IsSearch) {
        if (self.searchResultArray.count==0) {
            [tableView setBackgroundView:[UIView Friend_EmptyDefaultView]];
        }else{
            [tableView setBackgroundView:nil];
        }

        return self.searchResultArray.count;
    }

    _emptyView.hidden = _addressBookDic.allValues.count > 0 ? YES : NO;
    NSUInteger result=0;

    NSArray *arr = [_addressBookDic objectForKey:[_keys objectAtIndex:section]];


    result=arr.count;
    return  result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressBookCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"AddressBookCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.m_delegate = self;
    [cell addSubview:[self seperateViewWithHeight:58]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UserEntity *entity = nil;
    if (self.IsSearch) {
        entity = self.searchResultArray[row];
    }
    else{
        NSString *key = [_keys objectAtIndex:section];

        NSArray *nameSection = [_addressBookDic objectForKey:key];

        NSString *str = [nameSection objectAtIndex:row];
        for (UserEntity *userEntity in self.addressBookTemp) {
            if ([userEntity.phoneNo isEqualToString:str]) {
                entity = userEntity;
            }
        }
    }
    cell.userEntity = entity;
    cell.headImg.image = [UIImage imageNamed:DEFAULTHEADICON];
    cell.nameLab.text = entity.name;
    cell.telLab.text = entity.phoneNo;

    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - viewForHeaderInSection 不停留在顶部
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    if (scrollView == self.addBookTabView)
    //    {
    //        //YOUR_HEIGHT 为最高的那个headerView的高度
    //        CGFloat sectionHeaderHeight = 58;
    //        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
    //            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    //        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
    //            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    //        }
    //    }
}
#pragma mark - Event
- (IBAction)openPrivacyButtonClicked:(id)sender
{
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CONTACTS"]];
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
        
    }
    
}

@end
