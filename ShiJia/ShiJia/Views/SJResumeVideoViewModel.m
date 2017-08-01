//
//  SJResumeVideoViewModel.m
//  ShiJia
//
//  Created by yy on 2017/5/22.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "SJResumeVideoViewModel.h"

#import "SJResumeVideoTipView.h"

#import "UIWindow+PazLabs.h"

#import "SJMultiVideoDetailViewController.h"

#import "WatchListEntity.h"

@interface SJResumeVideoViewModel ()
{
    BOOL resumeSwitch;
    RecentVideo *recentVideo;
    BOOL isTogetherMode;
}
@end

@implementation SJResumeVideoViewModel

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        resumeSwitch = [defaults boolForKey:kResumeVideoSwitchKey];
        
    }
    return self;
    
}

#pragma mark - Operations
- (void)start
{
    // 获取关联设备
//    [[TogetherManager sharedInstance] getDeviceDetectionRequestForCompletion:^(NSArray *devices,NSString *error){
//
//        // 判断是否有关联设备
//        if (devices.count > 0) {
    
            if (resumeSwitch) {
                [self loadLastRecentVideo];
            }
//        }
//    }];
    
}

- (void)loadLastRecentVideo
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    
    //end
    [parameters setValue:@"MOBILE" forKey:@"deviceType"];
    [parameters setValue:T_STBext forKey:@"abilityString"];
    
    
    // 获取最后一条观看记录
    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN forParam:@"/integration/2.0/queryHistory" forParameters:parameters  completion:^(id responseObject) {
        
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSMutableArray *historyList =  [responseDic objectForKey:@"data"];
        NSString *code = [responseDic objectForKey:@"code"];
        
        if (code.intValue == 0 && historyList.count > 0) {
            
            recentVideo = [[RecentVideo alloc] initWithDict:[historyList firstObject]];
            
            // 判断观看时间是否超过一周 && 该节目未提示过 && ![recentVideo.deviceType isEqualToString:@"MOBILE"]
            if (![self checkRecentVideoIsMoreThanOneWeek] && ![self checkRecentVideoIsReminded] && ![recentVideo.deviceType isEqualToString:@"MOBILE"]) {
                
                //设置为已提醒，下次不再提醒
                [self setRecentVideoReminded];
                
//                NSArray *devicelist = [TogetherManager sharedInstance].detectedDevices;
                SJAppdelegateService *service = [AppDelegate appDelegate].appdelegateService;
                HiTVDeviceInfo *deviceEntity = [TogetherManager sharedInstance].connectedDevice;
               
                if ([deviceEntity.state isEqualToString:@"TOGETHER_SAME_NET"]||[deviceEntity.state isEqualToString:@"TOGETHER_DIFF_NET"]) {
                   
                    
                    //回家模式
                    if (service.isMainVCLoaded) {
                        
                        [self showTogetherTipView];
                    }
                    else{
                        isTogetherMode = YES;
                        [service addObserver:self forKeyPath:NSStringFromSelector(@selector(isMainVCLoaded)) options:NSKeyValueObservingOptionNew context:nil];
                    }
                    
                }
                else{
                    //离家模式
                    if (service.isMainVCLoaded) {
                        
                        [self showUntogetherTipView];
                    }
                    else{
                        isTogetherMode = NO;
                        [service addObserver:self forKeyPath:NSStringFromSelector(@selector(isMainVCLoaded)) options:NSKeyValueObservingOptionNew context:nil];
                    }
                    
                }
                
            }
            
        }
    }failure:^(NSString *error) {
        
        
    }];
}

// 判断最后一条历史记录观看时间是否超过一周
- (BOOL)checkRecentVideoIsMoreThanOneWeek
{
    //当前时间戳
    NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
    
    //一周时间戳
    double weekInterval = 7 * 24 * 60 * 60;
    
    //观看记录时间戳
    double dateline = [recentVideo.dateline.description doubleValue];
    
    //时间戳差值
    double subInterval = nowInterval - dateline;
    
    if (subInterval <= weekInterval) {
        //时间未超过一周
        return NO;
    }
    
    return YES;
}

// 检查是否提醒过
- (BOOL)checkRecentVideoIsReminded
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"RecentVideoKey%@",recentVideo.dateline.description];
    return [defaults boolForKey:key];
}

