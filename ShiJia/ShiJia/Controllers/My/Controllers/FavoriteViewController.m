//
//  FavoriteViewController.m
//  ShiJia
//
//  Created by 蒋海量 on 16/6/29.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "FavoriteViewController.h"
#import "BaseAFHTTPManager.h"
#import "RecentVideo.h"
#import "JSON.h"
#import "RecentTableViewCell.h"
#import "OMGToast.h"
#import "WatchListEntity.h"

#import "SJMultiVideoDetailViewController.h"


@interface FavoriteViewController ()<RecentTableViewCellDelegate>
@property (nonatomic, strong) NSMutableArray *favoriteArray;
@property (nonatomic, strong) NSArray *allKeys;

@end

@implementation FavoriteViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.tipLab.text = @"您最近没有收藏过任何影片";
    self.tipImg.image = [UIImage imageNamed:@"browsecollection"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self batchQueryHistory];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"next" object:nil];
    
}

- (void)setFavoriteArray:(NSMutableArray *)favoriteArray
{
    _favoriteArray = favoriteArray;
    if (_favoriteArray.count > 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editView];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    [self showTips];
    [self.tableView reloadData];
}
#pragma mark - 刷新UI
-(void)refreshHistory{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.0/*延迟执行时间*/ * NSEC_PER_SEC));
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
    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN forParam:@"/integration/2.0/queryCollection" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSArray *historyList =  [responseDic objectForKey:@"data"];
        NSString *code = [responseDic objectForKey:@"code"];
        if (code.intValue == 0) {
            NSMutableArray *ary = [NSMutableArray array];
            for (NSDictionary *dic in historyList) {
                [ary addObject:[[RecentVideo alloc]initWithDict:dic]];
            }
            self.favoriteArray  = ary;
        }
    }failure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf p_handleNetworkError];
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
    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN forParam:@"/integration/2.0/deleteCollection" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        //重新查询
        NSString *code = [responseObject objectForKey:@"code"];
        if (code.intValue == 0) {
          //  [self refreshHistory];
            [weakSelf.favoriteArray removeObject:video];
            [self.tableView reloadData];
        }
        [self showTips];
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
    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN forParam:@"/integration/2.0/deleteCollection" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSString *code = [responseObject objectForKey:@"code"];
        if (code.intValue == 0) {
            self.navigationItem.rightBarButtonItem = nil;
            [self setEditing:NO animated:YES];
            //[self refreshHistory];
            weakSelf.favoriteArray = nil;

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
    int a = [dataPoint intValue]/1000;
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
        [timeStr appendString:@"0秒"];
    }
    return timeStr;
}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
       return 95.;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.favoriteArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"RecentTableViewCell";
    RecentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:@"cell"];
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.watchTime.hidden = YES;
    cell.m_delegate = self;
    RecentVideo *video = self.favoriteArray[indexPath.row];
    cell.recentVideo = video;
    cell.titleLab.text = video.objectName;
    
    if (video.lastProgramName.length == 0 ||[video.playType isEqualToString:@"vod"]) {
        cell.titleLab.font = [UIFont boldSystemFontOfSize:16.0f];
        cell.titleLab.textColor = kLiveColor;
    }
    else{
        cell.titleLab.font = [UIFont systemFontOfSize:12.0f];
        cell.titleLab.textColor = [UIColor lightGrayColor];
        cell.videoName.text = video.lastProgramName;
    }
    if ([video.businessType isEqualToString:@"livereplay"]&&(![video.playType isEqualToString:@"vod"])) {
        [cell.fWatchTime setText:video.duration];
        cell.fWatchTime.hidden = NO;
    }
    else{
        cell.fWatchTime.hidden = YES;
    }
    if (video.bannerImg.length == 0) {
        [cell.fitVideoImg setImageWithURL:[NSURL URLWithString: video.verticalImg] placeholderImage:[UIImage imageNamed:@"loadingImage"]];    
    }
    else{
    [cell.fitVideoImg setImageWithURL:[NSURL URLWithString: video.bannerImg] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
    }
    //[cell.fitVideoImg setImageWithURL:[NSURL URLWithString: video.bannerImg] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
    
   // [cell.watchTime setText:[NSString stringWithFormat:@"观看到%@",[self getWatchTimeFromDatePoint:video.endWatchTime]]];
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
      //  RecentTableViewCell *cell = (RecentTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    }
    else{
        RecentVideo*content = self.favoriteArray[indexPath.row];
        if (content.expired.intValue != 0) {
            [self deleteHistory:content];
            
        }else{
            if ([content.businessType isEqualToString:@"watchtv"]) {
                // 看点
                if ([content.playType isEqualToString:@"live"]) {
                    self.hidesBottomBarWhenPushed = YES;
                    SJMultiVideoDetailViewController *detailVC =detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeLive];
                    
                    WatchListEntity *watchEntity = [[WatchListEntity alloc]init];
                    watchEntity.contentId = content.lastProgramId;
                    watchEntity.channelUuid = content.objectId;

                    watchEntity.startTime = [content.startTime longLongValue];
                    watchEntity.endTime = [content.endTime longLongValue];
                    //watchEntity.categoryId = content.objectId;
                    watchEntity.programSeriesName = content.lastProgramName;
                    watchEntity.deviceType = content.deviceType;
                    
                    detailVC.watchEntity = watchEntity;
                    
                    [self.navigationController pushViewController:detailVC animated:YES];
                    // }
                    
                }
                else if ([content.playType isEqualToString:@"replay"]){
                    // 回看
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
                    
                    [self.navigationController pushViewController:detailVC animated:YES];
                    
                }
                else{
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
                    
                    detailVC.watchEntity = entity;
                    
                    [self.navigationController pushViewController:detailVC animated:YES];
                }
                
            }
            else if ([content.businessType isEqualToString:@"vod"]){
                // 点播
                self.hidesBottomBarWhenPushed = YES;
                SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
                detailVC.videoID = content.objectId;

                [self.navigationController pushViewController:detailVC animated:YES];
                
            }
            else if ([content.businessType isEqualToString:@"livereplay"]){
                // 直播
                /* if ([content.playType isEqualToString:@"vod"]) {
                 self.hidesBottomBarWhenPushed = YES;
                 SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeWatchTV];
                 detailVC.videoID = content.assortId;
                 detailVC.categoryID = content.objectId;
                 WatchListEntity *entity = [[WatchListEntity alloc]init];
                 entity.programSeriesId = content.objectId;
                 entity.categoryId = content.assortId;
                 entity.contentId = content.lastProgramId;
                 entity.businessType = content.businessType;
                 entity.programSeriesName = content.objectName;
                 entity.startTime = [content.startTime longLongValue];
                 entity.endTime = [content.endTime longLongValue];
                 
                 detailVC.watchEntity = entity;
                 
                 [self.navigationController pushViewController:detailVC animated:YES];
                 }
                 else{*/
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
                
                [self.navigationController pushViewController:detailVC animated:YES];
                // }
                
            }
        }
        }
        
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)showTips{
    if (_favoriteArray.count>0) {
        self.tipLab.hidden = YES;
        self.tipImg.hidden = YES;
    }
    else{
        self.tipLab.hidden = NO;
        self.tipImg.hidden = NO;
        self.deleteView.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
    }

    
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
