//
//  SJLiveTVDetailViewController.m
//  ShiJia
//
//  Created by yy on 16/6/17.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//  直播详情页

#import "SJLiveTVDetailViewController.h"
#import "YYKit.h"

#import "TPIMUser.h"

#import "SJLiveTVViewModel.h"

#import "SJVideoPlayerKit.h"
#import "SJVideoPlayerView.h"
#import "SJVideoDetailSegmentedControl.h"
#import "SJLiveTVVideoDetailMainView.h"
#import "SJPrivateChatRoomMainView.h"
#import "SJVideoToolView.h"
#import "SJVideoRecommendView.h"
#import "SJPublicChatRoomMainView.h"
#import "SJLiveTVProgramView.h"
#import "TPIMAlertView.h"
#import "TPPrivateMUCInputView.h"
#import "TPPublicMUCInputView.h"

#import "TPDanmakuData.h"
#import "TPXmppRoomManager.h"
#import "TVStation.h"
#import "TVProgram.h"
#import "TPIMContentModel.h"
#import "ScreenManager.h"
#import "SJLiveTVCollcetModel.h"
#import "SJPortraitShareView.h"
#import "SJShareVideoViewModel.h"
#import "SJShareVideoViewController.h"
#import "SJLoginViewController.h"
#import "SJGuestYouLikeViewController.h"
#import "SJHitTestView.h"
#import "SJPayViewController.h"
#import "SJVIPViewController.h"
#import "SJRemoteControlViewController.h"
#import "SJShareManager.h"
#import "SJShareMessage.h"
#import "AlbumShareView.h"
#import "SJDLNAListViews.h"
#import "ShareAppViewController.h"
#import "QRCodeController.h"
#import "HWVideoModel.h"
#import "HWOauthManager.h"
#import "SJAdViewModel.h"

static NSInteger kAnimationDuration  = 0.3;
static CGFloat   kSegmentecControlHeight = 40.0;
//static CGFloat   kInnerSpacing = 10.0;

@interface SJLiveTVDetailViewController ()<SJVideoPlayerDelegate,SJVideoToolViewDelegate,SJShareDelegate,guestDelegate,PhotoShareDelegate,DLNAViewDelegate>
{

    SJHitTestView *mainView;//用于详情view与聊天室view的切换

    NSInteger lastSelectedIndex;//分段开关上一次选中索引
    NSMutableArray *videos;// 视频array

    //add by jhl 20160702
    NSTimer *verTimer;//计时器
    NSInteger currentVideoIndex;

    SJGuestYouLikeViewController *guestVC;

    __block NSString *localeDateStr;
    __block float current;
    SJShareManager *shareManager;

    long  second;//当前观看时长
    SJAdViewModel *adViewModel;

}


@property (nonatomic, strong) SJLiveTVViewModel              *viewModel;
@property (nonatomic, strong) SJVideoPlayerKit               *player;              //播放器
@property (nonatomic, strong) SJVideoToolView                *toolView;
@property (nonatomic, strong) SJVideoDetailSegmentedControl  *segmentedControl;    //分段开关
@property (nonatomic, strong) SJLiveTVVideoDetailMainView    *videoDetailView;     //视频详情主view
@property (nonatomic, strong) SJPrivateChatRoomMainView      *privateChatRoomView; //私聊 聊天室主view
@property (nonatomic, strong) SJPublicChatRoomMainView       *publicChatRoomView;  //群聊 聊天室主view
@property (nonatomic, strong) ScreenManager                  *screenManager;
@property (nonatomic, strong) SJPortraitShareView            *shareView;
@property (nonatomic, strong) ShareAlertView                 *shareAlertView;
@property (nonatomic, strong) NSArray                        *programArray;        //选集列表

@property (nonatomic, strong) NSMutableArray                 *recommendList;       //猜您喜欢
@property (nonatomic, assign) BOOL                            noDetail;
@property (nonatomic, strong) NSMutableArray *productArray;     //收费购买产品信息
@property (nonatomic, strong) AlbumShareView                 *shareListView;
@property (nonatomic, strong) SJDLNAListViews                *DLNAListView;

@end

@implementation SJLiveTVDetailViewController

