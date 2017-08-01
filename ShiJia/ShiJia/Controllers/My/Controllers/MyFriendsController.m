//
//  MyFriendsController.m
//  HiTV
//
//  Created by 蒋海量 on 15/7/23.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "MyFriendsController.h"
#import "BaseAFHTTPManager.h"
#import "UserEntity.h"
#import "QRCodeController.h"
#import "AddFriendsController.h"
#import "FriendInfoController.h"
#import "RecentVideo.h"
#import "TPXmppRoomManager.h"
#import "SJMultiVideoDetailViewController.h"
#import "WatchListEntity.h"
#import "HiTVVideo.h"
#import "TVProgram.h"
#import "TVStation.h"
#import "WatchFocusVideoProgramEntity.h"
#import "WatchFocusVideoEntity.h"
#import "TPIMUser.h"
#import "UIView+DefaultEmptyView.h"

@interface MyFriendsController ()<UITableViewDataSource,UITableViewDelegate>{
    NSTimer *verTimer;

}
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property(nonatomic,strong) NSMutableArray *friendsList;
@property(nonatomic,strong) NSMutableArray *watchingList;
@property(nonatomic,strong) NSMutableArray *searchResultArray;

@property(nonatomic,weak) IBOutlet UITableView *friendsTabView;
@property(nonatomic,weak) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property(nonatomic) BOOL IsSearch;

@property (strong, nonatomic)  UIView *defaultView;

@end

@implementation MyFriendsController
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
    self.view.backgroundColor = klightGrayColor;
    self.friendsTabView.backgroundColor = klightGrayColor;
    self.friendsTabView.separatorColor = kTabLineColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissAlert:) name:TPIMNotification_FollowFriends object:nil];

    self.title = @"好友";
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithImage:[ UIImage imageNamed : @"添加好友" ] style:UIBarButtonItemStylePlain target:self action:@selector(addFriendsClick)];
    [addBtn setTintColor:kNavTitleColor];

    self.navigationItem.rightBarButtonItem = addBtn;
    
    UIImageView *lineView = [UIImageView new];
    lineView.backgroundColor = UIColorHex( e5e5e5);
    [self.topImageView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.topImageView);
        make.height.mas_equalTo(1);
    }];
    
    [self setExtraCellLineHidden:self.friendsTabView];
    [self.textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];

    // 下拉刷新
    __weak __typeof(self)weakSelf = self;
    self.friendsTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getFriends];
    }];

    self.searchButton.layer.borderColor = kColorBlueTheme.CGColor;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.friendsTabView.mj_header beginRefreshing];
}
-(UIView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 110, 150)];
        _defaultView.backgroundColor = [UIColor clearColor];
        
        UIImageView *zwddImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 90, 90)];
        zwddImg.image = [UIImage imageNamed:@"img_none_friend"];
        [_defaultView addSubview:zwddImg];
        
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, 30, 30)];
        lab.backgroundColor = [UIColor clearColor];
        lab.text = @"先去";
        lab.textColor = [UIColor lightGrayColor];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentCenter;
        [_defaultView addSubview:lab];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(30, 110, 65, 30);
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:@"添加好友" forState:UIControlStateNormal];
        [btn setTitleColor:kColorBlueTheme forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(addFriendsClick) forControlEvents:UIControlEventTouchUpInside];
        [_defaultView addSubview:btn];
        
        UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(95, 110, 15, 30)];
        lab2.backgroundColor = [UIColor clearColor];
        lab2.text = @"吧";
        lab2.textColor = [UIColor lightGrayColor];
        lab2.font = [UIFont systemFontOfSize:14];
        lab2.textAlignment = NSTextAlignmentCenter;
        [_defaultView addSubview:lab2];
        
        _defaultView.center = CGPointMake(W/2, H/2-100);
        
        [self.view addSubview:_defaultView];
    }
    
    return _defaultView;
}
- (void)p_backButtonTapped{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)addFriendsClick{
    self.hidesBottomBarWhenPushed = YES;
    AddFriendsController *addFriendsVC = [[AddFriendsController alloc]init];
    [self.navigationController pushViewController:addFriendsVC animated:YES];
}
-(void)getFriends{
    [self.friendsList removeAllObjects];

    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
   // [MBProgressHUD showMessag:@"加载中" toView:self.view.window];

    [BaseAFHTTPManager postRequestOperationForHost:SOCIALHOST forParam:@"/taipan/getUserFriendList" forParameters:parameters  completion:^(id responseObject) {
//        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        [self.friendsTabView.mj_header endRefreshing];

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
                if (entity.nickName == nil||[entity.nickName isEqualToString:@"" ]) {
                    entity.enName = [HiTVConstants CHTOEN:entity.name];
                }
                else{
                    entity.enName = [HiTVConstants CHTOEN:entity.nickName];
                }

                [self.friendsList addObject:entity];
                
                if (entity.jid.length == 0) {
                    entity.jid = [TPIMUser jidString:entity.uid];
                }
               
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                     [[TPXmppRoomManager defaultManager] saveNickname:entity.name withUserJid:entity.jid];
                    [[TPXmppRoomManager defaultManager] saveHeadImageUrl:entity.faceImg withUserJid:entity.jid];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 更新界面
                        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                    });
                });
                
            }
            if (self.friendsList.count == 0) {
                self.defaultView.hidden = NO;
            }
            else{
                [HiTVGlobals sharedInstance].friendsArray = self.friendsList;
                self.defaultView.hidden = YES;
            }
            [self.friendsTabView reloadData];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self getFriendsWatching];

                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                });
            });
        }
        DDLogInfo(@"suc");
    }failure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        [self.friendsTabView.mj_header endRefreshing];

        DDLogInfo(@"fail");
        
    }];
}
-(void)getFriendsWatching{
    [self.watchingList removeAllObjects];
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];

    NSString *friendUidsStr = @"";
    for (UserEntity *entity in self.friendsList) {
        friendUidsStr = [NSString stringWithFormat:@"%@,%@",friendUidsStr,entity.uid];
    }
    if (friendUidsStr.length >1) {
        friendUidsStr = [friendUidsStr substringFromIndex:1];
        [parameters setValue:friendUidsStr forKey:@"oprUids"];
    }
