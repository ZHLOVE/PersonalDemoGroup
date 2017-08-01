//
//  SJVideoDetailViewController.m
//  ShiJia
//
//  Created by yy on 16/2/2.
//  Copyright © 2016年 yy. All rights reserved.
//  点播详情页

#import "SJVideoDetailViewController.h"

#import "YYKit.h"

#import "TPIMUser.h"
#import "SJVideoPlayerKit.h"
#import "SJVideoPlayerView.h"
#import "SJVideoDetailSegmentedControl.h"
#import "SJPrivateChatRoomMainView.h"
#import "SJVideoToolView.h"
#import "TPVideoDetailMainView.h"
#import "SJVideoInfoView.h"
#import "SJVideoRecommendView.h"
#import "TPPrivateMUCInputView.h"

#import "HiTVVideo.h"
#import "VideoSource.h"
#import "TPDanmakuData.h"

#import "TPIMAlertView.h"
#import "VideoDataProvider.h"
#import "AES128Util.h"
#import "SJChatRoomViewModel.h"
#import "SJLiveTVCollcetModel.h"
#import "ScreenManager.h"
#import "TPIMContentModel.h"
#import "TPXmppRoomManager.h"

#import "SJShareVideoViewModel.h"
#import "SJShareVideoViewController.h"
#import "SJPortraitShareView.h"
#import "SJVedioNetWork.h"
#import "SJ30SVedioRequestModel.h"
#import "WatchListEntity.h"
#import "SJLoginViewController.h"
#import "SJGuestYouLikeViewController.h"
#import "SJHitTestView.h"
#import "SJVIPViewController.h"
#import "ProductEntity.h"
#import "SJPayViewController.h"
#import "SJRemoteControlViewController.h"
#import "SJShareManager.h"
#import "AlbumShareView.h"
#import "ShareAppViewController.h"
#import "SJDLNAListViews.h"
#import "QRCodeController.h"
#import "HWVideoModel.h"
#import "HWOauthManager.h"
#import "SJAdViewModel.h"

static NSInteger kAnimationDuration  = 0.3;
static CGFloat   kSegmentecControlHeight = 40.0;
//static CGFloat   kInnerSpacing = 10.0;

@interface SJVideoDetailViewController ()<SJVideoPlayerDelegate,SJVideoToolViewDelegate,SJShareDelegate,UINavigationControllerDelegate,guestDelegate,PhotoShareDelegate,DLNAViewDelegate>
{

    SJHitTestView *mainView;//用于详情view与聊天室view的切换


    NSInteger       lastSelectedIndex;//分段开关上一次选中索引
    NSMutableArray *videos;           // 视频array

    __block HiTVVideo *video;
    //    NSInteger currentVideoIndex;

    //add by jhl 20160702
    NSTimer *verTimer;              //计时器

    SJGuestYouLikeViewController *guestVC;


    __block float current;
    __block NSString *localeDateStr;
    SJShareManager *shareManager;

    long  second;//当前观看时长

    //RACObserves handle instance array.
    NSMutableArray* RACObserves;
    
    SJAdViewModel *adViewModel;

}
@property (nonatomic, strong) SJVideoPlayerKit              *player;          //播放器
@property (nonatomic, strong) SJVideoToolView               *toolView;
@property (nonatomic, strong) SJVideoDetailSegmentedControl *segmentedControl;//分段开关
@property (nonatomic, strong) TPVideoDetailMainView         *videoDetailView; //视频详情主view
@property (nonatomic, strong) SJPrivateChatRoomMainView     *chatRoomView;    //聊天室主view
@property (nonatomic, strong) ScreenManager *screenManager;
@property (nonatomic, strong) SJPortraitShareView *shareView ;
@property (nonatomic, strong) ShareAlertView *shareAlertView;

@property (nonatomic, strong) NSMutableArray *relevantList;      //相关推荐
@property (nonatomic, strong) NSMutableArray *recommendList;     //猜您喜欢

@property (nonatomic, strong) NSMutableArray *productArray;     //收费购买产品信息

@property (nonatomic, strong) AlbumShareView *shareListView;
@property (nonatomic, strong) SJDLNAListViews                *DLNAListView;

@end