#pragma mark - Lifecycle
- (instancetype)initWithVideoType:(kLiveTVDetailType)videotype
{
    self = [super init];

    if (self) {
        
        _videoType = videotype;

        __weak __typeof(self)weakSelf = self;
        adViewModel = [[SJAdViewModel alloc] initWithActiveController:self];
        [adViewModel setLoadAdFailedBlock:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您未关联电视设备，先打开“扫一扫”页面进行关联！" message:nil delegate:strongSelf cancelButtonTitle:@"前往扫一扫" otherButtonTitles:@"取消", nil];
            alert.tag=1001;
            [alert show];
        }];
        
        _viewModel = [[SJLiveTVViewModel alloc] init];

        // 播放器
        _player = [[SJVideoPlayerKit alloc] init];
        _player.delegate = self;
        _player.activeController = self;
        _player.userAgent = @"010121###MOBILE";
        _videoDatePoint = 0;
        [_player setDidClickBack:^{
            // 返回
            NSString* playerError = [[NSUserDefaults standardUserDefaults] objectForKey:kPlayerError];

            if (playerError == nil) {
                playerError = @"no";
            }

            __strong __typeof(weakSelf)strongSelf = weakSelf;

            //DDLogInfo(@"%@", strongSelf.tabBarController.tabBar.selectedItem.title);
            //strongSelf.tabBarController.selectedIndex
            NSString* content = [NSString stringWithFormat:@"id=%@&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&programtypename=%@&tag=%@&firstsource=%@&epgname=%@&playPoint=%.2f&Url=%@&BuffCount=%ld&BuffAverTimeCost=%f&startTime=%@&endTime=%@&PlayTotalTimeCost=%.2f&playstream=%lld&error=%@", isNullString(strongSelf.watchEntity.contentId), ((long)strongSelf.videoType == kLiveTVDetailTypeLive? @"直播": @"回看"),isNullString(strongSelf.tvStation.uuid),isNullString(strongSelf.watchEntity.programSeriesId),[NSString stringWithFormat:@"%d",(int)strongSelf.tvProgram.programId],isNullString(strongSelf.watchEntity.programSeriesName),isNullString(strongSelf.tvProgram.programName),isNullString(strongSelf.watchEntity.programSeriesType), isNullString(strongSelf.tvProgram.mediaType), isNullString(strongSelf.tabBarController.tabBar.selectedItem.title),isNullString(strongSelf.epgName), strongSelf.player.videoStartFrom, isNullString(strongSelf.tvProgram.programUrl), (long)strongSelf.player.countBuffer,strongSelf.player.avgTotalBuffer, isNullString(strongSelf->localeDateStr), [Utils getCurrentTime], strongSelf.player.videoDuration,[strongSelf.player getReceivedBytes], isNullString(playerError)];

            [Utils BDLog:1 module:@"604" action:@"AppPlayQos" content:content];
            [strongSelf popViewController];
        }];


        [_player setDidClickDanmu:^(BOOL showBarrage) {
            // 弹幕开关
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            TPIMContentModel *model = [[TPIMContentModel alloc] init];
            if (showBarrage) {
                model.action = @"open";
            }
            else{
                model.action = @"close";
            }
            model.playerType = @"danmuSwitch";
            [strongSelf.screenManager remoteNetVideoWithContentModel:model];
        }];

        // 播放器当前播放时长
        [RACObserve(_player, currentPlayedSeconds) subscribeNext:^(NSNumber *secondsNum) {
            [TPXmppRoomManager defaultManager].currentPlayedSeconds = [secondsNum floatValue];

            static int lastVal = 0;
            int val = (int)[TPXmppRoomManager defaultManager].currentPlayedSeconds;

            if (val % (60 * 5) == 0 && val != 0 && lastVal != val) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                strongSelf->current = [secondsNum floatValue];
                DDLogInfo(@"当前已播放: %.2f",strongSelf->current);

                NSString* content = [NSString stringWithFormat:@"curstatus=%@&time=%0.2f&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@", (long)strongSelf.videoType == kLiveTVDetailTypeLive? @"直播": @"回看",strongSelf->current, isNullString(strongSelf.tvStation.uuid),isNullString(strongSelf.watchEntity.programSeriesId),[NSString stringWithFormat:@"%d",(int)strongSelf.tvProgram.programId],isNullString(strongSelf.watchEntity.programSeriesName),isNullString(strongSelf.tvProgram.programName)];
                [Utils BDLog:1 module:@"603" action:@"AppCheckPoint" content:content];
            }

            lastVal = val;
        }];

        [RACObserve(_player, currentVideoIndex) subscribeNext:^(NSNumber *x) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf->currentVideoIndex != [x integerValue]) {
                strongSelf->currentVideoIndex = [x integerValue];
                _videoDetailView.seriesTableView.currentVideoIndex = currentVideoIndex;
                TVProgram *program = strongSelf.programArray [strongSelf->currentVideoIndex];
                [strongSelf getHWPlayUrl:program.programUrl];

                [TPXmppRoomManager defaultManager].tvProgram = program;
                strongSelf.player.view.title = program.programName;

                [self queryPriceRequest];
                [self addHistort:@"start"];

            }

        }];

        [RACObserve(_player, actionUrl) subscribeNext:^(id x) {
            if (guestVC) {
                [guestVC.view removeFromSuperview];
                guestVC = nil;
            }
        }];

        // 投屏、分享、收藏view
        _toolView = [[SJVideoToolView alloc] init];
        _toolView.delegate = self;


        if (videotype == kLiveTVDetailTypeLive) {
            //直播
            _player.view.showDanmuSwitch = YES;
            // 分段开关
#ifndef BeiJing
            _segmentedControl = [[SJVideoDetailSegmentedControl alloc] initWithItems:@[@"详情",@"广场",@"私聊"]];
            // 群聊 聊天室view
            _publicChatRoomView = [[SJPublicChatRoomMainView alloc] init];
            _publicChatRoomView.activeController = self;
            _publicChatRoomView.backgroundColor = kColorLightGrayBackground;
            _publicChatRoomView.inputView.iflyManager = _viewModel;

            [_publicChatRoomView setPublicRoomDidReceiveDanmuData:^(TPDanmakuData *data) {

                __strong __typeof(weakSelf)strongSelf = weakSelf;;
                [strongSelf.player.view sendBarrage:data];
                [strongSelf screenDanmuData:data];


                if (data&& data.isSender) {
                    // add log.
                    NSString* content = [NSString stringWithFormat:@"type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&actiontype=%@",(long)strongSelf.videoType == kLiveTVDetailTypeLive? @"直播": @"回看",isNullString(strongSelf.tvStation.uuid),isNullString(strongSelf.watchEntity.programSeriesId),[NSString stringWithFormat:@"%d",(int)strongSelf.tvProgram.programId],isNullString(strongSelf.watchEntity.programSeriesName),isNullString(strongSelf.tvProgram.programName),@"广场"];
                    [Utils BDLog:1 module:@"605" action:@"PrivateMessage" content:content];
                    // add log.
                }
            }];
            [RACObserve(_publicChatRoomView, beyonded) subscribeNext:^(NSNumber *x) {
                mainView.beyonded = x.boolValue;
            }];
            
            @weakify(self)
            //聊天室开始播放语音，关闭播放器声音
            [_publicChatRoomView setVoiceMessageWillStartPlay:^{
                @strongify(self)
                [self.player mutePlayer];
            }];
            
            //聊天室语音播放结束，恢复播放器声音
            [_publicChatRoomView setVoiceMessageDidFinishPlaying:^{
                @strongify(self)
                [self.player recoverPlayerVolume];
            }];

#else
            _segmentedControl = [[SJVideoDetailSegmentedControl alloc] initWithItems:@[@"详情",@"私聊"]];
#endif
            
        }
        else{
            //回看
            _player.view.showDanmuSwitch = NO;
            _segmentedControl = [[SJVideoDetailSegmentedControl alloc] initWithItems:@[@"详情",@"私聊"]];
        }

        _segmentedControl.activeController = self;
        [_segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];

        lastSelectedIndex = _segmentedControl.selectedSegmentIndex;

        // main view
        mainView = [[SJHitTestView alloc] init];
        mainView.backgroundColor = kColorLightGrayBackground;

        //私聊  聊天室view
        _privateChatRoomView = [[SJPrivateChatRoomMainView alloc] init];
        _privateChatRoomView.backgroundColor = kColorLightGrayBackground;
        _privateChatRoomView.activeController = self;
        _privateChatRoomView.inputView.iflyManager = _viewModel;
        [_privateChatRoomView setPrivateRoomDidReceiveDanmuData:^(TPDanmakuData *data) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;;

            if (data&&data.isSender) {

                // add log.
                NSString* content = [NSString stringWithFormat:@"type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&actiontype=%@",(long)strongSelf.videoType == kLiveTVDetailTypeLive? @"直播": @"回看",isNullString(strongSelf.tvStation.uuid),isNullString(strongSelf.watchEntity.programSeriesId),[NSString stringWithFormat:@"%d",(int)strongSelf.tvProgram.programId],isNullString(strongSelf.watchEntity.programSeriesName),isNullString(strongSelf.tvProgram.programName),@"私聊"];
                [Utils BDLog:1 module:@"605" action:@"PrivateMessage" content:content];
                // add log.

            }
            [strongSelf.player.view sendBarrage:data];
            [strongSelf screenDanmuData:data];
        }];

        [RACObserve(_privateChatRoomView, beyonded) subscribeNext:^(NSNumber *x) {
            mainView.beyonded = x.boolValue;
        }];

        @weakify(self)
        //聊天室开始播放语音，关闭播放器声音
        [_privateChatRoomView setVoiceMessageWillStartPlay:^{
            @strongify(self)
            [self.player mutePlayer];
        }];
        
        //聊天室语音播放结束，恢复播放器声音
        [_privateChatRoomView setVoiceMessageDidFinishPlaying:^{
            @strongify(self)
            [self.player recoverPlayerVolume];
        }];
        
        // 详情view
        _videoDetailView = [[SJLiveTVVideoDetailMainView alloc] init];
        _videoDetailView.backgroundColor = kColorLightGrayBackground;

        // 选集
        [_videoDetailView.seriesTableView setDidSelectItemAtIndex:^(NSInteger index) {

            __strong __typeof(weakSelf)strongSelf = weakSelf;;
            strongSelf->currentVideoIndex = index;
            strongSelf.player.currentVideoIndex = strongSelf->currentVideoIndex;
            strongSelf.player.view.currentVideoIndex = strongSelf->currentVideoIndex;
            strongSelf.toolView.screened = NO;
            TVProgram *program = strongSelf.programArray [strongSelf->currentVideoIndex];

            [strongSelf getHWPlayUrl:program.programUrl];

            strongSelf.player.view.title = program.programName;
            strongSelf.watchEntity.setNumber = program.seriesNum;
            strongSelf->_tvProgram.programId = program.programId;
            if ([program.mediaType isEqualToString:@"live"]) {
                strongSelf.player.view.showDanmuSwitch = YES;
            }
            else{
                strongSelf.player.view.showDanmuSwitch = NO;
            }
            [TPXmppRoomManager defaultManager].tvProgram = program;

            [strongSelf queryPriceRequest];
            strongSelf.tvProgram =program;
            [strongSelf addHistort:@"start"];

            if (![strongSelf.tvProgram.mediaType isEqualToString:@"live"]) {
                _videoType = kLiveTVDetailTypeReplay;
                [strongSelf.publicChatRoomView leaveChatRoom];
                strongSelf.publicChatRoomView = nil;
            }else{
                _videoType = kLiveTVDetailTypeLive;
            }
            [strongSelf clearData];
            [strongSelf refreshData];
        }];

        _videoDetailView.didSelect = ^(NSInteger index){
            __strong __typeof(weakSelf)strongSelf = weakSelf;;
            strongSelf->currentVideoIndex = index;
            strongSelf.player.currentVideoIndex = strongSelf->currentVideoIndex;
            strongSelf.player.view.currentVideoIndex = strongSelf->currentVideoIndex;
            strongSelf.toolView.screened = NO;
            TVProgram *program = strongSelf.programArray [strongSelf->currentVideoIndex];

            [strongSelf getHWPlayUrl:program.programUrl];

            strongSelf.player.view.title = program.programName;
            strongSelf.watchEntity.setNumber = program.seriesNum;
            strongSelf->_tvProgram.programId = program.programId;

            [TPXmppRoomManager defaultManager].tvProgram = program;
            [strongSelf queryPriceRequest];
            strongSelf.tvProgram =program;
            [strongSelf addHistort:@"start"];

            if (![strongSelf.tvProgram.mediaType isEqualToString:@"live"]) {
                _videoType = kLiveTVDetailTypeReplay;
                [strongSelf.publicChatRoomView leaveChatRoom];
                strongSelf.publicChatRoomView = nil;
            }else{
                _videoType = kLiveTVDetailTypeLive;
            }
            [strongSelf clearData];
            [strongSelf refreshData];
        };
        //vip 通道
        [_videoDetailView setVipLanesImgTapped:^(NSInteger index) {

            __strong __typeof(weakSelf)strongSelf = weakSelf;;
            if ([[HiTVGlobals sharedInstance].disable_moudles containsObject:@"vip"]) {
                [OMGToast showWithText:@"暂未开放"];
            }
            else{
                SJVIPViewController *VIPVC =[[SJVIPViewController alloc]initWithNibName:@"SJVIPViewController" bundle:nil];
                [strongSelf.navigationController pushViewController:VIPVC animated:YES];
            }

        }];
        // 选择为您推荐
        [_videoDetailView.recommendView setDidSelectRecommendItemAtIndex:^(NSInteger index) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;;
            strongSelf.toolView.screened = NO;
            WatchListEntity *recommendModel = strongSelf.recommendList[index];
            if ([TPXmppRoomManager defaultManager].isInChatRoom) {

                NSString *mes = [NSString stringWithFormat:@"亲爱的%@:",[HiTVGlobals sharedInstance].nickName];

                TPIMAlertView *alert = [[TPIMAlertView alloc]initWithTitle:mes
                                                                   message:@"是否退出聊天室"
                                                           leftButtonTitle:@"取消"
                                                          rightButtonTitle:@"退出"];
                alert.rightButtonClickBlock = ^(){
                    [strongSelf handleRecommendModel:recommendModel];
                };
                [alert show];
            }
            else{
                [strongSelf handleRecommendModel:recommendModel];
            }

        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = kColorLightGrayBackground;
    self.navigationController.navigationBarHidden = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutAccount:) name:TPXMPPOfflineNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyNow) name:TPIMNotification_BuyNow object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinRoom:) name:TPIMNotification_FollowJoinRoom object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goRemoteVC:) name:TPIMNotification_GOREMOTE object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runBackgroundComponent) name:TPIMNotification_vedioReadyToPlay object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_refreshAfterUserLogin)
                                                 name:TPIMNotification_ReloadUser
                                               object:nil];

    [self.view addSubview:_toolView];
    [self.view addSubview:_player.view];
    [self.view addSubview:_segmentedControl];
    [self.view addSubview:mainView];
    [mainView addSubview:_privateChatRoomView];

    if (_videoType == kLiveTVDetailTypeLive) {
#ifndef BeiJing
        [mainView addSubview:_publicChatRoomView];
#endif
    }

    [mainView addSubview:_videoDetailView];

    // 显示直播数据
    if (_tvProgram.programUrl == nil && self.watchEntity == nil) {

        [MBProgressHUD showError:@"该节目无法播放" toView:self.view];
        _player.view.title = _tvProgram.programName;

        _videoDetailView.programView.channelLogo = self.watchEntity.channelLogo;
        _videoDetailView.programView.channelName = self.watchEntity.channelName;
        _videoDetailView.programView.programName = self.watchEntity.programSeriesName;

        if (self.watchEntity.channelUuid.length > 0) {
            _publicChatRoomView.channelId = self.watchEntity.channelUuid;
        }

    }
    else{
        _player.view.title = _tvProgram.programName;

        _videoDetailView.programView.channelLogo = self.tvStation.logo;
        _videoDetailView.programView.channelName = self.tvStation.channelName;
        _videoDetailView.programView.programName = self.tvProgram.programName;

        // loadVideInfomation回调已调用
        //if (self.tvStation.uuid.length > 0) {
        //    _publicChatRoomView.channelId = self.tvStation.uuid;
        //}
        // 加载直播详情
        [self loadVideoInformation];
    }

    if ([TPXmppRoomManager defaultManager].isInChatRoom) {

        _segmentedControl.selectedSegmentIndex = _segmentedControl.items.count - 1;
        [self segmentedControlValueChanged:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [HiTVGlobals sharedInstance].isWatchingVideo = YES;
    if (!_player.isScreening) {
        _player.datePoint = self.videoDatePoint;
        [_player play];
    }

    [_privateChatRoomView refreshData];

}
-(void)p_refreshAfterUserLogin{
    //影片鉴权
    [self queryPriceRequest];
}
-(void) runBackgroundComponent
{

    
    localeDateStr =  [Utils getCurrentTime];
    NSString* content = [NSString stringWithFormat:@"type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&programtypename=%@&firstsource=%@&epgname=%@&tag=%@&starttime=%@", ((long)self.videoType == kLiveTVDetailTypeLive? @"直播": @"回看"),isNullString(self.tvStation.uuid),isNullString(self.watchEntity.programSeriesId),[NSString stringWithFormat:@"%d",(int)self.tvProgram.programId],isNullString(self.watchEntity.programSeriesName),isNullString(self.tvProgram.programName),
                         isNullString(self.watchEntity.programSeriesType),isNullString(self.tabBarController.tabBar.selectedItem.title),isNullString(self.epgName), isNullString(self.tvProgram.mediaType), [Utils getCurrentTime]];

    [Utils BDLog:1 module:@"604" action:@"AppPlayAction" content:content];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [HiTVGlobals sharedInstance].isWatchingVideo = NO;
    [_player stop];

    [verTimer invalidate];
    verTimer=nil;
    [self deviceOrientationDidChange];


    [[NSNotificationCenter defaultCenter] removeObserver:self name:TPIMNotification_vedioReadyToPlay object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_dlnaBroastcastCallbackImp object:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    _toolView.frame = CGRectMake(0,
                                 _player.view.frame.size.height + _player.view.frame.origin.y - 1,
                                 self.view.frame.size.width,
                                 kSegmentecControlHeight);


    _segmentedControl.frame = CGRectMake(0,
                                         _toolView.frame.size.height + _toolView.frame.origin.y,
                                         self.view.frame.size.width,
                                         kSegmentecControlHeight);


    CGFloat originy =  _segmentedControl.frame.size.height + _segmentedControl.frame.origin.y;

    mainView.frame = CGRectMake(0,
                                originy,
                                self.view.frame.size.width,
                                self.view.frame.size.height - originy);

    _videoDetailView.frame = mainView.bounds;
    _privateChatRoomView.frame = mainView.bounds;
    _publicChatRoomView.frame = mainView.bounds;

    if (_player.view.style == SJVideoPlayerViewStyleFullScreen) {
        mainView.hidden = YES;
    }
    else{
        mainView.hidden = NO;
    }
}

- (void)dealloc
{
    [_player clearPlayer];
    _player = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _viewModel = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public operation
- (void)clearData
{
    //    [_player clearPlayer];
    if (_videoType == kLiveTVDetailTypeLive) {
        [_publicChatRoomView leaveChatRoom];
    }
    [[TPXmppRoomManager defaultManager] leaveOldRoom];
}

- (void)refreshData
{
    if (_tvProgram.programUrl.length > 0) {
        [self getHWPlayUrl:_tvProgram.programUrl];
    }

    _player.view.title = _tvProgram.programName;

    //_videoDetailView.programView.channelLogo = self.watchEntity.channelLogo;
    //_videoDetailView.programView.channelName = self.watchEntity.channelName;
    //_videoDetailView.programView.programName = self.watchEntity.programSeriesName;

    __weak __typeof(self)weakSelf = self; 
    if (_videoType == kLiveTVDetailTypeLive) {
        //直播
        _player.view.showDanmuSwitch = YES;
        // 分段开关
#ifndef BeiJing
        _segmentedControl.items = @[@"详情",@"广场",@"私聊"];
        if (_publicChatRoomView == nil) {
            // 群聊 聊天室view
            _publicChatRoomView = [[SJPublicChatRoomMainView alloc] init];
            _publicChatRoomView.activeController = self;
            
            _publicChatRoomView.backgroundColor = kColorLightGrayBackground;
            _publicChatRoomView.inputView.iflyManager = _viewModel;
            [_publicChatRoomView setPublicRoomDidReceiveDanmuData:^(TPDanmakuData *data) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf.player.view sendBarrage:data];
                [strongSelf screenDanmuData:data];
                if (data && data.isSender) {
                    // add log.
                    NSString* content = [NSString stringWithFormat:@"type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&actiontype=%@",(long)strongSelf.videoType == kLiveTVDetailTypeLive? @"直播": @"回看",isNullString(strongSelf.tvStation.uuid),isNullString(strongSelf.watchEntity.programSeriesId),[NSString stringWithFormat:@"%d",(int)strongSelf.tvProgram.programId],isNullString(strongSelf.watchEntity.programSeriesName),isNullString(strongSelf.tvProgram.programName),@"广场"];
                    [Utils BDLog:1 module:@"605" action:@"PrivateMessage" content:content];
                    // add log.
                    
                }
            }];
            @weakify(self)
            //聊天室开始播放语音，关闭播放器声音
            [_publicChatRoomView setVoiceMessageWillStartPlay:^{
                @strongify(self)
                [self.player mutePlayer];
            }];
            
            //聊天室语音播放结束，恢复播放器声音
            [_publicChatRoomView setVoiceMessageDidFinishPlaying:^{
                @strongify(self)
                [self.player recoverPlayerVolume];
            }];
            
            [mainView insertSubview:_publicChatRoomView aboveSubview:self.privateChatRoomView];
        }
#else 
        _segmentedControl.items = @[@"详情",@"私聊"];
#endif
        
    }
    else{
        //回看
        if (_publicChatRoomView) {
            [_publicChatRoomView removeFromSuperview];
        }
        _player.view.showDanmuSwitch = NO;
        _segmentedControl.items = @[@"详情",@"私聊"];
    }

    // loadVideoInformation 回调里已经调用了。
    //_publicChatRoomView.channelId = self.watchEntity.channelUuid;

    self.player.currentVideoIndex = currentVideoIndex;
    self.player.view.currentVideoIndex = currentVideoIndex;
    [self loadVideoInformation];

    [_privateChatRoomView refreshData];
    [self.view setNeedsLayout];

}

#pragma mark - Event
- (void)segmentedControlValueChanged:(id)sender
{

#ifndef BeiJing
    Boolean isNoPublicRoom = NO;
#else
    Boolean isNoPublicRoom = YES;
#endif
    if (lastSelectedIndex != _segmentedControl.selectedSegmentIndex) {

        [_publicChatRoomView.inputView resignFirstResponder];
        [_privateChatRoomView.inputView resignFirstResponder];

        if (_videoType == kLiveTVDetailTypeReplay || isNoPublicRoom) {

            CATransition *animation = [CATransition animation];
            animation.duration = kAnimationDuration;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            animation.type = kCATransitionPush;

            NSInteger chatroomTag = [[mainView subviews] indexOfObject:_privateChatRoomView];
            NSInteger videodetailTag = [[mainView subviews] indexOfObject:_videoDetailView];

            if (_segmentedControl.selectedSegmentIndex == 1) {

                animation.subtype = kCATransitionFromRight;

                [mainView exchangeSubviewAtIndex:videodetailTag withSubviewAtIndex:chatroomTag];
                [[mainView layer] addAnimation:animation forKey:@"animation"];
            }
            else{

                animation.subtype = kCATransitionFromLeft;

                [mainView exchangeSubviewAtIndex:videodetailTag withSubviewAtIndex:chatroomTag];
                [[mainView layer] addAnimation:animation forKey:@"animation"];
            }
            lastSelectedIndex = _segmentedControl.selectedSegmentIndex;

        }
        else{

            NSInteger privatechatroomTag = [[mainView subviews] indexOfObject:_privateChatRoomView];
            NSInteger publicchatroomTag = [[mainView subviews] indexOfObject:_publicChatRoomView];
            NSInteger videodetailTag = [[mainView subviews] indexOfObject:_videoDetailView];

            NSInteger lastViewTag = videodetailTag;
            switch (lastSelectedIndex) {
                case 0:
                    lastViewTag = videodetailTag;
                    break;
                case 1:
                    lastViewTag = publicchatroomTag;
                    break;
                case 2:
                    lastViewTag = privatechatroomTag;
                    break;
                default:
                    break;
            }

            CATransition *animation = [CATransition animation];
            animation.duration = kAnimationDuration;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            animation.type = kCATransitionPush;
            animation.subtype = kCATransitionFromRight;

            if (_segmentedControl.selectedSegmentIndex == 0) {

                [mainView exchangeSubviewAtIndex:lastViewTag withSubviewAtIndex:videodetailTag];
                [[mainView layer] addAnimation:animation forKey:@"animation"];
            }
            else if (_segmentedControl.selectedSegmentIndex == 1){

                [_privateChatRoomView.inputView resignFirstResponder];
                [mainView exchangeSubviewAtIndex:lastViewTag withSubviewAtIndex:publicchatroomTag];
                [[mainView layer] addAnimation:animation forKey:@"animation"];
            }
            else{

                [_publicChatRoomView.inputView resignFirstResponder];
                [mainView exchangeSubviewAtIndex:lastViewTag withSubviewAtIndex:privatechatroomTag];
                [[mainView layer] addAnimation:animation forKey:@"animation"];
            }
            lastSelectedIndex = _segmentedControl.selectedSegmentIndex;
        }

    }

}

- (void)logoutAccount:(NSNotification *)notification
{
    [self addHistort:@"end"];

    __weak __typeof(self)weakSelf = self;
    [self.player clearPlayerWithCompletion:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;;
        [strongSelf.privateChatRoomView leaveChatRoom];
        [strongSelf.publicChatRoomView leaveChatRoom];
        [strongSelf performSelector:@selector(popToRootController) withObject:strongSelf afterDelay:0.5];
    }];
}