//    [MBProgressHUD showMessag:@"获取好友" toView:nil];
    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN forParam:@"/integration/2.0/getWatching" forParameters:parameters  completion:^(id responseObject) {
//        [MBProgressHUD hideHUD];
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"code"] intValue] == 0) {
            NSArray *usersArray = [resultDic objectForKey:@"data"];
            if ([usersArray isKindOfClass:[NSNull class]]) {
                return ;
            }
            
            for (NSMutableDictionary *userDic in usersArray) {
                RecentVideo* entity = [[RecentVideo alloc]initWithDict:userDic];
                [self.watchingList addObject:entity];
            }
            [self setFriendsAddrBook];
            
        }
        DDLogInfo(@"suc");

    }failure:^(NSString *error) {

        DDLogInfo(@"fail");
         [MBProgressHUD hideHUD];
        
    }];
}
-(NSMutableArray *)friendsList
{
    if (!_friendsList) {
        _friendsList = [NSMutableArray array];
    }
    return _friendsList;
}
-(NSMutableArray *)watchingList
{
    if (!_watchingList) {
        _watchingList = [NSMutableArray array];
    }
    return _watchingList;
}
-(NSMutableArray *)searchResultArray
{
    if (!_searchResultArray) {
        _searchResultArray = [NSMutableArray array];
    }
    return _searchResultArray;
}

