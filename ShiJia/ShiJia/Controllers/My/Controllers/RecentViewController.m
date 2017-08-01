//
//  RecentViewController.m
//  HiTV
//
//  created by iSwift on 3/9/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "RecentViewController.h"
#import "BaseAFHTTPManager.h"
#import "RecentVideo.h"
#import "JSON.h"
#import "RecentTableViewCell.h"
#import "OMGToast.h"

#import "SJMultiVideoDetailViewController.h"
#import "SJVideoDetailViewController.h"
#import "SJLiveTVDetailViewController.h"

@interface RecentViewController ()<RecentTableViewCellDelegate>
@property (nonatomic, strong) NSMutableArray *historyList;
@property (nonatomic, strong) NSMutableDictionary *recentDic;
@property (nonatomic, strong) NSArray *allKeys;
@property (nonatomic, strong) UIView  *noDataView;
@end

@implementation RecentViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tipLab.hidden = YES;
    self.tipImg.hidden = YES;
    self.title = @"最近观看";
    self.tipLab.text = @"您最近没有看过任何影片";
    self.tipImg.image = [UIImage imageNamed:@"browsehistory"];
    
    self.tableView.separatorColor = [UIColor clearColor];    
    
    // 下拉刷新
    __weak __typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf batchQueryHistory];
    }];
    [self.tableView.mj_header beginRefreshing];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"next" object:nil];
}

- (void)setRecentDic:(NSMutableDictionary *)recentDic
{
    _recentDic = recentDic;
    [self getAllKeys];
    if (self.allKeys.count > 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editView];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    [self showTips];
    [self.tableView reloadData];
}
- (NSMutableArray *)historyList
{
    if (!_historyList) {
        _historyList = [NSMutableArray new];
    }
    return _historyList;
}
#pragma mark - 刷新UI
-(void)refreshHistory{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self batchQueryHistory];
        
    });
}
//批量查询观看纪录
-(void)batchQueryHistory
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    if (self.pUid) {
        [parameters setValue:self.pUid forKey:@"uid"];
    }
    else{
        [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    }
    //end
    [parameters setValue:@"MOBILE" forKey:@"deviceType"];
    [parameters setValue:T_STBext forKey:@"abilityString"];

    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN forParam:@"/integration/2.0/queryHistory" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSMutableArray *historyList =  [responseDic objectForKey:@"data"];
        NSString *code = [responseDic objectForKey:@"code"];
        if (code.intValue == 0) {
            [self.historyList removeAllObjects];
            [self.historyList   addObjectsFromArray:historyList];
            weakSelf.recentDic = [weakSelf getFilterArrayFromAry:historyList];
        }
        [self.tableView.mj_header endRefreshing];
    }failure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf p_handleNetworkError];
        [self.tableView.mj_header endRefreshing];

    }];
}
//单条删除观看纪录
-(void)deleteHistory:(RecentVideo *)video
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"oprUids"];
    [parameters setValue:video.businessType forKey:@"businessType"];
    [parameters setValue:video.objectId forKey:@"objectId"];
    [parameters setValue:video.startTime forKey:@"startTime"];
    [parameters setValue:video.endTime forKey:@"endTime"];
    //[parameters setValue:video.templateId forKey:@"templateId"];
    [parameters setValue:@"MOBILE" forKey:@"deviceType"];

    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN forParam:@"/integration/2.0/deleteHistory" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        //重新查询
        NSString *code = [responseObject objectForKey:@"code"];
        if (code.intValue == 0) {
            //[self refreshHistory];
            int n = -1;
            for (int i = 0 ;i<_historyList.count;i++) {
                NSDictionary *dic = _historyList[i];
                if ([dic[@"lastProgramId"] isEqualToString:video.lastProgramId]) {
                    n = i;
                    break;
                }
            }
            if (n!=-1) {
                [self.historyList removeObjectAtIndex:(NSUInteger)n];
            }
            weakSelf.recentDic = [weakSelf getFilterArrayFromAry:_historyList];
            [weakSelf.tableView reloadData];
        }
        [OMGToast showWithText:[responseObject objectForKey:@"message"]];

    }failure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
    }];
}
//批量删除观看纪录
-(void)batchDeleteHistory
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"oprUids"];
    [parameters setValue:@"MOBILE" forKey:@"deviceType"];

    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN forParam:@"/integration/2.0/deleteHistory" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSString *code = [responseObject objectForKey:@"code"];
        if (code.intValue == 0) {
            self.navigationItem.rightBarButtonItem = nil;
            [self setEditing:NO animated:YES];
            //[self refreshHistory];
            weakSelf.recentDic = nil;
        }
        [OMGToast showWithText:[responseObject objectForKey:@"message"]];
    }failure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
}

