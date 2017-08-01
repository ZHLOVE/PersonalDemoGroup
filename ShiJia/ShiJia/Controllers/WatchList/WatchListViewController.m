//
//  WatchListViewController.m
//  ShiJia
//
//  Created by 蒋海量 on 2017/3/13.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "WatchListViewController.h"
#import "YFViewPager.h"
#import "MyListView.h"
#import "SJLoginViewController.h"
#import "BIMSManager.h"
#import "MJRefresh.h"
#import "WatchListEntity.h"

#import "SJMultiVideoDetailViewController.h"
#import "SJRemoteControlViewController.h"
#import "SJSetFavoriteViewController.h"
#import "JRWaterFallLayout.h"
#import "SJLightViewController.h"
#import "UITabBar+badge.h"
#import "RecommendView.h"
#import "FriendsWatchView.h"
#import "SearchViewController.h"

@interface WatchListViewController ()<MyListViewDelegate,RecommendViewDelegate,FriendsWatchViewDelegate>
@property (nonatomic, strong) TRTopNavgationView *naviView;

@property (nonatomic, strong) YFViewPager *pageVC;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) MyListView *myListView;
@property (nonatomic, strong) RecommendView *recommendView;
@property (nonatomic, strong) FriendsWatchView *friendsWatchView;
    
@property (strong, nonatomic) IBOutlet UILabel *loginTipLab;

@end

