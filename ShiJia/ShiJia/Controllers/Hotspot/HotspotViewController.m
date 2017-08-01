//
//  HotspotViewController.m
//  ShiJia
//
//  Created by 蒋海量 on 2017/2/22.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "HotspotViewController.h"
#import "HotspotViewCell.h"
#import "WMPlayer.h"
#import "HotsVideoModel.h"
#import "HotDetailView.h"
#import "AlbumShareView.h"
#import "SJShareAlertView.h"
#import "SJ30SVedioRequestModel.h"
#import "SJShareVideoViewModel.h"
#import "SJShareVideoViewController.h"
#import "DmsDataPovider.h"
#import "SJShareMessage.h"
#import "SJShareManager.h"
#import "SJMultiVideoDetailViewController.h"
#import "HomeJumpWebViewController.h"

#define Host @"http://221.131.123.204:8031/mock/ysten-mdms-api/"
#define kNavbarHeight ((kDeviceVersion>=7.0)? 64 :44 )
#define kIOS7DELTA   ((kDeviceVersion>=7.0)? 20 :0 )
#define kDeviceVersion [[UIDevice currentDevice].systemVersion floatValue]
#define kTabBarHeight 49

#define CellHeight 260*W/375


typedef enum : NSUInteger {
    paused,
    finished,
} StopType;

static NSString *identify = @"HotspotViewCell";

@interface HotspotViewController ()<WMPlayerDelegate,UIScrollViewDelegate,HotspotViewCellDelegate,PhotoShareDelegate>
@property (nonatomic,weak) IBOutlet UITableView *hotsTabView;

@property (nonatomic,strong) NSMutableArray *viedoLists;
@property (nonatomic,strong) WMPlayer *wmPlayer; // 播放器View
@property (nonatomic,strong) NSIndexPath *currentIndexPath; // 当前播放的cell
@property (nonatomic,assign) BOOL isSmallScreen; // 是否放置在window上
@property(nonatomic,strong) HotspotViewCell *currentCell; // 当前cell

@property (strong, nonatomic) HotDetailView *detailView;

@property (strong, nonatomic) HotsVideoModel *currentModel;
//add by allen 用于分享部分
@property (nonatomic, strong) AlbumShareView *shareListView;
@property (nonatomic, strong) HotsVideoModel *shareModel;
@property (nonatomic, strong) SJShareManager *shareManager;

@property (nonatomic, assign) StopType stopType;
@property (nonatomic,assign) int nextPageNumber;
@property (nonatomic,assign) int random;
@property (nonatomic, strong)NSDateFormatter *dateFormatter;
@property (strong, nonatomic)  UIView *defaultView;
@property (strong, nonatomic) NSString* timePos;
@end

@implementation HotspotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.view.backgroundColor = klightGrayColor;
    self.title = @"有料";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.tabBar.translucent=NO;
    self.hotsTabView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.hotsTabView registerNib:[UINib nibWithNibName:identify bundle:nil] forCellReuseIdentifier:identify];
    // 下拉刷新
    __weak __typeof(self)weakSelf = self;
    self.hotsTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf stopPlay];
        [strongSelf refreshData];
    }];

    [self.hotsTabView.mj_header beginRefreshing];

    // 上拉加载更多
    self.hotsTabView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];

    
    
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
   /* [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notiShowDetail)
                                                 name:kNotification_WMPLAYERPAUSE
                                               object:nil];*/
    //分享Mananger
    self.shareManager = [[SJShareManager alloc]init];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = NO;
    [AppDelegate appDelegate].appdelegateService.coinView.hidden = NO;

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopPlay];
}