@implementation SJVideoDetailViewController

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];

    if (self) {

        @weakify(self)

        adViewModel = [[SJAdViewModel alloc] initWithActiveController:self];
        [adViewModel setLoadAdFailedBlock:^{
            @strongify(self)
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您未关联电视设备，先打开“扫一扫”页面进行关联！" message:nil delegate:self cancelButtonTitle:@"前往扫一扫" otherButtonTitles:@"取消", nil];
            alert.tag=1001;
            [alert show];
        }];
        
        RACObserves = [NSMutableArray array];
        // 播放器
        _player = [[SJVideoPlayerKit alloc] init];
        _player.delegate = self;
        _player.activeController = self;
        [_player setDidClickBack:^{
            @strongify(self)
            // 返回
            NSString* playerError = [[NSUserDefaults standardUserDefaults] objectForKey:kPlayerError];
            if (playerError == nil) {
                playerError = @"no";
            }
            VideoSource *data = self->video.sources[self.currentVideoIndex];
            NSString* content = [NSString stringWithFormat:@"id=%@&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&programtypename=%@&firstsource=%@&epgname=%@&tag=%@&playPoint=%.2f&Url=%@&BuffCount=%ld&BuffAverTimeCost=%.2f&startTime=%@&endTime=%@&PlayTotalTimeCost=%.2f&playstream=%lld&error=%@", isNullString(self.watchEntity.contentId),  @"点播",isNullString(data.channelUuid),isNullString(self.watchEntity.programSeriesId),self->_programId,isNullString(self.watchEntity.programSeriesName),isNullString(data.name), isNullString(self.watchEntity.programSeriesType),isNullString(self.tabBarController.tabBar.selectedItem.title), isNullString(self.epgName), isNullString(self->video.tag), self.player.videoStartFrom,isNullString(data.actionURL), (long)self.player.countBuffer,self.player.avgTotalBuffer,isNullString(self->localeDateStr), [Utils getCurrentTime],self.player.videoDuration,[self.player getReceivedBytes], isNullString(playerError)];

            [Utils BDLog:1 module:@"604" action:@"AppPlayQos" content:content];

            [self popViewController];

        }];

        [_player setDidClickDanmu:^(BOOL showBarrage) {
            // 弹幕开关
            @strongify(self)
            TPIMContentModel *model = [[TPIMContentModel alloc] init];
            if (showBarrage) {
                model.action = @"open";
            }
            else{
                model.action = @"close";
            }
            model.playerType = @"danmuSwitch";
            [self.screenManager remoteNetVideoWithContentModel:model];
        }];


        [RACObserves addObject: [RACObserve(_player, currentPlayedSeconds) subscribeNext:^(NSNumber *secondsNum) {
            [TPXmppRoomManager defaultManager].currentPlayedSeconds = [secondsNum floatValue];

            static int lastVal = 0;
            int val = (int)[TPXmppRoomManager defaultManager].currentPlayedSeconds;

            if (val % (60 * 5) == 0 && val != 0 && lastVal != val) {
                //__strong __typeof(weakSelf)strongSelf = weakSelf;
                @strongify(self)
                self->current = [TPXmppRoomManager defaultManager].currentPlayedSeconds;
                DDLogInfo(@"当前已播放: %.2f",self->current);
                VideoSource *data = self->video.sources[self.currentVideoIndex];
                NSString* content = [NSString stringWithFormat:@"curstatus=%@&time=%0.2f&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@",  @"点播",self->current,isNullString(data.channelUuid), isNullString(self.watchEntity.programSeriesId),isNullString(self.programId),isNullString(self.watchEntity.programSeriesName), isNullString(data.name)];

                [Utils BDLog:1 module:@"603" action:@"AppCheckPoint" content:content];
            }

            lastVal = val;

        }]];


        [RACObserves addObject:[RACObserve(_player, currentVideoIndex) subscribeNext:^(NSNumber *x) {
            //__strong __typeof(weakSelf)strongSelf = weakSelf;
            @strongify(self)
            if (self.currentVideoIndex != [x integerValue]) {
                if (_player.isDidClickSeries || (!([video.playSort isEqualToString:@"DESC"]/*||[video.playSort isEqualToString:@"desc"]*/))) {
                    self.currentVideoIndex = [x integerValue];
                    self.videoDetailView.currentVideoIndex = self.currentVideoIndex;
                    self.videoDetailView.seriesTableView.currentVideoIndex = self.currentVideoIndex;

                }
                else{
                    // [PRD-11821]
                    self.currentVideoIndex = /*[x intValue];//*/_currentVideoIndex-1;
                    _videoDetailView.currentVideoIndex = self.currentVideoIndex;
                    _videoDetailView.seriesTableView.currentVideoIndex = self.currentVideoIndex;
                }
                _player.view.currentVideoIndex = self.currentVideoIndex;


                if (self->video.sources.count > self.currentVideoIndex) {
                    VideoSource *data = self->video.sources[self.currentVideoIndex];
                    [self getHWPlayUrl:data.actionURL];
                    self.player.view.title = data.name;
                    [TPXmppRoomManager defaultManager].videoSource = data;

                    [self queryPriceRequest];
                    [self addHistort:@"start"];


                }
            }
            _player.isDidClickSeries = NO;

        }]];

        [RACObserves addObject:[RACObserve(_player, actionUrl) subscribeNext:^(id x) {
            if (guestVC) {
                [guestVC.view removeFromSuperview];
                guestVC = nil;
            }
        }]];

        // 投屏、分享、收藏view
        _toolView = [[SJVideoToolView alloc] init];
        _toolView.delegate = self;

        // 分段开关
        _segmentedControl = [[SJVideoDetailSegmentedControl alloc] initWithItems:@[@"详情",@"私聊"]];
        _segmentedControl.activeController = self;
        [_segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];

        lastSelectedIndex = _segmentedControl.selectedSegmentIndex;


        // main view
        mainView = [[SJHitTestView alloc] init];
        mainView.backgroundColor = kColorLightGrayBackground;

        // 详情view
        _videoDetailView = [[TPVideoDetailMainView alloc] init];
        _videoDetailView.backgroundColor = kColorLightGrayBackground;
        //_videoDetailView.delegate = self;

        [_videoDetailView.seriesTableView setDidSelectItemAtIndex:^(NSInteger index) {
            @strongify(self)
            //__strong __typeof(weakSelf)strongSelf = weakSelf;;
            self.currentVideoIndex = index;
            self.player.currentVideoIndex = self.currentVideoIndex;
            self.player.view.currentVideoIndex = self.currentVideoIndex;
            self.toolView.screened = NO;
            if (self->video.sources.count > self.currentVideoIndex) {
                VideoSource *data = self->video.sources[self.currentVideoIndex];
                [self getHWPlayUrl:data.actionURL];
                self.player.view.title = data.name;
                self.watchEntity.setNumber = data.setNumber;
                self.player.trialDura = data.trialDura.floatValue*60;
                [TPXmppRoomManager defaultManager].videoSource = data;
                [self queryPriceRequest];
                [self addHistort:@"start"];

            }
        }];

        [_videoDetailView setDidSelectItemAtIndex:^(NSInteger index) {


            @strongify(self)
            self.currentVideoIndex = index;
            self.player.currentVideoIndex = self.currentVideoIndex;
            self.player.view.currentVideoIndex = self.currentVideoIndex;
            self.toolView.screened = NO;

            if (self->video.sources.count > self.currentVideoIndex) {
                VideoSource *data = self->video.sources[self.currentVideoIndex];
                [self getHWPlayUrl:data.actionURL];
                self.player.view.title = data.name;
                self.watchEntity.setNumber = data.setNumber;
                self.player.trialDura = data.trialDura.floatValue*60;
                [TPXmppRoomManager defaultManager].videoSource = data;
                [self queryPriceRequest];
                [self addHistort:@"start"];

            }
        }];
        //vip 通道
        [_videoDetailView setVipLanesImgTapped:^(NSInteger index) {
            @strongify(self)
            //__strong __typeof(weakSelf)strongSelf = weakSelf;;
            if ([[HiTVGlobals sharedInstance].disable_moudles containsObject:@"vip"]) {
                [OMGToast showWithText:@"暂未开放"];
            }
            else{
                SJVIPViewController *VIPVC =[[SJVIPViewController alloc]initWithNibName:@"SJVIPViewController" bundle:nil];
                [self.navigationController pushViewController:VIPVC animated:YES];
            }

        }];
        // 选择为您推荐
        [_videoDetailView.recommendView setDidSelectRecommendItemAtIndex:^(NSInteger index) {
            //__strong __typeof(weakSelf)strongSelf = weakSelf;;
            @strongify(self)
            self.toolView.screened = NO;

            WatchListEntity *recommendModel = self.relevantList[index];

            if ([TPXmppRoomManager defaultManager].isInChatRoom) {

                NSString *mes = [NSString stringWithFormat:@"亲爱的%@:",[HiTVGlobals sharedInstance].nickName];

                TPIMAlertView *alert = [[TPIMAlertView alloc]initWithTitle:mes
                                                                   message:@"是否退出聊天室"
                                                           leftButtonTitle:@"取消"
                                                          rightButtonTitle:@"退出"];
                alert.rightButtonClickBlock = ^(){
                    [self handleRecommendModel:recommendModel];
                };
                [alert show];
            }
            else{
                [self handleRecommendModel:recommendModel];
            }

        }];

        // 聊天室view
        _chatRoomView = [[SJPrivateChatRoomMainView alloc] init];
        _chatRoomView.backgroundColor = kColorLightGrayBackground;
        _chatRoomView.activeController = self;

        //聊天室开始播放语音，关闭播放器声音
        [_chatRoomView setVoiceMessageWillStartPlay:^{
            @strongify(self)
            [self.player mutePlayer];
        }];
        
        //聊天室语音播放结束，恢复播放器声音
        [_chatRoomView setVoiceMessageDidFinishPlaying:^{
            @strongify(self)
            [self.player recoverPlayerVolume];
        }];
        
        HiTVVideo *vvv = video;
        [_chatRoomView setPrivateRoomDidReceiveDanmuData:^(TPDanmakuData *dataMsg) {
            @strongify(self)
            if (dataMsg&&dataMsg.isSender) {

                // add log.
                VideoSource *data = vvv.sources[self.currentVideoIndex];

                NSString* content = [NSString stringWithFormat:@"type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&actiontype=%@", @"点播",isNullString(data.channelUuid), isNullString(self.watchEntity.programSeriesId),isNullString(self.programId),isNullString(self.watchEntity.programSeriesName), isNullString(data.name), @"私聊"];
                [Utils BDLog:1 module:@"605" action:@"PrivateMessage" content:content];
                // add log.

            }
            [self.player.view sendBarrage:dataMsg];
            [self screenDanmuData:dataMsg];
        }];

        [RACObserves addObject:[RACObserve(_chatRoomView, beyonded) subscribeNext:^(NSNumber *x) {
            //__strong __typeof(weakSelf)strongSelf = weakSelf;;
            @strongify(self)
            self->mainView.beyonded = x.boolValue;
        }]];

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinRoom:) name:TPIMNotification_FollowJoinRoom object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyNow) name:TPIMNotification_BuyNow object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goRemoteVC:) name:TPIMNotification_GOREMOTE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runBackgroundComponent) name:TPIMNotification_vedioReadyToPlay object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_refreshAfterUserLogin)
                                                 name:TPIMNotification_ReloadUser
                                               object:nil];


    [self.view addSubview:_player.view];
    [self.view addSubview:_toolView];
    [self.view addSubview:_segmentedControl];

    [self.view addSubview:mainView];
    [mainView addSubview:_chatRoomView];
    [mainView addSubview:_videoDetailView];

    if ([TPXmppRoomManager defaultManager].isInChatRoom) {
        _segmentedControl.selectedSegmentIndex = 1;
        [self segmentedControlValueChanged:nil];
    }
    [self loadVideoInfomation];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.navigationController.navigationBarHidden = YES;

    [HiTVGlobals sharedInstance].isWatchingVideo = YES;
    if (!_player.isScreening) {
        [_player play];
    }
    [_chatRoomView refreshData];
}
-(void)p_refreshAfterUserLogin{
    //影片鉴权
    [self queryPriceRequest];
}
-(void) runBackgroundComponent
{
    __weak __typeof(self)weakSelf = self;
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    // add log.
    localeDateStr = [Utils getCurrentTime];
    VideoSource *data = strongSelf->video.sources[strongSelf.currentVideoIndex];
    NSString* content = [NSString stringWithFormat:@"type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&programtypename=%@&firstsource=%@&epgname=%@&tag=%@&starttime=%@",  @"点播",isNullString(data.channelUuid), isNullString(strongSelf.watchEntity.programSeriesId),isNullString(strongSelf.programId), isNullString(strongSelf.watchEntity.programSeriesName), isNullString(data.name), isNullString(strongSelf.watchEntity.programSeriesType),isNullString(strongSelf.tabBarController.tabBar.selectedItem.title), isNullString(strongSelf.epgName), isNullString(strongSelf->video.tag), [Utils getCurrentTime]];

    [Utils BDLog:1 module:@"604" action:@"AppPlayAction" content:content];
    // add log.
}


