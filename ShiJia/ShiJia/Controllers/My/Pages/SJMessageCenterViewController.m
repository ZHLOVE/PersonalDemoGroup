//
//  SJMessageCenterViewController.m
//  ShiJia
//
//  Created by yy on 16/3/14.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJMessageCenterViewController.h"

#import "SJMessageCenterCell.h"
#import "SJDeleteView.h"
#import "TPMessageCenterDataModel.h"

#import "SJMessageDetailViewController.h"
#import "TPIMNodeModel.h"
//#import "TPXmppRoomManager.h"
#import "TPIMUser.h"

//static const CGFloat MJDuration = 2.0;

@interface SJMessageCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL firstLoad;
    NSInteger currentPage;
    UIButton* rightBt;
    
}

@property (nonatomic, strong) UITableView        *table;
//@property (nonatomic, strong) ASTableView        *tableView;
@property (nonatomic, strong) TRTopNavgationView *naviView;
@property (nonatomic, assign) BOOL               isEditing;
//@property (nonatomic, strong) SJDeleteView       *bottomView;
@property (nonatomic, strong) UIButton           *bottomButton;
@property (nonatomic, strong) NSMutableArray     *removedItems;
@property (nonatomic, strong) NSMutableArray     *items;
@property (nonatomic, strong) NSMutableArray     *removedIndexPathArray;

@property (nonatomic, strong) UIView             *noDataView;
@property (nonatomic, assign) BOOL isDeleting;

@end

@implementation SJMessageCenterViewController

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {

        currentPage = 1;
        
        _items = [[NSMutableArray alloc] init];
        _removedItems = [[NSMutableArray alloc] init];
        _removedIndexPathArray = [[NSMutableArray alloc] init];
          [self getFriends];
        // table view
        _table = [[UITableView alloc] init];
        _table.backgroundColor = [UIColor clearColor];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        [self.table registerNib:[UINib nibWithNibName:kSJMessageCenterCellIdentifier bundle:nil] forCellReuseIdentifier:kSJMessageCenterCellIdentifier];

        __weak __typeof(self)weakSelf = self;
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            currentPage = 1;

            [strongSelf downloadMessageList];
            
        }];


        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.backgroundColor = [UIColor whiteColor];
        [_bottomButton addTarget:self action:@selector(botttomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bottomButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [_bottomButton setTitle:@"全部清空" forState:UIControlStateNormal];
        
       /* [[UINavigationBar appearance]  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];*/
        
    }
    
    return self;
}