- (void)popToRootController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.player clearPlayer];
}

- (void)popViewController
{
    if ([TPXmppRoomManager defaultManager].isInChatRoom) {
        NSString *mes = [NSString stringWithFormat:@"亲爱的%@:",[HiTVGlobals sharedInstance].nickName];

        TPIMAlertView *alert = [[TPIMAlertView alloc]initWithTitle:mes
                                                           message:@"是否退出聊天室"
                                                   leftButtonTitle:@"取消"
                                                  rightButtonTitle:@"退出"];
        alert.rightButtonClickBlock = ^(){
            [self addHistort:@"end"];
            [self.player clearPlayer];
            [self.privateChatRoomView leaveChatRoom];
            [self.publicChatRoomView leaveChatRoom];
            [[TPXmppRoomManager defaultManager] clearData];
            [self.navigationController popViewControllerAnimated:YES];
        };
        [alert show];
    }else{
        [self addHistort:@"end"];
        [self.player clearPlayer];
        [self.privateChatRoomView leaveChatRoom];
        [self.publicChatRoomView leaveChatRoom];
        [[TPXmppRoomManager defaultManager] clearData];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - SJVideoPlayerDelegate
- (void)playerWillChangeFrame
{
    [_publicChatRoomView.inputView resignFirstResponder];
    [_privateChatRoomView.inputView resignFirstResponder];
}

- (void)playerDidFinishMinimumScreen
{
    //播放器小屏
    [_publicChatRoomView.inputView resignFirstResponder];
    [_privateChatRoomView.inputView resignFirstResponder];
    [self.view setNeedsLayout];
}

- (void)playerDidFinishFullScreen
{
    //播放器全屏
    [_publicChatRoomView.inputView resignFirstResponder];
    [_privateChatRoomView.inputView resignFirstResponder];
    [self.view setNeedsLayout];
}

- (void)playerDidClickCollect
{
    //收藏/取消收藏
    if (_toolView.collected) {
        [self cancelCollectVideo];
    }
    else{
        [self collectVideo];
    }
}

- (void)playerDidClickScreen
{
    //投屏
    [self toolViewDidStartScreeningVideo:nil];
}

- (void)playerDidCancelScreen
{
    // 取消投屏
    [self toolViewDidCancelScreen:nil];
}

- (void)playerDidPauseInScreening
{
    //投屏操作：暂停
    [self ScreenProjectionOperation:@"pause" withStartTime:nil];
}

- (void)playerDidResumeInScreening
{
    //投屏操作：继续
    [self ScreenProjectionOperation:@"resume" withStartTime:nil];
}
- (void)playerDidSeekToSecondsInScreening:(CGFloat)seconds
{
    //投屏操作：seek
    [self ScreenProjectionOperation:@"seek" withStartTime:[NSString stringWithFormat:@"%.0f",seconds]];
}
- (void)playerDidPlayToEnd
{
    //播放器结束播放
    [self getRecommendList];
}

#pragma mark -  Request
/*
 * 查询直播详情
 */
- (void)loadVideoInformation
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (_tvStation.uuid == nil) {
        _videoDetailView.programView.channelLogo = self.watchEntity.channelLogo;
        _videoDetailView.programView.channelName = self.watchEntity.channelName;
        if (_tvStation == nil) {
            _tvStation = [[TVStation alloc] init];
        }
        _tvStation.uuid = self.watchEntity.channelUuid;
        _tvStation.logo = self.watchEntity.channelLogo;
        _tvStation.channelName = self.watchEntity.channelName;

        if (_tvProgram == nil) {
            _tvProgram = [[TVProgram alloc] init];
        }
        _tvProgram.programId = [self.watchEntity.contentId doubleValue];
        _tvProgram.startTime = [NSString stringWithFormat:@"%.f",self.watchEntity.startTime];
        _tvProgram.endTime = [NSString stringWithFormat:@"%.f",self.watchEntity.endTime];
        _tvProgram.desImg = self.watchEntity.verticalPosterAddr;
        _tvProgram.programName = self.watchEntity.programSeriesName;
        _tvProgram.channelUuid = self.watchEntity.channelUuid;

        [TPXmppRoomManager defaultManager].tvProgram = _tvProgram;
        [TPXmppRoomManager defaultManager].tvStation = _tvStation;
        if (_videoType == kLiveTVDetailTypeReplay) {
            [TPXmppRoomManager defaultManager].videoType = TPChatRoomVideoTypeReplay;
        }
        else{
            [TPXmppRoomManager defaultManager].videoType = TPChatRoomVideoTypeLive;
        }
        [parameters setValue:self.watchEntity.channelName forKey:@"channelUuid"];

        if (!(/*[self.watchEntity.contentType isEqualToString:@"live"]&&*/[self live:self.watchEntity])) {
            [parameters setValue:self.watchEntity.programSeriesId forKey:@"programSetId"];
        }
        [parameters setValue:WATCHTVGROUPID forKey:@"templateId"];
        [parameters setValue:self.watchEntity.channelUuid forKey:@"channelUuid"];
        [parameters setValue:[NSString stringWithFormat:@"%ld",(long)self.watchEntity.startTime]    forKey:@"startTime"];
        [parameters setValue:[NSString stringWithFormat:@"%ld",(long)self.watchEntity.endTime] forKey:@"endTime"];
        [parameters setValue:self.watchEntity.contentId forKey:@"programId"];
        [parameters setValue:self.watchEntity.programSeriesName forKey:@"programName"];
    }
    else{//21893950
        NSString *programId = [NSString stringWithFormat:@"%.f",_tvProgram.programId];
        [parameters setValue:@"" forKey:@"programSetId"];
        [parameters setValue:WATCHTVGROUPID forKey:@"templateId"];
        [parameters setValue:_tvStation.uuid forKey:@"channelUuid"];
        [parameters setValue:_tvProgram.startTime forKey:@"startTime"];
        [parameters setValue:_tvProgram.endTime forKey:@"endTime"];
        [parameters setValue:programId forKey:@"programId"];
        [parameters setValue:_tvProgram.programName forKey:@"programName"];

    }
    [parameters setValue:T_STBext forKey:@"abilityString"];

    [BaseAFHTTPManager getRequestOperationForHost:FUSE_EPG forParam:@"/epg/user/getReleProgramList.shtml" forParameters:parameters completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        if (responseObject == nil ||[(NSArray *)responseObject count] == 0) {


            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未能播放："
                                                            message:@"该片仅支持电视观看"
                                                           delegate:self
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            //_player.isTVPlay = YES;
            self.noDetail = YES;

            return;
        }
        second = [Utils nowTimeString].longLongValue;

        NSMutableArray *array = [NSMutableArray array];
        NSArray *programs = responseObject[@"programList"];

        self.watchEntity.contentId = [NSString stringWithFormat:@"%d",(int)self.tvProgram.programId];
        self.watchEntity.programSeriesId = responseObject[@"programSetId"];
        self.watchEntity.programSeriesName = responseObject[@"programSetName"];
        if ([self.watchEntity.programSeriesId.class isSubclassOfClass:[NSNull class]]) {
            self.watchEntity.programSeriesId = @"";
        }

        for (NSDictionary *dic in programs) {
            TVProgram *program = [[TVProgram alloc] initWithDictionary:dic];
            if (program.cur.intValue == 1) {
                NSInteger index = [programs indexOfObject:dic];
                currentVideoIndex = index;
                _videoDetailView.seriesTableView.currentIndexPath =  [NSIndexPath indexPathForRow:index inSection:0];;

                _tvProgram = [self playTvProgram:program];
                _player.view.title = _tvProgram.programName;
                [self getHWPlayUrl:_tvProgram.programUrl];

                self.watchEntity.setNumber =_tvProgram.seriesNum;

                self.ppvId = program.ppvId;

            }
            [array addObject:program];

        }

        if ([isNullString(self.ppvId) length] != 0) {
            [self queryPriceRequest];
        }


        if ((!_player.actionUrl) && array.count>0) {
            TVProgram *program = array[0];
            currentVideoIndex = 0;
            _tvProgram = [self playTvProgram:program];
            _player.view.title = _tvProgram.programName;
            [self getHWPlayUrl:_tvProgram.programUrl];


        }
        if (_tvProgram.programUrl.length == 0) {
            _tvProgram = [array objectAtIndex:currentVideoIndex];
            [self getHWPlayUrl:_tvProgram.programUrl];

        }
        if ([_tvProgram.mediaType isEqualToString:@"live"]) {
            self.player.view.showDanmuSwitch = YES;
        }
        else{
            self.player.view.showDanmuSwitch = NO;
        }
        [self queryPriceRequest];

        if (_videoDetailView.programView.programName.length == 0) {
            _videoDetailView.programView.programName = responseObject[@"programSetName"];
        }

        self.player.currentVideoIndex = self->currentVideoIndex;
        self.player.view.currentVideoIndex = self->currentVideoIndex;

        self.tvProgram.hPosterAddr = responseObject[@"hPosterAddr"];
        self.tvProgram.vPosterAddr = responseObject[@"vPosterAddr"];
        self.tvProgram.directors = responseObject[@"director"];
        self.tvProgram.actors = responseObject[@"leading"];
        self.programArray = array;


        // 选集
        //        if (self.programArray.count>2) {
        _player.view.seriesList = self.programArray;
        //        }
        _player.view.seriesCount = self.programArray.count;

        //_player.view.seriesStyle = self.programArray.count>2?SJVideoPlayerSeriesViewStyleTableView:SJVideoPlayerSeriesViewStyleCollectionView;

        if (self.programArray.count>1 &&(![responseObject[@"orderType"] isEqualToString:@"series"])) {
            _player.view.seriesStyle = SJVideoPlayerSeriesViewStyleTableView;

            _videoDetailView.seriesTableView.list = self.programArray;
            _videoDetailView.seriesTableView.height = 44 * self.programArray.count + 40;
            if (_videoDetailView.seriesTableView.height > 216) {
                _videoDetailView.seriesTableView.height = 216;
            }
            _videoDetailView.seriesTableView.playH = _player.view.size.height+kSegmentecControlHeight;
            [_videoDetailView setNeedsLayout];

            [_videoDetailView.seriesTableView.tabView reloadData];
            _videoDetailView.seriesTableView.tabView.hidden = NO;

        }else{
            _player.view.seriesStyle = SJVideoPlayerSeriesViewStyleCollectionView;
            _videoDetailView.dataArray = [self.programArray mutableCopy];
            _videoDetailView.seriesTableView.tabView.hidden = YES;
            [_videoDetailView setNeedsLayout];
        }


        _publicChatRoomView.channelId = _tvProgram.channelUuid;
        [TPXmppRoomManager defaultManager].tvProgram = _tvProgram;
        [TPXmppRoomManager defaultManager].tvStation = _tvStation;
        [TPXmppRoomManager defaultManager].videoType = TPChatRoomVideoTypeLive;

        if (_videoType == kLiveTVDetailTypeReplay) {
            [TPXmppRoomManager defaultManager].videoType = TPChatRoomVideoTypeReplay;
        }
        else{
            [TPXmppRoomManager defaultManager].videoType = TPChatRoomVideoTypeLive;
        }

        self.tvStation.channelName = _tvProgram.channelName;
        self.tvStation.uuid = _tvProgram.channelUuid;
        _videoDetailView.programView.channelName = _tvProgram.channelName;



       // [self initVerTimer];
        [self querySingleHistory];
        [self checkVideoHasCollected];
        [self loadRecommendListRequest];
        if (self.neededScreen) {
            [self.toolView screenButtonClicked:nil];
        }

    } failure:^(AFHTTPRequestOperation *operation,NSString *error) {

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self p_handleNetworkError];

    }];
}


