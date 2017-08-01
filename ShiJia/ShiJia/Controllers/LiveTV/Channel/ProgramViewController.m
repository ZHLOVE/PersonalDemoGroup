//
//  Program ViewController.m
//  HiTV
//
//  Created by 蒋海量 on 15/1/20.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "ProgramViewController.h"
#import "TVDataProvider.h"
#import "TVDetailDateViewController.h"
//#import "VideoPlayerKit.h"
#import "TVStationDetail.h"
#import "TVStation.h"
#import "MBProgressHUD.h"
#import "LocalTVStationManager.h"

#import "SJMultiVideoDetailViewController.h"
#import "SJLiveTVDetailViewController.h"

NSString * const kPushLiveTVControllerNotification = @"PushLiveTVControllerNotification";

@interface ProgramViewController ()

@property (nonatomic, strong) NSArray* tvDateArray;
@property (nonatomic, strong) TVDetailDateViewController* detailDateController;

@property (nonatomic, strong) NSArray* playableListArray;
@property (nonatomic, strong) TVProgram* currentPlayingProgram;
@property (nonatomic) BOOL isOnline;

@property (nonatomic, strong) NSDate* lastRefreshDate;
@end

@implementation ProgramViewController

- (instancetype)initWithTVStation:(TVStation*)station{
    self = [super init];
    if (self) {
        self.station = station;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.hidesBottomBarWhenPushed = YES;
    self.detailDateController = [[TVDetailDateViewController alloc] init];
    self.detailDateController.view.backgroundColor = [UIColor whiteColor];
    self.detailCategoryController = self.detailDateController;
    [self addChildViewController:self.detailCategoryController];

    [self refashProgramList];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self playFinished];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_playProgramFromNotification:)
                                                 name:[HiTVConstants HiTVConstantsPlayNotificationName]
                                               object:nil];
    
    if (self.tvDateArray && self.lastRefreshDate && [[NSDate date] timeIntervalSinceDate:self.lastRefreshDate] > 60 * 5) {
        [self p_refreshProgramList];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[HiTVConstants HiTVConstantsPlayNotificationName]
                                                  object:nil];
}
-(void)refashProgramList
{
    self.title = self.station.channelName;
    
    __weak typeof(self) weakSelf = self;
    //MBProgressHUD* HUD = [MBProgressHUD showHUDAddedTo:self.detailDateController.view animated:YES];
    //HUD.labelText = @"加载中...";
    [[TVDataProvider sharedInstance] getProgramListForUUID:self.station.uuid
                                                completion:^(id responseObject) {
                                                   weakSelf.tvDateArray = (NSArray*)responseObject;
      //                                              [MBProgressHUD hideHUDForView:self.detailDateController.view animated:YES];
                                                } failure:^(NSString *error) {
        //                                            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                    [weakSelf p_handleNetworkError];
                                                }];
}
- (void)setTvDateArray:(NSArray *)tvDateArray{
    _tvDateArray = tvDateArray;
    self.lastRefreshDate = [NSDate date];
    self.detailDateController.uuid = self.station.uuid;
    self.detailDateController.tvDateListArray = self.tvDateArray;
}

- (void)p_playProgramFromNotification:(NSNotification*)notification{
    [self p_playProgram:notification.userInfo[[HiTVConstants HiTVConstantsPlayNotificationVideo]]
                 inList:notification.userInfo[[HiTVConstants HiTVConstantsPlayNotificationVideoList]]
                 fromUI:YES];
    
}

- (void)p_playProgram:(TVProgram*)program inList:(NSArray*)list fromUI:(BOOL)user{
    [[LocalTVStationManager sharedInstance] addVisitedStation:self.station];
    self.playableListArray = list;
    self.currentPlayingProgram = program;
    self.isOnline = [program canPlay];
    program.uuid = self.station.uuid;
    [self playVideo:program.programUrl andTitle:self.station.channelName andTVProgram:program isStreaming:self.isOnline];
    if (!user) {
        [self p_selectCurrentPlayingProgram];
    }
}

- (void)p_refreshProgramList{
    __weak typeof(self) weakSelf = self;
    [[TVDataProvider sharedInstance] getProgramListForUUID:self.station.uuid
                                                completion:^(id responseObject) {
                                                    weakSelf.tvDateArray = responseObject;
                                                } failure:^(NSString *error) {
                                                }];
    
}

- (void)p_selectCurrentPlayingProgram{
    __weak TVDetailDateViewController* controller = self.detailDateController;
    [self  dispatchDelayed:^{
        [controller selectProgram:self.currentPlayingProgram ForList:self.playableListArray];
    }];
    
}

- (void)playVideo:(NSString *)url andTitle:(NSString *)title andTVProgram:(id)tvProgram isStreaming:(BOOL)isStreaming
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPushLiveTVControllerNotification object:self];
    
    TVProgram *data = (TVProgram *)tvProgram;
    SJMultiVideoDetailViewController *liveVC ;
    if ([data.mediaType isEqualToString:@"live"]) {
        liveVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeLive];
    }
    else{
        liveVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeReplay];
    }
    liveVC.tvProgram = tvProgram;
    liveVC.tvStation = self.station;

    [self.navigationController pushViewController:liveVC animated:YES];
}

#pragma mark - VideoPlayerDelegate
- (BOOL)hasNextVideo{
    NSUInteger index = [self.playableListArray indexOfObject:self.currentPlayingProgram];
    if (index != NSNotFound && index < self.playableListArray.count - 1) {
        TVProgram* program = self.playableListArray[index + 1];
        return program.canPlay || program.canReplay;
    }
    return NO;
}
- (BOOL)hasPrevVideo{
    NSUInteger index = [self.playableListArray indexOfObject:self.currentPlayingProgram];
    if (index != NSNotFound && index > 0) {
        TVProgram* program = self.playableListArray[index - 1];
        return program.canPlay || program.canReplay;
    }
    return NO;
}
- (void)playNextVideo{
    NSUInteger index = [self.playableListArray indexOfObject:self.currentPlayingProgram];
    if (index != NSNotFound && index < self.playableListArray.count - 1) {
        TVProgram* program = self.playableListArray[index + 1];
        [self p_playProgram:program
                     inList:self.playableListArray
                     fromUI:NO];
    }
}
- (void)playPrevVideo{
    NSUInteger index = [self.playableListArray indexOfObject:self.currentPlayingProgram];
    if (index != NSNotFound && index > 0) {
        TVProgram* program = self.playableListArray[index - 1];
        [self p_playProgram:program
                     inList:self.playableListArray
                     fromUI:NO];
    }
}

@end