- (void)removeAllVideos{
    [self batchDeleteHistory];
}
#pragma mark - RecentTableViewCellDelegate
- (void)deleteRecentVideo:(RecentVideo *)entity{
    [self deleteHistory:entity];
}
//add by jzb at20150810
- (NSString *)getDateStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateformat = [[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyy.MM.dd"];
    NSString *str = [dateformat stringFromDate:date];
    return str;
}

- (NSMutableDictionary *)getFilterArrayFromAry:(NSArray *)originalAry
{
    NSMutableDictionary *muDic = [NSMutableDictionary new];
    for (NSDictionary *dic in originalAry) {
        NSString *dateline = dic[@"dateline"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateline longLongValue]];
        NSString *str = [self getDateStringFromDate:date];
        NSMutableArray *ary = muDic[str];
        if (!ary) {
            ary = [[NSMutableArray alloc]initWithObjects:[[RecentVideo alloc]initWithDict:dic], nil];
        }
        else{
            [ary addObject:[[RecentVideo alloc]initWithDict:dic]];
        }
        [muDic setObject:ary forKey:str];
    }
    
    return muDic;
}

- (NSString *)getWatchTimeFromDatePoint:(NSString *)dataPoint
{
    NSMutableString *timeStr = [NSMutableString new];
    int a = [dataPoint intValue];
    if (a<10) {
        return @"不足10秒";
    }
    if (a > 3600){
        int h = a/3600;
        a = a%3600;
        [timeStr appendString:[NSString stringWithFormat:@"%d小时",h]];
    }
    if (a > 60) {
        int m = a/60;
        a = a%60;
        [timeStr appendString:[NSString stringWithFormat:@"%d分钟",m]];
    }
    if (a > 0) {
        [timeStr appendString:[NSString stringWithFormat:@"%d秒",a]];
    }

    if (timeStr.length == 0) {
//        [timeStr appendString:@"0秒"];
        return @"不足10秒";
    }
    return timeStr;
}

- (void)getAllKeys
{
    NSArray *ary = [self.recentDic allKeys];
    self.allKeys = [ary sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj2 compare:obj1];
    }];
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.allKeys count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, W, 35)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    if (section!=0) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, W, 1)];
        line.backgroundColor = kTabLineColor;
        [headerView addSubview:line];
    }
    
    NSString *key = self.allKeys[section];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 310, 10)];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor darkGrayColor]];