-(void)getRecommendList{
    NSString *type = @"replay";
    if ([ self.LivePlayType isEqualToString:@"play"]) {
        type = @"live";
    }
    else{
        type = @"replay";
    }
    WEAKSELF
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:type,@"type",
                            [NSString stringWithFormat:@"%zd",_tvProgram.programId],@"programSeriesId",
                            //self.watchEntity.categoryId,@"categoryId",
                            _tvProgram.uuid,@"channelUuid",
                            //WATCHTVGROUPID,@"tvTemplateId",
                            //[[HiTVGlobals sharedInstance]getEpg_groupId],@"vodTemplateId",
                            _tvProgram.startTime,@"startTime",
                            _tvProgram.endTime,@"endTime",
                            @"1",@"isPlayOver",
                            [HiTVGlobals sharedInstance].uid,@"userId",
                            T_STBext,@"abilityString",

                            nil];

    [BaseAFHTTPManager postRequestOperationForHost:MYEPG forParam:@"/foryou/getRecommendList" forParameters:params completion:^(id responseObject)
     {

         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (responseObject == nil) {
             return;
         }
         NSArray *personalList = responseObject[@"resultList"];
         self.recommendList = [[NSMutableArray alloc] init];
         for (NSDictionary *dic in personalList) {
             WatchListEntity *data = [[WatchListEntity alloc] initWithDictionary:dic];
             [self.recommendList addObject:data];
         }

         guestVC = [[SJGuestYouLikeViewController alloc]init];
         guestVC.modelsArray = self.recommendList;

         [self.view addSubview:guestVC.view];
         guestVC.view.frame = self.player.view.frame;
         guestVC.deleage = self;
         guestVC.clickBlock = ^(UIButton *but){

             [weakSelf.navigationController popViewControllerAnimated:YES];
         };

         _videoDetailView.recommendView.list = [NSArray arrayWithArray:self.recommendList];
         [_videoDetailView setNeedsLayout];

     } failure:^(NSString *error) {
         [_videoDetailView setNeedsLayout];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [self p_handleNetworkError];


     }];
}