-(WatchListEntity *)watchEntity{
    if (!_watchEntity) {
        _watchEntity = [WatchListEntity new];
    }
    return _watchEntity;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    self.navigationController.navigationBarHidden = NO;
    [HiTVGlobals sharedInstance].isWatchingVideo = NO;
    if (!_player.isTVPlay) {
        [_player stop];
    }


    [verTimer invalidate];
    verTimer=nil;

    [self deviceOrientationDidChange];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:TPIMNotification_vedioReadyToPlay object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_dlnaBroastcastCallbackImp object:nil];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    // tool view
    _toolView.frame = CGRectMake(0,
                                 _player.view.frame.size.height + _player.view.frame.origin.y,
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
    _chatRoomView.frame = mainView.bounds;

    if (_player.view.style == SJVideoPlayerViewStyleFullScreen) {
        mainView.hidden = YES;
    }
    else{
        mainView.hidden = NO;
    }

    guestVC.view.frame = self.player.view.frame;

}

- (void)dealloc
{
    DDLogInfo(@"############### videoDetailViewController dealloc");
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

#pragma mark - Public operation
- (void)clearData
{
    //    [_player clearPlayer];
    [[TPXmppRoomManager defaultManager] leaveOldRoom];
    //    if ([TPXmppRoomManager defaultManager].isInChatRoom) {
    //        [[TPXmppRoomManager defaultManager] leaveRoom];
    //    }
}

- (void)refreshData
{
    self.currentVideoIndex = 0;
    _player.currentVideoIndex = self.currentVideoIndex;
    _player.view.currentVideoIndex = self.currentVideoIndex;
    _videoDetailView.currentVideoIndex = self.currentVideoIndex;
    [self loadVideoInfomation];
    [_chatRoomView refreshData];

}

#pragma mark - Event
- (void)segmentedControlValueChanged:(id)sender
{

    if (lastSelectedIndex != _segmentedControl.selectedSegmentIndex) {

        [_chatRoomView.inputView resignFirstResponder];
        CATransition *animation = [CATransition animation];
        animation.duration = kAnimationDuration;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionPush;

        NSInteger chatroomTag = [[mainView subviews] indexOfObject:_chatRoomView];
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

}

- (void)logoutAccount:(NSNotification *)notification
{
    [self addHistort:@"end"];
    __weak __typeof(self)weakSelf = self;
    [self.player clearPlayerWithCompletion:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.chatRoomView leaveChatRoom];
        [strongSelf performSelector:@selector(popToRootController) withObject:strongSelf afterDelay:0.5];
    }];

}

- (void)popToRootController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.player clearPlayer];

    for (RACDisposable *handler in RACObserves) {
        [handler dispose];
    }
}