-(void)showDetailView:(NSString *)content{
    if (self.currentModel.programSeriesId.length>0 ||self.currentModel.actionType.length>0) {
        [self.currentCell.mainImageView addSubview:self.detailView];
        _detailView.titleLab.text = self.currentModel.programSeriesName;
        if (self.currentModel.actionType.length==0) {
            [_detailView.posterImg setImageWithURL:[NSURL URLWithString:self.currentModel.programSeriesPoster] placeholderImage:[UIImage imageNamed:@"hotspaceimg"]];
        }
        else{
            [_detailView.posterImg setImageWithURL:[NSURL URLWithString:self.currentModel.actionPoster] placeholderImage:[UIImage imageNamed:@"hotspaceimg"]];
        }
        [_detailView.continuBtn setTitle:content forState:UIControlStateNormal];
        
        if ([self.currentModel.actionType isEqualToString:@"ps"]) {
            _detailView.tipString = @"点击观看完整视频";
        }
        else if([self.currentModel.actionType isEqualToString:@"replay"]){
            _detailView.tipString = @"点击观看最热视频";
        }
        else if([self.currentModel.actionType isEqualToString:@"live"]){
            _detailView.tipString = @"点击观看精彩直播";
        }
        else if([self.currentModel.actionType isEqualToString:@"ad"]){
            _detailView.tipString = @"点击赢取超多好礼";
        }
        else if([self.currentModel.actionType isEqualToString:@"smos"]){
            _detailView.tipString = @"必淘商品大集锦";
        }
        else if([self.currentModel.actionType isEqualToString:@"ams"]){
            _detailView.tipString = @"点击查看装机必备APP";
        }
        else{
            _detailView.tipString = @"点击观看完整视频";
        }
    }
}
-(HotDetailView *)detailView{
    if (!_detailView) {
        _detailView = [[[NSBundle mainBundle] loadNibNamed:@"HotDetailView" owner:self options:nil] firstObject];
        _detailView.frame = self.currentCell.mainImageView.bounds;

        WEAKSELF
        [_detailView setDidClickButtonAtIndex:^(NSInteger index){
            if (index == 0) {
                [weakSelf playDetailVideo];
                [weakSelf.detailView removeFromSuperview];
            }
            else{
                [weakSelf replayCurrentVideo];
                [weakSelf.detailView removeFromSuperview];

            }
        }];
    }

    return _detailView;
}

// 请求数据
- (void)refreshData
{
    
    self.random  = arc4random() % 100;
    NSString* url = [NSString stringWithFormat:@"%@findHotVideoList.json?abilityString=%@&pageNum=%d&random=%d",DMS_HOST,T_STBext,0,self.random];
    WEAKSELF
    [BaseAFHTTPManager getRequestOperationForHost:url forParam:@"" forParameters:nil completion:^(id responseObject) {
        weakSelf.defaultView.hidden = YES;
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"resultCode"];
        if ([code isEqualToString:@"000"]) {
            [weakSelf.viedoLists removeAllObjects];
            NSArray *list = responseDic[@"data"][@"list"];
            for (NSDictionary *dic in list) {
                HotsVideoModel *model = [[HotsVideoModel alloc]initWithDictionary:dic];
                [weakSelf.viedoLists addObject:model];
            }
            _currentModel = weakSelf.viedoLists.firstObject;
            weakSelf.nextPageNumber = 1;
        }

        [weakSelf.hotsTabView.mj_header endRefreshing];
        [weakSelf.hotsTabView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        [weakSelf.hotsTabView.mj_header endRefreshing];
        weakSelf.viedoLists = nil;
        [weakSelf.hotsTabView reloadData];
        weakSelf.defaultView.hidden = NO;
    }];
}
// 请求数据
- (void)loadMoreData
{
    NSString* url = [NSString stringWithFormat:@"%@findHotVideoList.json?abilityString=%@&pageNum=%d&random=%d",DMS_HOST,T_STBext,self.nextPageNumber,self.random];
    
    WEAKSELF
    [BaseAFHTTPManager getRequestOperationForHost:url forParam:@"" forParameters:nil completion:^(id responseObject) {
        
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"resultCode"];
        if ([code isEqualToString:@"000"]) {
            NSArray *list = responseDic[@"data"][@"list"];
            for (NSDictionary *dic in list) {
                HotsVideoModel *model = [[HotsVideoModel alloc]initWithDictionary:dic];
                [weakSelf.viedoLists addObject:model];
            }
            weakSelf.nextPageNumber += 1;
        }

        [self.hotsTabView.mj_footer endRefreshing];
        [self.hotsTabView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        [self.hotsTabView.mj_footer endRefreshing];
    }];
}