#pragma mark - 猜您喜欢(直播没有相关推荐)
-(void)loadRecommendListRequest{
    NSString *type = @"replay";
    if ([ self.LivePlayType isEqualToString:@"play"]) {
        type = @"live";
    }
    else{
        type = @"replay";
    }

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:type,@"type",
                            // [NSString stringWithFormat:@"%zd",_tvProgram.programId],@"programSeriesId",
                            //self.watchEntity.categoryId,@"categoryId",
                            _tvProgram.uuid,@"channelUuid",
                            WATCHTVGROUPID,@"tvTemplateId",
                            [[HiTVGlobals sharedInstance]getEpg_groupId],@"vodTemplateId",
                            _tvProgram.startTime,@"startTime",
                            _tvProgram.endTime,@"endTime",
                            @"0",@"isPlayOver",
                            [HiTVGlobals sharedInstance].uid,@"userId",
                            T_STBext,@"abilityString",
                            nil];
    if (!_tvProgram.uuid) {
        params = [NSDictionary dictionaryWithObjectsAndKeys:type,@"type",
                  self.watchEntity.programSeriesId,@"programSeriesId",
                  WATCHTVGROUPID,@"tvTemplateId",
                  [[HiTVGlobals sharedInstance]getEpg_groupId],@"vodTemplateId",
                  self.watchEntity.channelUuid,@"channelUuid",
                  [NSString stringWithFormat:@"%zd",self.watchEntity.startTime],@"startTime",
                  [NSString stringWithFormat:@"%zd",self.watchEntity.endTime],@"endTime",
                  @"1",@"isPlayOver",
                  [HiTVGlobals sharedInstance].uid,@"userId",
                  T_STBext,@"abilityString",
                  nil];
    }
    [BaseAFHTTPManager postRequestOperationForHost:MYEPG forParam:@"/foryou/getRecommendList" forParameters:params completion:^(id responseObject){

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (responseObject == nil) {
            return;
        }
        if (responseObject[@"resultList"] == nil) {
            return;
        }


        NSArray *personalList = responseObject[@"resultList"];
        self.recommendList = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in personalList) {
            WatchListEntity *data = [[WatchListEntity alloc] initWithDictionary:dic];
            [self.recommendList addObject:data];
            if (self.recommendList.count>=30) {
                break;
            }
        }

        _videoDetailView.recommendView.list = [NSArray arrayWithArray:self.recommendList];
        [_videoDetailView setNeedsLayout];

    } failure:^(NSString *error) {
        [_videoDetailView setNeedsLayout];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)handleRecommendModel:(WatchListEntity *)recommendModel
{
    [self clearData];

    if ([recommendModel.contentType isEqualToString:@"live"]) {

        self.watchEntity = recommendModel;
        self.tvProgram = nil;
        self.tvStation = nil;

        [self refreshData];
    }
    else{
        if ([self.delegate respondsToSelector:@selector(liveTVDetail:didSelectRecommendItem:)]) {
            [self.delegate liveTVDetail:self didSelectRecommendItem:recommendModel];
        }
    }
}
//如果是直播，直接播放列表页传过来的节目
-(TVProgram *)playTvProgram:(TVProgram *)program{
    if ([_tvProgram.mediaType isEqualToString:@"live"]) {
        program.programUrl = _tvProgram.programUrl;
        program.programName = _tvProgram.programName;
    }
    return program;
}
#pragma mark -  定时器
- (void)initVerTimer
{
    if (!verTimer) {
        verTimer = [NSTimer scheduledTimerWithTimeInterval:DELAYSECONDS target:self selector:@selector(verUpdate) userInfo:nil repeats:YES];
        [verTimer fire];
    }
}

- (void)verUpdate
{
    [self addHistort:@"start"];
}

#pragma mark -  添加足迹
- (void)addHistort:(NSString *)logType
{
    if (self.noDetail) {
        return;
    }
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];

    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"oprUids"];
    if ([self.watchEntity.contentType isEqualToString:@"watchtv"]||[self.watchEntity.contentType isEqualToString:@"newWatchTv"]) {
        [parameters setValue:@"watchtv" forKey:@"businessType"];
    }
    else{
        [parameters setValue:@"livereplay" forKey:@"businessType"];
    }

    if (self.watchEntity.programSeriesId.intValue >0) {
        [parameters setValue:@"vod" forKey:@"playType"];
        [parameters setValue:self.watchEntity.programSeriesId forKey:@"objectId"];
    }
    else{
        if ([ self.LivePlayType isEqualToString:@"play"]) {
            [parameters setValue:@"live" forKey:@"playType"];
        }
        else{
            [parameters setValue:@"replay" forKey:@"playType"];
        }
        [parameters setValue:self.tvProgram.uuid forKey:@"objectId"];
        [parameters setValue:self.tvProgram.startTime forKey:@"startTime"];
        [parameters setValue:self.tvProgram.endTime forKey:@"endTime"];

    }
    if (self.watchEntity.programSeriesName.length>0) {
        [parameters setValue:self.watchEntity.programSeriesName forKey:@"objectName"];
    }else{
        [parameters setValue:self.tvProgram.channelName forKey:@"objectName"];
    }

    [parameters setValue:@"" forKey:@"assortId"];
    [parameters setValue:[NSString stringWithFormat:@"%d",(int)_tvProgram.programId ]forKey:@"lastProgramId"];
    [parameters setValue:self.tvProgram.programName forKey:@"lastProgramName"];

    int currentTime = floor(CMTimeGetSeconds([_player.view.player currentTime]));
    if (self.videoDatePoint<0) {
        self.videoDatePoint = 0;
    }
    NSString *pointString = [NSString stringWithFormat:@"%d",(int)currentTime];
    if (currentTime == 0 &&self.videoDatePoint) {
        pointString = [NSString stringWithFormat:@"%d",(int)self.videoDatePoint];
    }
    [parameters setValue:[NSString stringWithFormat:@"%d",(int)self.videoDatePoint] forKey:@"startWatchTime"];

    [parameters setValue:pointString forKey:@"endWatchTime"];
    [parameters setValue:self.tvProgram.hPosterAddr forKey:@"bannerImg"];
    [parameters setValue:self.tvProgram.vPosterAddr forKey:@"verticalImg"];
    [parameters setValue:self.tvProgram.directors forKey:@"directors"];
    [parameters setValue:self.tvProgram.actors forKey:@"actors"];
    [parameters setValue:[[HiTVGlobals sharedInstance]getEpg_groupId] forKey:@"deviceGroupId"];
    [parameters setValue:WATCHTVGROUPID forKey:@"templateId"];
    [parameters setValue:@"MOBILE" forKey:@"vendor"];

    NSString *seconds = [NSString stringWithFormat:@"%lld",[Utils nowTimeString].longLongValue - second];

    if(seconds.intValue<0){
        seconds = @"0";
    }
    [parameters setValue:seconds forKey:@"seconds"];
    [parameters setValue:self.watchEntity.setNumber forKey:@"seriesNumber"];
    [parameters setValue:@"MOBILE" forKey:@"deviceType"];
    if ([logType isEqualToString:@"start"]&&(pointString.intValue>0)) {
        [parameters setValue:@"watching" forKey:@"logType"];
    }
    else{
        [parameters setValue:logType forKey:@"logType"];
    }

    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN forParam:@"/integration/2.0/addHistory" forParameters:parameters  completion:^(id responseObject) {


    }failure:^(NSString *error) {


    }];
}

#pragma mark -  投屏
- (ScreenManager *)screenManager
{
    return [ScreenManager sharedInstance];
}

//开始投屏
- (void)onClickScreenProjection
{
    int currentTime = floor(CMTimeGetSeconds([_player.view.player currentTime]));
    NSString *pointString = [NSString stringWithFormat:@"%d",(int)currentTime];
    [self ScreenProjectionOperation:@"play" withStartTime:pointString];
}