-(void)setFriendsAddrBook{
    for (UserEntity *userEntity in self.friendsList) {
        for (RecentVideo *watchingEntity in self.watchingList) {
            if (userEntity.uid.intValue == watchingEntity.uid.intValue) {
                userEntity.programName = watchingEntity.lastProgramName;
                if (!userEntity.programName) {
                    userEntity.programName = watchingEntity.objectName;
                }
                userEntity.watchingEntity = watchingEntity;
            }
        }
    }
    [self.friendsTabView reloadData];
}

#pragma mark - 扫一扫
- (BOOL)validateCamera {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        DDLogWarn(@"相机权限受限");
        return NO;
    }
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (IBAction)searchFriend:(id)sender {
    if (self.textField.text == nil ||self.textField.text == nil ||[self.textField.text isEqualToString:@""]) {
        self.IsSearch = NO;
    }
    else{
        self.IsSearch = YES;
        [self.searchResultArray removeAllObjects];
        // 谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",self.textField.text];
        for (UserEntity *entity in self.friendsList) {
            NSString *name = entity.nickName;
            if (entity.nickName == nil||[entity.nickName isEqualToString:@"" ]) {
                name = entity.name;
            }
            //NSString *enName = [HiTVConstants CHTOEN:name];

            if ([predicate evaluateWithObject:entity.enName]||[predicate evaluateWithObject:entity.phoneNo]||[predicate evaluateWithObject:entity.nickName]||[predicate evaluateWithObject:entity.name]) {
                [self.searchResultArray addObject:entity];
            }
        }
    }
    
    [self.friendsTabView reloadData];
}
#pragma mark - UITextFieldDelegate
- (IBAction)textFieldValueChanged:(UITextField *)textField
{
    if (textField.text == nil ||self.textField.text == nil ||[self.textField.text isEqualToString:@""]) {
        self.IsSearch = NO;
    }
    else{
        self.IsSearch = YES;
        [self.searchResultArray removeAllObjects];
        // 谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",textField.text];
        for (UserEntity *entity in self.friendsList) {
            NSString *name = entity.nickName;
            if (entity.nickName == nil||[entity.nickName isEqualToString:@"" ]) {
                name = entity.name;
            }
            //NSString *enName = [HiTVConstants CHTOEN:name];

            if ([predicate evaluateWithObject:entity.enName]||[predicate evaluateWithObject:entity.phoneNo]||[predicate evaluateWithObject:entity.nickName]||[predicate evaluateWithObject:entity.name]) {
                [self.searchResultArray addObject:entity];
            }
        }
    }
    [self.friendsTabView reloadData];
}
#pragma mark - MyFriendsCellDelegate
- (void)watchFriendVideo:(UserEntity *)userEntity{
    if (!userEntity.watchingEntity) {
        return;
    }
    [self goVideoDetailVC:userEntity.watchingEntity];
}