//FIXME: 目前方案： 刷新全部状态
//TODO:  点击某条消息 刷新当前点击消息的状态

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    // 马上进入刷新状态
   //[_table.mj_header beginRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorLightGrayBackground;
    
    // add subview
   // [self initNavigationView];
    self.title = @"消息";
    
    UIBarButtonItem *managerItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteClick)];
    self.navigationItem.rightBarButtonItem = managerItem;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    
    [self.view addSubview:_table];
    //[self.view addSubview:_bottomView];
    [self.view addSubview:_bottomButton];
    
    //[_table.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:TPIMNotification_ReceiveMessages object:nil];
    
    [_table.mj_header beginRefreshing];

    //[self getFriends];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    
    if (self.isDeleting) {
        
        _table.frame = CGRectMake(0,
                                  _naviView.frame.size.height,
                                  self.view.frame.size.width,
                                  self.view.frame.size.height - _naviView.frame.size.height - kSJDeleteViewHeight);
        _bottomButton.frame = CGRectMake(0,
                                         _table.frame.origin.y + _table.frame.size.height,
                                         self.view.frame.size.width,
                                         kSJDeleteViewHeight);
//        _bottomView.frame = CGRectMake(0,
//                                       _table.frame.origin.y + _table.frame.size.height,
//                                       self.view.frame.size.width,
//                                       kSJDeleteViewHeight);
        
    }
    else{
        _table.frame = CGRectMake(0,
                                  _naviView.frame.size.height,
                                  self.view.frame.size.width,
                                  self.view.frame.size.height - _naviView.frame.size.height);
        _bottomButton.frame = CGRectMake(0,
                                         self.view.frame.size.height,
                                         self.view.frame.size.width,
                                         kSJDeleteViewHeight);
//        _bottomView.frame = CGRectMake(0,
//                                       self.view.frame.size.height,
//                                       self.view.frame.size.width,
//                                       kSJDeleteViewHeight);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)deleteClick{
    self.isDeleting = !self.isDeleting;
    
    if (self.isDeleting) {
        [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
    }
    else{
        [self.navigationItem.rightBarButtonItem setTitle:@"删除"];
    }
    self.table.mj_footer.hidden = YES;
    [self.table reloadData];
    [self.view setNeedsLayout];
}
#pragma mark - ASTableViewDataSource, ASTableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_items.count==0) {
        [self addOrRemoveNoDataView];
    }else{
        [_noDataView removeFromSuperview];
    }
    
    return _items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SJMessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:kSJMessageCenterCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:kSJMessageCenterCellIdentifier owner:self options:nil] lastObject];
    }
    
    TPMessageCenterDataModel *item = _items[indexPath.row];
    [cell showMessage:item];
    cell.isDeleting = self.isDeleting;
    
    [cell setDeleteButtonClicked:^(SJMessageCenterCell *sender) {
        NSIndexPath *path = [tableView indexPathForCell:sender];
        TPMessageCenterDataModel *model = self.items[path.row];
        if (![self.removedItems containsObject:model]) {
            [self.removedItems addObject:model];
            [self.removedIndexPathArray addObject:path];
        }
        [self deleteMessages];
    }];
    
    /*
    if (_table.isEditing) {
        if ([_removedItems containsObject:item]) {
            cell.checked = YES;
        }
        else{
            cell.checked = NO;
        }
    }
   
    @weakify(cell);
    [cell setCheckButtonClicked:^(BOOL isChecked) {
    
        @strongify(cell);
        
        
        NSIndexPath *indexpath = [tableView indexPathForCell:cell];
        TPMessageCenterDataModel *model = _items[indexpath.row];
        
        if (isChecked) {
            
            if (![_removedItems containsObject:model]) {
                [_removedItems addObject:model];
                [_removedIndexPathArray addObject:indexpath];
            }
        }
        else{
            if ([_removedItems containsObject:model]) {
                [_removedItems removeObject:model];
                [_removedIndexPathArray removeObject:indexpath];
            }
            
        }
        
        
        if (_removedItems.count > 0) {
            
            if (_removedItems.count == _items.count) {
                _bottomView.isSelectedAll = YES;
            }
            else{
                _bottomView.isSelectedAll = NO;
            }
            _bottomView.isDeleteEnabled = YES;
            
        }
        else{
            
            _bottomView.isDeleteEnabled = NO;
            _bottomView.isSelectedAll = NO;
        }
            

    }];
     */

    return cell;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (tableView.isEditing) {
//        SJMessageCenterCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        cell.checked = !cell.checked;
//        
//        if (cell.checkButtonClicked) {
//            cell.checkButtonClicked(cell.checked);
//        }
//    }
//    else{
        self.hidesBottomBarWhenPushed = YES;
        TPMessageCenterDataModel *model = _items[indexPath.row];
        
        model.read = YES;
        
        [_items replaceObjectAtIndex:indexPath.row withObject:model];
        
        SJMessageDetailViewController *detailVC = [[SJMessageDetailViewController alloc] init];
        detailVC.msgId = model.msgId;
        detailVC.msgModel = model;
        [self.navigationController pushViewController:detailVC animated:YES];
        [self.table reloadData];
//    }
    
}

#pragma mark - Event
- (void)botttomButtonClicked:(id)sender
{
    _removedItems = [NSMutableArray arrayWithArray:_items];
    for (int i = 0; i < _items.count; i++) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
        [_removedIndexPathArray addObject:indexpath];
    }
    
    [self deleteMessages];
}

