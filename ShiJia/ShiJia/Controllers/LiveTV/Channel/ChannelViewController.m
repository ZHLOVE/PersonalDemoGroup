//
//  ChannelViewController.m
//  HiTV
//
//  Created by 蒋海量 on 15/1/20.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "ChannelViewController.h"
#import "ProgramViewController.h"
#import "MJRefresh.h"

#import "SJMultiVideoDetailViewController.h"
#import "SJRemoteControlViewController.h"
#import "SearchViewController.h"

#define CHANNEL_TABVIEW    10001
#define PROGRAM_TABVIEW    10002

#define TabHeight 70
//#define RECENTWATCH @"RECENTWATCH"

@interface ChannelViewController ()<UINavigationControllerDelegate>
@property (assign, nonatomic) NSInteger beforeVisitIndex;
@property (strong, nonatomic)  UIView *defaultView;

@end

@implementation ChannelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.delegate = self;
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[[ UIImage imageNamed : @"searchicon" ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goSearchVC)];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    self.beforeVisitIndex = 0;
    self.channelTabView.layer.masksToBounds = YES;
    
    self.channelTabView.separatorColor = kTabLineColor;
    [self.channelTabView setSeparatorInset:UIEdgeInsetsZero];

    self.channelTabView.backgroundColor = klightGrayColor;
    
    [self setExtraCellLineHidden:self.channelTabView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:kPushLiveTVControllerNotification object:nil];

    [self loadData];

}
-(void)viewWillAppear:(BOOL)animated{
    [AppDelegate appDelegate].appdelegateService.coinView.hidden = NO;
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)goSearchVC
{
    self.hidesBottomBarWhenPushed = YES;
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
-(void)loadData
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[TVDataProvider sharedInstance] getTVListWithCompletion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];

        weakSelf.tvsArray = (NSArray*)responseObject;
        weakSelf.defaultView.hidden = YES;

    } failure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
       // [weakSelf p_handleError:error];
        weakSelf.defaultView.hidden = NO;
    }];
    [[TVDataProvider sharedInstance] getServerTimeWithCompletion:^(id responseObject) {
        
    } failure:^(NSString *error) {
        
    }];
    
}

-(void)setTvsArray:(NSArray *)tvsArray
{
    _tvsArray = tvsArray;
    //过滤bims下线节目
    for (TVStation *tvStation in  [LocalTVStationManager sharedInstance].visitedStations){
        NSArray *channelIdList = [[HiTVGlobals sharedInstance].offline_CHANNEL componentsSeparatedByString:NSLocalizedString(@",", nil)];
        BOOL IsOffline = [channelIdList containsObject:tvStation.uuid];
        
        if (IsOffline) {
            [[LocalTVStationManager sharedInstance].visitedStations removeObject:tvStation];
        }
    }
    
    //过滤节目列表下线节目
    NSArray *tempArray = [[LocalTVStationManager sharedInstance].visitedStations copy];
    [[LocalTVStationManager sharedInstance].visitedStations removeAllObjects];
    for (TVStation *tvStation in  tempArray){
        for (TVStation *entity in _tvsArray) {
            if ([tvStation.uuid isEqualToString:entity.uuid]) {
                [[LocalTVStationManager sharedInstance].visitedStations addObject:tvStation];
            }
        }
    }
    self.recentTvsArray = [LocalTVStationManager sharedInstance].visitedStations;
    [self.channelTabView reloadData];
    if (!_programViewController) {
        TVStation* station = nil;
        if (_tvsArray.count > 0){
            station = _tvsArray[0];
            [self.channelTabView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            
            _programViewController = [[ProgramViewController alloc] initWithTVStation:station];
            self.programViewController.view.frame = CGRectMake(0, 0, W, H-64-CGRectGetHeight(self.tabBarController.tabBar.frame));
            //        self.programViewController.view.backgroundColor = [UIColor redColor];
            [self.view addSubview:self.programViewController.view];
            [self.programViewController.view setClipsToBounds:YES];
            [self addChildViewController:self.programViewController];
        }

    }
    
    //[self.channelTabView removeFromSuperview];
    [self.view addSubview:self.channelTabView];
    /*dispatch_async(dispatch_get_main_queue(), ^{
        
        
    });*/
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
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TabHeight;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tvsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChannelCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ChannelCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.backgroundColor = klightGrayColor;
    NSInteger row = indexPath.row;
    TVStation *entity = nil;
    entity = self.tvsArray[row];

    [cell.channelImg setImageWithURL:[NSURL URLWithString:entity.logo] placeholderImage:[UIImage imageNamed:@"channelplace"]];

    UIView *view = [[UIView alloc]initWithFrame:cell.bounds];
    [view setBackgroundColor:[UIColor whiteColor]];
    cell.selectedBackgroundView = view;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    TVStation *station = nil;

    station = self.tvsArray[row];
    self.programViewController.station = station;
    [self.programViewController refashProgramList];
    [LocalTVStationManager sharedInstance].changed = YES;
    self.beforeVisitIndex = indexPath.row;
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - viewForHeaderInSection 不停留在顶部
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.channelTabView)
    {
        //YOUR_HEIGHT 为最高的那个headerView的高度
        CGFloat sectionHeaderHeight = TabHeight;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [retryBtn addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - 处理Tabbar隐藏/显示问题
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[SJMultiVideoDetailViewController class]]) {
        self.hidesBottomBarWhenPushed = NO;
    }

}

- (void)handleNotification:(NSNotification *)sender
{
    self.hidesBottomBarWhenPushed = YES;
}

@end