//投屏操作
- (void)ScreenProjectionOperation:(NSString *)action withStartTime:(NSString *)startTime
{

    TPIMContentModel *contentModel = [[TPIMContentModel alloc]init];

    //频道直播
    contentModel.playerType = @"liveReplay";

    if ([action isEqualToString:@"exit"] || [action isEqualToString:@"pause"] || [action isEqualToString:@"resume"]) {
        contentModel.programId = self.watchEntity.contentId;
        contentModel.action = action;
    }
    else{

        TVProgram *program = self.programArray [self->currentVideoIndex];

        contentModel.uuId = program.uuid;
        contentModel.assortId = self.watchEntity.programSeriesId;
        contentModel.catgId = self.watchEntity.programSeriesId;
        contentModel.programId = [NSString stringWithFormat:@"%.f", program.programId];
        contentModel.startTime = program.startTime;
        contentModel.endTime = program.endTime;

        contentModel.content = program.programName;
        contentModel.progName = program.programName;
        contentModel.url = program.programUrl;

        if ([self.tvProgram.mediaType isEqualToString:@"live"]) {
            contentModel.liveTag = @"1";
        }else{
            contentModel.liveTag = @"2";
        }

        contentModel.datePoint = startTime;
        contentModel.action = action;

        if (_player.view.showBarrage) {
            contentModel.haveDanmu = @"true";
        }
        else{
            contentModel.haveDanmu = @"false";
        }

        NSString* content = [NSString stringWithFormat:@"state=%@&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&filetype=%@", @"%d", (long)self.videoType == kLiveTVDetailTypeLive? @"直播": @"回看",isNullString(self.tvProgram.uuid), isNullString(self.watchEntity.programSeriesId),isNullString(self.watchEntity.contentId),isNullString(self.watchEntity.programSeriesName), isNullString(self.tvProgram.programName),@"互联网"];

        [[NSUserDefaults standardUserDefaults] setObject:content forKey:@"ScreenMappingContent"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    [self.screenManager remoteNetVideoWithContentModel:contentModel];

}

- (void)screenDanmuData:(TPDanmakuData *)data
{
    if (!_player.isScreening) {
        //不在投屏状态下不进行弹幕投屏
        return;
    }
    //弹幕消息投屏
    //content=[{"from":xxx,"content":"xxx","isMyself":"xxx",type: "text"," playerType ":"danmu"}]
    //type:text(文字)、voice（语音）

    TPIMContentModel *model = [[TPIMContentModel alloc] init];
    model.from = data.senderName;
    model.playerType = @"danmu";
    if (data.isSender) {
        model.isMyself = @"true";
    }
    else{
        model.isMyself = @"false";
    }

    if (!data.isVoiceMessage) {
        //文字弹幕
        model.content = data.message;
        model.type = @"text";

    }
    else{
        //语音弹幕
        model.content = data.message;
        model.type = @"voice";
    }

    model.showToast = NO;
    [self.screenManager remoteNetVideoWithContentModel:model];
}

#pragma mark - SJVideoToolViewDelegate
#pragma mark - 详情页投屏
- (void)toolViewDidStartScreeningVideo:(SJVideoToolView *)toolview{

    /*self.DLNAListView.currentVideoURL = [self.player.actionUrl description];
    [self.DLNAListView ShowDLNAListViewsIn:[UIApplication sharedApplication].keyWindow];

    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(DLNACallBack:)
                                                name:kNotification_dlnaBroastcastCallbackImp
                                              object:nil];*/
    //    //投屏
        if (![HiTVGlobals sharedInstance].isLogin) {
            //        [self showAlert:@"请先登录" withDelegate:nil];
            SJLoginViewController *sjVC = [[SJLoginViewController alloc]init];
            [self presentViewController:sjVC animated:YES completion:nil];
            return;
        }
        [ScreenManager sharedInstance].screenManagerBlock = ^(BOOL isSuccess,NSString *time){
            if (isSuccess) {
                _toolView.screened = YES;
                _player.isScreening = YES;
            }
            else{
                if (time.floatValue>0) {
                    [self toolViewDidCancelScreen:nil];
                    [_player seekToTime:time.floatValue];
                }
                else if (time.floatValue == -1){
                    [self showNoDeviceAlert];
                }
                else if(time.floatValue == 0){
                    _toolView.screened = NO;
                    _player.isScreening = NO;
                }
            }
        };
        [self onClickScreenProjection];
}

- (void)toolViewDidCancelScreen:(SJVideoToolView *)toolview
{
    // 取消投屏
    [self ScreenProjectionOperation:@"exit" withStartTime:@"0"];
    _player.isScreening = NO;
    _toolView.screened = NO;
    [MBProgressHUD show:@"电视端已退出播放" icon:nil view:self.view];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        if (buttonIndex == 0) {
            [self scan];
        }
    }
    else{
        if (buttonIndex == 0) {
            [self popViewController];
        }
    }
}
#pragma mark - 详情页收藏
- (void)toolViewDidStartCollectingVideo:(SJVideoToolView *)toolview
{
    // 收藏
    [self collectVideo];

}

- (void)toolViewDidCancelCollectVideo:(SJVideoToolView *)toolview
{
    // 取消收藏
    [self cancelCollectVideo];
}

- (void)collectVideo{
    // 收藏
    SJLiveTVCollcetModel *model = [SJLiveTVCollcetModel new];


    model.uid             = [HiTVGlobals sharedInstance].uid;
    model.oprUids         = [HiTVGlobals sharedInstance].uid;
    model.businessType    = @"livereplay";

    if (self.watchEntity.programSeriesId.intValue >0) {
        model.playType        = @"vod";
        model.objectId        = self.watchEntity.programSeriesId;
    }
    else{
        if ([ self.LivePlayType isEqualToString:@"play"]) {
            model.playType        = @"live";
        }
        else{
            model.playType        = @"replay";
        }
        model.objectId        = self.tvProgram.uuid;
    }
    if (self.watchEntity.programSeriesName.length>0) {
        model.objectName      = self.watchEntity.programSeriesName;
    }else{
        model.objectName      = self.tvProgram.channelName;
    }
    model.startTime       = self.tvProgram.startTime;
    model.endTime         = self.tvProgram.endTime;
    model.assortId        = @"";
    model.lastProgramId   = [NSString stringWithFormat:@"%d",(int)_tvProgram.programId ];
    model.lastProgramName = [NSString stringWithFormat:@"%@",_tvProgram.programName];
    model.startWatchTime  = @"0";
    int currentTime       = floor(CMTimeGetSeconds([_player.view.player currentTime]));
    NSString *pointString = [NSString stringWithFormat:@"%d",(int)currentTime];

    model.endWatchTime    = pointString;
    model.bannerImg       = self.tvProgram.hPosterAddr;
    model.verticalImg     = self.tvProgram.vPosterAddr;

    model.directors       = @"";
    model.actors          = @"";
    model.deviceGroupId   = [[HiTVGlobals sharedInstance]getEpg_groupId];

    model.templateId      = WATCHTVGROUPID ;
    model.deviceType      = @"MOBILE";

    WEAKSELF

    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN forParam:@"/integration/2.0/addCollection" forParameters:[model mj_keyValues]  completion:^(id responseObject) {
        
        DDLogInfo(@"-----%@",responseObject);
        NSNumber *code = responseObject[@"code"];
        if (code.integerValue == 0) {
            NSString* content = [NSString stringWithFormat:@"type=%@&uuid=%@&programSeriesId=%@&programseriesname=%@",self.videoType == kLiveTVDetailTypeLive? @"直播":@"回看", isNullString(self.tvProgram.uuid), isNullString(self.watchEntity.programSeriesId), isNullString(self.watchEntity.programSeriesName)];
            [Utils BDLog:1 module:@"605" action:@"AppFavorite" content:content];

            [MBProgressHUD showSuccess:@"收藏成功" toView:weakSelf.view];
            _toolView.collected = YES;
            _player.view.isCollected = YES;
            [UMengManager event:@"U_AppFavorite"];

        }else{

            [MBProgressHUD showError:@"收藏失败" toView:weakSelf.view];
        }
    }failure:^(NSString *error) {

        DDLogError(@"-----%@",error);
        [MBProgressHUD showError:@"请求出错" toView:weakSelf.view];
        _toolView.collected = NO;
        _player.view.isCollected = NO;
    }];
}

- (void)cancelCollectVideo
{
    // 取消收藏
    SJCancelCollcetionModel *model = [SJCancelCollcetionModel new];
    model.uid          = [HiTVGlobals sharedInstance].uid;
    model.oprUids      = [HiTVGlobals sharedInstance].uid;
    model.businessType = @"livereplay";

    if (self.watchEntity.programSeriesId.intValue >0) {
        model.playType        = @"vod";
        model.objectId        = self.watchEntity.programSeriesId;
    }
    else{
        if ([ self.LivePlayType isEqualToString:@"play"]) {
            model.playType        = @"live";
        }
        else{
            model.playType        = @"replay";
        }
        model.objectId        = self.tvProgram.uuid;
        model.startTime    = self.tvProgram.startTime;
        model.endTime      = self.tvProgram.endTime;
    }

    model.templateId   = WATCHTVGROUPID;
    model.deviceType   = @"MOBILE";
    WEAKSELF

    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN forParam:@"/integration/2.0/deleteCollection" forParameters:[model mj_keyValues]  completion:^(id responseObject) {

        NSNumber *code = responseObject[@"code"];
        if (code.integerValue == 0) {
            [MBProgressHUD showSuccess:@"取消收藏" toView:weakSelf.view];
            _toolView.collected = NO;
            _player.view.isCollected = NO;

        }else{
            [MBProgressHUD showError:@"取消失败" toView:weakSelf.view];
        }

    }failure:^(NSString *error) {
        [MBProgressHUD showError:@"请求出错" toView:weakSelf.view];
        _toolView.collected = YES;
        _player.view.isCollected = YES;
    }];
}

- (NSString *)shortVedioString:(NSString *)string{

    NSString *keyWord = [NSString new];

    keyWord = @"/lookback/";

    NSArray *array = [string componentsSeparatedByString:keyWord];
    NSString *stringA = [[NSString alloc]init];
    for (int i=1; i<array.count; i++) {
        NSString *cword;
        cword = [NSString stringWithFormat:@"%@",(NSString *)array[i]];
        stringA = [NSString stringWithFormat:@"%@%@",stringA,cword];
    }

    stringA =[NSString stringWithFormat:@"%@",stringA];
    return stringA;
}
#pragma mark - 详情页分享
-(SMSRequestParams *)gengeratSmsPrams{
    TVProgram *program = self.programArray[self->currentVideoIndex];
    program = program==nil?self.tvProgram:program;
    NSString *aa = [NSString stringWithFormat:@"%f",self.player.currentPlayedSeconds];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:aa];
    aa =[num1 stringValue];
    SMSRequestParams *smsparams = [SMSRequestParams new];
    smsparams.uid = [HiTVGlobals sharedInstance].uid;
    smsparams.userName = [HiTVGlobals sharedInstance].nickName;
    smsparams.userImgUrl = [HiTVGlobals sharedInstance].faceImg;
    smsparams.phoneNo = [HiTVGlobals sharedInstance].phoneNo;
    smsparams.domain = [HiTVGlobals sharedInstance].domain;
    smsparams.psId = self.watchEntity.programSeriesId;
    smsparams.pId =[NSString stringWithFormat:@"%lf",program.programId];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:smsparams.pId];
    smsparams.pId = [num2 stringValue];
    smsparams.uuid = program.channelUuid;
    smsparams.channelBeginTime = program.startTime;
    smsparams.channelEndTime = program.endTime;
    smsparams.contentName = program.programName;
    smsparams.mediaType = program.mediaType;
    smsparams.contentType = self.watchEntity.contentType;
    smsparams.startTime = [NSString stringWithFormat:@"%ld",(long)[aa integerValue]];
    smsparams.shareSeconds = @"30";
    DDLogInfo(@"-目前的数据是----%@", [smsparams mj_keyValues]);
    return smsparams;
}

-(void)playerDidClickShare{

    // 分享
    if (![HiTVGlobals sharedInstance].isLogin) {


        SJLoginViewController *sjVC = [[SJLoginViewController alloc]init];
        [self.navigationController presentViewController:sjVC animated:YES completion:nil];
        return;
    }

    _shareView =[[SJPortraitShareView alloc]initWithTpye:0];

    [[UIApplication sharedApplication].keyWindow addSubview:_shareView];
    [_shareView showInView:[UIApplication sharedApplication].keyWindow];

    [self LiveTVshareMethod];


}

- (NSString *)timeString:(NSString *)timeString{

    long long int date1 = (long long int)[timeString intValue];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
    NSDateFormatter* toformatter = [[NSDateFormatter alloc] init];
    [toformatter setDateStyle:NSDateFormatterMediumStyle];
    [toformatter setTimeStyle:NSDateFormatterShortStyle];
    [toformatter setDateFormat:@"yyyyMMddHHmmss"];//设置目标时间字符串的格式
    NSString *targetTime = [toformatter stringFromDate:date2];//将时间转化成目标时间字符串
    return targetTime;
}