- (void)popViewController
{
    __weak __typeof(self)weakSelf = self;
    if ([TPXmppRoomManager defaultManager].isInChatRoom) {

        NSString *mes = [NSString stringWithFormat:@"亲爱的%@:",[HiTVGlobals sharedInstance].nickName];

        TPIMAlertView *alert = [[TPIMAlertView alloc]initWithTitle:mes
                                                           message:@"是否退出聊天室"
                                                   leftButtonTitle:@"取消"
                                                  rightButtonTitle:@"退出"];
        alert.rightButtonClickBlock = ^(){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf addHistort:@"end"];
            [strongSelf.player clearPlayer];
            [strongSelf.chatRoomView leaveChatRoom];
            [[TPXmppRoomManager defaultManager] clearData];
            for (RACDisposable *handler in RACObserves) {
                [handler dispose];
            }
            _chatRoomView.activeController = nil;
            _toolView.delegate = nil;

            _player.delegate = nil;
            _player.activeController = nil;

            self.shareAlertView.sharedelegate = nil;

            _segmentedControl.activeController = nil;
            [_segmentedControl removeAllTargets];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        };
        [alert show];
    }else{

        [self addHistort:@"end"];
        [self.player clearPlayer];
        _player = nil;
        [self.chatRoomView leaveChatRoom];
        [[TPXmppRoomManager defaultManager] clearData];
        for (RACDisposable *handler in RACObserves) {
            [handler dispose];
        }
        _chatRoomView.activeController = nil;
        _toolView.delegate = nil;

        _player.delegate = nil;
        _player.activeController = nil;

        self.shareAlertView.sharedelegate = nil;

        _segmentedControl.activeController = nil;
        [_segmentedControl removeAllTargets];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - SJVideoPlayerDelegate
- (void)playerWillChangeFrame
{
    [_chatRoomView.inputView resignFirstResponder];
}

- (void)playerDidFinishMinimumScreen
{
    //播放器小屏
    [_chatRoomView.inputView resignFirstResponder];
    [self.view setNeedsLayout];
}

- (void)playerDidFinishFullScreen
{
    //播放器全屏
    [_chatRoomView.inputView resignFirstResponder];
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
- (void)playerDidPlayToCacheVideo{
    if ([video.typeCode isEqualToString:@"11"]) {
        VideoSource *videoSource = video.sources[self.currentVideoIndex];
        if(videoSource.sourceID.length>0 &&video.videoID.length>0){
            NSMutableArray *tempArray = [NSMutableArray array];
            NSArray *videoList = [NSUserDefaultsManager getObjectForKey:video.videoID];
            [tempArray addObjectsFromArray:videoList];
            [tempArray addObject:videoSource.sourceID];
            
            [NSUserDefaultsManager saveObject:tempArray forKey:video.videoID];
        }
    }
}

#pragma mark - Request
-(void)loadVideoInfomation
{
    __weak __typeof(self)weakSelf = self;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString* url = [NSString stringWithFormat:@"%@/epg/getDetail.shtml?templateId=%@&psId=%@&abilityString=%@",FUSE_EPG, [HiTVGlobals sharedInstance].getEpg_groupId,self.videoID,T_STBext];

    [BaseAFHTTPManager getRequestOperationForHost:url forParam:@"" forParameters:nil completion:^(id responseObject) {

        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        id sources = responseObject[@"data"][@"sources"];
        if (responseObject == nil ||[(NSArray *)responseObject count] == 0 ||[responseObject[@"data"] isKindOfClass:[NSNull class]]||[responseObject[@"code"] isEqualToString:@"3"]||[sources count]==0) {


            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未能播放："
                                                            message:@"该片仅支持电视观看"
                                                           delegate:strongSelf
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            //_player.isTVPlay = YES;


            return;
        }


        second = [Utils nowTimeString].longLongValue;

        [strongSelf getRelevantList];

        video = (HiTVVideo*)[[HiTVVideo alloc] initWithDict:responseObject[@"data"]];
        self.ppvId = isNullString(video.ppvId);

        self.watchEntity.programSeriesId = video.videoID;
        self.watchEntity.programSeriesName = video.name;
        self.watchEntity.programSeriesType = video.type;


        if ([isNullString(self.ppvId) length] != 0) {
          //  [self queryPriceRequest];
        }

        BOOL xz = [video.cpcode isEqualToString:@"TENCENT"]||[video.definition isEqualToString:@"4k"];
        if ([CHANNELID isEqualToString:taipanTest63]) {
            xz = [video.cpcode isEqualToString:@"TENCENT"]||[video.description isEqualToString:@"4k"]||video.ppvId.length!=0;
        }
        if (xz) {

            _player.isTVPlay = YES;
            _toolView.isTVPlay = YES;

            // 简介
            _videoDetailView.infoView.info = video.information;
            for (VideoSource *data in video.sources) {
                if (data.setNumber.intValue == strongSelf.watchEntity.setNumber.intValue) {
                    NSInteger index = [video.sources indexOfObject:data];
                    strongSelf.currentVideoIndex = index;
                    break;
                }
            }
            // 剧集
            if ([video.typeCode isEqualToString:@"11"]) {
                NSArray *videoArray = [self getStrongVideoSourceArray];
                if (!videoArray) {
                    //如果电视剧里有非法集号，当综艺节目(typeCode=17)处理
                    video.typeCode = @"17";
                    _player.view.seriesList  = video.sources;
                    //}
                    
                    _player.view.seriesCount = video.sources.count;
                    _player.view.seriesStyle = video.sources.count>2?SJVideoPlayerSeriesViewStyleTableView:SJVideoPlayerSeriesViewStyleCollectionView;
                    _videoDetailView.seriesTableView.hidden = NO;
                }
                else{
                    _videoDetailView.programSetId = video.videoID;
                    _videoDetailView.list    = videoArray;;
                    _player.view.seriesList  = videoArray;
                    _player.view.seriesCount = video.sources.count;
                    _player.view.seriesStyle = SJVideoPlayerSeriesViewStyleCollectionView;
                    _videoDetailView.seriesTableView.hidden = YES;
                }
            }else{

                //if (video.sources.count>2) {
                _player.view.seriesList  = video.sources;
                //}

                _player.view.seriesCount = video.sources.count;
                _player.view.seriesStyle = video.sources.count>2?SJVideoPlayerSeriesViewStyleTableView:SJVideoPlayerSeriesViewStyleCollectionView;
                _videoDetailView.seriesTableView.hidden = NO;
            }

            if (video.sources.count > strongSelf.currentVideoIndex) {

                // 当前播放
                VideoSource *data = video.sources[strongSelf.currentVideoIndex];
                _player.view.title = data.name;
                _player.currentVideoIndex = strongSelf.currentVideoIndex;
                _player.view.currentVideoIndex = strongSelf.currentVideoIndex;
                _videoDetailView.currentVideoIndex = strongSelf.currentVideoIndex;
                _player.datePoint = strongSelf.videoDatePoint;
                _player.trialDura = data.trialDura.floatValue*60;
                [TPXmppRoomManager defaultManager].videoSource = data;
            }

            if ([video.typeCode isEqualToString:@"11"]) {
                _videoDetailView.zongyi = NO;
                _videoDetailView.seriesTableView.hidden = YES;


            }else{
                if (video.sources.count>2) {
                    _videoDetailView.seriesTableView.currentIndexPath =  [NSIndexPath indexPathForRow:strongSelf.currentVideoIndex inSection:0];;
                    _videoDetailView.zongyi = YES;
                    _videoDetailView.seriesTableView.list = video.sources;
                    _videoDetailView.seriesTableView.height = 44*video.sources.count+40;
                    if (_videoDetailView.seriesTableView.height>216) {
                        _videoDetailView.seriesTableView.height = 216;
                    }
                    _videoDetailView.seriesTableView.playH = _player.view.size.height+kSegmentecControlHeight;
                    [_videoDetailView setNeedsLayout];
                    [_videoDetailView.seriesTableView.tabView reloadData];
                }
                else{
                    _videoDetailView.zongyi = NO;
                    _videoDetailView.list    = [NSArray arrayWithArray:video.sources];
                    _videoDetailView.seriesTableView.hidden = YES;
                }
            }
            _videoDetailView.collectionview.userInteractionEnabled = NO;
            _videoDetailView.seriesTableView.userInteractionEnabled = NO;
            return ;
        }
        // 简介
        _videoDetailView.infoView.info = video.information;
        if (strongSelf.watchEntity.setNumber.intValue!=0) {
            for (VideoSource *data in video.sources) {
                if (data.setNumber.intValue == strongSelf.watchEntity.setNumber.intValue ) {
                    NSInteger index = [video.sources indexOfObject:data];
                    strongSelf.currentVideoIndex = index;
                    break;
                }
            }
        }

        // 剧集
        if ([video.typeCode isEqualToString:@"11"])
        {
            NSArray *videoArray = [self getStrongVideoSourceArray];
            if (!videoArray) {
                //如果电视剧里有非法集号，当综艺节目(typeCode=17)处理
                video.typeCode = @"17";
                _player.view.seriesList  = video.sources;
                _player.view.seriesCount = video.sources.count;
                _player.view.seriesStyle = video.sources.count>2?SJVideoPlayerSeriesViewStyleTableView:SJVideoPlayerSeriesViewStyleCollectionView;
                _videoDetailView.seriesTableView.hidden = NO;
            }
            else{
                _videoDetailView.programSetId = video.videoID;
                _videoDetailView.list    = videoArray;
                _player.view.seriesList  = videoArray;
                _player.view.seriesCount = video.sources.count;
                _player.view.seriesStyle = SJVideoPlayerSeriesViewStyleCollectionView;
                _videoDetailView.seriesTableView.hidden = YES;
            }
            
        }
        else{
            _player.view.seriesList  = video.sources;
            _player.view.seriesCount = video.sources.count;
            _player.view.seriesStyle = video.sources.count>2?SJVideoPlayerSeriesViewStyleTableView:SJVideoPlayerSeriesViewStyleCollectionView;
            _videoDetailView.seriesTableView.hidden = NO;
        }


        // xmpproom
        if ([TPXmppRoomManager defaultManager].isInChatRoom) {
            NSString *programId = [TPXmppRoomManager defaultManager].invitedMessageModel.contentModel.programId;
            for (VideoSource *data in video.sources) {
                if ([data.sourceID isEqualToString:programId]) {
                    NSInteger index = [video.sources indexOfObject:data];
                    strongSelf.currentVideoIndex = index;
                    break;
                }
            }
        }

        if (strongSelf.programId.length > 0) {
            //NSString *programId = [TPXmppRoomManager defaultManager].invitedMessageModel.contentModel.programId;
            for (VideoSource *data in video.sources) {
                if ([data.sourceID isEqualToString:strongSelf.programId]) {
                    NSInteger index = [video.sources indexOfObject:data];
                    strongSelf.currentVideoIndex = index;
                    break;
                }
            }
        }

        [TPXmppRoomManager defaultManager].video = video;
        [TPXmppRoomManager defaultManager].videoType = TPChatRoomVideoTypeVOD;

        if (video.sources.count > strongSelf.currentVideoIndex) {
            strongSelf.currentVideoIndex = strongSelf.currentVideoIndex;
            // 当前播放
            VideoSource *data = video.sources[strongSelf.currentVideoIndex];
            _player.trialDura = data.trialDura.floatValue*60;
            [self getHWPlayUrl:data.actionURL];
            _player.view.title = data.name;
            _player.currentVideoIndex = strongSelf.currentVideoIndex;
            _player.view.currentVideoIndex = strongSelf.currentVideoIndex;
            _videoDetailView.currentVideoIndex = strongSelf.currentVideoIndex;
            _player.datePoint = strongSelf.videoDatePoint;
            strongSelf.watchEntity.setNumber = data.setNumber;
            _player.trialDura = data.trialDura.floatValue*60;
            [TPXmppRoomManager defaultManager].videoSource = data;

            strongSelf.programId = data.sourceID;
            strongSelf.watchEntity.channelUuid = data.channelUuid;

            //[self queryPriceRequest];
        }

        if ([video.typeCode isEqualToString:@"11"]) {
            _videoDetailView.zongyi = NO;
            _videoDetailView.seriesTableView.hidden = YES;


        }else{
            if (video.sources.count>1||[video.typeCode isEqualToString:@"17"]) {
                _videoDetailView.seriesTableView.currentIndexPath =  [NSIndexPath indexPathForRow:strongSelf.currentVideoIndex inSection:0];;
                _videoDetailView.zongyi = YES;
                _videoDetailView.seriesTableView.list = video.sources;
                _videoDetailView.seriesTableView.height = 44*video.sources.count+40;
                if (_videoDetailView.seriesTableView.height>216) {
                    _videoDetailView.seriesTableView.height = 216;
                }
                _videoDetailView.seriesTableView.playH = _player.view.size.height+kSegmentecControlHeight;
                [_videoDetailView setNeedsLayout];
                [_videoDetailView.seriesTableView.tabView reloadData];
            }
            else{
                _videoDetailView.zongyi = NO;
                _videoDetailView.list    = [NSArray arrayWithArray:video.sources];
                _videoDetailView.seriesTableView.hidden = YES;
            }
        }

        [strongSelf checkWatchTVHasCollected];



        //[strongSelf initVerTimer];
        [strongSelf querySingleHistory];
        if (self.neededScreen) {
            [self.toolView screenButtonClicked:nil];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        [strongSelf p_handleNetworkError];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        if (buttonIndex == 0) {
            [self scan];
        }
    }
    else{
        if(buttonIndex == 0) {
            [self popViewController];
        }
    }
}
#pragma mark - 相关推荐
- (void)getRelevantList
{

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _videoID,@"programSeriesId",
                            WATCHTVGROUPID,@"tvTemplateId",
                            [[HiTVGlobals sharedInstance]getEpg_groupId],@"vodTemplateId",
                            [HiTVGlobals sharedInstance].uid,@"userId",
                            T_STBext,@"abilityString",
                            nil];


    [BaseAFHTTPManager postRequestOperationForHost:MYEPG forParam:@"/vod/getRelevantList" forParameters:params completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (responseObject == nil) {
            return;
        }
        if (responseObject[@"resultList"] == nil) {
            return;
        }
        NSArray *personalList = responseObject[@"resultList"];
        self.relevantList = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in personalList) {
            WatchListEntity *data = [[WatchListEntity alloc] initWithDictionary:dic];
            [self.relevantList addObject:data];
            if (self.relevantList.count>=30) {
                break;
            }
        }
        _videoDetailView.recommendView.list = [NSArray arrayWithArray:self.relevantList];
        [_videoDetailView setNeedsLayout];

    } failure:^(NSString *error) {

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)handleRecommendModel:(WatchListEntity *)recommendModel
{
    [self clearData];

    if ([recommendModel.contentType isEqualToString:@"vod"]||[recommendModel.contentType isEqualToString:@"watchtv"]) {

        self.videoID = recommendModel.programSeriesId;

        [self refreshData];

    }
    else{
        if ([self.delegate respondsToSelector:@selector(vodDetail:didSelectRecommendItem:)]) {
            [self.delegate vodDetail:self didSelectRecommendItem:recommendModel];
        }
    }
}

#pragma mark - 猜您喜欢
-(void)getRecommendList{

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"vod",@"type",
                            _videoID,@"programSeriesId",
                            WATCHTVGROUPID,@"tvTemplateId",
                            [[HiTVGlobals sharedInstance]getEpg_groupId],@"vodTemplateId",
                            @"1",@"isPlayOver",
                            [HiTVGlobals sharedInstance].uid,@"userId",
                            _categoryID,@"categoryId",
                            T_STBext,@"abilityString",
                            nil];

    __weak __typeof(self)weakSelf = self;
    [BaseAFHTTPManager postRequestOperationForHost:MYEPG forParam:@"/foryou/getRecommendList" forParameters:params completion:^(id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;;
        if (responseObject[@"resultList"]== nil) {
            return;
        }
        NSMutableArray *resultArray = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"resultList"]) {
            WatchListEntity* entity = [[WatchListEntity alloc]initWithDictionary:dic];
            [resultArray addObject:entity];
        }
        guestVC = [[SJGuestYouLikeViewController alloc]init];
        guestVC.modelsArray = resultArray;
        [strongSelf.view addSubview:guestVC.view];
        guestVC.view.frame = strongSelf.player.view.frame;
        guestVC.deleage = strongSelf;
        guestVC.clickBlock = ^(UIButton *but){
            [strongSelf.navigationController popViewControllerAnimated:YES];
        };

        strongSelf.recommendList = resultArray;
    } failure:^(NSString *error) {


    }];
}
#pragma mark - 播放地址解码
- (NSString *)encodeActionUrl:(NSString *)actionUrl
{
    NSString *key = @"36b9c7e8695468dc";

    NSString *resultUrl;

    if ([actionUrl rangeOfString:@"yst://"].location != NSNotFound) {
        NSString *strUrl = [actionUrl stringByReplacingOccurrencesOfString:@"yst://" withString:@""];
        resultUrl = [AES128Util AES128Decrypt:strUrl key:key];
    }
    else{
        resultUrl = actionUrl;
    }

    if ([resultUrl hasSuffix:@".ts"]) {
        DDLogInfo(@"ts播放不了");

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未能播放："
                                                        message:@"该节目暂不能播放"
                                                       delegate:self
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil, nil];
        [alert show];



        //resultUrl = [self transcodingToM3u8:resultUrl];

    }

    resultUrl = [[resultUrl.description  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    resultUrl=[resultUrl stringByReplacingOccurrencesOfString:@"%00" withString:@""];
    return resultUrl;
}
//ts转m3u8
-(NSString *)transcodingToM3u8:(NSString *)url
{
    if ([url hasSuffix:@".m3u8"]) {
        return url;
    }
    NSArray *boxtArray = [url componentsSeparatedByString:@".com"];
    NSString *boxLastStr = [boxtArray lastObject];
    NSString *phoneUrl = [NSString stringWithFormat:@"http://phone.media.ysten.com%@",boxLastStr];

    NSArray *dataArray = [phoneUrl componentsSeparatedByString:@"/"];

    NSString *lastStr = [dataArray lastObject];
    NSString *preStr = [phoneUrl stringByReplacingOccurrencesOfString:lastStr withString:@""];


    NSArray *array = [lastStr componentsSeparatedByString:@"."];

    NSString *folder = [array firstObject];
    NSString *m3u8Url = [NSString stringWithFormat:@"%@%@/%@.m3u8",preStr,folder,folder];
    if (m3u8Url) {

        return m3u8Url;
    }
    return url;
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
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];

    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"oprUids"];
    if ([video.contentType isEqualToString:@"vod"]) {
        [parameters setValue:@"vod" forKey:@"businessType"];
    }
    else{
        [parameters setValue:@"watchtv" forKey:@"businessType"];
    }
    [parameters setValue:@"vod" forKey:@"playType"];
    [parameters setValue:video.videoID forKey:@"objectId"];

    [parameters setValue:video.name forKey:@"objectName"];
    [parameters setValue:@"" forKey:@"startTime"];
    [parameters setValue:@"" forKey:@"endTime"];
    [parameters setValue:@"" forKey:@"assortId"];
    VideoSource *videoSource = video.sources[self.currentVideoIndex];

    [parameters setValue:videoSource.sourceID forKey:@"lastProgramId"];
    [parameters setValue:videoSource.name forKey:@"lastProgramNam"];

    int currentTime = floor(CMTimeGetSeconds([_player.view.player currentTime]));
    NSString *pointString = [NSString stringWithFormat:@"%d",(int)currentTime];
    if (self.videoDatePoint<0) {
        self.videoDatePoint = 0;
    }
    if (currentTime == 0 &&self.videoDatePoint) {
        pointString = [NSString stringWithFormat:@"%d",(int)self.videoDatePoint];
    }
    [parameters setValue:[NSString stringWithFormat:@"%d",(int)self.videoDatePoint] forKey:@"startWatchTime"];

    [parameters setValue:pointString forKey:@"endWatchTime"];
    [parameters setValue:video.picurl forKey:@"bannerImg"];
    [parameters setValue:video.picurl forKey:@"verticalImg"];
    [parameters setValue:video.director forKey:@"directors"];
    [parameters setValue:video.actor forKey:@"actors"];
    [parameters setValue:[[HiTVGlobals sharedInstance]getEpg_groupId] forKey:@"deviceGroupId"];
    [parameters setValue:WATCHTVGROUPID forKey:@"templateId"];
    [parameters setValue:@"" forKey:@"vendor"];

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

        if ([[responseObject objectForKey:@"code"] intValue] == 0) {
        }
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

    TPIMContentModel *content = [[TPIMContentModel alloc]init];
    VideoSource *videoSource = video.sources[self.currentVideoIndex];

    if ([action isEqualToString:@"exit"] || [action isEqualToString:@"pause"] || [action isEqualToString:@"resume"]) {
        content.playerType = @"onDemand";
        content.programId = videoSource.sourceID;
        content.action = action;
    }
    else if ([action isEqualToString:@"seek"]){
        content.playerType = @"onDemand";
        content.programId = videoSource.sourceID;
        content.action = action;
        content.datePoint = startTime;
    }
    else{
        content.playerType = @"onDemand";
        content.programSeriesId = video.videoID;
        content.programId = videoSource.sourceID;
        content.content = videoSource.name;
        content.liveTag = @"3";

        content.datePoint = startTime;
        content.action = action;

        if (_player.view.showBarrage) {
            content.haveDanmu = @"true";
        }
        else{
            content.haveDanmu = @"false";
        }

        NSString* content = [NSString stringWithFormat:@"state=%@&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&filetype=%@", @"%d", @"点播",isNullString(videoSource.channelUuid), isNullString(self.watchEntity.programSeriesId),isNullString(self.programId),isNullString(self.watchEntity.programSeriesName), isNullString(videoSource.name),@"互联网"];

        [[NSUserDefaults standardUserDefaults] setObject:content forKey:@"ScreenMappingContent"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }



    [self.screenManager remoteNetVideoWithContentModel:content];

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
     object:nil];
     */

    //投屏
    if (![HiTVGlobals sharedInstance].isLogin) {
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

- (void)collectVideo
{
    // 收藏
    _toolView.collected = YES;


    // 收藏
    SJLiveTVCollcetModel *model = [SJLiveTVCollcetModel new];


    model.uid             = [HiTVGlobals sharedInstance].uid;
    model.oprUids         = [HiTVGlobals sharedInstance].uid;
    if ([video.contentType isEqualToString:@"vod"]) {
        model.businessType    = @"vod";
    }
    else{
        model.businessType    = @"watchtv";
    }
    model.playType        = @"vod";
    model.objectId        = video.videoID;
    model.objectName      = video.name;
    model.startTime       = @"";
    model.endTime         = @"";
    model.assortId        = @"";
    VideoSource *videoSource = video.sources[self.currentVideoIndex];
    model.lastProgramId   = videoSource.detailsid;
    model.startWatchTime  = @"0";
    int currentTime = floor(CMTimeGetSeconds([_player.view.player currentTime]));
    NSString *pointString = [NSString stringWithFormat:@"%d",(int)currentTime];

    model.endWatchTime    = pointString;
    model.bannerImg       = video.picurl;
    model.verticalImg     = video.picurl;

    model.directors       = video.director;
    model.actors          = video.actor;
    model.deviceGroupId   = [[HiTVGlobals sharedInstance]getEpg_groupId];

    model.templateId      = WATCHTVGROUPID ;
    model.deviceType      = @"MOBILE";

    WEAKSELF
    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN forParam:@"/integration/2.0/addCollection" forParameters:[model mj_keyValues]  completion:^(id responseObject) {

        DDLogInfo(@"-----%@",responseObject);
        NSNumber *code = responseObject[@"code"];
        if (code.integerValue == 0) {
            // add log.
            VideoSource *data = self->video.sources[self.currentVideoIndex];
            NSString* content = [NSString stringWithFormat:@"type=%@&uuid=%@&programSeriesId=%@&programseriesname=%@", @"点播", isNullString(data.channelUuid), isNullString(self.watchEntity.programSeriesId), isNullString(self.watchEntity.programSeriesName)];
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
    _toolView.collected = NO;

    // 取消收藏
    SJCancelCollcetionModel *model = [SJCancelCollcetionModel new];
    model.uid          = [HiTVGlobals sharedInstance].uid;
    model.oprUids      = [HiTVGlobals sharedInstance].uid;
    if ([video.contentType isEqualToString:@"vod"]) {
        model.businessType    = @"vod";
    }
    else{
        model.businessType    = @"watchtv";
    }
    model.playType     = @"vod";
    model.objectId     = video.videoID;
    model.startTime    = @"";
    model.endTime      = @"";
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

#pragma mark - 详情页分享
- (void)playerDidClickShare
{

    if (![HiTVGlobals sharedInstance].isLogin) {
        SJLoginViewController *sjVC = [[SJLoginViewController alloc]init];
        [self.navigationController presentViewController:sjVC animated:YES completion:nil];
        return;
    }



    if ([_player.actionUrl absoluteString].length==0) {
        [MBProgressHUD showError:@"分享失败，地址为空" toView:self.view];
        return;
    }
    _shareView =[[SJPortraitShareView alloc]initWithTpye:0];
    [[UIApplication sharedApplication].keyWindow addSubview:_shareView];
    [_shareView showInView:[UIApplication sharedApplication].keyWindow];
    //    _shareListView = self.shareListView;
    [self shareMethod];


}
//vod
//lookback
-(SMSRequestParams *)generateParams{

    VideoSource *data = video.sources[self.currentVideoIndex];
    NSString *aa = [NSString stringWithFormat:@"%f",self.player.currentPlayedSeconds];
    SMSRequestParams *smsparams = [SMSRequestParams new];
    smsparams.uid = [HiTVGlobals sharedInstance].uid;
    smsparams.userName = [HiTVGlobals sharedInstance].nickName;
    smsparams.userImgUrl = [HiTVGlobals sharedInstance].faceImg;
    smsparams.phoneNo = [HiTVGlobals sharedInstance].phoneNo;
    smsparams.domain = [HiTVGlobals sharedInstance].domain;
    smsparams.psId = self.watchEntity.programSeriesId;
    smsparams.pId =self.programId;
    smsparams.uuid = data.uuid==nil?data.channelUuid:data.uuid;
    smsparams.channelBeginTime = data.startTime;
    smsparams.channelEndTime = data.endTime;
    smsparams.contentName = data.name;
    smsparams.mediaType = data.mediaType;
    smsparams.contentType = video.contentType;
    smsparams.startTime = [NSString stringWithFormat:@"%ld",(long)[aa integerValue]];
    smsparams.shareSeconds = @"30";
    return smsparams;
}
-(void)shareMethod{

     SJ30SVedioRequestModel *model = [SJ30SVedioRequestModel new];

     NSString *aa = [NSString stringWithFormat:@"%f",self.player.currentPlayedSeconds];
     model.videoTime = [aa integerValue];

     VideoSource *videoSource = video.sources[self.currentVideoIndex];

     if ([videoSource.mediaType isEqualToString:@"live"]) {
     model.videoType        = @"live";
     model.videoTime = [aa integerValue];
     if (videoSource.channelUuid) {
     model.videoId = videoSource.channelUuid;
     }else{
     //当channelUUID 为空时候 需要自己截取出来
     NSRange range = [videoSource.actionURL rangeOfString:@"live/"];
     NSString *temp = [videoSource.actionURL substringFromIndex:range.location];
     //NSArray *a = [temp componentsSeparatedByString:@"/"];
     temp = [temp stringByReplacingOccurrencesOfString:@"live/" withString:@""];
     temp = [temp substringToIndex:[temp rangeOfString:@"/"].location];
     model.videoId = temp;
     }


     model.videoTitle = videoSource.name;
     model.videoSecond = 30;
     }else{
     model.videoType = [video.contentType isEqualToString:@"vod"]?@"vod":[[self.player.actionUrl absoluteString] containsString:@"/media/"]? @"looktv":@"lookback" ;//lootv==media?lookback ?
     model.videoId = [self shortVedioString:[self.player.actionUrl absoluteString] judgeString:model.videoType];
     model.videoSecond = 30;
     }
     model.userName = [HiTVGlobals sharedInstance].nickName;
     model.userHeadImageUrl = [HiTVGlobals sharedInstance].faceImg;



    WEAKSELF
    HiTVVideo *vvv = video;
    NSInteger cccc = self.currentVideoIndex;
    VideoSource *data = video.sources[self.currentVideoIndex];

    _shareView.shareButtonBlock = ^(UIButton *button){

        if (button.tag==10) {
            weakSelf.hidesBottomBarWhenPushed = YES;
            SJShareVideoViewController *shareVC = [[SJShareVideoViewController alloc] init];
            SJShareVideoViewModel *viewModel = [[SJShareVideoViewModel alloc] initWithController:shareVC];
            viewModel.video = vvv;
            if (video.sources.count > self.currentVideoIndex) {

                VideoSource *data = vvv.sources[cccc];
                viewModel.videoSource = data;
            }
            viewModel.videoType = TPShareVideoTypeVOD;
            viewModel.currentPlayedSeconds = weakSelf.player.currentPlayedSeconds;

            shareVC.viewModel = viewModel;

            [weakSelf.navigationController pushViewController:shareVC animated:YES];


            NSString* content = [NSString stringWithFormat:@"state=%@&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&way=%@&sharetime=%@&sharepoint=%@",@"%d", @"点播", isNullString(weakSelf.watchEntity.channelUuid), isNullString(weakSelf.watchEntity.programSeriesId), isNullString(weakSelf.programId), isNullString(weakSelf.watchEntity.programSeriesName), isNullString(data.name), @"和家庭好友", isNullString([[NSUserDefaults standardUserDefaults] objectForKey:LOG_SHARE_VIDEO_LENGTH]), [Utils getCurrentTime]];
            [NSUserDefaultsManager saveObject:content forKey:LOG_SHARE_CONTENT];


        }else{

            [weakSelf.shareAlertView showAlertViewIn:weakSelf.view];
            weakSelf.shareAlertView.shareType = button.tag-10;
//            weakSelf.shareAlertView.theModel = model;
            weakSelf.shareAlertView.titleText.text =data.name;
            weakSelf.shareAlertView.smsModel= [weakSelf generateParams];
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


    if ([self.player.actionUrl absoluteString].length==0) {
        [MBProgressHUD showError:@"分享失败，地址为空" toView:self.view];
        return;
    }
    _shareListView = self.shareListView;
    //    _shareView =[[SJPortraitShareView alloc]initWithTpye:1];
    //    [self.view addSubview:_shareView];
    //
    //    [_shareView showInView:self.view];
    //    [self shareMethod];
}

- (NSString *)shortVedioString:(NSString *)string judgeString:(NSString *)typeString
{
    if (![typeString isEqualToString:@"lookback"]) {
        NSString *bbb = [string stringByReplacingOccurrencesOfString:@"http://" withString:@""];
        NSArray *array= [bbb componentsSeparatedByString:@"/"];
        NSString*stringA = @"";
        for (int i=1; i<array.count; i++) {
            NSString *c = [NSString stringWithFormat:@"/%@",(NSString *)array[i]];
            stringA = [NSString stringWithFormat:@"%@%@",stringA,c];
        }
        return stringA;
    }else{

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



}


#pragma mark - 查询收藏过
- (void)checkWatchTVHasCollected
{

    SJLiveRequestIsCollectModel *model =[SJLiveRequestIsCollectModel new];

    model.uid = [HiTVGlobals sharedInstance].uid;
    model.businessType = @"vod";
    model.objectId = video.videoID;
    model.startTime = @"";
    model.endTime = @"";
    model.deviceType = @"MOBILE";


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

    }];

}

#pragma -mark 分享delegate
- (void)SJShareContentWithPlatform:(Platform)type andModel:(SJ30SVedioModel *)model isDo:(BOOL) flag{

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

    [self.shareAlertView hiddenAlertView];

    NSString* way = nil;
    switch (type) {
        case ShiJia:
            way = CurrentAppName;
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

    VideoSource *data = self->video.sources[self.currentVideoIndex];

    // add log.
    NSString* content = [NSString stringWithFormat:@"state=%@&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&way=%@&sharetime=%@&sharepoint=%@",@"%d", @"点播", isNullString(self.watchEntity.channelUuid), isNullString(self.watchEntity.programSeriesId), isNullString(self.programId), isNullString(self.watchEntity.programSeriesName), isNullString(data.name), isNullString(way), isNullString([[NSUserDefaults standardUserDefaults] objectForKey:LOG_SHARE_VIDEO_LENGTH]), [Utils getCurrentTime]];
    [NSUserDefaultsManager saveObject:content forKey:LOG_SHARE_CONTENT];



}

#pragma mark - Setter & Getter
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![_chatRoomView.inputView isExclusiveTouch]) {
        [_chatRoomView.inputView resignFirstResponder];
    }
}

- (ShareAlertView *)shareAlertView
{
    if (!_shareAlertView) {
        _shareAlertView = [ShareAlertView new];
        _shareAlertView.sharedelegate = self;
    }
    return _shareAlertView;
}

-(void)chooseOneWatchEntityFromGuestList:(WatchListEntity *)model{

//    if ([model.contentType isEqualToString:@"vod"]) {
//
//        self.videoID = model.programSeriesId;
//        [self refreshData];
//
//    }else{
        if ([self.delegate respondsToSelector:@selector(vodDetail:didSelectRecommendItem:)]) {
            [self.delegate vodDetail:self didSelectRecommendItem:model];
        }
//    }
}
#pragma -mark OrientationDidChange
-(void)deviceOrientationDidChange{

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    //    CGSize layoutSize ;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;

    if ((orientation == UIDeviceOrientationLandscapeLeft ||  orientation == UIDeviceOrientationLandscapeRight) && screenSize.width > screenSize.height) {
        [_shareView hiddleFromSuperView];
        [_shareListView hiddleFromSuperView];
        [_shareAlertView hiddenAlertView];
        [_chatRoomView.inputView resignFirstResponder];
        guestVC.view.frame = self.player.view.frame;
        [guestVC.view layoutIfNeeded];
         [_player.view setStyle:SJVideoPlayerViewStyleFullScreen];
    }else if(orientation == UIDeviceOrientationPortrait  && screenSize.width < screenSize.height){

        guestVC.view.frame = self.player.view.frame;
        [guestVC.view layoutIfNeeded];
        [_chatRoomView.inputView resignFirstResponder];
        [_shareView hiddleFromSuperView];
        [_shareAlertView hiddenAlertView];
        [_player.view setStyle:SJVideoPlayerViewStyleMini];
    }
    [_videoDetailView.seriesTableView hiddenFullView];

}
#pragma -mark follow好友加入聊天室
- (void)joinRoom:(NSNotification *)notification
{
    _segmentedControl.selectedSegmentIndex = 1;
    [self segmentedControlValueChanged:nil];
}

#pragma -mark 影片鉴权
-(void)queryPriceRequest
{
    //self.player.noFree = NO;
    if ([[HiTVGlobals sharedInstance].disable_moudles containsObject:@"vip"]) {
        return;
    }
    if ([self.watchEntity.contentType isEqualToString:@"watchtv"]) {
        //return;
    }

    NSString *contentId = self.videoID;
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


    VideoSource *videoSource = video.sources[self.currentVideoIndex];
    //!!!:后台逻辑 当ppvlist 为[] 不需要鉴权
    //!!!:
    if (videoSource.ppvList.count<1) {
        //        [parameters setValue:nil forKey:@"cosInquiryInfo"];
        return;
    }else{
        [parameters setValue:[videoSource.ppvList mj_JSONString]/*@"[{\"contentId\":\"3254141\",\"productIdList\":[\"900000009\",\"400000102\"],\"idType\":\"0\",\"ppvId\":\"\"}]"*/ forKey:@"cosInquiryInfo"];
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
            payVC.recommArray = self.relevantList;
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
#pragma -mark 遥控器
- (void)goRemoteVC:(NSNotification *)notification
{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:NSStringFromSelector(@selector(orientation))];
    SJRemoteControlViewController *remoteVC = [[SJRemoteControlViewController alloc] init];
    // [self.navigationController pushViewController:remoteVC animated:YES];
    [self presentViewController:remoteVC animated:YES completion:nil];
}
#pragma mark

-(AlbumShareView *)shareListView{

    _shareListView = [[AlbumShareView alloc]init];
    _shareListView.photoShareDelegate = self;
    [_shareListView setTitleString:@" 分享到微信、朋友圈、微博、通讯录仅支持30秒或60秒片段"];
    [[UIApplication sharedApplication].keyWindow addSubview:_shareListView];
    [_shareListView AlbumShareShowInView:[UIApplication sharedApplication].keyWindow];
    return _shareListView;
}

#pragma mark  photoShareDelegate
-(void)PhotoShareToSocailName:(Platform)name{

     SJ30SVedioRequestModel *model = [SJ30SVedioRequestModel new];

     NSString *aa = [NSString stringWithFormat:@"%f",self.player.currentPlayedSeconds];
     model.videoTime = [aa integerValue];

     VideoSource *videoSource = video.sources[self.currentVideoIndex];

     if ([videoSource.mediaType isEqualToString:@"live"]) {
     model.videoType        = @"live";
     model.videoTime = [aa integerValue];
     if (videoSource.channelUuid) {
     model.videoId = videoSource.channelUuid;
     }else{
     //当channelUUID 为空时候 需要自己截取出来
     NSRange range = [videoSource.actionURL rangeOfString:@"live/"];
     NSString *temp = [videoSource.actionURL substringFromIndex:range.location];
     //NSArray *a = [temp componentsSeparatedByString:@"/"];
     temp = [temp stringByReplacingOccurrencesOfString:@"live/" withString:@""];
     temp = [temp substringToIndex:[temp rangeOfString:@"/"].location];
     model.videoId = temp;
     }


     model.videoTitle = videoSource.name;
     model.videoSecond = 30;
     }else{
     model.videoType = [video.contentType isEqualToString:@"vod"]?@"vod":[[self.player.actionUrl absoluteString] containsString:@"/media/"]? @"looktv":@"lookback" ;//lootv==media?lookback ?
     model.videoId = [self shortVedioString:[self.player.actionUrl absoluteString] judgeString:model.videoType];
     model.videoSecond = 30;
     }
     model.userName = [HiTVGlobals sharedInstance].nickName;
     model.userHeadImageUrl = [HiTVGlobals sharedInstance].faceImg;



    WEAKSELF
    HiTVVideo *vvv = video;
    NSInteger cccc = self.currentVideoIndex;
    VideoSource *data = video.sources[self.currentVideoIndex];

    if (name==ShiJia) {
        weakSelf.hidesBottomBarWhenPushed = YES;
        SJShareVideoViewController *shareVC = [[SJShareVideoViewController alloc] init];
        SJShareVideoViewModel *viewModel = [[SJShareVideoViewModel alloc] initWithController:shareVC];
        viewModel.video = vvv;
        if (video.sources.count > self.currentVideoIndex) {

            VideoSource *data = vvv.sources[cccc];
            viewModel.videoSource = data;
        }
        viewModel.videoType = TPShareVideoTypeVOD;
        viewModel.currentPlayedSeconds = weakSelf.player.currentPlayedSeconds;

        shareVC.viewModel = viewModel;

        [weakSelf.navigationController pushViewController:shareVC animated:YES];


        NSString* content = [NSString stringWithFormat:@"state=%@&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&way=%@&sharetime=%@&sharepoint=%@",@"%d", @"点播", isNullString(weakSelf.watchEntity.channelUuid), isNullString(weakSelf.watchEntity.programSeriesId), isNullString(weakSelf.programId), isNullString(weakSelf.watchEntity.programSeriesName), isNullString(data.name), @"和家庭好友", isNullString([[NSUserDefaults standardUserDefaults] objectForKey:LOG_SHARE_VIDEO_LENGTH]), [Utils getCurrentTime]];
        [NSUserDefaultsManager saveObject:content forKey:LOG_SHARE_CONTENT];


    }else{

        [weakSelf.shareAlertView showAlertViewIn:weakSelf.view];
        weakSelf.shareAlertView.shareType = name;
        //self.shareAlertView.theModel = model;
        weakSelf.shareAlertView.titleText.text =data.name;
        weakSelf.shareAlertView.smsModel = [self generateParams];
    }

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
#pragma mark  缺集处理
//缺集填满
-(NSArray *)getStrongVideoSourceArray{
    //return [NSArray arrayWithArray:video.sources];
    NSMutableArray *videoArray = [NSMutableArray arrayWithArray:video.sources];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    if (video.sources.count>1) {
        /*for (int i = 0;i<videoArray.count;i++) {
         VideoSource *videoSource = videoArray[i];
         if (videoSource.setNumber.intValue == 0) {
         [videoArray removeObject:videoSource];
         i--;
         }
         else{
         break;
         }
         }
         if (videoArray.count == 0) {
         //return [NSArray arrayWithArray:video.sources];
         return nil;
         }*/
        //缺集判断：只要有非法集号直接return nil
        int max = 0;
        for (VideoSource *videoSource in videoArray) {
            if (videoSource.setNumber.intValue == 0) {
                return nil;
            }
            //找出最大集号
            if (videoSource.setNumber.intValue>max) {
                max = videoSource.setNumber.intValue;
            }
        }
        VideoSource *firstSource = videoArray.firstObject;
        VideoSource *lastSource = videoArray.lastObject;
        if (firstSource.setNumber.intValue >lastSource.setNumber.intValue) {
            //VideoSource *data = videoArray.firstObject;
            //int firstNum = data.setNumber.intValue;
            for (int i = max; i>0; i--) {
                VideoSource *dumySource = [VideoSource new];
                dumySource.setNumber = [NSString stringWithFormat:@"%d",i];
                dumySource.isEnable = NO;
                [tempArray addObject:dumySource];
            }
            for (int i = 0; i<videoArray.count; i++) {
                VideoSource *source = videoArray[i];
                int setNum = source.setNumber.intValue;
                if (setNum == 0) {
                    // [tempArray replaceObjectAtIndex:firstNum-i withObject:source];
                }
                else{
                    [tempArray replaceObjectAtIndex:max-setNum withObject:source];
                }
            }
        }
        else{
            //VideoSource *data = videoArray.lastObject;
            //int lastNum = data.setNumber.intValue;
            for (int i = 0; i<max; i++) {
                VideoSource *dumySource = [VideoSource new];
                dumySource.setNumber = [NSString stringWithFormat:@"%d",i+1];
                dumySource.isEnable = NO;
                [tempArray addObject:dumySource];
            }
            for (int i = 0; i<videoArray.count; i++) {
                VideoSource *source = videoArray[i];
                int setNum = source.setNumber.intValue;
                [tempArray replaceObjectAtIndex:setNum-1 withObject:source];
            }
        }
    }
    else{
        return [NSArray arrayWithArray:video.sources];
    }
    
    video.sources = tempArray;
    return tempArray;
}
/*
 -(NSInteger)getCanPlayVideoSourceIndex{
 for (VideoSource *source in video.sources) {
 if (source.sourceID && source.actionURL) {
 //self.currentVideoIndex = [video.sources indexOfObject:source];
 return [video.sources indexOfObject:source];
 }
 }
 return self.currentVideoIndex;
 }*/
-(void)setCurrentVideoIndex:(NSInteger)currentVideoIndex{
    if (currentVideoIndex<0) {
        [self playerDidPlayToEnd];
        return;
    }
    VideoSource *source = video.sources[currentVideoIndex];
    if(source.sourceID && source.actionURL){
        _currentVideoIndex = currentVideoIndex;
    }
    else{
        for (NSInteger i= currentVideoIndex;i<video.sources.count;i++) {
            VideoSource *currentSource = video.sources[i];
            if (currentSource.sourceID && currentSource.actionURL) {
                _currentVideoIndex = i;
                break;
            }
        }
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
    if ([video.contentType isEqualToString:@"vod"]) {
        [parameters setValue:@"vod" forKey:@"businessType"];
    }
    else{
        [parameters setValue:@"watchtv" forKey:@"businessType"];
    }
    [parameters setValue:video.videoID forKey:@"objectId"];
    
    [parameters setValue:@"" forKey:@"startTime"];
    [parameters setValue:@"" forKey:@"endTime"];
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
            NSString *lastProgramId = data[@"lastProgramId"];
            if (lastProgramId.intValue!=0) {
                for (VideoSource *data in video.sources) {
                    if ([lastProgramId isEqualToString:data.sourceID]) {
                        NSInteger index = [video.sources indexOfObject:data];
                        weakSelf.currentVideoIndex = index;
                        
                        // 当前播放
                        VideoSource *data = video.sources[weakSelf.currentVideoIndex];
                        _player.trialDura = data.trialDura.floatValue*60;
                        [self getHWPlayUrl:data.actionURL];
                        _player.view.title = data.name;
                        _player.currentVideoIndex = weakSelf.currentVideoIndex;
                        _player.view.currentVideoIndex = weakSelf.currentVideoIndex;
                        _videoDetailView.currentVideoIndex = weakSelf.currentVideoIndex;
                        _player.datePoint = weakSelf.videoDatePoint;
                        weakSelf.watchEntity.setNumber = data.setNumber;
                        _player.trialDura = data.trialDura.floatValue*60;
                        [TPXmppRoomManager defaultManager].videoSource = data;
                        
                        weakSelf.programId = data.sourceID;
                        weakSelf.watchEntity.channelUuid = data.channelUuid;
                        
                        break;
                    }
                }
                [self queryPriceRequest];
            }
            else{
                _player.datePoint = weakSelf.videoDatePoint;
                [self queryPriceRequest];
            }
        }
        else{
            [self queryPriceRequest];
        }
        [weakSelf initVerTimer];
    }failure:^(NSString *error) {
        [weakSelf initVerTimer];
        [self queryPriceRequest];
    }];
}
#pragma mark - 兑换华为CDN播放地址
-(void)getHWPlayUrl:(NSString *)actionURL{
    //url = @"http://ip:port/icntv/p_bjystmvod000000000000015285746";
    if ([actionURL hasPrefix:@"yst://"]) {
        actionURL = [self encodeActionUrl:actionURL];
    }
    if (![actionURL hasPrefix:@"http://ip:port/"]) {
       // NSString *url = [self encodeActionUrl:actionURL];
        self.player.actionUrl = [NSURL URLWithString:actionURL];
    }
    else{
        HWVideoModel *model = [HWVideoModel new];
        NSArray *arr = [actionURL componentsSeparatedByString:@"/"];
        model.cid = arr.lastObject;
        model.tid = @"-1";
        model.playType = @"1";
        model.contentType = @"0";
        model.businessType = @"1";
        
        WEAKSELF
        [[HWOauthManager sharedInstance]playContentAuthorize:model completion:^(NSString *playUrl,NSString *error){
            if (error==nil) {
                weakSelf.player.actionUrl = [NSURL URLWithString:playUrl];
            }
            else{
               // [weakSelf hwCDNauthentication:model];
            }
        }];
    }
    //NSString *url = [self encodeActionUrl:@"yst://6384F027740A9FE3FD23B192774CBAEDC80E064F723F38DB97E2E8DE0128826F60C53562B583FAFDF7F37CAC140BC6B1FC5A53C8D17EFD58638DDF876FCF796A"];
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