/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    if (self.wmPlayer==nil||self.wmPlayer.superview==nil){
        return;
    }
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            DDLogInfo(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            DDLogInfo(@"第0个旋转方向---电池栏在上");
            if (self.wmPlayer.isFullscreen) {
                if (self.isSmallScreen) {
                    //放widow上,小屏显示
                    // [self toSmallScreen];
                }
                else
                {
                    [self toCell];
                }
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            DDLogInfo(@"第2个旋转方向---电池栏在右");
            self.wmPlayer.isFullscreen = YES;
            [self setNeedsStatusBarAppearanceUpdate];
            [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            DDLogInfo(@"第1个旋转方向---电池栏在左");
            self.wmPlayer.isFullscreen = YES;
            [self setNeedsStatusBarAppearanceUpdate];
            [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
        }
            break;
        default:
            break;
    }
}
// 当前cell显示
-(void)toCell{


    HotspotViewCell *currentCell = (HotspotViewCell *)[self.hotsTabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndexPath.row inSection:0]];
    // 每次切换的时候都要先移除掉
    [self.wmPlayer removeFromSuperview];

    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5f animations:^{

        weakSelf.wmPlayer.transform = CGAffineTransformIdentity;
        //重新设置frame，重新设置layer的frame
        weakSelf.wmPlayer.frame = currentCell.mainImageView.bounds;
        weakSelf.wmPlayer.playerLayer.frame =  self.wmPlayer.bounds;
        [currentCell.mainImageView addSubview:weakSelf.wmPlayer];
        [currentCell.mainImageView bringSubviewToFront:weakSelf.wmPlayer];
        [weakSelf.wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.wmPlayer).with.offset(0);
            make.right.equalTo(weakSelf.wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(weakSelf.wmPlayer).with.offset(0);
        }];
        [weakSelf.wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.wmPlayer).with.offset(0);
            make.right.equalTo(weakSelf.wmPlayer).with.offset(0);
            make.height.mas_equalTo(50);
            make.top.equalTo(weakSelf.wmPlayer).with.offset(0);
        }];
        [weakSelf.wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.wmPlayer.topView).with.offset(15);
            make.right.equalTo(weakSelf.wmPlayer.topView).with.offset(-15);
            make.center.equalTo(weakSelf.wmPlayer.topView);
            make.top.equalTo(weakSelf.wmPlayer.topView).with.offset(0);
        }];
        [weakSelf.wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(weakSelf.wmPlayer).with.offset(5);
        }];
        [weakSelf.wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.wmPlayer);
            make.width.equalTo(weakSelf.wmPlayer);
            make.height.equalTo(@30);
        }];
    }completion:^(BOOL finished) {
        weakSelf.wmPlayer.isFullscreen = NO;
        [weakSelf setNeedsStatusBarAppearanceUpdate];
        weakSelf.isSmallScreen = NO;
        weakSelf.wmPlayer.fullScreenBtn.selected = NO;
        self.wmPlayer.backbtn.hidden = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];

    }];

}


