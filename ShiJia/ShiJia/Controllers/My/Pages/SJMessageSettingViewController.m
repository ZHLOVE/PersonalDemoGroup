//
//  SJMessageSettingViewController.m
//  ShiJia
//
//  Created by yy on 16/3/15.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJMessageSettingViewController.h"
#import "SJMessageSettingCell.h"
#import "SJSwitch.h"

@interface SJMessageSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_titleItems;
    NSArray *_detailItems;
    BOOL programKuaiBaoSwitch;
    BOOL programReminderSwitch;
    BOOL adSwitch;
    BOOL notiPermission;
    BOOL resumeSwitch;
    
}

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) TRTopNavgationView *naviView;
@property (nonatomic, strong) NSMutableArray *boolValuesArray;


@end

@implementation SJMessageSettingViewController

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.backgroundColor = [UIColor clearColor];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        [_table registerClass:[SJMessageSettingCell class] forCellReuseIdentifier:@"SJMessageSettingCell"];
        
        //_items = @[@"节目快报",@"节目提醒",@"头部广告"];
        _titleItems = @[@"应用消息推送",@"离家/回家模式消息提醒"];
        _detailItems = @[@"开启后，您可以收到来自和家庭为您推荐的精彩内容",@"开启后，将收到跨屏续播观看消息提醒"];
        notiPermission = [self getNotificationPermission];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        resumeSwitch = [defaults boolForKey:kResumeVideoSwitchKey];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorLightGrayBackground;
    //[self initNavigationView];
    self.title = @"新消息通知";
    [self.view addSubview:_table];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeGround)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
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

/*
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)setNeedsStatusBarAppearanceUpdate
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}
 */

#pragma mark - Data
- (NSMutableArray *)boolValuesArray
{
    if (!_boolValuesArray) {
        NSString *a = [NSUserDefaultsManager getObjectForKey:kProgramKuaiBaoPermissionKey];
        NSString *b = [NSUserDefaultsManager getObjectForKey:kProgramReminderPermissionKey];
        NSString *c = [NSUserDefaultsManager getObjectForKey:kShowHeaderAdKey];
        
        _boolValuesArray = [[NSMutableArray alloc]initWithObjects:StringNotEmpty(a)?@"1":@"0",StringNotEmpty(b)?@"1":@"0",StringNotEmpty(c)?@"1":@"0", nil];
        
    }
    return _boolValuesArray;
}

- (BOOL)getNotificationPermission
{
    if (kIOS8_OR_LATER) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (setting.types != UIUserNotificationTypeNone) {
            return YES;
        }
    }
    // app 最低支持8.0版本，所以不存在老版本API调用问题
#if 0
    } else {
        
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(type != UIRemoteNotificationTypeNone)
            return YES;
    }
#endif
    return NO;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 0;
//    }
//    return _titleItems.count;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20.0;
    }
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SJMessageSettingCell";
    SJMessageSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[SJMessageSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.text = _titleItems[indexPath.section];
    cell.detailText = _detailItems[indexPath.section];
    
    
    if (indexPath.section == 0) {
        
//        cell.text = @"离线接收新消息通知";
        cell.rightSwitch.changeValueAfterAction = YES;
        [cell setTheSwitch:[self getNotificationPermission]];
        //cell.switchOn = [self getNotificationPermission];
        [cell setSwitchValueChanged:^(BOOL isOn) {
            
            NSString *identifier = [NSBundle mainBundle].bundleIdentifier;
            NSString *str = [NSString stringWithFormat:@"prefs:root=NOTIFICATIONS_ID&path=(%@)",identifier];
            
            
            NSURL *url = [NSURL URLWithString:str];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                
                [[UIApplication sharedApplication] openURL:url];
                
            }
            
        }];
    }
    else{
        
        /*
        cell.text = _items[indexPath.row];
        
        NSString *ss = self.boolValuesArray[indexPath.row];
        [cell setTheSwitch:[ss isEqualToString:@"1"]?YES:NO];
        NSArray *keys = @[kProgramKuaiBaoPermissionKey,kProgramReminderPermissionKey,kShowHeaderAdKey];
        
        [cell setSwitchValueChanged:^(BOOL isOn) {
            
            [NSUserDefaultsManager saveObject:isOn?@"1":@"0" forKey:keys[indexPath.row]];
            [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_MessagePermissionChanged object:nil];
        }];
         */
        [cell setTheSwitch:resumeSwitch];
        [cell setSwitchValueChanged:^(BOOL isOn){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:isOn forKey:kResumeVideoSwitchKey];
            [defaults synchronize];
        }];
        
    }
    
    
    return cell;
    
}

#pragma mark - Notification
- (void)applicationWillEnterForeGround
{
//    BOOL permission = [self getNotificationPermission];
//    if (notiPermission != permission) {
//        notiPermission = permission;
        [_table reloadData];
//    }
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
    UILabel* lbl = [UIHelper createTitleLabel:@"新消息通知"];
    lbl.textColor = [UIColor whiteColor];
    [_naviView setTitleView:lbl];
    
    
}

@end