//喵
- (void)aimFriend:(UserEntity *)userEntity
{
    if (!userEntity.watchingEntity) {
        return;
    }
    WatchListEntity *watchEntity = [[WatchListEntity alloc]init];
    
    RecentVideo *content = userEntity.watchingEntity;
    if ([content.businessType isEqualToString:@"watchtv"]) {
        watchEntity.programSeriesName = content.objectName;
        
    }
    else if ([content.businessType isEqualToString:@"vod"]){
        // 点播
        
        watchEntity.programSeriesName = content.objectName;
        
    }
    else if ([content.businessType isEqualToString:@"livereplay"]){
        // 直播
        watchEntity.programSeriesName = content.lastProgramName;
        
    }
    
    [TPXmppRoomManager defaultManager].watchListEntity = watchEntity;
    NSArray *arr = [NSArray arrayWithObjects:userEntity, nil];
    [TPXmppRoomManager defaultManager].invitedUserList = [NSArray arrayWithArray:arr];
    
    [TPXmppRoomManager defaultManager].stype = @"noti";
    [[TPXmppRoomManager defaultManager] sendFollowFriendMessage];
    [MBProgressHUD showMessag:@"请求中，请耐心等待..." toView:nil];
    if (!verTimer) {
        verTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(verUpdate) userInfo:nil repeats:NO];
    }
}
-(void)verUpdate{
    
    [self closeTimer];
}
-(void)closeTimer{
    [verTimer invalidate];
    verTimer = nil;
//    [MBProgressHUD hideHUD];

    [MBProgressHUD show:@"请求超时" icon:nil view:nil];
}
- (void)dismissAlert:(NSNotification *)notification
{
    // [MBProgressHUD show:@"连接超时" icon:nil view:nil];
    [MBProgressHUD hideHUD];
    
}
- (void)friendDetail:(UserEntity *)userEntity{
    self.hidesBottomBarWhenPushed = YES;
    FriendInfoController *friendInfoVC= [[FriendInfoController alloc] initWithNibName:@"FriendInfoController" bundle:nil];
    friendInfoVC.userEntity = userEntity;
   [self.navigationController pushViewController:friendInfoVC animated:YES];
    
}
#pragma mark - 好友正在观看
-(void)goVideoDetailVC:(RecentVideo *)content{
    
    if ([content.businessType isEqualToString:@"watchtv"]) {
        if ([content.playType isEqualToString:@"live"]) {
            // 直播
            self.hidesBottomBarWhenPushed = YES;
            
            SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeLive];
            
            WatchListEntity *watchEntity = [[WatchListEntity alloc]init];
            watchEntity.contentId = content.lastProgramId;
            watchEntity.channelUuid = content.objectId;
            watchEntity.startTime = [content.startTime longLongValue];
            watchEntity.endTime = [content.endTime longLongValue];
            //watchEntity.categoryId = content.objectId;
            watchEntity.programSeriesName = content.lastProgramName;
            watchEntity.deviceType = content.deviceType;
            
            detailVC.watchEntity = watchEntity;
            // detailVC.videoDatePoint = content.endWatchTime.floatValue;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        else if ([content.playType isEqualToString:@"replay"]){
            // 直播
            self.hidesBottomBarWhenPushed = YES;
            
            SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeReplay];
            
            WatchListEntity *watchEntity = [[WatchListEntity alloc]init];
            watchEntity.contentId = content.lastProgramId;
            watchEntity.channelUuid = content.objectId;
            watchEntity.startTime = [content.startTime longLongValue];
            watchEntity.endTime = [content.endTime longLongValue];
            //watchEntity.categoryId = content.objectId;
            watchEntity.programSeriesName = content.lastProgramName;
            watchEntity.deviceType = content.deviceType;
            detailVC.watchEntity = watchEntity;
            // detailVC.videoDatePoint = content.endWatchTime.floatValue;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        else if ([content.playType isEqualToString:@"vod"]){
            // 点播
            self.hidesBottomBarWhenPushed = YES;
            SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
            detailVC.videoID = content.objectId;
            
            WatchListEntity *entity = [[WatchListEntity alloc]init];
            entity.setNumber = content.seriesNumber;
            
            detailVC.watchEntity = entity;
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
        else{
            // 看点
            self.hidesBottomBarWhenPushed = YES;
            SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeWatchTV];
            detailVC.videoID = content.assortId;
            detailVC.categoryID = content.objectId;
            WatchListEntity *entity = [[WatchListEntity alloc]init];
            entity.programSeriesId = content.objectId;
            entity.categoryId = content.assortId;
            entity.contentId = content.lastProgramId;
            entity.programSeriesName = content.objectName;
            entity.startTime = [content.startTime longLongValue];
            entity.endTime = [content.endTime longLongValue];
            entity.setNumber = content.seriesNumber;
            detailVC.programId = content.lastProgramId;
            detailVC.watchEntity = entity;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    else if ([content.businessType isEqualToString:@"vod"]){
        // 点播
        self.hidesBottomBarWhenPushed = YES;
        SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
        detailVC.videoID = content.objectId;
        
        WatchListEntity *entity = [[WatchListEntity alloc]init];
        entity.setNumber = content.seriesNumber;

        detailVC.watchEntity = entity;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    else if ([content.businessType isEqualToString:@"livereplay"]){
        // 直播
        self.hidesBottomBarWhenPushed = YES;
        
        SJMultiVideoDetailViewController *detailVC ;
        if ([content.playType isEqualToString:@"replay"]) {
            detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeReplay];
        }
        else{
            detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeLive];
        }
        
        WatchListEntity *watchEntity = [[WatchListEntity alloc]init];
        watchEntity.contentId = content.lastProgramId;
        if ([content.playType isEqualToString:@"vod"]) {
            watchEntity.programSeriesId = content.objectId;
        }
        else{
            watchEntity.channelUuid = content.objectId;
        }
        watchEntity.startTime = [content.startTime longLongValue];
        watchEntity.endTime = [content.endTime longLongValue];
        //watchEntity.categoryId = content.objectId;
        watchEntity.programSeriesName = content.lastProgramName;
        watchEntity.deviceType = content.deviceType;

        detailVC.watchEntity = watchEntity;
        // detailVC.videoDatePoint = content.endWatchTime.floatValue;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
-(UIView *)seperateView:(UIView *)sender{
    UIView *view =  [[UIView alloc] initWithFrame:CGRectMake(0, sender.frame.size.height-0.5,W, 0.5)];
    view.backgroundColor = [UIColor colorWithRed:71/255.0 green:92/255.0 blue:122/255.0 alpha:1];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNumber =self.IsSearch?self.searchResultArray.count:self.friendsList.count;
    //if (rowNumber==0) {
    //    [tableView setBackgroundView:[UIView Friend_EmptyDefaultView]];
    //}else{
        [tableView setBackgroundView:nil];
    //}
    return rowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyFriendsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MyFriendsCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.m_delegate = self;
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryView = nil;
    //[cell addSubview:[self seperateView:cell]];

    NSInteger row = indexPath.row;
    UserEntity *entity = nil;
    if (self.IsSearch) {
        if (self.searchResultArray.count>row) {
            entity = self.searchResultArray[row];
        }
    }
    else{
        if (self.friendsList.count>row) {
            entity = self.friendsList[row];
        }
    }
    [cell.headImg setImageWithURL:[NSURL URLWithString:entity.faceImg] placeholderImage:[UIImage imageNamed:DEFAULTHEADICON]];
    if (entity.nickName==nil ||[entity.nickName isEqualToString:@""]) {
        cell.nameLab.text = entity.name;
    }
    else{
        cell.nameLab.text = entity.nickName;
    }
    cell.videoLab.text = entity.programName;
    if (entity.programName==nil || [entity.programName isEqualToString:@""]) {
        cell.wlogo.hidden = YES;
        cell.aimBtn.hidden = YES;
    }
    else {
        cell.wlogo.hidden = NO;
        if ([entity.watchingEntity.deviceType isEqualToString:@"MOBILE"]) {
            cell.aimBtn.hidden = NO;
            [cell.wlogo setImage:[UIImage imageNamed:@"sjwk"]];
        }else{
            cell.aimBtn.hidden = YES;
            [cell.wlogo setImage:[UIImage imageNamed:@"dsgk"]];
        }
    }
    cell.videocallBtn.hidden = YES;
    cell.userEntity = entity;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   /* NSInteger row = indexPath.row;
    UserEntity *entity = nil;
    if (self.IsSearch) {
        entity = self.searchResultArray[row];
    }
    else{
        entity = self.friendsList[row];
    }
    self.hidesBottomBarWhenPushed = YES;
    FriendInfoController *friendInfoVC= [[FriendInfoController alloc] initWithNibName:@"FriendInfoController" bundle:nil];
    friendInfoVC.userEntity = entity;
    [self.navigationController pushViewController:friendInfoVC animated:YES];*/
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