// 全屏显示
-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    self.wmPlayer.backbtn.hidden = NO;
     [[UIApplication sharedApplication] setStatusBarHidden:YES];

    // 先移除
    [self.wmPlayer removeFromSuperview];
    self.wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        self.wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        self.wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    // 重新设置frame
    self.wmPlayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.wmPlayer.playerLayer.frame =  CGRectMake(0,0, kScreenHeight,kScreenWidth);

    [self.wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(kScreenWidth-40);
        make.width.mas_equalTo(kScreenHeight);
    }];

    [self.wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        //        make.left.equalTo(wmPlayer).with.offset(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(kScreenHeight);
    }];

    [self.wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.wmPlayer).with.offset((-kScreenHeight/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(self.wmPlayer).with.offset(5);

    }];

    [self.wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wmPlayer.topView).with.offset(45);
        make.right.equalTo(self.wmPlayer.topView).with.offset(-45);
        make.center.equalTo(self.wmPlayer.topView);
        make.top.equalTo(self.wmPlayer.topView).with.offset(0);
    }];

    [self.wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenHeight);
        make.center.mas_equalTo(CGPointMake(kScreenWidth/2-36, -(kScreenWidth/2)));
        make.height.equalTo(@30);
    }];

    [self.wmPlayer.loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(kScreenWidth/2-37, -(kScreenWidth/2-37)));
    }];
    [self.wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenHeight);
        make.center.mas_equalTo(CGPointMake(kScreenWidth/2-36, -(kScreenWidth/2)+36));
        make.height.equalTo(@30);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self.wmPlayer];

    self.wmPlayer.fullScreenBtn.selected = YES;
    [self.wmPlayer bringSubviewToFront:self.wmPlayer.bottomView];

}
#pragma mark - 播放器的代理回调
///播放器事件
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn{
    DDLogInfo(@"didClickedCloseButton");
    HotspotViewCell *currentCell = (HotspotViewCell *)[self.hotsTabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndexPath.row inSection:0]];
    [currentCell.playButton.superview bringSubviewToFront:currentCell.playButton];
    [currentCell.timeLabel.superview bringSubviewToFront:currentCell.timeLabel];

    [self releaseWMPlayer];
    [self setNeedsStatusBarAppearanceUpdate];

}
-(void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn{
    if (fullScreenBtn.isSelected) {//全屏显示
        self.wmPlayer.isFullscreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
       // [[UIApplication sharedApplication] setStatusBarHidden:YES];

    }else{
        //[[UIApplication sharedApplication] setStatusBarHidden:NO];
        if (self.isSmallScreen) {
            //放widow上,小屏显示
            // [self toSmallScreen];
        }else{
            [self toCell];
        }
    }
}
-(void)wmplayer:(WMPlayer *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap{
    DDLogInfo(@"didSingleTaped");
}
-(void)wmplayer:(WMPlayer *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap{
    DDLogInfo(@"didDoubleTaped");
}
//点击播放暂停按钮代理方法
-(void)wmplayer:(WMPlayer *)wmplayer clickedPlayOrPauseButton:(UIButton *)playOrPauseBtn{
    if (wmplayer.player.rate == 0) {
        [self showDetailView:@"  继续播放"];
    }


}
///播放状态
-(void)wmplayerFailedPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    DDLogInfo(@"wmplayerDidFailedPlay");
}
-(void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    DDLogInfo(@"wmplayerDidReadyToPlay");
}
-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer{
    DDLogInfo(@"wmplayerDidFinishedPlay");
    if (self.wmPlayer.isFullscreen) {
        [self toCell];
    }
    [self showDetailView:@"  重新播放本片"];

    NSString* content = [NSString stringWithFormat:@"id=%@&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&programtypename=%@&tag=%@&firstsource=%@&epgname=%@&playPoint=%.2f&Url=%@&BuffCount=%@&BuffAverTimeCost=%f&startTime=%@&endTime=%@&PlayTotalTimeCost=%@&playstream=%lld&error=%@", isNullString(@""), @"短视频",isNullString(@""),isNullString(self.currentModel.programSeriesId),isNullString(self.currentModel.videoId),isNullString(self.currentModel.programSeriesName),isNullString(self.currentModel.title),isNullString(@""), isNullString(@""), isNullString(self.tabBarController.tabBar.selectedItem.title), isNullString(@""), 0.0f, isNullString(self.currentModel.videoUrl), @"0", 0.0f, isNullString(self.timePos), [Utils getCurrentTime], self.currentModel.timeLength, [self getReceivedBytes], isNullString(@"no")];
    
    [Utils BDLog:1 module:@"604" action:@"AppPlayQos" content:content];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viedoLists.count;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return CellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotspotViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    cell.m_delegate = self;
    [self configCell:cell indexpath:indexPath tableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UIImageView *imageViewSepE = [[UIImageView alloc]initWithFrame:CGRectMake(0, CellHeight-5, W, 5)];
    imageViewSepE.backgroundColor = klightGrayColor;
    [cell.contentView addSubview:imageViewSepE];
    
    return cell;
}
- (void)configCell:(HotspotViewCell *)cell indexpath:(NSIndexPath *)indexpath tableView:(UITableView *)tableView
{
    HotsVideoModel *model = self.viedoLists[indexpath.row];
    cell.titleLabel.text = model.title;
    cell.timeLabel.text = [self convertTime:[model.timeLength floatValue]];
    cell.playCountLabel.text = [NSString stringWithFormat:@"观看次数 %@",model.playCounts];
    [cell.playButton addTarget:self action:@selector(startPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
    cell.playButton.tag = indexpath.row;
    [cell.mainImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholderImage:nil];
    cell.hotsVideoModel = model;


    // 当播放器的View存在的时候
    if (self.wmPlayer&&self.wmPlayer.superview) {
        if (indexpath.row==self.currentIndexPath.row) {
            [cell.playButton.superview sendSubviewToBack:cell.playButton];
            [cell.timeLabel.superview sendSubviewToBack:cell.timeLabel];
        }else{
            [cell.playButton.superview bringSubviewToFront:cell.playButton];
            [cell.timeLabel.superview bringSubviewToFront:cell.timeLabel];
        }
        // 获取所有可见的cell的indexpaths
        NSArray *indexpaths = [tableView indexPathsForVisibleRows];

        // 已经移除可见区域了
        if (![indexpaths containsObject:self.currentIndexPath]&&self.currentIndexPath!=nil) {//复用

            // 是否小窗口模式包含了
            if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:self.wmPlayer]) {
                self.wmPlayer.hidden = NO;
            }else{
                self.wmPlayer.hidden = YES;
                [cell.playButton.superview bringSubviewToFront:cell.playButton];
                [cell.timeLabel.superview bringSubviewToFront:cell.timeLabel];
            }
        }else{ // 在可见区域以内 加到cell上面
            if ([cell.mainImageView.subviews containsObject:self.wmPlayer]) {
                [cell.mainImageView addSubview:self.wmPlayer];

                [self.wmPlayer play];
                self.wmPlayer.hidden = NO;
            }

        }
    }
}
#pragma mark - 播放器播放

- (void)startPlayVideo:(UIButton *)sender
{
    // 获取当前的indexpath
    self.currentIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];

    // iOS 7 和 8 以上获取cell的方式不同
    if ([UIDevice currentDevice].systemVersion.floatValue>=8||[UIDevice currentDevice].systemVersion.floatValue<7) {
        self.currentCell = (HotspotViewCell *)sender.superview.superview;
    }else{//ios7系统 UITableViewCell上多了一个层级UITableViewCellScrollView
        self.currentCell = (HotspotViewCell *)sender.superview.superview.subviews;
    }
    HotsVideoModel *model = [self.viedoLists objectAtIndex:sender.tag];

    

    // 小窗口的时候点击播放另一个 先移除掉
    if (self.isSmallScreen) {
        [self releaseWMPlayer];
        self.isSmallScreen = NO;

    }
    // 当有上一个在播放的时候 点击 就先release
    if (self.wmPlayer) {
        NSString* content = [NSString stringWithFormat:@"id=%@&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&programtypename=%@&tag=%@&firstsource=%@&epgname=%@&playPoint=%.2f&Url=%@&BuffCount=%@&BuffAverTimeCost=%f&startTime=%@&endTime=%@&PlayTotalTimeCost=%@&playstream=%lld&error=%@", isNullString(@""), @"短视频",isNullString(@""),isNullString(self.currentModel.programSeriesId),isNullString(self.currentModel.videoId),isNullString(self.currentModel.programSeriesName),isNullString(self.currentModel.title),isNullString(@""), isNullString(@""), isNullString(self.tabBarController.tabBar.selectedItem.title), isNullString(@""), 0.0f, isNullString(self.currentModel.videoUrl), @"0", 0.0f, isNullString(self.timePos), [Utils getCurrentTime], self.currentModel.timeLength, [self getReceivedBytes], isNullString(@"no")];
        
        [Utils BDLog:1 module:@"604" action:@"AppPlayQos" content:content];
        [self releaseWMPlayer];
        self.wmPlayer = [[WMPlayer alloc]initWithFrame:self.currentCell.mainImageView.bounds];
        self.wmPlayer.delegate = self;
        self.wmPlayer.closeBtnStyle = CloseBtnStyleClose;
        self.wmPlayer.URLString = model.videoUrl;
        self.wmPlayer.titleLabel.text = model.title;
        
        //        [wmPlayer play];
    }else{
        // 当没有一个在播放的时候
        self.wmPlayer = [[WMPlayer alloc]initWithFrame:self.currentCell.mainImageView.bounds];
        self.wmPlayer.delegate = self;
        self.wmPlayer.closeBtnStyle = CloseBtnStyleClose;
        self.wmPlayer.titleLabel.text = model.title;
        self.wmPlayer.URLString = model.videoUrl;
    }
    self.currentModel = model;
    // 把播放器加到当前cell的imageView上面
    [self.currentCell.mainImageView addSubview:self.wmPlayer];
    [self.currentCell.mainImageView bringSubviewToFront:self.wmPlayer];
    [self.currentCell.playButton.superview sendSubviewToBack:self.currentCell.playButton];
    [self.currentCell.timeLabel.superview sendSubviewToBack:self.currentCell.timeLabel];

    [self.hotsTabView reloadData];
    
    
    [self umengEvent];
}


#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView ==self.hotsTabView){
        if (self.wmPlayer==nil) {
            return;
        }

        if (self.wmPlayer.superview) {
            CGRect rectInTableView = [self.hotsTabView rectForRowAtIndexPath:self.currentIndexPath];
            CGRect rectInSuperview = [self.hotsTabView convertRect:rectInTableView toView:[self.hotsTabView superview]];
            if (rectInSuperview.origin.y<-self.currentCell.mainImageView.frame.size.height||rectInSuperview.origin.y>kScreenHeight-kNavbarHeight-kTabBarHeight) {//往上拖动

                if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:self.wmPlayer]&&self.isSmallScreen) {
                    self.isSmallScreen = YES;
                }else{
                    [self stopPlay];
                }

            }else{
                if ([self.currentCell.mainImageView.subviews containsObject:self.wmPlayer]) {

                }else{
                    [self toCell];
                }
            }
        }

    }
}