//    [label.layer setBorderWidth:0.5];
//    [label.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    NSString *today = [self getDateStringFromDate:[NSDate date]];
    if ([today isEqualToString:key]) {
        [label setText:@"今天"];
    }
    else{
        [label setText:key];
    }
    [headerView addSubview:label];

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95.;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = self.allKeys[section];
    NSArray *ary = self.recentDic[key];
    return [ary count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"RecentTableViewCell";
    RecentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:@"cell"];
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.m_delegate = self;
    NSString *key = self.allKeys[indexPath.section];
    NSArray *ary = self.recentDic[key];
    RecentVideo *video = ary[indexPath.row];
    cell.recentVideo = video;
    cell.titleLab.text = video.objectName;
    
    if ([video.deviceType isEqualToString:@"MOBILE"]) {
        cell.deviceImgView.image = [UIImage imageNamed:@"recent_device_mobile"];
    }
    else{
        cell.deviceImgView.image = [UIImage imageNamed:@"recent_device_tv"];
    }
    
    /*if ([video.businessType isEqualToString:@"livereplay"] &&(![video.playType isEqualToString:@"vod"])) {*/
    if ([video.playType isEqualToString:@"replay"]||[video.playType isEqualToString:@"live"]) {
        [cell.watchTime setText:video.duration];
    }
    else{
        if ([[self getWatchTimeFromDatePoint:video.endWatchTime] isEqualToString:@"不足10秒"]) {
        [cell.watchTime setText:[NSString stringWithFormat:@"观看%@",[self getWatchTimeFromDatePoint:video.endWatchTime]]];
        }else{
        [cell.watchTime setText:[NSString stringWithFormat:@"观看到%@",[self getWatchTimeFromDatePoint:video.endWatchTime]]];
        }
    }
    if (video.lastProgramName.length == 0 ||[video.playType isEqualToString:@"vod"]) {
//        cell.titleLab.font = [UIFont boldSystemFontOfSize:16.0f];
//        cell.titleLab.textColor = kLiveColor;
//        cell.videoName.text = cell.watchTime.text;
//        cell.videoName.font = [UIFont systemFontOfSize:12.0f];
//        cell.videoName.textColor = [UIColor lightGrayColor];
//        cell.watchTime.hidden = YES;
        cell.titleLab.text = @"";
        cell.videoName.text = video.objectName;
        cell.heightOfTitleLabel.constant = 0.0;
    }
    else{
//        cell.titleLab.font = [UIFont systemFontOfSize:12.0f];
//        cell.titleLab.textColor = [UIColor lightGrayColor];
//        cell.videoName.text = video.lastProgramName;
//        cell.videoName.font = [UIFont boldSystemFontOfSize:16.0f];
//        cell.videoName.textColor = kLiveColor;
//        cell.watchTime.hidden = NO;
        cell.heightOfTitleLabel.constant = 20.0;
        cell.videoName.text = video.lastProgramName;

    }

    if (video.verticalImg.length == 0) {
        [cell.fitVideoImg setImageWithURL:[NSURL URLWithString: video.bannerImg] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
        
    }
    else{
        [cell.fitVideoImg setImageWithURL:[NSURL URLWithString: video.verticalImg] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
    }
   // [cell.fitVideoImg setImageWithURL:[NSURL URLWithString: video.bannerImg] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
    if (video.expired.intValue == 0) {
        
        cell.offlineTag.hidden = YES;
    }else{
        
        cell.offlineTag.hidden = NO;
    }

    if (self.editing) {
        [cell.selectedBtn setHidden:NO];
    }
    else
    {
        [cell.selectedBtn setHidden:YES];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing) {
       // RecentTableViewCell *cell = (RecentTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    }
    else{
        NSString *key = self.allKeys[indexPath.section];
        NSArray *ary = self.recentDic[key];
        RecentVideo *content = ary[indexPath.row];
        if (content.expired.intValue != 0) {
            [self deleteHistory:content];
            
        }else{
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
                    if (!self.pUid) {
                        detailVC.videoDatePoint = content.endWatchTime.floatValue;
                    }
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
                    if (!self.pUid) {
                        detailVC.videoDatePoint = content.endWatchTime.floatValue;
                    }
                    
                    WatchListEntity *entity = [[WatchListEntity alloc]init];
                    entity.programSeriesId = content.objectId;
                    entity.categoryId = content.assortId;
                    entity.contentId = content.lastProgramId;
                    entity.programSeriesName = content.objectName;
                    entity.startTime = [content.startTime longLongValue];
                    entity.endTime = [content.endTime longLongValue];
                    entity.setNumber = content.seriesNumber;
                    detailVC.watchEntity = entity;
                    detailVC.programId = content.lastProgramId;

                    [self.navigationController pushViewController:detailVC animated:YES];
                }
                
            }
            else if ([content.businessType isEqualToString:@"vod"]){
                
                // 点播
                self.hidesBottomBarWhenPushed = YES;
                SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
                detailVC.videoID = content.objectId;
                if (!self.pUid) {
                    detailVC.videoDatePoint = content.endWatchTime.floatValue;
                }
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
                detailVC.videoDatePoint = content.endWatchTime.floatValue;
                
                [self.navigationController pushViewController:detailVC animated:YES];
            }
            
        }
        }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)showTips{
    if (_recentDic.count>0) {
//        self.tipLab.hidden = YES;
//        self.tipImg.hidden = YES;
        [_noDataView removeFromSuperview];

    }
    else{
//        self.tipLab.hidden = YES;
//        self.tipImg.hidden = YES;
        [self addOrRemoveNoDataView];
        self.deleteView.hidden = YES;
    }
}

-(UIView *)noDataView{

    if (!_noDataView) {
        _noDataView = [UIView new];
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"browsehistory"]];
        [_noDataView addSubview:imageV];


        UILabel *label =[UILabel new];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = 1;
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"您最近没有看过任何影片";
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


    [self.tableView addSubview:self.noDataView];
    [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.tableView);
        make.size.mas_equalTo(CGSizeMake(200, 120));
        make.top.mas_equalTo(self.tableView).offset(120);
    }];
}


@end