@implementation WatchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.tabBar.translucent=NO;

    self.view.backgroundColor = klightGrayColor;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_refreshAfterUserLogin)
                                                 name:TPIMNotification_ReloadUser
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_refreshAfterUserInterested)
                                                 name:TPIMNotification_UserInterested
                                               object:nil];
    
    [self initUI];
    
}
-(void)initUI{
    [self initNavigationView];
    
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(self.view);
    }];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.backgroundColor = [UIColor clearColor];
    searchBtn.frame = CGRectMake(_naviView.frame.size.width-50, 24, 40, 40);
    [searchBtn setImage:[ UIImage imageNamed : @"searchicon" ] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(goSearchVC) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:searchBtn];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = NO;
    self.navigationController.navigationBarHidden = YES;
   // [self isHavePersonalResultRequest];

    if ([HiTVGlobals sharedInstance].isLogin) {
       // _titleLab.text = [NSString stringWithFormat:@"亲爱的\"%@\"",[HiTVGlobals sharedInstance].nickName];
    }else{
        [HiTVGlobals sharedInstance].nickName = @"游客";
    }
    [AppDelegate appDelegate].appdelegateService.coinView.hidden = NO;
    
}
- (void)p_refreshAfterUserLogin {
    //获取未读消息
    [self getMessageNumberRequest];
    
}
- (void)p_refreshAfterUserInterested {
    [self.myListView p_reloadData];
}
-(void)goSearchVC
{
    self.hidesBottomBarWhenPushed = YES;
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
#pragma mark - Subview
- (void)initNavigationView
{
        _naviView = [TRTopNavgationView navgationView];
        _naviView.userInteractionEnabled = YES;
        [self.view addSubview:_naviView];
        _naviView.backgroundColor = kNavgationBarColor;
        
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
        
        // title
        UILabel* lbl = [UIHelper createTitleLabel:self.title];
        lbl.textColor = kNavTitleColor;
        [_naviView setTitleView:lbl];
        
        
    }
-(MyListView *)myListView{
    if (!_myListView) {
        _myListView = [[MyListView alloc]initWithFrame:CGRectMake(0, 0, W, H)];
        _myListView.m_delegate = self;
    }
    return _myListView;
}
-(RecommendView *)recommendView{
    if (!_recommendView) {
        _recommendView = [[RecommendView alloc]initWithFrame:CGRectMake(0, 0, W, H)];
        _recommendView.m_delegate = self;
    }
    return _recommendView;
}
-(FriendsWatchView *)friendsWatchView{
    if (!_friendsWatchView) {
        _friendsWatchView = [[FriendsWatchView alloc]initWithFrame:CGRectMake(0, 0, W, H)];
        _friendsWatchView.m_delegate = self;
    }
    return _friendsWatchView;
}
-(UIView *)topView{
    if (!_topView) {
        _topView = [UIView new];
        _pageVC = [[YFViewPager alloc] initWithFrame:CGRectMake(0, 25, SCREEN_WIDTH, SCREEN_HEIGHT-64)
                                              titles:@[@"今日看单",@"猜你想看",@"大家在看"]
                                               icons:nil
                                       selectedIcons:nil
                                               views:@[self.myListView,self.recommendView,self.friendsWatchView]];
        _pageVC.viewTag = @"MyListView";
        _pageVC.backgroundColor = [UIColor blackColor];
#ifdef BeiJing
        _pageVC.tabSelectedArrowBgColor = [UIColor clearColor];
        _pageVC.tabSelectedTitleColor = [UIColor whiteColor];
        _pageVC.tabTitleColor = [UIColor lightGrayColor];
#else
        _pageVC.tabSelectedArrowBgColor = kColorBlueTheme;
        _pageVC.tabSelectedTitleColor = kColorBlueTheme;
        _pageVC.tabTitleColor = [UIColor blackColor];
#endif

        _pageVC.tabArrowBgColor = RGB(229, 229, 229, 1);
        _pageVC.showVLine = NO;
        _pageVC.showBottomLine = NO;
        _pageVC.backgroundColor = [UIColor clearColor];
        
        //        _topView.backgroundColor= [UIColor clearColor];
        [_topView addSubview:_pageVC];
        
        [_pageVC didSelectedBlock:^(id viewPager, NSInteger index) {
            
            switch (index) {
                case 0:
                    [UMengManager event:@"U_Today"];
                    break;
                case 1:
                    [UMengManager event:@"U_Guess"];
                    break;
                    
                case 2:
                    [UMengManager event:@"U_Around"];
                    break;
                default:
                    break;
            }
            
        }];
    }
    return _topView;
}

-(UILabel *)loginTipLab{
    if (!_loginTipLab) {
        _loginTipLab = [[UILabel alloc]init];
        _loginTipLab.backgroundColor = [UIColor clearColor];
       // _loginTipLab.textColor = [UIColor lightGrayColor];
        _loginTipLab.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:_loginTipLab];
        [_loginTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(220, 50));
        }];
        NSString *str = @"登录才能看到你的个性节目单哦！";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
        [attr addAttribute:NSForegroundColorAttributeName value:kColorBlueTheme range:NSMakeRange(0,2)];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(2,str.length-2)];
        _loginTipLab.attributedText = attr;
        _loginTipLab.userInteractionEnabled = YES;
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.backgroundColor = [UIColor clearColor];
        loginBtn.frame = CGRectMake(0, 0, 40, _loginTipLab.frame.size.height);
        [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        [_loginTipLab addSubview:loginBtn];
    }
    return _loginTipLab;
}
-(IBAction)login:(id)sender{
    SJLoginViewController *sjVC = [[SJLoginViewController alloc]init];
    [self presentViewController:sjVC animated:YES completion:nil];
}
#pragma mark - View Delegate
-(void)goDetailVC:(WatchListEntity *)content{
    NSString* programseriestype = nil;
    if ([content.contentType isEqualToString:@"watchtv"]) {
        //看点页查详情
        self.hidesBottomBarWhenPushed = YES;
        SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
        detailVC.videoID = content.programSeriesId;
        [self.navigationController pushViewController:detailVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        programseriestype = @"看点";
    }
    else if ([content.contentType isEqualToString:@"vod"]){
        // 点播
        self.hidesBottomBarWhenPushed = YES;
        SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
        detailVC.videoID = content.programSeriesId;
        [self.navigationController pushViewController:detailVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        programseriestype = @"点播";
    }
    else if ([content.contentType isEqualToString:@"live"]){
        // 直播
        self.hidesBottomBarWhenPushed = YES;
        SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeLive];
        detailVC.watchEntity = content;
        [self.navigationController pushViewController:detailVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        programseriestype = @"直播";
    }
    else{
        
        // 回看
        self.hidesBottomBarWhenPushed = YES;
        SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeReplay];
        detailVC.watchEntity = content;
        [self.navigationController pushViewController:detailVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        programseriestype = @"回看";
    }
    
    NSString* listname = _pageVC.selectIndex == 0 ? @"今日看单" :  (_pageVC.selectIndex == 1? @"猜你想看":@"大家在看");
    
    NSString* str = [NSString stringWithFormat:@"listname=%@&programseriestype=%@&programseriesid=%@&programseriesname=%@", isNullString(listname),isNullString(programseriestype), isNullString(content.programSeriesId), isNullString(content.programSeriesName)];
    [Utils BDLog:1 module:@"605" action:@"ProgramListClick" content:str];
    
    
    
}
- (NSString*)p_currentUID {
    if ([HiTVGlobals sharedInstance].isLogin) {
        if (![HiTVGlobals sharedInstance].uid) {
            return @"";
        }
        return [HiTVGlobals sharedInstance].uid;
        
    }else{
        if (![HiTVGlobals sharedInstance].anonymousUid) {
            return @"";
        }
        return [HiTVGlobals sharedInstance].anonymousUid;
    }
}
-(void)goSJSetFavoriteViewController{
    /*SJSetFavoriteViewController * favoriteVC = [[SJSetFavoriteViewController alloc] init];
     [self.navigationController pushViewController:favoriteVC animated:YES];*/
    SJLightViewController * favoriteVC = [[SJLightViewController alloc] init];
   // [self.navigationController pushViewController:favoriteVC animated:YES];
    [self presentViewController:favoriteVC animated:YES completion:^{
    }];
}
-(void)showMainViewController{
    [AppDelegate appDelegate].appdelegateService.SetF = YES;
    [[AppDelegate appDelegate].appdelegateService showMainViewController];
}
#pragma mark -  Request
- (void)isHavePersonalResultRequest
{
        
        __weak __typeof(self)weakSelf = self;
        NSDictionary *param = @{
                                @"userId" : [self p_currentUID],
                                //@"tvTemplateId" : WATCHTVGROUPID,
                                //@"vodTemplateId" : [[HiTVGlobals sharedInstance]getEpg_groupId],
                                @"abilityString" :  T_STBext,
                                };
        NSString* url = [NSString stringWithFormat:@"%@personal/isHavePersonalResult",
                         MYEPG];
        
        DDLogInfo(@"url: %@", url);
        //    [HUD showAnimated:YES];
        [MBProgressHUD showMessag:nil toView:self.view];
        [BaseAFHTTPManager getRequestOperationForHost:url forParam:@"" forParameters:param completion:^(id responseObject) {
            //        [HUD hideAnimated:YES];
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
            if (!strongSelf) {
                return;
            }
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            if ([[resultDic objectForKey:@"code"] intValue] == 0) {
                if ([[resultDic objectForKey:@"isHave"] intValue] == 1) {
                }
                else{
                    [strongSelf goSJSetFavoriteViewController];
                }
            }
            else{
                //[strongSelf goSJSetFavoriteViewController];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
            
            if (!strongSelf) {
                return;
            }
        }];
}
    //获取未读消息条数
- (void)getMessageNumberRequest{
    if (![HiTVGlobals sharedInstance].isLogin) {
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:@"0" forKey:@"readed"];
    
    //获取消息列表
    [BaseAFHTTPManager getRequestOperationForHost:MSGCENTERHOST forParam:@"/message/msgCnt" forParameters:parameters completion:^(id responseObject) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *cnt = [responseObject objectForKey:@"cnt"];
            if ([cnt integerValue] > 0) {
                //显示
                [strongSelf.tabBarController.tabBar showBadgeOnItemIndex:3];
                
            }
            else{
                //隐藏
                [strongSelf.tabBarController.tabBar hideBadgeOnItemIndex:3];
            }
        }
        else{
            [strongSelf.tabBarController.tabBar hideBadgeOnItemIndex:3];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.tabBarController.tabBar hideBadgeOnItemIndex:3];
        
    }];
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