- (NSMutableArray *)viedoLists
{
    if (_viedoLists == nil) {
        _viedoLists = [[NSMutableArray alloc] init];
    }
    return _viedoLists;
}


/**
 *  释放WMPlayer
 */
-(void)releaseWMPlayer{
    [self.wmPlayer.player.currentItem cancelPendingSeeks];
    [self.wmPlayer.player.currentItem.asset cancelLoading];
    [self.wmPlayer pause];


    [self.wmPlayer removeFromSuperview];
    [self.wmPlayer.playerLayer removeFromSuperlayer];
    [self.wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    self.wmPlayer.player = nil;
    self.wmPlayer.currentItem = nil;
    //释放定时器，否侧不会调用WMPlayer中的dealloc方法
    [self.wmPlayer.autoDismissTimer invalidate];
    self.wmPlayer.autoDismissTimer = nil;


    self.wmPlayer.playOrPauseBtn = nil;
    self.wmPlayer.playerLayer = nil;
    self.wmPlayer = nil;
    [_detailView removeFromSuperview];

}
#pragma mark HotspotViewCellDelegate
- (void)shareCurrentVideo:(HotsVideoModel *)hotsVideoModel{
    _shareModel = [HotsVideoModel new];
    _shareModel = hotsVideoModel;
    _shareListView = self.shareListView;

}
#pragma mark  photoShareDelegate
-(void)PhotoShareToSocailName:(Platform)name{

    if (name == ShiJia) {

        SJShareVideoViewController *shareVC = [[SJShareVideoViewController alloc] init];
        SJShareVideoViewModel *viewModel = [[SJShareVideoViewModel alloc] initWithController:shareVC];
        viewModel.hotspotVideoImage = _shareModel.poster;
        viewModel.hotspotVideoID = _shareModel.videoId;
        viewModel.hotspotVideoUrl = _shareModel.videoUrl;
        viewModel.hotspotVideoTitle = _shareModel.title;


        shareVC.viewModel = viewModel;
        self.hidesBottomBarWhenPushed = YES;
        if (self.parentController) {
            [self.parentController.navigationController pushViewController:shareVC animated:YES];
        }
        else{
            [self.navigationController pushViewController:shareVC animated:YES];
        }
        self.hidesBottomBarWhenPushed = NO;
        
        
        // add log.
        NSString* content = [NSString stringWithFormat:@"state=%@&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&way=%@&sharetime=%@&sharepoint=%@",@"%d",
                             @"短视频", isNullString(@""), isNullString(@""), viewModel.hotspotVideoID, isNullString(@""), isNullString(viewModel.hotspotVideoImage), @"和家庭好友", @"", [Utils getCurrentTime]];
         
        [NSUserDefaultsManager saveObject:content forKey:LOG_SHARE_CONTENT];
        
        
    }else{

        SJShareAlertView *alertView = [SJShareAlertView alertViewDefault];
        alertView.title = @"分享";
        alertView.content = _shareModel.title;
        alertView.alertImageString =_shareModel.poster;
        alertView.buttonTtileArray= @[@"取消",@"确定"];
        alertView.deterColor = kColorBlueTheme;
        [alertView show];
        WEAKSELF
        alertView.alertBlock = ^(id sender,NSString *text){
            UIButton *button = (UIButton *)sender;
            if (button.tag ==0) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"取消分享" toView:nil];
            }else{
                requestWebLink *params = [requestWebLink new];
                params.ability  = T_STBext;
                params.uid = [HiTVGlobals sharedInstance].uid;
                params.contentId = _shareModel.videoId;
                params.userImg = [HiTVGlobals sharedInstance].faceImg;
                params.userName = [HiTVGlobals sharedInstance].nickName;
                [MBProgressHUD showMessag:@"正在分享" toView:nil];
                [DmsDataPovider hotSpotVideoGenerateWebLinkWith:params
                                                CompletionBlock:^(id responseObject) {
                                                    [MBProgressHUD hideHUD];
                                                    SJShareMessage *shareMessage = [SJShareMessage new];
                                                    shareMessage.platform = name;
                                                    shareMessage.messageType = ShareMessageTypeUrl;
                                                    shareMessage.messageTitle =@"【和家庭-分享精彩瞬间】" ;
                                                    shareMessage.messageContent =responseObject[@"title"];
                                                    shareMessage.messageSourceLink =responseObject[@"visitUrl"];
                                                    shareMessage.messageThumbImageUrl =responseObject[@"imageUrl"];
                                                    [HiTVGlobals sharedInstance].shareType = @"短视频";
                                                    
                                                    NSString* way = nil;
                                                    switch (name) {
                                                        case ShiJia:
                                                            way = @"视加";
                                                            break;
                                                        case WeChat:
                                                            way = @"微信";
                                                            [HiTVGlobals sharedInstance].shareWay = @"微信";
                                                            break;
                                                        case WeChatFriend:
                                                            way = @"朋友圈";
                                                            [HiTVGlobals sharedInstance].shareWay = @"朋友圈";
                                                            break;
                                                        case SinaWeiBo:
                                                            way = @"新浪微博";
                                                            break;
                                                        case Contact:
                                                            way = @"通讯录";
                                                            break;
                                                        default:
                                                            break;
                                                    }
                                                    
                                                    // add log.
                                                    NSString* content = [NSString stringWithFormat:@"state=%@&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&way=%@&sharetime=%@&sharepoint=%@",@"%d", @"短视频", isNullString(@""), isNullString(@""), isNullString(@""), isNullString(_shareModel.videoId), _shareModel.title, way, @"", [Utils getCurrentTime]];
                                                    
                                                    [NSUserDefaultsManager saveObject:content forKey:LOG_SHARE_CONTENT];
                                                    
                                                    [weakSelf.shareManager shareObject:shareMessage];
                                                    
                                                     
                                                    
                                                } failure:^(NSString *message) {
                                                    [MBProgressHUD showError:message toView:nil];

                                                }];

            }
        };
    }
}

