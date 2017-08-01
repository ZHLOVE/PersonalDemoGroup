//
//  MainViewController.m
//  ShiJia
//
//  Created by 蒋海量 on 2017/2/16.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "MainViewController.h"
#import "IndexViewController.h"
#import "ChannelUnitModel.h"
#import "TagManagerViewController.h"
#import "HomePageViewController.h"
#import "DmsDataPovider.h"
#import "ChannelViewController.h"
#import "HomeCallBackDelegate.h"
#import "VideoCategory.h"
#import "VideoCategoryDetailViewController.h"
#import "HomeJumpWebViewController.h"
#import "SJMultiVideoDetailViewController.h"
#import "SearchViewController.h"
#import "ChooseCategoryViewController.h"
#import "HotspotViewController.h"
#import "SJResumeVideoViewModel.h"

@interface MainViewController ()<LPPageVCDataSource,LPPageVCDelegate,MainDelegate>
@property (nonatomic, copy) NSMutableArray *channelsArray; // 服务器数据源数组
@property (nonatomic, copy) NSMutableArray *topsArray; // 真实显示的数据源数组

@property (nonatomic, strong) ChannelUnitModel *currentChannelModel;      //记录当前tab页内容
//@property (nonatomic, strong) HomePageViewController *homePageVC;
@property (nonatomic, strong) HotspotViewController *hotSpotVC;
@property (strong, nonatomic)  UIView *defaultView;
@property (strong, nonatomic)  UIImageView *helpView;
@property (nonatomic, assign)  NSInteger hotSpotIndex;//有料索引
@property (nonatomic, assign)  BOOL hasHotSpot;//菜单栏是否包含有料
@property (nonatomic, strong)  SJResumeVideoViewModel *resumeViewModel;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidden) name:@"hidden" object:nil];
    // Do any additional setup after loading the view from its nib.

    [self initUI];

    [self loadNavigationsRequest];

    //[self doServerData];

    [[AppDelegate appDelegate].appdelegateService loadRemoteLogo];
    [[AppDelegate appDelegate].appdelegateService setIsMainVCLoaded:YES];
    [self initHelpView];
//    _resumeViewModel = [[SJResumeVideoViewModel alloc] init];
//    [_resumeViewModel start];
}