-(void)LiveTVshareMethod{


    TVProgram *program = self.programArray[self->currentVideoIndex];

    program = program==nil?self.tvProgram:program;
     NSString *aa = [NSString stringWithFormat:@"%f",self.player.currentPlayedSeconds];
     NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:aa];
     aa =[num1 stringValue];
     SJ30SVedioRequestModel *model = [SJ30SVedioRequestModel new];


     if ([self.LivePlayType isEqualToString:@"play"]) {
     model.videoType        = @"live";
     model.videoTime = [aa integerValue];
     model.videoId = program.uuid;
     model.videoTitle = program.programName;
     }else{
     if ([[self.player.actionUrl absoluteString]containsString:@"/media/"]) {

     model.videoTime = [aa integerValue];
     model.videoType = @"looktv";
     model.videoId = [self shortVedioString:[self.player.actionUrl absoluteString]];
     model.userName = [HiTVGlobals sharedInstance].nickName;
     model.userHeadImageUrl = [HiTVGlobals sharedInstance].faceImg;
     }else{
     model.videoType        = @"lookback";
     model.videoTime = [aa integerValue];
     model.videoId = [NSString stringWithFormat:@"%@/%@/%@",program.uuid,[self timeString:program.startTime],[self timeString:program.endTime]];
     model.videoTitle = program.programName;
     }

     }
     model.userName = [HiTVGlobals sharedInstance].nickName;
     model.userHeadImageUrl = [HiTVGlobals sharedInstance].faceImg;
     model.videoSecond = 30;

    WEAKSELF

    _shareView.shareButtonBlock = ^(UIButton *button){

        if (button.tag==10) {

            weakSelf.hidesBottomBarWhenPushed = YES;
            SJShareVideoViewController *shareVC = [[SJShareVideoViewController alloc] init];

            SJShareVideoViewModel *viewModel = [[SJShareVideoViewModel alloc] initWithController:shareVC];
            viewModel.tvProgram = program;
            viewModel.tvStation = weakSelf.tvStation;
            if (_videoType == kLiveTVDetailTypeLive) {
                viewModel.videoType = TPShareVideoTypeLive;
            }
            else{
                viewModel.videoType = TPShareVideoTypeReplay;
            }

            viewModel.currentPlayedSeconds = weakSelf.player.currentPlayedSeconds;
            shareVC.viewModel = viewModel;

            [weakSelf.navigationController pushViewController:shareVC animated:YES];


            // add log.
            NSString* content = [NSString stringWithFormat:@"state=%@&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&way=%@&sharetime=%@&sharepoint=%@",@"%d", weakSelf.videoType == kLiveTVDetailTypeLive? @"直播":@"回看", isNullString(weakSelf.tvStation.uuid), isNullString(weakSelf.watchEntity.programSeriesId), [NSString stringWithFormat:@"%d",(int)weakSelf.tvProgram.programId], isNullString(weakSelf.watchEntity.programSeriesName), isNullString(weakSelf.tvProgram.programName), @"和家庭好友",[[NSUserDefaults standardUserDefaults] objectForKey:LOG_SHARE_VIDEO_LENGTH], [Utils getCurrentTime]];
            [NSUserDefaultsManager saveObject:content forKey:LOG_SHARE_CONTENT];


        }else{

            [weakSelf.shareAlertView showAlertViewIn:weakSelf.view];
            weakSelf.shareAlertView.shareType = button.tag-10;
//            weakSelf.shareAlertView.theModel = model;
            weakSelf.shareAlertView.smsModel = [weakSelf gengeratSmsPrams];
            weakSelf.shareAlertView.titleText.text = program.programName;
        }
        
    };
    
}

- (void)toolViewDidStartShareVideo:(SJVideoToolView *)toolview
{
    // 分享
    if (![HiTVGlobals sharedInstance].isLogin) {
        SJLoginViewController *sjVC = [[SJLoginViewController alloc]init];
        [self.navigationController presentViewController:sjVC animated:YES completion:nil];
        return;
    }
    _shareListView = self.shareListView;
    //    _shareView =[[SJPortraitShareView alloc]initWithTpye:1];
    //    [self.view addSubview:_shareView];
    //    [_shareView showInView:self.view];
    //    [self LiveTVshareMethod];
}


#pragma mark - 查询收藏过
- (void)checkVideoHasCollected
{

    SJLiveRequestIsCollectModel *model =[SJLiveRequestIsCollectModel new];

    model.uid = [HiTVGlobals sharedInstance].uid;
    model.businessType = @"livereplay";
    model.objectId = self.tvProgram.uuid;
    model.deviceType = @"MOBILE";

    if (self.watchEntity.programSeriesId.intValue >0) {
        model.objectId        = self.watchEntity.programSeriesId;
    }
    else{
        model.objectId        = self.tvProgram.uuid;
        model.startTime = self.tvProgram.startTime;
        model.endTime = self.tvProgram.endTime;
    }

    //    WEAKSELF
    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN forParam:@"/integration/2.0/checkIsCollection" forParameters:[model mj_keyValues]  completion:^(id responseObject) {

        DDLogInfo(@"-----%@",responseObject);
        NSNumber *code = responseObject[@"code"];
        if (code.integerValue == 0) {

            _toolView.collected = YES;
            _player.view.isCollected = YES;
        }
        else{
            _toolView.collected = NO;
            _player.view.isCollected = NO;
        }

    }failure:^(NSString *error) {

        DDLogError(@"-----%@",error);


    }];

}
#pragma -mark 分享delegate

- (void)SJShareContentWithPlatform:(Platform)type andModel:(SJ30SVedioModel *)model isDo:(BOOL) flag{

    [self.shareAlertView hiddenAlertView];

    if (shareManager == nil) {
        shareManager = [[SJShareManager alloc]init];
    }


    if (flag) {
        SJShareMessage *shareMessage = [SJShareMessage new];
        shareMessage.platform = type;
        shareMessage.messageType = ShareMessageTypeUrl;
        shareMessage.messageTitle = model.title;
        shareMessage.messageContent = model.content;
        shareMessage.messageSourceLink =model.link;
        shareMessage.messageThumbImageUrl = model.imgUrl;

        [shareManager shareObject:shareMessage];
    }

    NSString* way = nil;
    switch (type) {
        case ShiJia:
            way = @"视加";
            break;
        case WeChat:
            way = @"微信";
            break;
        case WeChatFriend:
            way = @"朋友圈";
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
    NSString* content = [NSString stringWithFormat:@"state=%@&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&way=%@&sharetime=%@&sharepoint=%@",@"%d", self.videoType == kLiveTVDetailTypeLive? @"直播":@"回看", isNullString(self.tvStation.uuid), isNullString(self.watchEntity.programSeriesId), [NSString stringWithFormat:@"%d",(int)self.tvProgram.programId], isNullString(self.watchEntity.programSeriesName), isNullString(self.tvProgram.programName), way,[[NSUserDefaults standardUserDefaults] objectForKey:LOG_SHARE_VIDEO_LENGTH], [Utils getCurrentTime]];
    [NSUserDefaultsManager saveObject:content forKey:LOG_SHARE_CONTENT];

}

#pragma mark - Setter & Getter
- (ShareAlertView *)shareAlertView
{
    if (!_shareAlertView) {
        _shareAlertView = [ShareAlertView new];
        _shareAlertView.sharedelegate = self;
    }
    return _shareAlertView;
}

- (WatchListEntity *)watchEntity
{
    if (!_watchEntity) {
        _watchEntity = [WatchListEntity new];
    }
    return _watchEntity;
}


-(void)chooseOneWatchEntityFromGuestList:(WatchListEntity *)model{

    if ([model.contentType isEqualToString:@"live"]) {

        self.watchEntity = model;
        self.tvProgram = nil;
        self.tvStation = nil;
        [self refreshData];
    }
    else{
        if ([self.delegate respondsToSelector:@selector(liveTVDetail:didSelectRecommendItem:)]) {
            [self.delegate liveTVDetail:self didSelectRecommendItem:model];
        }
    }

}
#pragma -mark 是否在直播中
-(BOOL)live:(WatchListEntity *)entity{
    NSString *stamp = [Utils nowTimeString];
    long long date = [stamp longLongValue];
    if (date >=entity.startTime && date <= entity.endTime) {
        return YES;
    }
    return NO;
}
#pragma -mark OrientationDidChange
-(void)deviceOrientationDidChange{

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    //    CGSize layoutSize ;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;

    if ((orientation == UIDeviceOrientationLandscapeLeft ||  orientation == UIDeviceOrientationLandscapeRight) && screenSize.width > screenSize.height) {

        guestVC.view.frame = self.player.view.frame;
        [guestVC.view layoutIfNeeded];
        [_shareView hiddleFromSuperView];
        [_shareListView hiddleFromSuperView];
         [_shareAlertView hiddenAlertView];
          [_player.view setStyle:SJVideoPlayerViewStyleFullScreen];
    }else if(orientation == UIDeviceOrientationPortrait  && screenSize.width < screenSize.height){

        guestVC.view.frame = self.player.view.frame;
        [guestVC.view layoutIfNeeded];
        [_shareView hiddleFromSuperView];
         [_shareAlertView hiddenAlertView];
          [_player.view setStyle:SJVideoPlayerViewStyleMini];
    }

    [_videoDetailView.seriesTableView hiddenFullView];

}

#pragma -mark follow好友加入聊天室
- (void)joinRoom:(NSNotification *)notification
{
    _segmentedControl.selectedSegmentIndex = _segmentedControl.items.count - 1;
    [self segmentedControlValueChanged:nil];

}
#pragma -mark 遥控器
- (void)goRemoteVC:(NSNotification *)notification
{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:NSStringFromSelector(@selector(orientation))];
    SJRemoteControlViewController *remoteVC = [[SJRemoteControlViewController alloc] init];
    [self.navigationController pushViewController:remoteVC animated:YES];

}


- (void)animationDidStart:(CAAnimation *)anim
{}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{}
#pragma -mark 影片鉴权
-(void)queryPriceRequest
{
    if ([[HiTVGlobals sharedInstance].disable_moudles containsObject:@"vip"]) {
        return;
    }
    if ([self.watchEntity.contentType isEqualToString:@"watchtv"]) {
        // return;
    }
    NSString *contentId = self.tvProgram.uuid/*@"3122292"*/;
    /*if (self.watchEntity.programSeriesId.intValue >0) {
     contentId        = self.watchEntity.programSeriesId;
     }*/

    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    //[parameters setValue:TestUID forKey:@"uid"];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:@"VIDEO" forKey:@"businessType"];
    //[parameters setValue:self.videoID forKey:@"contentId"];
    [parameters setValue:contentId forKey:@"contentId"];
    [parameters setValue:[HiTVGlobals sharedInstance].phoneNo forKey:@"phone"];
    [parameters setValue:@"PHONE" forKey:@"source"];

    [parameters setValue:@"" forKey:@"token"];
    [parameters setValue:@"" forKey:@"deviceId"];
    [parameters setValue:@"" forKey:@"spToken"];

    //!!!:后台逻辑 当ppvlist 为[] 不需要鉴权
    //!!!:
    if ([_tvProgram.ppvList count]<1) {
        //    [parameters setValue:nil forKey:@"cosInquiryInfo"];
        return;

    }else{
        [parameters setValue:[_tvProgram.ppvList mj_JSONString] forKey:@"cosInquiryInfo"];
    }
    if (self.ppvId !=nil && self.ppvId.length > 0) {
        [parameters setValue:self.ppvId forKey:@"ppvId"];
    }
    __weak __typeof(self)weakSelf = self;

    [BaseAFHTTPManager postRequestOperationForHost:BUSINESSHOST forParam:@"/phone/queryPrice" forParameters:parameters  completion:^(id responseObject) {

        __strong __typeof(weakSelf)strongSelf = weakSelf;;
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"result"];
        if ([code isEqualToString:@"ORD-000"]) {
            strongSelf.player.noFree = NO;
        }
        else if ([code isEqualToString:@"ORD-400"]){
            strongSelf.player.noFree = YES;
            [_player showFullPayTipView];
            //[_player stop];

            NSArray *productlist = responseDic[@"productlist"];
            NSMutableArray *tempArray = [NSMutableArray array];

            for (NSDictionary *dic in productlist) {
                ProductEntity *entity = [[ProductEntity alloc]initWithDictionary:dic];
                entity.contentId = contentId;
                [tempArray addObject:entity];
#ifdef BeiJing
                break;
#else
#endif
            }
            strongSelf.productArray = tempArray;

        }

    }failure:^(NSString *error) {

    }];
}
#pragma -mark （收费节目）购买
-(void)buyNow{
    if ([HiTVGlobals sharedInstance].isLogin) {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:NSStringFromSelector(@selector(orientation))];
        ProductEntity *productEntity = self.productArray.firstObject;
        if ([productEntity.businessType isEqualToString:@"MEMBER"]) {
            SJVIPViewController *VIPVC =[[SJVIPViewController alloc]initWithNibName:@"SJVIPViewController" bundle:nil];
            [self.navigationController pushViewController:VIPVC animated:YES];
        }
        else{
            SJPayViewController *payVC = [[SJPayViewController alloc]initWithNibName:@"SJPayViewController" bundle:nil];
            payVC.productList = self.productArray;
            payVC.recommArray = self.recommendList;
            UINavigationController *payNav = [[UINavigationController alloc] initWithRootViewController:payVC];
            [self presentViewController:payNav animated:YES completion:nil];

            self.navigationController.navigationBarHidden = NO;
        }
    }
    else{
        SJLoginViewController *sjVC = [[SJLoginViewController alloc]init];
        [self presentViewController:sjVC animated:YES completion:nil];
    }

}