#pragma mark - Data
- (void)refreshData:(NSNotification *)sender
{
    // 马上进入刷新状态
    [_table.mj_header beginRefreshing];
}

- (void)downloadMessageList
{
    if (![HiTVGlobals sharedInstance].isLogin) {
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:[NSString stringWithFormat:@"%zd",currentPage] forKey:@"start"];
    [parameters setValue:@"10" forKey:@"num"];
    [parameters setValue:@"PHONE" forKey:@"deviceType"];

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //获取消息列表
    [BaseAFHTTPManager getRequestOperationForHost:MSGCENTERHOST forParam:@"/message/msgHistory" forParameters:parameters completion:^(id responseObject) {
       
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //隐藏HUD
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        
        //如果是下拉刷新，删除之前的所有数据
        if (currentPage == 1) {
            [strongSelf.items removeAllObjects];
            [strongSelf.removedItems removeAllObjects];
            [strongSelf.removedIndexPathArray removeAllObjects];
        }
       
       /* if (![responseObject isKindOfClass:[NSArray class]]) {
            [strongSelf.table.mj_header endRefreshing];
            rightBt.hidden = YES;
           
            return;
        }*/
        //数据解析
        NSArray *msglist = (NSArray *)responseObject[@"msgList"];
        for (NSDictionary *dic in msglist) {
            
            TPMessageCenterDataModel *data = [[TPMessageCenterDataModel alloc] initWithDictionary:dic];
            NSString *jid = data.from.jid;
            if (jid.length == 0) {
                jid = [TPIMUser jidString:data.from.uid];;
            }
//            data.faceImg = [[TPXmppRoomManager defaultManager] getHeadImageWithJid:jid];
            //data.faceImgUrl = [TPIMUser getAvatarImageUrlWithUsername:jid];
            if(data.faceImgUrl.length == 0){
                for (UserEntity *userEntity in [HiTVGlobals sharedInstance].friendsArray) {
                    if ([userEntity.uid intValue] == [data.from.uid intValue]) {
                        data.faceImgUrl = userEntity.faceImg;
                        break;
                    }
                }
            }
            [strongSelf.items addObject:data];
        }
        
        //根据数据显示/隐藏上拉加载更多
        if (msglist.count < 10) {
            //数据少于10条隐藏上拉加载更多
            [strongSelf.table.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            //数据==10条显示上拉加载更多
            currentPage ++;
            if (strongSelf.table.mj_footer == nil) {
                strongSelf.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:strongSelf refreshingAction:@selector(downloadMessageList)];
            }
            [strongSelf.table.mj_footer endRefreshing];
        }
        
        if (strongSelf.items.count > 0) {
            rightBt.hidden = NO;
        }
        else{
            rightBt.hidden = YES;
        }
        
        //刷新数据
        [strongSelf.table.mj_header endRefreshing];
        [strongSelf.table reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        [strongSelf.table.mj_header endRefreshing];
        [strongSelf.table.mj_footer endRefreshing];
    }];
    
}
-(void)getFriends{

        NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
        [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];

        [BaseAFHTTPManager postRequestOperationForHost:SOCIALHOST
                                              forParam:@"/taipan/getUserFriendList"
                                         forParameters:parameters
                                            completion:^(id responseObject) {
                                                NSDictionary *resultDic = (NSDictionary *)responseObject;
                                                if ([[resultDic objectForKey:@"code"] intValue] == 0) {
                                                    NSMutableArray *resultArray = [NSMutableArray array];

                                                    NSArray *usersArray = [resultDic objectForKey:@"users"];

                                                    for (NSMutableDictionary *userDic in usersArray) {
                                                        UserEntity *entity = [[UserEntity alloc]initWithDictionary:userDic];

                                                        [resultArray addObject:entity];
                                                    }

                                                    [HiTVGlobals sharedInstance].friendsArray = resultArray;
                                                }
                                                DDLogInfo(@"suc");
                                            }failure:^(NSString *error) {

                                                DDLogInfo(@"fail");

                                            }];


}
- (void)deleteMessages
{
    
    //for (TPMessageCenterDataModel *data in self.removedItems) {
       
        NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
        [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    
        if (self.removedItems.count > 1) {
            [parameters setValue:@"all" forKey:@"msgId"];
        }
        else{
            
            TPMessageCenterDataModel *data = [self.removedItems firstObject];
            [parameters setValue:data.msgId forKey:@"msgId"];
        }
    
        __weak __typeof(self)weakSelf = self;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        //删除消息
        [BaseAFHTTPManager getRequestOperationForHost:MSGCENTERHOST forParam:@"/message/delete" forParameters:parameters completion:^(id responseObject) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
            
            if (_removedIndexPathArray.count != 0) {
                
                [_items removeObjectsInArray:_removedItems];
                [_table beginUpdates];
                [_table deleteRowsAtIndexPaths:_removedIndexPathArray withRowAnimation:UITableViewRowAnimationFade];
                [_table endUpdates];
                [_removedItems removeAllObjects];
                [_removedIndexPathArray removeAllObjects];
//                _bottomView.isDeleteEnabled = NO;
//                _bottomView.isSelectedAll = NO;
            }
            
            if (_items.count == 0) {
                //self->rightBt.hidden=YES;
                //_table.mj_footer.hidden = YES;
                //[self->rightBt setTitle:@"删除" forState:UIControlStateNormal];
                //[self.table setEditing:NO animated:YES];
                //self.isDeleting = NO;
                //[self.view setNeedsLayout];
                // 马上进入刷新状态
                [_table.mj_header beginRefreshing];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        }];
    //}
}

#pragma mark - Subview
- (void)initNavigationView
{
    _naviView = [TRTopNavgationView navgationView];
    [self.view addSubview:_naviView];
    
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
    UILabel* lbl = [UIHelper createTitleLabel:@"消息"];
    lbl.textColor = kNavTitleColor;
    [_naviView setTitleView:lbl];
    
    // delete button
    rightBt = [UIHelper createRightButtonWithTitle:@"删除"];
    [rightBt setTitleColor:kNavTitleColor forState:UIControlStateNormal];
   
    [[rightBt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
      
        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        self.table.allowsSelectionDuringEditing = YES;
//        [self.table setEditing:!self.table.editing animated:YES];
        strongSelf.isDeleting = !strongSelf.isDeleting;
        
        if (strongSelf.isDeleting) {
            [strongSelf->rightBt setTitle:@"取消" forState:UIControlStateNormal];
        }
        else{
           [strongSelf->rightBt setTitle:@"删除" forState:UIControlStateNormal];
        }
        strongSelf.table.mj_footer.hidden = YES;
        [strongSelf.table reloadData];
        [strongSelf.view setNeedsLayout];
    }];

    [_naviView setHorizLIneFrame:CGRectZero];
    _naviView.backgroundColor =[UIColor whiteColor];
    rightBt.hidden = YES;
    [_naviView setRightView:rightBt];

}

#pragma mark NOData View
-(UIView *)noDataView{

    if (!_noDataView) {
        _noDataView = [UIView new];
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_msgnotify_noresult"]];
        [_noDataView addSubview:imageV];


        UILabel *label =[UILabel new];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = 1;
        label.text = @"你还没有收到任何消息";
        [_noDataView addSubview:label];
        
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_noDataView);
            make.size.mas_equalTo(CGSizeMake(85, 85));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_noDataView);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(imageV.mas_bottom).offset(10);
        }];
        
        
    }
    return _noDataView;
}

- (void)addOrRemoveNoDataView{

        
        [self.table addSubview:self.noDataView];
        [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.table);
            make.size.mas_equalTo(CGSizeMake(200, 120));
            make.top.mas_equalTo(self.table).offset(150);
        }];
}

@end
