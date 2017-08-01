//
//  SJMultiVideoDetailViewController.m
//  ShiJia
//
//  Created by yy on 16/7/22.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJMultiVideoDetailViewController.h"
#import "SJVideoDetailViewController.h"
#import "SJWatchTVDetailController.h"
#import "SJLiveTVDetailViewController.h"

#import "WatchListEntity.h"
#import "TVProgram.h"
#import "TVStation.h"

@interface SJMultiVideoDetailViewController ()<SJVideoDetailViewControllerDelegate,SJWatchTVDetailControllerDelegate,SJLiveTVDetailViewControllerDelegate>

@property (nonatomic, strong) SJVideoDetailViewController  *vodDetail;
@property (nonatomic, strong) SJWatchTVDetailController    *watchTVDetail;
@property (nonatomic, strong) SJLiveTVDetailViewController *liveTVDetail;

@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, assign) BOOL HiddenStatus;


@end

@implementation SJMultiVideoDetailViewController

#pragma mark - Lifecycle
- (instancetype)initWithVideoType:(SJVideoType)type
{
    self = [super init];
    
    if (self) {
        _videoType = type;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.statusView];
    
    [self setupChildController];

    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:k2StatusStyle animated:YES];
    [self getCurrentOrtainer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChangedAAA:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:k1StatusStyle animated:YES];
    [super viewWillDisappear:animated];

}
- (void)getCurrentOrtainer{
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    if ((orientation == UIDeviceOrientationLandscapeLeft ||  orientation == UIDeviceOrientationLandscapeRight)) {
        
        //横屏
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.HiddenStatus = YES;
        
    }else if(orientation == UIDeviceOrientationPortrait){
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        self.HiddenStatus = NO;
    }
}