#pragma mark 新版分享View
-(AlbumShareView *)shareListView{

    _shareListView = [[AlbumShareView alloc]init];
    _shareListView.photoShareDelegate = self;
    [_shareListView setTitleString:@" 分享到微信、朋友圈、微博、通讯录仅支持30秒或60秒片段"];
    [[UIApplication sharedApplication].keyWindow addSubview:_shareListView];
    [_shareListView AlbumShareShowInView:[UIApplication sharedApplication].keyWindow];
    return _shareListView;
}
#pragma mark 设备列表页面
-(SJDLNAListViews *)DLNAListView{
    if (!_DLNAListView) {
        _DLNAListView = [SJDLNAListViews new];
        _DLNAListView.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:_DLNAListView];
    }
    return _DLNAListView;
}

#pragma mark  photoShareDelegate
-(void)PhotoShareToSocailName:(Platform)name{
    TVProgram *program = self.programArray[self->currentVideoIndex];
    program = program==nil?self.tvProgram:program;
    NSString *aa = [NSString stringWithFormat:@"%f",self.player.currentPlayedSeconds];
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:aa];
    aa =[num1 stringValue];
     SJ30SVedioRequestModel *model = [SJ30SVedioRequestModel new];
     if ([self.LivePlayType isEqualToString:@"play"]) {
     model.videoType        = @"live";
     model.videoTime = [aa integerValue];
     model.videoId = program.uuid;
     model.videoTitle = program.programName;

     }else{
     if ([[self.player.actionUrl absoluteString]containsString:@"/media/"]) {

     model.videoTime = [aa integerValue];
     model.videoType = @"looktv";
     model.videoId = [self shortVedioString:[self.player.actionUrl absoluteString]];

     }else{
     model.videoType        = @"lookback";
     model.videoTime = [aa integerValue];
     model.videoId = [NSString stringWithFormat:@"%@/%@/%@",program.uuid,[self timeString:program.startTime],[self timeString:program.endTime]];
     model.videoTitle = program.programName;

     }

     }

     //      _smsVideoParams.shareType = @"lookback";

     //_smsVideoParams.contentName = self.tvProgram.programName;


     model.videoTime = [aa integerValue];
     model.userName = [HiTVGlobals sharedInstance].nickName;
     model.userHeadImageUrl = [HiTVGlobals sharedInstance].faceImg;
     model.videoSecond = 30;

    if (name==ShiJia) {

        self.hidesBottomBarWhenPushed = YES;
        SJShareVideoViewController *shareVC = [[SJShareVideoViewController alloc] init];

        SJShareVideoViewModel *viewModel = [[SJShareVideoViewModel alloc] initWithController:shareVC];
        viewModel.tvProgram = program;
        viewModel.tvStation = self.tvStation;
        if (_videoType == kLiveTVDetailTypeLive) {
            viewModel.videoType = TPShareVideoTypeLive;
        }
        else{
            viewModel.videoType = TPShareVideoTypeReplay;
        }

        viewModel.currentPlayedSeconds = self.player.currentPlayedSeconds;
        shareVC.viewModel = viewModel;

        [self.navigationController pushViewController:shareVC animated:YES];

        // add log.
        NSString* content = [NSString stringWithFormat:@"state=%@&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&way=%@&sharetime=%@&sharepoint=%@",@"%d", self.videoType == kLiveTVDetailTypeLive? @"直播":@"回看", isNullString(self.tvStation.uuid), isNullString(self.watchEntity.programSeriesId), [NSString stringWithFormat:@"%d",(int)self.tvProgram.programId], isNullString(self.watchEntity.programSeriesName), isNullString(self.tvProgram.programName), @"和家庭好友",[[NSUserDefaults standardUserDefaults] objectForKey:LOG_SHARE_VIDEO_LENGTH], [Utils getCurrentTime]];
        [NSUserDefaultsManager saveObject:content forKey:LOG_SHARE_CONTENT];


    }else{

        [self.shareAlertView showAlertViewIn:self.view];
        self.shareAlertView.shareType = name;
//        self.shareAlertView.theModel = model;
        self.shareAlertView.smsModel = [self gengeratSmsPrams];
        self.shareAlertView.titleText.text = program.programName;
    }
}
#pragma mark DLNADelegate

-(void)DLNACallBack:(NSNotification *)notify{
    [MBProgressHUD hideHUD];
    NSDictionary *dict = notify.object;
    if ([[dict objectForKey:@"status"] integerValue]==0) {
        [MBProgressHUD showSuccess:@"投屏成功" toView:nil];
        //DLNA 投屏成功标志
        [HiTVGlobals sharedInstance].DLNASuccess = YES;
        _toolView.screened = YES;
        _player.isScreening = YES;
    }else{
        [MBProgressHUD showSuccess:@"投屏失败" toView:nil];
         [HiTVGlobals sharedInstance].DLNASuccess = NO;
    }
}

-(void)DLNAViewButtonClickWithIndex:(NSInteger)index{
    if (index==1) {
        if ([HiTVGlobals sharedInstance].isLogin) {
            self.hidesBottomBarWhenPushed = YES;
            ShareAppViewController *shareAppVC = [[ShareAppViewController alloc]initWithNibName:@"ShareAppViewController" bundle:nil];;
            [self.navigationController pushViewController:shareAppVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        else{
            SJLoginViewController *sjVC = [[SJLoginViewController alloc]init];
            [self presentViewController:sjVC animated:YES completion:nil];
        }
    }else{
        DDLogInfo(@"搜索");
    }
}

-(void)DLNAViewScreenActionWithType:(NSInteger)type{
    if (type==0) {
        [ScreenManager sharedInstance].screenManagerBlock = ^(BOOL isSuccess,NSString *time){
            if (isSuccess) {
                _toolView.screened = YES;
                _player.isScreening = YES;
            }
            else{
                if (time.floatValue>0) {
                    [self toolViewDidCancelScreen:nil];
                    [_player seekToTime:time.floatValue];
                }
                else if (time.floatValue == -1){
                    [self showNoDeviceAlert];
                }
                else if(time.floatValue == 0){
                    _toolView.screened = NO;
                    _player.isScreening = NO;
                }
            }
        };
        [self onClickScreenProjection];
    }else{
        [MBProgressHUD showMessag:@"正在投屏" toView:nil];
    }
}
#pragma mark  电视未关联状态
-(void)showNoDeviceAlert{
    [adViewModel start];
}
-(void)scan{
    if ([HiTVGlobals sharedInstance].isLogin) {
        self.hidesBottomBarWhenPushed = YES;
        QRCodeController *qrVC = [[QRCodeController alloc]init];
        qrVC.type = @"2";
        [self.navigationController pushViewController:qrVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else{
        
        SJLoginViewController *sjVC = [[SJLoginViewController alloc]init];
        [self.navigationController presentViewController:sjVC animated:YES completion:nil];
    }
}
#pragma mark  单条查询足迹
-(void)querySingleHistory
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    if ([self.watchEntity.contentType isEqualToString:@"watchtv"]||[self.watchEntity.contentType isEqualToString:@"newWatchTv"]) {
        [parameters setValue:@"watchtv" forKey:@"businessType"];
    }
    else{
        [parameters setValue:@"livereplay" forKey:@"businessType"];
    }
    
    if (self.watchEntity.programSeriesId.intValue >0) {
        [parameters setValue:self.watchEntity.programSeriesId forKey:@"objectId"];
    }
    else{
        [parameters setValue:self.tvProgram.uuid forKey:@"objectId"];
        [parameters setValue:self.tvProgram.startTime forKey:@"startTime"];
        [parameters setValue:self.tvProgram.endTime forKey:@"endTime"];
        
    }

    [parameters setValue:@"MOBILE" forKey:@"deviceType"];
    [parameters setValue:T_STBext forKey:@"abilityString"];
    
    WEAKSELF
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN forParam:@"/integration/2.0/querySingleHistory" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"code"];
        if (code.intValue == 0) {
            NSDictionary *data = responseDic[@"data"];
            weakSelf.videoDatePoint = [data[@"endWatchTime"] floatValue];
            if (weakSelf.videoDatePoint<0) {
                weakSelf.videoDatePoint = 0;
            }
           // NSString *seriesNumber = data[@"seriesNumber"];

            _player.datePoint = weakSelf.videoDatePoint;
        }
        [weakSelf initVerTimer];
    }failure:^(NSString *error) {
        [weakSelf initVerTimer];
        
        
    }];
}
#pragma mark - 兑换华为CDN播放地址
-(void)getHWPlayUrl:(NSString *)actionURL{
    if (![actionURL hasPrefix:@"http://ip:port/"]) {
        self.player.actionUrl = [NSURL URLWithString:actionURL];
    }
    else{
        HWVideoModel *model = [HWVideoModel new];
        NSArray *arr = [actionURL componentsSeparatedByString:@"/"];
        model.cid = arr.lastObject;
        model.tid = @"-1";
        model.contentType = @"0";
        if ([ self.LivePlayType isEqualToString:@"play"]) {
            model.playType = @"2";
            model.businessType = @"2";
        }
        else{
            model.playType = @"1";
            model.businessType = @"1";
        }
        WEAKSELF
        [[HWOauthManager sharedInstance]playContentAuthorize:model completion:^(NSString *playUrl,NSString *error){
            if (error==nil) {
                weakSelf.player.actionUrl = [NSURL URLWithString:playUrl];
            }
            else{
                //[weakSelf hwCDNauthentication:model];
            }
        }];
    }
}
/*
 *鉴权token失效，再进行一次鉴权
 */
-(void)hwCDNauthentication:(id)model{
    [[HWOauthManager sharedInstance]playContentAuthorize:model completion:^(NSString *playUrl,NSString *error){
        if (error==nil) {
            self.player.actionUrl = [NSURL URLWithString:playUrl];
        }
        else{
            
        }
    }];
}
@end
