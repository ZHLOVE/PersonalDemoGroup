//
//  SJSettingViewController.m
//  ShiJia
//
//  Created by yy on 16/3/14.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJSettingViewController.h"
#import "SJMessageSettingViewController.h"
#import "SJAboutViewController.h"

#import "SJSettingCell.h"
#import "NSUserDefaultsManager.h"
#import "BIMSManager.h"
#import <AddressBook/AddressBook.h>

@interface SJSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_items;
    BOOL addressPermission;
}
@property (nonatomic, strong) UITableView        *table;
@property (nonatomic, strong) TRTopNavgationView *naviView;

@end

@implementation SJSettingViewController

#pragma mark -  Lifecycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        _table = [[UITableView alloc] init];
        _table.delegate = self;
        _table.dataSource = self;
        _table.backgroundColor = [UIColor clearColor];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        [_table registerClass:[SJSettingCell class] forCellReuseIdentifier:@"SJSettingCell"];
        
        _items = @[@"公开我的观看和收藏记录",@"允许访问本地通讯录",@"新消息通知",@"关于"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorLightGrayBackground;
    self.title = @"设置";
   // [self initNavigationView];
    [self.view addSubview:_table];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    BOOL permission = [self getAddressListPermission];
    if (addressPermission != permission) {
        addressPermission = permission;
        [_table reloadData];
    }
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _table.frame = CGRectMake( 0,
                              _naviView.frame.size.height,
                              self.view.frame.size.width,
                              self.view.frame.size.height - _naviView.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource & UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60.0;
    }
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SJSettingCell";
    
    SJSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[SJSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.title = _items[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.SwitchOn = [HiTVGlobals sharedInstance].isPublicRecord;
            cell.detail = @"关闭后对方将无法看到你的观看和收藏记录";
            cell.showSwitch = YES;
            cell.switchValueChanged = ^(BOOL isOn){
                [[BIMSManager sharedInstance] publicRecord:isOn?@"0":@"1"];
            };
            
        }
            break;
            
        case 1:
        {            
            cell.SwitchOn = addressPermission;
            cell.showSwitch = YES;
            cell.switchValueChanged = ^(BOOL isOn){
                
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CONTACTS"]];
                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:url];
                    
                }
                
            };
            
        }
            break;
            
//        case 1:{
//             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//            break;
//        case 2:{
//            
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//            break;
//        case 3:
//        {
//            
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//            break;
            
        default:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        self.hidesBottomBarWhenPushed = YES;
        SJMessageSettingViewController *msgSettingVC = [[SJMessageSettingViewController alloc] init];
        [self.navigationController pushViewController:msgSettingVC animated:YES];
    }
    else if (indexPath.row == 3)
    {
        self.hidesBottomBarWhenPushed = YES;
        SJAboutViewController *aboutVC = [[SJAboutViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}

#pragma mark - Address List Permission
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

/*#pragma mark - Subview
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
    UILabel* lbl = [UIHelper createTitleLabel:@"设置"];
    lbl.textColor = [UIColor whiteColor];
    [_naviView setTitleView:lbl];
    
    
}*/

@end