// 设置为已提醒
- (void)setRecentVideoReminded
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"RecentVideoKey%@",recentVideo.dateline.description];
    [defaults setBool:YES forKey:key];
}

#pragma mark - Show Tip View
- (void)showTogetherTipView
{
    //回家模式
    SJResumeVideoTipView *view = [[SJResumeVideoTipView alloc] initWithMode:SJResumeVideoModeTogether recentVideo:recentVideo];
    [view setLeftButtonClickBlock:^{
        //[self setRecentVideoReminded];
        [self gotoVideoDetailWhetherNeededScreen:NO];
    }];
    
    [view setRightButtonClickBlock:^{
        //[self setRecentVideoReminded];
        [self gotoVideoDetailWhetherNeededScreen:YES];
    }];
    [view show];
}

- (void)showUntogetherTipView
{
    //离家模式
    SJResumeVideoTipView *view = [[SJResumeVideoTipView alloc] initWithMode:SJResumeVideoModeUntogether recentVideo:recentVideo];
    [view setLeftButtonClickBlock:^{
        //[self setRecentVideoReminded];
        [self gotoVideoDetailWhetherNeededScreen:NO];
    }];
    [view setRightButtonClickBlock:^{
        //[self setRecentVideoReminded];
        
    }];
    [view show];

}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(isMainVCLoaded))]) {
        if (isTogetherMode) {
            [self showTogetherTipView];
        }
        else{
            [self showUntogetherTipView];
        }
    }
}