-(AlbumShareView *)shareListView{

    _shareListView = [[AlbumShareView alloc]init];
    _shareListView.photoShareDelegate = self;
    [_shareListView setTitleString:nil];
    [[UIApplication sharedApplication].keyWindow addSubview:_shareListView];
    [_shareListView AlbumShareShowInView:[UIApplication sharedApplication].keyWindow];
    return _shareListView;
}
-(void)reloadData{
    [self.hotsTabView.mj_header beginRefreshing];

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
        [retryBtn addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
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
#pragma mark 页面跳转
- (void)playDetailVideo{
    if ([self.currentModel.actionType isEqualToString:@"live"]||[self.currentModel.actionType isEqualToString:@"replay"]) {
        
        self.tabBarController.selectedIndex = 3;
    }
    else if([self.currentModel.actionType isEqualToString:@"ad"]||[self.currentModel.actionType isEqualToString:@"smos"]||[self.currentModel.actionType isEqualToString:@"ams"]||[self.currentModel.actionType isEqualToString:@"custom"]){
        HomeJumpWebViewController *jumpVC = [[HomeJumpWebViewController alloc]init];
        jumpVC.urlStr =self.currentModel.actionValue;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jumpVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else{
        SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
        detailVC.videoID = self.currentModel.programSeriesId;
        detailVC.categoryID = self.currentModel.programSeriesId;
        
        
        //[self.navigationController pushViewController:detailVC animated:YES];
        if (self.parentController) {
            self.parentController.hidesBottomBarWhenPushed = YES;
            [self.parentController.navigationController pushViewController:detailVC animated:YES];
            self.parentController.hidesBottomBarWhenPushed = NO;
        }
        else{
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        
        
        [self umengCGEvent];
    }
    
}

- (void)replayCurrentVideo{
    [self.wmPlayer play];
}

-(void)stopPlay{
    HotspotViewCell *currentCell = (HotspotViewCell *)[self.hotsTabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndexPath.row inSection:0]];
    [currentCell.playButton.superview bringSubviewToFront:currentCell.playButton];
    [currentCell.timeLabel.superview bringSubviewToFront:currentCell.timeLabel];
    [self releaseWMPlayer];
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)dealloc{
    DDLogInfo(@"%s dealloc",object_getClassName(self));
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self releaseWMPlayer];
}
// 懒加载formmater对象
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}
// 把时间转换成NSData然后转换成NSString
- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    NSString *newTime = [[self dateFormatter] stringFromDate:d];
    return newTime;
}