- (void)orientationChangedAAA:(NSNotification *)notification{
    // 收到 设备旋转 通知
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    if ((orientation == UIDeviceOrientationLandscapeLeft ||  orientation == UIDeviceOrientationLandscapeRight) && screenSize.width > screenSize.height) {
        self.HiddenStatus = YES;
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        //        [self.view layoutSubviews];
        
        _statusView.hidden = self.HiddenStatus;
        _statusView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
        CGRect FRAME = CGRectMake(0, 20., SCREEN_WIDTH, SCREEN_HEIGHT-20.);
        CGRect FRAME2 = self.view.bounds;
        
        _vodDetail.view.frame =self.HiddenStatus?FRAME2: FRAME;
        _watchTVDetail.view.frame = self.HiddenStatus?FRAME2: FRAME;
        _liveTVDetail.view.frame = self.HiddenStatus?FRAME2: FRAME;
        
    }else if(orientation == UIDeviceOrientationPortrait  && screenSize.width < screenSize.height){
        self.HiddenStatus = NO;

        _statusView.hidden = self.HiddenStatus;
        _statusView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
        CGRect FRAME = CGRectMake(0, 20., SCREEN_WIDTH, SCREEN_HEIGHT-20.);
        CGRect FRAME2 = self.view.bounds;
        
        _vodDetail.view.frame =self.HiddenStatus?FRAME2: FRAME;
        _watchTVDetail.view.frame = self.HiddenStatus?FRAME2: FRAME;;
        _liveTVDetail.view.frame = self.HiddenStatus?FRAME2: FRAME;;
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _statusView.hidden = self.HiddenStatus;
    _statusView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    CGRect FRAME = CGRectMake(0, 20., SCREEN_WIDTH, SCREEN_HEIGHT-20.);
    CGRect FRAME2 = self.view.bounds;
    
    [[UIApplication sharedApplication] setStatusBarHidden:self.HiddenStatus];
    _vodDetail.view.frame =self.HiddenStatus?FRAME2: FRAME;
    _watchTVDetail.view.frame = self.HiddenStatus?FRAME2: FRAME;;
    _liveTVDetail.view.frame = self.HiddenStatus?FRAME2: FRAME;;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    
    return YES;
}

#pragma mark - SJVideoDetailViewControllerDelegate
- (void)vodDetail:(SJVideoDetailViewController *)controller didSelectRecommendItem:(WatchListEntity *)recommendModel
{
    [self handleRecommendItem:recommendModel];
}

#pragma mark - SJWatchTVDetailControllerDelegate
- (void)watchTVDetail:(SJWatchTVDetailController *)controller didSelectRecommendItem:(WatchListEntity *)recommendModel
{
    [self handleRecommendItem:recommendModel];
}

#pragma mark - SJLiveTVDetailViewControllerDelegate
- (void)liveTVDetail:(SJLiveTVDetailViewController *)controller didSelectRecommendItem:(WatchListEntity *)recommendModel
{
    [self handleRecommendItem:recommendModel];
}

#pragma mark -
- (void)handleRecommendItem:(WatchListEntity *)recommendModel
{
    if (recommendModel.setNumber.length > 0) {
        _currentVideoIndex = [recommendModel.setNumber integerValue];
    }
    
    if ([recommendModel.contentType isEqualToString:@"vod"]) {
        
        _videoType = SJVideoTypeVOD;
        _videoID = recommendModel.programSeriesId;
        
    }
    else if ([recommendModel.contentType isEqualToString:@"watchtv"]){
        
        _videoType = SJVideoTypeWatchTV;
        _videoID = recommendModel.categoryId;
        _categoryID = recommendModel.programSeriesId;
        _watchEntity = recommendModel;
    }
    else if ([recommendModel.contentType isEqualToString:@"live"]){
        
        _videoType = SJVideoTypeLive;
        _watchEntity = recommendModel;
        
    }
    else{
        
        _videoType = SJVideoTypeReplay;
        _watchEntity = recommendModel;
        
    }
    
    [self setupChildController];
}

#pragma mark - Setup Child Controller
- (void)setupChildController
{
    switch (_videoType) {
        case SJVideoTypeVOD:
        {
            // 点播
            if (_vodDetail == nil) {
                _vodDetail = [[SJVideoDetailViewController alloc] init];
                _vodDetail.epgName = self.epgName;
                _vodDetail.delegate = self;
                _vodDetail.videoID = _videoID;
                _vodDetail.categoryID = _categoryID;
                _vodDetail.videoDatePoint = _videoDatePoint;
                _vodDetail.currentVideoIndex = self.currentVideoIndex;
                _vodDetail.watchEntity = _watchEntity;
                _vodDetail.programId = self.programId;
                _vodDetail.neededScreen = self.neededScreen;
                [self addChildViewController:_vodDetail];
                [self.view addSubview:_vodDetail.view];
            }
            else{
                _vodDetail.videoID = _videoID;
                _vodDetail.categoryID = _categoryID;
                _vodDetail.videoDatePoint = _videoDatePoint;
                _vodDetail.currentVideoIndex = self.currentVideoIndex;
                _vodDetail.watchEntity = _watchEntity;
                _vodDetail.programId = self.programId;
                _vodDetail.neededScreen = self.neededScreen;
                [_vodDetail clearData];
                [_vodDetail refreshData];
            }
            
            [self clearWatchTVDetail];
            [self clearLiveTVDetail];
            
            [self.view setNeedsLayout];
            
        }
            break;
            
        case SJVideoTypeWatchTV:
        {
            // 看点
            if (_watchTVDetail == nil) {
                _watchTVDetail = [[SJWatchTVDetailController alloc] init];
                _watchTVDetail.epgName = self.epgName;
                _watchTVDetail.delegate = self;
                _watchTVDetail.videoID = _videoID;
                _watchTVDetail.categoryID = _categoryID;
                _watchTVDetail.watchEntity = _watchEntity;
                _watchTVDetail.videoDatePoint = _videoDatePoint;
                _watchTVDetail.programId = self.programId;
                _watchTVDetail.neededScreen = self.neededScreen;
                [self addChildViewController:_watchTVDetail];
                [self.view addSubview:_watchTVDetail.view];
            }
            else{
                _watchTVDetail.videoID = _videoID;
                _watchTVDetail.categoryID = _categoryID;
                _watchTVDetail.watchEntity = _watchEntity;
                _watchTVDetail.videoDatePoint = _videoDatePoint;
                _watchTVDetail.programId = self.programId;
                //_watchTVDetail.seriesNumber = _seriesNumber;
                _watchTVDetail.neededScreen = self.neededScreen;
                [_watchTVDetail clearData];
                [_watchTVDetail refreshData];
            }
            [self clearVODDetail];
            [self clearLiveTVDetail];
            [self.view setNeedsLayout];
            
        }
            break;
            
        case SJVideoTypeLive:
        {
            // 直播
            if (_liveTVDetail == nil) {
                _liveTVDetail = [[SJLiveTVDetailViewController alloc] initWithVideoType:kLiveTVDetailTypeLive];
                _liveTVDetail.epgName = self.epgName;
                _liveTVDetail.delegate = self;
                _liveTVDetail.tvProgram = _tvProgram;
                _liveTVDetail.tvStation = _tvStation;
                _liveTVDetail.LivePlayType =_tvProgram.urlType;
                _liveTVDetail.watchEntity = _watchEntity;
                _liveTVDetail.LivePlayType = @"play";

                _liveTVDetail.videoDatePoint = _videoDatePoint;
                _liveTVDetail.neededScreen = self.neededScreen;
                [self addChildViewController:_liveTVDetail];
                [self.view addSubview:_liveTVDetail.view];
            }
            else{
                _liveTVDetail.videoType = kLiveTVDetailTypeLive;
                _liveTVDetail.tvProgram = _tvProgram;
                _liveTVDetail.tvStation = _tvStation;
                _liveTVDetail.LivePlayType =_tvProgram.urlType;
                _liveTVDetail.watchEntity = _watchEntity;
                _liveTVDetail.LivePlayType = @"play";
                _liveTVDetail.neededScreen = self.neededScreen;
                [_liveTVDetail clearData];
                [_liveTVDetail refreshData];
            }
            [self clearVODDetail];
            [self clearWatchTVDetail];
            [self.view setNeedsLayout];
        }
            break;
        case SJVideoTypeReplay:
        {
            // 回看
            if (_liveTVDetail == nil) {
                _liveTVDetail = [[SJLiveTVDetailViewController alloc] initWithVideoType:kLiveTVDetailTypeReplay];
                _liveTVDetail.epgName = self.epgName;
                _liveTVDetail.delegate = self;
                _liveTVDetail.tvProgram = _tvProgram;
                _liveTVDetail.tvStation = _tvStation;
                _liveTVDetail.LivePlayType = @"replay";
                _liveTVDetail.watchEntity = _watchEntity;
                _liveTVDetail.videoDatePoint = _videoDatePoint;
                _liveTVDetail.neededScreen = self.neededScreen;
                [self addChildViewController:_liveTVDetail];
                [self.view addSubview:_liveTVDetail.view];
            }
            else{
                _liveTVDetail.videoType = kLiveTVDetailTypeReplay;
                _liveTVDetail.tvProgram = _tvProgram;
                _liveTVDetail.tvStation = _tvStation;
                _liveTVDetail.LivePlayType = @"replay";
                _liveTVDetail.watchEntity = _watchEntity;
                _liveTVDetail.neededScreen = self.neededScreen;
                [_liveTVDetail clearData];
                [_liveTVDetail refreshData];
            }
            [self clearVODDetail];
            [self clearWatchTVDetail];
            [self.view setNeedsLayout];
        }
            break;
            
        default:
            break;
    }
}

- (void)clearVODDetail
{
    if (_vodDetail) {
        [_vodDetail removeFromParentViewController];
        [_vodDetail.view removeFromSuperview];
        [_vodDetail clearData];
        _vodDetail = nil;
    }
}

- (void)clearWatchTVDetail
{
    if (_watchTVDetail) {
        [_watchTVDetail removeFromParentViewController];
        [_watchTVDetail.view removeFromSuperview];
        [_watchTVDetail clearData];
        _watchTVDetail = nil;
    }
}

- (void)clearLiveTVDetail
{
    if (_liveTVDetail) {
        [_liveTVDetail removeFromParentViewController];
        [_liveTVDetail.view removeFromSuperview];
        [_liveTVDetail clearData];
        _liveTVDetail = nil;
    }
}

#pragma mark - Setter & Getter
- (UIView *)statusView
{
    if (!_statusView) {
        _statusView=[[UIView alloc]init];
        _statusView.backgroundColor = [UIColor blackColor];
    }
    return _statusView;
}

@end