- (void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    if (_helpView) {
        [_helpView removeFromSuperview];
    }
}
-(void)hidden{
    self.hidesBottomBarWhenPushed = YES;
}
-(void)initUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.tabBar.translucent=NO;
    // self.title = @"首页";
    self.view.backgroundColor = klightGrayColor;

    NSString *mainsearch = @"mainsearch";

    UIImage *searchImg = [UIImage imageNamed : mainsearch];
    UIImage *chooseImg = [UIImage imageNamed : @"shaixuan"];

    UIButton *centerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
    [centerBtn setImage:searchImg forState:UIControlStateNormal];
    [centerBtn addTarget:self action:@selector(goSearchVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithCustomView:centerBtn];
    
   // UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[searchImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goSearchVC)];

    UIBarButtonItem *chooseItem = [[UIBarButtonItem alloc]initWithImage:[chooseImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(chooseView)];
    self.navigationItem.rightBarButtonItems = @[chooseItem];


    UIBarButtonItem *spacerZero = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacerZero.width = (W-searchImg.size.width-chooseImg.size.width)/2;


    self.navigationItem.leftBarButtonItems = @[spacerZero,searchItem];


    self.delegate = self;
    self.dataSource = self;

    // 设置样式 - 两种样式
    self.segmentStyle = LPPageVCSegmentStyleLineHighlight;

    self.normalTextColor = [UIColor blackColor];
    self.higlightTextColor = kColorBlueTheme;
    self.lineBackground = kColorBlueTheme;

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = NO;
    self.showRemote = YES;
}
-(void)chooseView{

    ChooseCategoryViewController *chooseViewController = [[ChooseCategoryViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chooseViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)goSearchVC
{
    self.hidesBottomBarWhenPushed = YES;
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}
-(NSMutableArray *)channelsArray{
    if (!_channelsArray) {
        _channelsArray = [NSMutableArray array];
    }
    return _channelsArray;
}
-(NSMutableArray *)topsArray{
    if (!_topsArray) {
        _topsArray = [NSMutableArray array];
    }
    return _topsArray;
}

#pragma mark - 制作服务器假数据
-(void)doServerData{

    ChannelUnitModel *channelModel1 = [[ChannelUnitModel alloc] init];
    channelModel1.navigateId = @"111";
    channelModel1.name = @"精选";
    channelModel1.icon = @"精选";
    channelModel1.editAble = @"1";
    channelModel1.isTop = YES;
    [self.channelsArray addObject:channelModel1];


    ChannelUnitModel *channelModel2 = [[ChannelUnitModel alloc] init];
    channelModel2.navigateId = @"112";
    channelModel2.name = @"电影";
    channelModel2.icon = @"电影";
    channelModel2.editAble = @"1";
    channelModel2.isTop = YES;
    [self.channelsArray addObject:channelModel2];

    ChannelUnitModel *channelModel3 = [[ChannelUnitModel alloc] init];
    channelModel3.navigateId = @"113";
    channelModel3.name = @"电视剧";
    channelModel3.icon = @"电视剧";
    channelModel3.editAble = @"1";
    channelModel3.isTop = YES;
    [self.channelsArray addObject:channelModel3];

    ChannelUnitModel *channelModel4 = [[ChannelUnitModel alloc] init];
    channelModel4.navigateId = @"114";
    channelModel4.name = @"记录片";
    channelModel4.icon = @"纪录片";
    channelModel4.editAble = @"1";
    channelModel4.isTop = YES;
    [self.channelsArray addObject:channelModel4];

    ChannelUnitModel *channelModel5 = [[ChannelUnitModel alloc] init];
    channelModel5.navigateId = @"115";
    channelModel5.name = @"综艺";
    channelModel5.icon = @"综艺";
    channelModel5.editAble = @"1";
    channelModel5.isTop = YES;
    [self.channelsArray addObject:channelModel5];

    ChannelUnitModel *channelModel6 = [[ChannelUnitModel alloc] init];
    channelModel6.navigateId = @"116";
    channelModel6.name = @"少儿";
    channelModel6.icon = @"少儿";
    channelModel6.editAble = @"1";
    channelModel6.isTop = YES;
    [self.channelsArray addObject:channelModel6];

    ChannelUnitModel *channelModel7 = [[ChannelUnitModel alloc] init];
    channelModel7.navigateId = @"117";
    channelModel7.name = @"体育";
    channelModel7.icon = @"体育";
    channelModel7.editAble = @"1";
    channelModel7.isTop = YES;
    [self.channelsArray addObject:channelModel7];


    ChannelUnitModel *channelModel8 = [[ChannelUnitModel alloc] init];
    channelModel8.navigateId = @"118";
    channelModel8.name = @"新闻";
    channelModel8.icon = @"新闻";
    channelModel8.editAble = @"1";
    channelModel8.isTop = YES;
    [self.channelsArray addObject:channelModel8];

    ChannelUnitModel *channelModel9 = [[ChannelUnitModel alloc] init];
    channelModel9.navigateId = @"119";
    channelModel9.name = @"生活";
    channelModel9.icon = @"生活";
    channelModel9.editAble = @"1";
    channelModel9.isTop = YES;
    [self.channelsArray addObject:channelModel9];

    [self p_reloadTopMenus];

}
-(NSMutableArray *)setTopChannelArr{
    
    NSMutableArray *channelsArrayCopy = [self.channelsArray mutableCopy];
    
    //创建一个临时数组
    NSMutableArray *tempArray = [NSMutableArray array];

    //取出沙盒保存的头部分类
    NSMutableArray *topTags = [NSMutableArray array];
    [topTags addObjectsFromArray:[NSUserDefaultsManager getObjectForKey:NAV_TOPS]];
    
    //循环遍历找出实时数据【服务器下发的】中的沙盒数据，并加到临时数组中，目的是通过沙盒保存的数据进行排序和过滤

        for (NSDictionary *topsDic in topTags) {
            for (int i=0;i<channelsArrayCopy.count;i++) {
                ChannelUnitModel *topModel = channelsArrayCopy[i];
            if ([topModel.navigateId isEqualToString:topsDic[@"navigateId"]]) {
                [tempArray addObject:topModel];
                [channelsArrayCopy removeObject:topModel];
                i--;
            }
        }
    }
    
    //取出沙盒保存的底部隐藏分类
    NSMutableArray *bottonTags = [NSMutableArray array];
    [bottonTags addObjectsFromArray:[NSUserDefaultsManager getObjectForKey:NAV_BOTTONS]];
    
    //过滤底部隐藏的分类数据
    for (int i=0;i<channelsArrayCopy.count;i++) {
        ChannelUnitModel *bottonModel = channelsArrayCopy[i];
        for (NSDictionary *bottonDic in bottonTags) {
            if ([bottonModel.navigateId isEqualToString:bottonDic[@"navigateId"]]) {
                [channelsArrayCopy removeObject:bottonModel];
                i--;
            }
        }
    }
    
    //将剩下的实时数据加到排序后的临时数组中
    [tempArray addObjectsFromArray:channelsArrayCopy];
    
    return tempArray;
}
-(NSMutableArray *)setBottomChannelArr{
    NSMutableArray *tempArray = [NSMutableArray array];
    NSMutableArray *bottomChannelArr = [ChannelUnitModel mj_objectArrayWithKeyValuesArray:[NSUserDefaultsManager getObjectForKey:NAV_BOTTONS]];

        for (ChannelUnitModel *model in bottomChannelArr) {
            for (int i=0;i<self.channelsArray.count;i++) {
                ChannelUnitModel *bottomModel = self.channelsArray[i];
                if ([bottomModel.navigateId isEqualToString:model.navigateId]) {
                    [tempArray addObject:bottomModel];
                }
        }
    }
    return tempArray;
}

#pragma mark - 跳转都频道编辑页面
- (IBAction)goToTheChannelEdit {
    TagManagerViewController *tagVC = [[TagManagerViewController alloc] init];
    tagVC.topDataSource = [self setTopChannelArr];
    tagVC.bottomDataSource = [self setBottomChannelArr];

    //编辑后的回调
    WEAKSELF
    tagVC.removeInitialIndexBlock = ^(NSMutableArray *topArr, NSMutableArray *bottomArr){
        DDLogInfo(@"删除了初始选中项的回调:\n保留的频道有: %@", topArr);

        NSMutableArray *tops = [NSMutableArray array];
        for (ChannelUnitModel *model in topArr) {
            [tops addObject:model.mj_keyValues];
        }
        [NSUserDefaultsManager saveObject:tops forKey:NAV_TOPS];

        NSMutableArray *bottoms = [NSMutableArray array];
        for (ChannelUnitModel *model in bottomArr) {
            [bottoms addObject:model.mj_keyValues];
        }
        [NSUserDefaultsManager saveObject:bottoms forKey:NAV_BOTTONS];

        [weakSelf p_reloadTopMenus];

    };
    tagVC.chooseIndexBlock = ^(NSInteger index, NSMutableArray *topArr, NSMutableArray *bottomArr){
        //self.currentIndex = index;
        self.tabBarController.selectedIndex = 2;

    };

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tagVC];

    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 刷新当前导航页
-(void)p_reloadTopMenus{
    self.topsArray = [self setTopChannelArr];

    // 切记刷新界面数据

    [self reloadData];
    //    [self reloadDataAtIndex:0];
    if (self.currentChannelModel) {
        for (ChannelUnitModel *model in self.topsArray) {
            if ([model.navigateId isEqualToString:self.currentChannelModel.navigateId]) {
                self.currentIndex = [self.topsArray indexOfObject:model];
                break;
            }
        }
    }

}

#pragma mark - HZPageVcDataSource & Delegate
- (NSInteger)numberOfContentForPageVC:(LPPageVC *)pageVC {

    return self.topsArray.count;
}

- (NSString *)pageVC:(LPPageVC *)pageVC titleAtIndex:(NSInteger)index {
    ChannelUnitModel *channelModel = self.topsArray[index];
    channelModel.isLoaded = NO;
    return [NSString stringWithFormat:@"%@",channelModel.name];
}

- (UIViewController *)pageVC:(LPPageVC *)pageVC viewControllerAtIndex:(NSInteger)index {
    //有料 2017/5/10
    if (self.hasHotSpot && self.hotSpotIndex == index) {
        _hotSpotVC = [[HotspotViewController alloc] init];
        _hotSpotVC.parentController = self;
        _hotSpotVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        return _hotSpotVC;
    }
    else{
        HomePageViewController *_homePageVC = [[HomePageViewController alloc]init];
        _homePageVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        _homePageVC.delegate = self;
        return _homePageVC;
    }
    
    
}

- (void)pageVC:(LPPageVC *)pageVC didChangeToIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex {
    self.showRemote = YES;
    [self LoadCuttentIndexVCData:toIndex];
}

-(void)LoadCuttentIndexVCData:(NSInteger )index{
    if (index < self.topsArray.count) {
        //有料 2017/5/10
        if (self.hasHotSpot && self.hotSpotIndex == index) {
            //HotspotViewController *VC = (HotspotViewController *)[self viewControllerAtIndex:index];
            //[_hotSpotVC refreshData];
            
        }
        else{
            HomePageViewController *VC =(HomePageViewController *)[self viewControllerAtIndex:index];
            ChannelUnitModel *model = self.topsArray[index];
            if (!model.isLoaded) {
                model.isLoaded = YES;
                [VC setChanelModel:model];
            }
        }
        
    }
}

#pragma mark - 标题管理
- (void)pageVC:(LPPageVC *)pageVC didClickEditMode:(LPPageVCEditMode)mode {
    if (self.topsArray.count>0) {
        self.currentChannelModel = self.topsArray[self.currentIndex];
    }

    [self goToTheChannelEdit];

}

#pragma mark - Request
- (void)loadNavigationsRequest{
    WEAKSELF
    [DmsDataPovider getNavigationsRequestCompletion:^(NSArray *navigationArray) {
        weakSelf.defaultView.hidden = YES;
        if ([navigationArray isKindOfClass:[NSArray class]]) {
            for (NSDictionary *navDic in navigationArray) {
                ChannelUnitModel *model = [[ChannelUnitModel alloc]initWithDictionary:navDic];
                if ([model.actionType isEqualToString:@"hv"]) {
                    self.hotSpotIndex = [navigationArray indexOfObject:navDic];
                    self.hasHotSpot = YES;
                }
                [weakSelf.channelsArray addObject:model];
            }
            /*//有料 2017/5/10
            ChannelUnitModel *channelModel1 = [[ChannelUnitModel alloc] init];
            channelModel1.navigateId = @"111";
            channelModel1.name = @"你好";
            channelModel1.icon = @"有料";
            channelModel1.editAble = @"1";
            [weakSelf.channelsArray addObject:channelModel1];*/
            
            [self p_reloadTopMenus];
        }

    }failure:^(NSString *message){
        weakSelf.defaultView.hidden = NO;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)MainBricksCallBackWith:(homeModel *)model andContents:(contents *)contents andType:(NSInteger)type{
    if (type==1) {
        VideoCategory *video = [VideoCategory new];
        video.parentCatgId = contents.parentCategId;
        video.catgId = contents.categoryId;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[[VideoCategoryDetailViewController alloc] initWithVideoCategory:video] animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    }else{

        if ([contents.actionType isEqualToString:@"outter"]) {
            HomeJumpWebViewController *jumpVC = [[HomeJumpWebViewController alloc]init];
            if ([contents.title isEqualToString:@"生活缴费"]) {
                jumpVC.urlStr =[NSString stringWithFormat:@"%@?token=%@",contents.actionUrl,[HiTVGlobals sharedInstance].livingToken];
            }
            else{
                jumpVC.urlStr =contents.actionUrl;
            }
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:jumpVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        if ([contents.actionType isEqualToString:@"inner"]){
            SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
            detailVC.videoID = contents.programSeriesId;
            detailVC.categoryID = contents.programSeriesId;

            
            if ([self.topsArray[self.currentIndex] isKindOfClass:[ChannelUnitModel class]]) {
                ChannelUnitModel * model = self.topsArray[self.currentIndex] ;
                detailVC.epgName =  model.name;
            }
            
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            

                                            
            [self umengEvent:contents];
        }
    }
    
}
-(UIView *)defaultView{
    if (!_defaultView) {
        
        _defaultView = [UIView new];
        _defaultView.userInteractionEnabled = YES;
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nonetwork"]];
        [_defaultView addSubview:imageV];
        
        
        UILabel *label =[UILabel new];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = 1;
        label.font = [UIFont systemFontOfSize:14];
        NSString *str = @"网络连接失败,点击重试";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,8)];
        [attr addAttribute:NSForegroundColorAttributeName value:kColorBlueTheme range:NSMakeRange(9,2)];
        label.attributedText = attr;
        label.userInteractionEnabled = YES;
        [_defaultView addSubview:label];
        
        UIButton *retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        retryBtn.backgroundColor = [UIColor clearColor];
        [retryBtn addTarget:self action:@selector(loadNavigationsRequest) forControlEvents:UIControlEventTouchUpInside];
        [_defaultView addSubview:retryBtn];
        
        
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_defaultView);
            make.size.mas_equalTo(CGSizeMake(85, 85));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_defaultView);
            make.size.mas_equalTo(CGSizeMake(150, 50));
            make.top.mas_equalTo(imageV.mas_bottom).offset(10);
        }];
        
        [retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(label.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(40, 30));
            make.top.mas_equalTo(imageV.mas_bottom).offset(10);
        }];
        
        [self.view addSubview:_defaultView];
        [_defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(180, 180));
            make.top.mas_equalTo(self.view).offset(160);
        }];
    }
    
    return _defaultView;
}
#pragma mark - 友盟统计
-(void)umengEvent:(contents *)contents{
    ChannelUnitModel *model =  self.topsArray[self.currentIndex];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"常规视频" forKey:@"type_name"];
    [dic setValue:@"首页" forKey:@"first_nav"];
    [dic setValue:model.name forKey:@"sec_nav"];
    [dic setValue:contents.title forKey:@"program_name"];
    
    [UMengManager event:@"U_Play" attributes:dic];
}
#pragma mark - 首页遥控器泡泡浮层
- (BOOL)firstMain
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"main_help"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"main_help"];
        return YES;
    }
    else{
        return NO;
    }
}
-(void)initHelpView{
    if ([self firstMain]) {
        _helpView = [[UIImageView alloc]initWithFrame:[AppDelegate appDelegate].window.frame];
        _helpView.image = [UIImage imageNamed:@"remote_help.png"];
        _helpView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        
        [_helpView addGestureRecognizer:tapGr];
        [[AppDelegate appDelegate].window addSubview:_helpView];
    }
}
@end