#pragma mark - 友盟统计
-(void)umengEvent{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"短视频" forKey:@"type_name"];
    [dic setValue:@"有料" forKey:@"first_nav"];
    [dic setValue:@"有料" forKey:@"sec_nav"];
    [dic setValue:self.currentModel.title forKey:@"program_name"];
    
    NSString* content = [NSString stringWithFormat:@"type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&programtypename=%@&firstsource=%@&epgname=%@&tag=%@&starttime=%@", @"短视频",isNullString(@""),isNullString(self.currentModel.programSeriesId), isNullString(self.currentModel.videoId),isNullString(self.currentModel.programSeriesName),isNullString(self.currentModel.title),
                         isNullString(@""),isNullString(self.tabBarController.tabBar.selectedItem.title),isNullString(@""), isNullString(@""), [Utils getCurrentTime]];
    self.timePos = [Utils getCurrentTime];
    [Utils BDLog:1 module:@"604" action:@"AppPlayAction" content:content];
    
    [UMengManager event:@"U_Play" attributes:dic];
}

-(void)umengCGEvent{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"常规视频" forKey:@"type_name"];
    [dic setValue:@"有料" forKey:@"first_nav"];
    [dic setValue:self.currentModel.title forKey:@"sec_nav"];
    [dic setValue:self.currentModel.programSeriesName forKey:@"program_name"];
    
    [UMengManager event:@"U_ShortToLong" attributes:dic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(long long)getReceivedBytes
{
    AVPlayerItemAccessLog *accesslog = self.wmPlayer.player.currentItem.accessLog;
    NSArray *events = [accesslog events];
    AVPlayerItemAccessLogEvent *event = events.firstObject;
    
    return [event numberOfBytesTransferred]/1024;
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