#pragma mark -  页面跳转
- (void)gotoVideoDetailWhetherNeededScreen:(BOOL)neededScreen
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIViewController *activecontroller = [delegate.window visibleViewController];
    if (![activecontroller isKindOfClass:[SJMultiVideoDetailViewController class]]) {
        
        if ([recentVideo.businessType isEqualToString:@"watchtv"]) {
            if ([recentVideo.playType isEqualToString:@"live"]) {
                
                // 直播
                activecontroller.hidesBottomBarWhenPushed = YES;
                
                SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeLive];
                detailVC.neededScreen = neededScreen;
                WatchListEntity *watchEntity = [[WatchListEntity alloc]init];
                watchEntity.contentId = recentVideo.lastProgramId;
                watchEntity.channelUuid = recentVideo.objectId;
                watchEntity.startTime = [recentVideo.startTime longLongValue];
                watchEntity.endTime = [recentVideo.endTime longLongValue];
                //watchEntity.categoryId = recentVideo.objectId;
                watchEntity.programSeriesName = recentVideo.lastProgramName;
                watchEntity.deviceType = recentVideo.deviceType;
                
                detailVC.watchEntity = watchEntity;
                // detailVC.videoDatePoint = recentVideo.endWatchTime.floatValue;
                
                [activecontroller.navigationController pushViewController:detailVC animated:YES];
            }
            else if ([recentVideo.playType isEqualToString:@"replay"]){
                
                // 直播
                activecontroller.hidesBottomBarWhenPushed = YES;
                
                SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeReplay];
                detailVC.neededScreen = neededScreen;
                WatchListEntity *watchEntity = [[WatchListEntity alloc]init];
                watchEntity.contentId = recentVideo.lastProgramId;
                watchEntity.channelUuid = recentVideo.objectId;
                watchEntity.startTime = [recentVideo.startTime longLongValue];
                watchEntity.endTime = [recentVideo.endTime longLongValue];
                //watchEntity.categoryId = recentVideo.objectId;
                watchEntity.programSeriesName = recentVideo.lastProgramName;
                watchEntity.deviceType = recentVideo.deviceType;
                detailVC.watchEntity = watchEntity;
                // detailVC.videoDatePoint = recentVideo.endWatchTime.floatValue;
                
                [activecontroller.navigationController pushViewController:detailVC animated:YES];
            }
            else if ([recentVideo.playType isEqualToString:@"vod"]){
                
                // 点播
                activecontroller.hidesBottomBarWhenPushed = YES;
                SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
                detailVC.neededScreen = neededScreen;
                detailVC.videoID = recentVideo.objectId;
            
                WatchListEntity *entity = [[WatchListEntity alloc]init];
                entity.setNumber = recentVideo.seriesNumber;
                detailVC.watchEntity = entity;
                
                [activecontroller.navigationController pushViewController:detailVC animated:YES];
                
            }
            else{
              
                // 看点
                activecontroller.hidesBottomBarWhenPushed = YES;
                SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeWatchTV];
                detailVC.neededScreen = neededScreen;
                detailVC.videoID = recentVideo.assortId;
                detailVC.categoryID = recentVideo.objectId;
                
                
                WatchListEntity *entity = [[WatchListEntity alloc]init];
                entity.programSeriesId = recentVideo.objectId;
                entity.categoryId = recentVideo.assortId;
                entity.contentId = recentVideo.lastProgramId;
                entity.programSeriesName = recentVideo.objectName;
                entity.startTime = [recentVideo.startTime longLongValue];
                entity.endTime = [recentVideo.endTime longLongValue];
                entity.setNumber = recentVideo.seriesNumber;
                detailVC.watchEntity = entity;
                detailVC.programId = recentVideo.lastProgramId;
                
                [activecontroller.navigationController pushViewController:detailVC animated:YES];
            }
            
        }
        else if ([recentVideo.businessType isEqualToString:@"vod"]){
            
            // 点播
            activecontroller.hidesBottomBarWhenPushed = YES;
            SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
            detailVC.neededScreen = neededScreen;
            detailVC.videoID = recentVideo.objectId;
            
            WatchListEntity *entity = [[WatchListEntity alloc]init];
            entity.setNumber = recentVideo.seriesNumber;
            detailVC.watchEntity = entity;
            
            [activecontroller.navigationController pushViewController:detailVC animated:YES];
            
        }
        else if ([recentVideo.businessType isEqualToString:@"livereplay"]){
            
            // 直播
            activecontroller.hidesBottomBarWhenPushed = YES;
            
            SJMultiVideoDetailViewController *detailVC ;
            
            if ([recentVideo.playType isEqualToString:@"replay"]) {
                detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeReplay];
            }
            else{
                detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeLive];
            }
            detailVC.neededScreen = neededScreen;
            WatchListEntity *watchEntity = [[WatchListEntity alloc]init];
            watchEntity.contentId = recentVideo.lastProgramId;
            if ([recentVideo.playType isEqualToString:@"vod"]) {
                watchEntity.programSeriesId = recentVideo.objectId;
            }
            else{
                watchEntity.channelUuid = recentVideo.objectId;
            }
            watchEntity.startTime = [recentVideo.startTime longLongValue];
            watchEntity.endTime = [recentVideo.endTime longLongValue];
            //watchEntity.categoryId = recentVideo.objectId;
            watchEntity.programSeriesName = recentVideo.lastProgramName;
            watchEntity.deviceType = recentVideo.deviceType;
            detailVC.watchEntity = watchEntity;
            detailVC.videoDatePoint = recentVideo.endWatchTime.floatValue;
            
            [activecontroller.navigationController pushViewController:detailVC animated:YES];
        }
        
        activecontroller.hidesBottomBarWhenPushed = NO;
        
    }
    else{
        if ([recentVideo.businessType isEqualToString:@"watchtv"]) {
            if ([recentVideo.playType isEqualToString:@"live"]) {
                
                
                
                SJMultiVideoDetailViewController *detailVC = (SJMultiVideoDetailViewController *)activecontroller;
                detailVC.videoType = SJVideoTypeLive;
                detailVC.neededScreen = neededScreen;
                WatchListEntity *watchEntity = [[WatchListEntity alloc]init];
                watchEntity.contentId = recentVideo.lastProgramId;
                watchEntity.channelUuid = recentVideo.objectId;
                watchEntity.startTime = [recentVideo.startTime longLongValue];
                watchEntity.endTime = [recentVideo.endTime longLongValue];
                //watchEntity.categoryId = recentVideo.objectId;
                watchEntity.programSeriesName = recentVideo.lastProgramName;
                watchEntity.deviceType = recentVideo.deviceType;
                
                detailVC.watchEntity = watchEntity;
                // detailVC.videoDatePoint = recentVideo.endWatchTime.floatValue;
                
                [detailVC setupChildController];
            }
            else if ([recentVideo.playType isEqualToString:@"replay"]){
                
                // 直播
                SJMultiVideoDetailViewController *detailVC = (SJMultiVideoDetailViewController *)activecontroller;
                detailVC.videoType = SJVideoTypeReplay;
                detailVC.neededScreen = neededScreen;
                WatchListEntity *watchEntity = [[WatchListEntity alloc]init];
                watchEntity.contentId = recentVideo.lastProgramId;
                watchEntity.channelUuid = recentVideo.objectId;
                watchEntity.startTime = [recentVideo.startTime longLongValue];
                watchEntity.endTime = [recentVideo.endTime longLongValue];
                //watchEntity.categoryId = recentVideo.objectId;
                watchEntity.programSeriesName = recentVideo.lastProgramName;
                watchEntity.deviceType = recentVideo.deviceType;
                detailVC.watchEntity = watchEntity;
                // detailVC.videoDatePoint = recentVideo.endWatchTime.floatValue;
                
                [detailVC setupChildController];
            }
            else if ([recentVideo.playType isEqualToString:@"vod"]){
                
                // 点播
                SJMultiVideoDetailViewController *detailVC = (SJMultiVideoDetailViewController *)activecontroller;
                detailVC.videoType = SJVideoTypeVOD;
                detailVC.neededScreen = neededScreen;
                detailVC.videoID = recentVideo.objectId;
                
                WatchListEntity *entity = [[WatchListEntity alloc]init];
                entity.setNumber = recentVideo.seriesNumber;
                detailVC.watchEntity = entity;
                
                [detailVC setupChildController];
                
            }
            else{
                
                // 看点
                SJMultiVideoDetailViewController *detailVC = (SJMultiVideoDetailViewController *)activecontroller;
                detailVC.videoType = SJVideoTypeWatchTV;
                detailVC.neededScreen = neededScreen;
                detailVC.videoID = recentVideo.assortId;
                detailVC.categoryID = recentVideo.objectId;
                
                
                WatchListEntity *entity = [[WatchListEntity alloc]init];
                entity.programSeriesId = recentVideo.objectId;
                entity.categoryId = recentVideo.assortId;
                entity.contentId = recentVideo.lastProgramId;
                entity.programSeriesName = recentVideo.objectName;
                entity.startTime = [recentVideo.startTime longLongValue];
                entity.endTime = [recentVideo.endTime longLongValue];
                entity.setNumber = recentVideo.seriesNumber;
                detailVC.watchEntity = entity;
                detailVC.programId = recentVideo.lastProgramId;
                
                [detailVC setupChildController];
            }
            
        }
        else if ([recentVideo.businessType isEqualToString:@"vod"]){
            
            // 点播
            SJMultiVideoDetailViewController *detailVC = (SJMultiVideoDetailViewController *)activecontroller;
            detailVC.videoType = SJVideoTypeVOD;
            detailVC.neededScreen = neededScreen;
            detailVC.videoID = recentVideo.objectId;
            
            WatchListEntity *entity = [[WatchListEntity alloc]init];
            entity.setNumber = recentVideo.seriesNumber;
            detailVC.watchEntity = entity;
            
            [detailVC setupChildController];
            
        }
        else if ([recentVideo.businessType isEqualToString:@"livereplay"]){
            
            // 直播
            
            SJMultiVideoDetailViewController *detailVC = (SJMultiVideoDetailViewController *)activecontroller;
            
            if ([recentVideo.playType isEqualToString:@"replay"]) {
                detailVC.videoType = SJVideoTypeReplay;
            }
            else{
                detailVC.videoType = SJVideoTypeLive;
            }
            detailVC.neededScreen = neededScreen;
            WatchListEntity *watchEntity = [[WatchListEntity alloc]init];
            watchEntity.contentId = recentVideo.lastProgramId;
            if ([recentVideo.playType isEqualToString:@"vod"]) {
                watchEntity.programSeriesId = recentVideo.objectId;
            }
            else{
                watchEntity.channelUuid = recentVideo.objectId;
            }
            watchEntity.startTime = [recentVideo.startTime longLongValue];
            watchEntity.endTime = [recentVideo.endTime longLongValue];
            //watchEntity.categoryId = recentVideo.objectId;
            watchEntity.programSeriesName = recentVideo.lastProgramName;
            watchEntity.deviceType = recentVideo.deviceType;
            detailVC.watchEntity = watchEntity;
            detailVC.videoDatePoint = recentVideo.endWatchTime.floatValue;
            
            [detailVC setupChildController];
        }

    }
}
@end
