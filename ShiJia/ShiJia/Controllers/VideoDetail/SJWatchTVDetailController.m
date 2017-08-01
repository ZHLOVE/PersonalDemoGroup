//
//  SJWatchTVDetailController.m
//  ShiJia
//
//  Created by yy on 16/7/1.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJWatchTVDetailController.h"

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
#import "TPIMAlertView.h"
#import "TPPrivateMUCInputView.h"

#import "VideoDataProvider.h"
#import "HiTVVideo.h"
#import "VideoSource.h"
#import "AES128Util.h"
#import "SJLiveTVCollcetModel.h"
#import "ScreenManager.h"
#import "TPIMContentModel.h"
#import "TPXmppRoomManager.h"
#import "TPDanmakuData.h"

#import "SJShareVideoViewModel.h"
#import "SJShareVideoViewController.h"
#import "SJ30SVedioRequestModel.h"
#import "SJPortraitShareView.h"
#import "SJLoginViewController.h"
#import "SJGuestYouLikeViewController.h"
#import "SJHitTestView.h"
#import "SJVIPViewController.h"
#import "SJRemoteControlViewController.h"
#import "SJShareManager.h"
#import "SJShareMessage.h"
#import "ProductEntity.h"
#import "SJPayViewController.h"
#import "AlbumShareView.h"
#import "ShareAppViewController.h"
#import "SJDLNAListViews.h"
#import "QRCodeController.h"
#import "SJAdViewModel.h"

static NSInteger kAnimationDuration  = 0.3;
static CGFloat   kSegmentecControlHeight = 40.0;
//static CGFloat   kInnerSpacing = 10.0;

@interface SJWatchTVDetailController ()<SJVideoPlayerDelegate,SJVideoToolViewDelegate,SJShareDelegate,guestDelegate,PhotoShareDelegate,DLNAViewDelegate>
{
    SJHitTestView *mainView;         //用于详情view与聊天室view的切换

    NSInteger       lastSelectedIndex;//分段开关上一次选中索引
    NSMutableArray *videos;           // 视频array

    WatchFocusVideoEntity *video;
    //    NSInteger currentVideoIndex;

    //add by jhl 20160702
    NSTimer *verTimer;              //计时器
    SJGuestYouLikeViewController *guestVC;
    //NSInteger currentVideoIndex;
    SJShareManager *shareManager;

    long  second;//当前观看时长

    __block NSString *localeDateStr;
    SJAdViewModel *adViewModel;
}

@property (nonatomic, strong) SJVideoPlayerKit               *player;           //播放器
@property (nonatomic, strong) SJVideoToolView                *toolView;
@property (nonatomic, strong) SJVideoDetailSegmentedControl  *segmentedControl; //分段开关
@property (nonatomic, strong) TPVideoDetailMainView          *videoDetailView;  //视频详情主view
@property (nonatomic, strong) SJPrivateChatRoomMainView      *chatRoomView;     //聊天室主view

@property (nonatomic, strong) ScreenManager                  *screenManager;
@property (nonatomic, strong) SJPortraitShareView            *shareView ;
@property (nonatomic, strong) ShareAlertView                 *shareAlertView;

@property (nonatomic, strong) NSMutableArray                 *relevantList;     //相关推荐
@property (nonatomic, strong) NSMutableArray                 *recommendList;    //猜您喜欢
@property (nonatomic, strong) NSArray                        *programArray;     //选集列表
@property (nonatomic, assign) BOOL                            noDetail;
@property (nonatomic, strong) NSMutableArray *productArray;     //收费购买产品信息
@property (nonatomic, strong) AlbumShareView                 *shareListView;
@property (nonatomic, strong) SJDLNAListViews                *DLNAListView;

@end


@implementation SJWatchTVDetailController
#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];

    if (self) {
        __weak __typeof(self)weakSelf = self;
        adViewModel = [[SJAdViewModel alloc] initWithActiveController:self];
        [adViewModel setLoadAdFailedBlock:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您未关联电视设备，先打开“扫一扫”页面进行关联！" message:nil delegate:strongSelf cancelButtonTitle:@"前往扫一扫" otherButtonTitles:@"取消", nil];
            alert.tag=1001;
            [alert show];
        }];
        
        // 播放器
        _player = [[SJVideoPlayerKit alloc] init];
        _player.delegate = self;
        _player.activeController = self;
        _player.userAgent = @"010121001026256#";

        [_player setDidClickBack:^{
            // 返回
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSString* playerError = [[NSUserDefaults standardUserDefaults] objectForKey:kPlayerError];
            if (playerError == nil) {
                playerError = @"no";
            }
            NSString* content = [NSString stringWithFormat:@"id=%@&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&programtypename=%@&tag=%@&firstsource=%@&epgname=%@&playPoint=%.2f&Url=%@&BuffCount=%ld&BuffAverTimeCost=%f&startTime=%@&endTime=%@&PlayTotalTimeCost=%.2f&playstream=%lld&error=%@", isNullString(strongSelf.watchEntity.contentId), @"看点",isNullString(strongSelf.watchEntity.channelUuid),isNullString(strongSelf.watchEntity.programSeriesId),isNullString(strongSelf.programId),isNullString(strongSelf.watchEntity.programSeriesName),isNullString(strongSelf.programname),isNullString(strongSelf.watchEntity.programSeriesType), isNullString(strongSelf->video.tag),isNullString(strongSelf.tabBarController.tabBar.selectedItem.title), isNullString(strongSelf.epgName), strongSelf.player.videoStartFrom, isNullString(strongSelf.player.actionUrl), (long)strongSelf.player.countBuffer,strongSelf.player.avgTotalBuffer, isNullString(strongSelf->localeDateStr), [Utils getCurrentTime],strongSelf.player.videoDuration,[strongSelf.player getReceivedBytes], isNullString(playerError)];

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

        [RACObserve(_player, currentPlayedSeconds) subscribeNext:^(NSNumber *secondsNum) {
            [TPXmppRoomManager defaultManager].currentPlayedSeconds = [secondsNum floatValue];

            static int lastVal = 0;
            int val = (int)[TPXmppRoomManager defaultManager].currentPlayedSeconds;

            second = val;
            if (val % (60 * 5) == 0 && val != 0 && lastVal != val) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;

                DDLogInfo(@"当前已播放: %.2ld",strongSelf->second);

                NSString* content = [NSString stringWithFormat:@"curstatus=%@&time=%ld&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@", @"看点",strongSelf->second, isNullString(strongSelf.watchEntity.channelUuid),isNullString(strongSelf.watchEntity.programSeriesId),isNullString(strongSelf.programId),isNullString(strongSelf.watchEntity.programSeriesName),isNullString(strongSelf.programname)];
                [Utils BDLog:1 module:@"603" action:@"AppCheckPoint" content:content];
            }

            lastVal = val;
        }];

        [RACObserve(_player, currentVideoIndex) subscribeNext:^(NSNumber *x) {
            if (self.currentVideoIndex != [x integerValue]) {
                NSArray *tempArray = video.programes;
                if ([video.programOrder isEqualToString:@"1"]) {

                    self.currentVideoIndex = [x integerValue];
                    _videoDetailView.currentVideoIndex = self.currentVideoIndex;
                    _videoDetailView.seriesTableView.currentVideoIndex = self.currentVideoIndex;

                }
                else{
                    self.currentVideoIndex = [x integerValue];
                    _videoDetailView.currentVideoIndex = [x integerValue];
                    _videoDetailView.seriesTableView.currentVideoIndex = self.currentVideoIndex;
                }
                if (tempArray.count > self.currentVideoIndex&&self.currentVideoIndex>=0) {
                    WatchFocusVideoProgramEntity *data = tempArray[self.currentVideoIndex];
                    _player.actionUrl = [NSURL URLWithString:[self encodeActionUrl:data.programMobileUrl]];
                    _player.view.title = data.programName;
                    [TPXmppRoomManager defaultManager].watchProgramEntity = data;
                }
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


        // 选集
        [_videoDetailView.seriesTableView setDidSelectItemAtIndex:^(NSInteger index) {

            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.currentVideoIndex = index;
            strongSelf.player.currentVideoIndex = strongSelf.currentVideoIndex;
            strongSelf.player.view.currentVideoIndex = strongSelf.currentVideoIndex;
            strongSelf.toolView.screened = NO;
            if (video.programes.count > strongSelf.currentVideoIndex) {
                WatchFocusVideoProgramEntity *data = strongSelf->video.programes[strongSelf.currentVideoIndex];
                strongSelf.player.actionUrl = [NSURL URLWithString:[strongSelf encodeActionUrl:data.programMobileUrl]];
                strongSelf.player.view.title = data.programName;
                strongSelf.watchEntity.setNumber = data.seriesNum;
                strongSelf.watchEntity.contentId = data.programId;
                [TPXmppRoomManager defaultManager].watchProgramEntity = data;
            }
        }];

        [_videoDetailView setDidSelectItemAtIndex:^(NSInteger index) {

            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.currentVideoIndex = index;
            strongSelf.player.currentVideoIndex = strongSelf.currentVideoIndex;
            strongSelf.player.view.currentVideoIndex = strongSelf.currentVideoIndex;
            strongSelf.toolView.screened = NO;
            if (video.programes.count > strongSelf.currentVideoIndex) {
                WatchFocusVideoProgramEntity *data = strongSelf->video.programes[strongSelf.currentVideoIndex];
                strongSelf.player.actionUrl = [NSURL URLWithString:[strongSelf encodeActionUrl:data.programMobileUrl]];
                strongSelf.player.view.title = data.programName;
                strongSelf.watchEntity.setNumber = data.seriesNum;
                strongSelf.watchEntity.contentId = data.programId;
                [TPXmppRoomManager defaultManager].watchProgramEntity = data;
            }
        }];
        //vip 通道
        [_videoDetailView setVipLanesImgTapped:^(NSInteger index) {

            __strong __typeof(weakSelf)strongSelf = weakSelf;
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
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.toolView.screened = NO;
            WatchListEntity *recommendModel = strongSelf.relevantList[index];

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

        // 聊天室view
        _chatRoomView = [[SJPrivateChatRoomMainView alloc] init];
        _chatRoomView.backgroundColor = kColorLightGrayBackground;
        _chatRoomView.activeController = self;
        [_chatRoomView setPrivateRoomDidReceiveDanmuData:^(TPDanmakuData *data) {

            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (data) {
                [strongSelf.player.view sendBarrage:data];
                [strongSelf screenDanmuData:data];
            }
            if (data&& data.isSender) {
                // add log.
                NSString* content = [NSString stringWithFormat:@"type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&actiontype=%@", @"看点",isNullString(strongSelf.watchEntity.channelUuid),isNullString(strongSelf.watchEntity.programSeriesId), isNullString(strongSelf->_programId), isNullString(strongSelf.watchEntity.programSeriesName), isNullString(strongSelf.programname), @"私聊"];
                [Utils BDLog:1 module:@"605" action:@"PrivateMessage" content:content];
                // add log.
            }

        }];
        [RACObserve(_chatRoomView, beyonded) subscribeNext:^(NSNumber *x) {
            mainView.beyonded = x.boolValue;
        }];
        
        //聊天室开始播放语音，关闭播放器声音
        @weakify(self)
        [_chatRoomView setVoiceMessageWillStartPlay:^{
            @strongify(self)
            [self.player mutePlayer];
        }];
        
        //聊天室语音播放结束，恢复播放器声音
        [_chatRoomView setVoiceMessageDidFinishPlaying:^{
            @strongify(self)
            [self.player recoverPlayerVolume];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinRoom:) name:TPIMNotification_FollowJoinRoom object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goRemoteVC:) name:TPIMNotification_GOREMOTE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runBackgroundComponent) name:TPIMNotification_vedioReadyToPlay object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runBackgroundComponent) name:@"vedioReadyToPlay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyNow) name:TPIMNotification_BuyNow object:nil];
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


    [self loadRulanVideoInformation];

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
- (void) runBackgroundComponent {
    self -> localeDateStr = [Utils getCurrentTime];

    // add log.
    NSString* content = [NSString stringWithFormat:@"type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&programtypename=%@&firstsource=%@&epgname=%@&tag=%@&starttime=%@", @"看点",isNullString(self.watchEntity.channelUuid), isNullString(self.watchEntity.programSeriesId),isNullString(self.programId),isNullString(self.watchEntity.programSeriesName), isNullString(self.programname), isNullString(self.watchEntity.programSeriesType), isNullString(self.tabBarController.tabBar.selectedItem.title), isNullString(self.epgName), isNullString(self->video.tag), [Utils getCurrentTime]];
    [Utils BDLog:1 module:@"604" action:@"AppPlayAction" content:content];
    // add log.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [HiTVGlobals sharedInstance].isWatchingVideo = NO;
    [_player stop];
    [self deviceOrientationDidChange];

    [verTimer invalidate];
    verTimer=nil;
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

}

- (void)dealloc
{
    [_player clearPlayer];
    _player = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self loadRulanVideoInformation];
    [_chatRoomView refreshData];

}

#pragma mark - Event
- (void)segmentedControlValueChanged:(id)sender
{

    if (lastSelectedIndex != _segmentedControl.selectedSegmentIndex) {

        [_chatRoomView.inputView resignFirstResponder];

        CATransition *animation = [CATransition animation];
        //        animation.delegate = self;
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
            [self.chatRoomView leaveChatRoom];
            [[TPXmppRoomManager defaultManager] clearData];
            [self.navigationController popViewControllerAnimated:YES];
        };
        [alert show];
    }else{

        [self addHistort:@"end"];
        [self.player clearPlayer];
        [self.chatRoomView leaveChatRoom];
        [[TPXmppRoomManager defaultManager] clearData];
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


#pragma mark - Request 查选集
- (void)loadRulanVideoInformation
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.watchEntity.programSeriesId.length == 0) {
        [parameters setValue:self.categoryID forKey:@"programSetId"];
    }
    else{
        [parameters setValue:self.watchEntity.programSeriesId forKey:@"programSetId"];
    }
    [parameters setValue:WATCHTVGROUPID forKey:@"templateId"];
    [parameters setValue:self.watchEntity.channelUuid forKey:@"channelUuid"];
    [parameters setValue:[NSString stringWithFormat:@"%ld",(long)self.watchEntity.startTime]    forKey:@"startTime"];
    [parameters setValue:[NSString stringWithFormat:@"%ld",(long)self.watchEntity.endTime] forKey:@"endTime"];
    [parameters setValue:self.watchEntity.contentId forKey:@"programId"];
    [parameters setValue:self.watchEntity.programSeriesName forKey:@"programName"];
    [parameters setValue:T_STBext forKey:@"abilityString"];

    [BaseAFHTTPManager getRequestOperationForHost:FUSE_EPG forParam:@"/epg/user/getReleProgramList.shtml" forParameters:parameters completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];



        //programOrder 0:正序 1:倒序
        if (responseObject == nil ||[(NSArray *)responseObject count] == 0) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未能播放："
                                                            message:@"该片仅支持电视观看"
                                                           delegate:self
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            // _player.isTVPlay = YES;
            self.noDetail = YES;

            return;

        }
        else{
            [self getRelevantList];
        }


        second = [Utils nowTimeString].longLongValue;


        self.watchEntity.posterAddr = responseObject[@"hPosterAddr"];
        self.watchEntity.verticalPosterAddr = responseObject[@"vPosterAddr"];

        WatchFocusVideoEntity *entity = [[WatchFocusVideoEntity alloc]init];
        entity.catgId                 = responseObject[@"programSetId"];
        entity.catgName               = responseObject[@"programSetName"];
        entity.clickRate              = responseObject[@"clickRate"];
        entity.desc                   = responseObject[@"desc"];
        entity.director               = responseObject[@"director"];
        entity.img                    = responseObject[@"hPosterAddr"];
        entity.leading                = responseObject[@"leading"];
        entity.orderType              = responseObject[@"orderType"];
        entity.programOrder           = responseObject[@"programOrder"];
        entity.tag                    = responseObject[@"tag"];
        entity.year                   = responseObject[@"year"];

        NSMutableArray* programs = [WatchFocusVideoProgramEntity arrayOfModelsFromDictionaries:responseObject[@"programList"] error:nil];
        /*if ([entity.programOrder isEqualToString:@"1"]) {
         NSArray *array = (NSArray<WatchFocusVideoProgramEntity>*)programs;
         NSArray* reversedArray = [[array reverseObjectEnumerator] allObjects];
         entity.programes = [NSArray arrayWithArray:reversedArray];

         }else{*/
        entity.programes = (NSArray<WatchFocusVideoProgramEntity>*)programs;
        //}



        entity.ppvId                  = isNullString(responseObject[@"ppvId"]);

        self.ppvId = isNullString(responseObject[@"ppvId"]);

        self.ppvId = isNullString(responseObject[@"ppvId"]);
        if ([isNullString(self.ppvId) length] != 0) {
            [self queryPriceRequest];
        }

//        NSMutableArray* programs = [WatchFocusVideoProgramEntity arrayOfModelsFromDictionaries:responseObject[@"programList"] error:nil];
        entity.programes = (NSArray<WatchFocusVideoProgramEntity>*)programs;
        
        


        video = entity;

        // 简介
        _videoDetailView.infoView.info = video.desc;

        // 剧集
        _videoDetailView.list = [NSArray arrayWithArray:video.programes];
        _videoDetailView.zongyi = NO;

        //播放器全屏模式下选集样式
        if (![entity.orderType isEqualToString:@"series"] || video.programes.count==1) {
            _player.view.seriesList =  video.programes;
            _player.view.seriesStyle = SJVideoPlayerSeriesViewStyleTableView;
        }
        else{
            
            //            if ([entity.programOrder isEqualToString:@"1"]){
            //                //倒序
            //                _player.view.seriesDescending = YES;
            //            }
            _player.view.seriesList = video.programes;
            _player.view.seriesCount = video.programes.count;
            _player.view.seriesStyle = SJVideoPlayerSeriesViewStyleCollectionView;
        }

        if ([TPXmppRoomManager defaultManager].isInChatRoom) {

            NSString *programId = [TPXmppRoomManager defaultManager].invitedMessageModel.contentModel.programId;

            for (WatchFocusVideoProgramEntity *data in video.programes) {
                if ([data.programId isEqualToString:programId]) {
                    NSInteger index = [video.programes indexOfObject:data];
                    self.currentVideoIndex = index;
                    break;
                }
            }
        }

        [TPXmppRoomManager defaultManager].watchEntity = video;
        [TPXmppRoomManager defaultManager].videoType = TPChatRoomVideoTypeWatchTV;
        if (self.programId.length > 0 ) {

            //NSString *programId = [TPXmppRoomManager defaultManager].invitedMessageModel.contentModel.programId;

            for (WatchFocusVideoProgramEntity *data in video.programes) {
                if ([data.programId isEqualToString:self.programId]) {
                    NSInteger index = [video.programes indexOfObject:data];
                    self.currentVideoIndex = index;
                    break;
                }
            }
        }
        else{
            for (WatchFocusVideoProgramEntity *data in video.programes) {
                if (data.seriesNum.intValue == self.watchEntity.setNumber.intValue) {
                    NSInteger index = [video.programes indexOfObject:data];
                    self.watchEntity.contentId = data.programId;
                    self.currentVideoIndex = index;
                    break;
                }
            }
        }


        if (![entity.orderType isEqualToString:@"series"] || video.programes.count==1) {
            _videoDetailView.seriesTableView.currentIndexPath =  [NSIndexPath indexPathForRow:self.currentVideoIndex inSection:0];;
            _videoDetailView.zongyi = YES;
            _videoDetailView.seriesTableView.list = _videoDetailView.list;
            _videoDetailView.seriesTableView.height = 44*_videoDetailView.list.count+40;
            if (_videoDetailView.seriesTableView.height>216) {
                _videoDetailView.seriesTableView.height = 216;
            }
            _videoDetailView.seriesTableView.playH = _player.view.size.height+kSegmentecControlHeight;
            [_videoDetailView.seriesTableView.tabView reloadData];
            _videoDetailView.seriesTableView.hidden = NO;
        }
        else{
            _videoDetailView.seriesTableView.hidden = YES;
        }

        if (video.programes.count > self.currentVideoIndex) {
            //当前播放
            WatchFocusVideoProgramEntity *data = video.programes[self.currentVideoIndex];
            _player.actionUrl = [NSURL URLWithString:[self encodeActionUrl:data.programMobileUrl]];
            _player.view.title = data.programName;
            _player.currentVideoIndex = self.currentVideoIndex;
            _player.view.currentVideoIndex = self.currentVideoIndex;
            _player.datePoint = self.videoDatePoint;
            _videoDetailView.currentVideoIndex = self.currentVideoIndex;
            self.watchEntity.contentId = data.programId;
            [TPXmppRoomManager defaultManager].watchProgramEntity = data;
        }
        // xmpp room

        WatchFocusVideoProgramEntity *data = video.programes[self.currentVideoIndex];

        self.watchEntity.programSeriesId = entity.catgId;
        self.watchEntity.programSeriesName = entity.catgName;
        self.watchEntity.programSeriesType = data.contentType;

        self.watchEntity.channelUuid = data.uuid;
        self.watchEntity.channelName = entity.channelName;
        self.programId = data.programId;
        self.programname = data.programName;

        [self checkWatchTVHasCollected];
        [self initVerTimer];
        if (self.neededScreen) {
            [self.toolView screenButtonClicked:nil];
        }

    } failure:^(AFHTTPRequestOperation *operation,NSString *error) {

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self p_handleNetworkError];

    }];
}

#pragma mark - 相关推荐
- (void)getRelevantList
{

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.watchEntity.programSeriesId,@"programSeriesId",
                            WATCHTVGROUPID,@"tvTemplateId",
                            [[HiTVGlobals sharedInstance]getEpg_groupId],@"vodTemplateId",
                            [HiTVGlobals sharedInstance].uid,@"userId",
                            T_STBext,@"abilityString",
                            nil];

    DDLogInfo(@"%@", self.watchEntity.programSeriesId);
    

    [BaseAFHTTPManager postRequestOperationForHost:MYEPG forParam:@"/vod/getRelevantList" forParameters:params completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (responseObject == nil) {
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
    if ([recommendModel.contentType isEqualToString:@"watchtv"]) {
        self.videoID = recommendModel.programSeriesId;

        [self refreshData];
    }
    else{
        if ([self.delegate respondsToSelector:@selector(watchTVDetail:didSelectRecommendItem:)]) {
            [self.delegate watchTVDetail:self didSelectRecommendItem:recommendModel];
        }
    }
}

#pragma mark - 猜您喜欢
-(void)getRecommendList{

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"watchtv",@"type",
                            self.watchEntity.programSeriesId,@"programSeriesId",
                            self.watchEntity.categoryId,@"categoryId",
                            WATCHTVGROUPID,@"tvTemplateId",
                            [[HiTVGlobals sharedInstance]getEpg_groupId],@"vodTemplateId",
                            @"0",@"isPlayOver",
                            [HiTVGlobals sharedInstance].uid,@"userId",
                            nil];

    __weak __typeof(self)weakSelf = self;
    [BaseAFHTTPManager postRequestOperationForHost:MYEPG forParam:@"/foryou/getRecommendList" forParameters:params completion:^(id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (responseObject == nil) {
            return;
        }
        if (responseObject[@"resultList"] == nil) {
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
    _player.userAgent = @"010121001026256#";
    return actionUrl;

    //    NSString *resultUrl;
    //
    //    if ([actionUrl rangeOfString:@"yst://"].location != NSNotFound) {
    //        NSString *key = @"36b9c7e8695468dc";
    //        NSString *strUrl = [actionUrl stringByReplacingOccurrencesOfString:@"yst://" withString:@""];
    //
    //        resultUrl = [AES128Util AES128Decrypt:strUrl key:key];
    //
    //    }
    //    else{
    //        resultUrl = actionUrl;
    //    }
    //
    //    if ([resultUrl hasSuffix:@".ts"]) {
    //        DDLogInfo(@"ts播放不了");
    //
    //
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未能播放："
    //                                                        message:@"该节目暂不能播放"
    //                                                       delegate:self
    //                                              cancelButtonTitle:@"关闭"
    //                                              otherButtonTitles:nil, nil];
    //        [alert show];
    //
    //
    //
    //        //resultUrl = [self transcodingToM3u8:resultUrl];
    //    }
    //
    //    return resultUrl;
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
    if (self.noDetail) {
        return;
    }
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];

    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"oprUids"];
    [parameters setValue:@"watchtv" forKey:@"businessType"];
    [parameters setValue:@"vod" forKey:@"playType"];

    [parameters setValue:self.watchEntity.programSeriesId forKey:@"objectId"];
    [parameters setValue:StringNotEmpty(self.watchEntity.programSeriesName)?self.watchEntity.programSeriesName:video.catgName forKey:@"objectName"];

    [parameters setValue:[NSString stringWithFormat:@"%ld",(long)self.watchEntity.startTime] forKey:@"startTime"];
    [parameters setValue:[NSString stringWithFormat:@"%ld",(long)self.watchEntity.endTime] forKey:@"endTime"];
    [parameters setValue:self.watchEntity.categoryId forKey:@"assortId"];
    [parameters setValue:self.watchEntity.contentId forKey:@"lastProgramId"];
    [parameters setValue:self.watchEntity.programSeriesName forKey:@"lastProgramNam"];

    int currentTime = floor(CMTimeGetSeconds([_player.view.player currentTime]));
    NSString *pointString = [NSString stringWithFormat:@"%d",(int)currentTime];
    if (currentTime == 0 &&self.videoDatePoint) {
        pointString = [NSString stringWithFormat:@"%d",(int)self.videoDatePoint];
    }
    [parameters setValue:[NSString stringWithFormat:@"%d",(int)self.videoDatePoint] forKey:@"startWatchTime"];

    [parameters setValue:pointString forKey:@"endWatchTime"];
    [parameters setValue:StringNotEmpty(self.watchEntity.posterAddr)?self.watchEntity.posterAddr:video.img forKey:@"bannerImg"];
    [parameters setValue:StringNotEmpty(self.watchEntity.verticalPosterAddr)?self.watchEntity.verticalPosterAddr:video.img forKey:@"verticalImg"];
    [parameters setValue:@"" forKey:@"directors"];
    [parameters setValue:@"" forKey:@"actors"];
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
- (void)ScreenProjectionOperation:(NSString *)action withStartTime:(NSString *)startTime{

    TPIMContentModel *content = [[TPIMContentModel alloc]init];
    WatchFocusVideoProgramEntity *data = video.programes[self.currentVideoIndex];

    content.playerType = @"watchTV";

    if ([action isEqualToString:@"exit"] || [action isEqualToString:@"pause"] || [action isEqualToString:@"resume"]) {
        content.programId = data.programId;
        content.action = action;
    }
    else if ([action isEqualToString:@"seek"]){

        content.programId = data.programId;
        content.action = action;
        content.datePoint = startTime;
    }
    else{

        content.catgId = video.catgId;
        content.assortId = video.catgId;
        content.programId = data.programId;
        content.content = data.programName;
        content.progName = data.programName;
        content.liveTag = @"3";

        content.datePoint = startTime;
        content.action = action;
        if (_player.view.showBarrage) {
            content.haveDanmu = @"true";
        }
        else{
            content.haveDanmu = @"false";
        }

        NSString* content = [NSString stringWithFormat:@"state=%@&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&filetype=%@", @"%d", @"看点",isNullString(self.watchEntity.channelUuid), isNullString(self.watchEntity.programSeriesId),isNullString(data.programId),isNullString(self.watchEntity.programSeriesName), isNullString(data.programName), @"互联网"];

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

- (void)toolViewDidStartScreeningVideo:(SJVideoToolView *)toolview
{


   /* self.DLNAListView.currentVideoURL = [self.player.actionUrl description];
    [self.DLNAListView ShowDLNAListViewsIn:[UIApplication sharedApplication].keyWindow];

    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(DLNACallBack:)
                                                name:kNotification_dlnaBroastcastCallbackImp
                                              object:nil];*/

    //投屏
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

    //不需要提示框
    /*if ([[ScreenManager sharedInstance].state isEqualToString:TOGETHER_SAME_NET]||[[ScreenManager sharedInstance].state isEqualToString:TOGETHER_DIFF_NET]) {
     _player.isScreening = NO;
     _toolView.screened = NO;
     [MBProgressHUD show:@"电视端已退出播放" icon:nil view:self.view];
     }
     else{
     TPIMAlertView *alert = [[TPIMAlertView alloc] initWithTitle:[NSString stringWithFormat:@"亲爱的%@",[HiTVGlobals sharedInstance].nickName] message:@"电视已退出播放，继续在手机端观看" leftButtonTitle:@"取消" rightButtonTitle:@"确认"];
     [alert setRightButtonClickBlock:^{
     _player.isScreening = NO;
     _toolView.screened = NO;
     }];

     [alert show];
     }*/
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
    __block SJLiveTVCollcetModel *model = [SJLiveTVCollcetModel new];


    model.uid             = [HiTVGlobals sharedInstance].uid;
    model.oprUids         = [HiTVGlobals sharedInstance].uid;
    model.businessType    = @"watchtv";
    model.playType        = @"vod";
    model.objectId        = StringNotEmpty(self.watchEntity.programSeriesId)?self.watchEntity.programSeriesId:self.categoryID;
    model.objectName      = StringNotEmpty(self.watchEntity.programSeriesName)?self.watchEntity.programSeriesName:video.catgName;

    model.startTime       = [NSString stringWithFormat:@"%ld",(long)self.watchEntity.startTime];
    model.endTime         = [NSString stringWithFormat:@"%ld",(long)self.watchEntity.endTime];
    model.assortId        = self.watchEntity.categoryId;
    model.lastProgramId   = self.watchEntity.contentId;
    model.lastProgramName = self.watchEntity.programSeriesName;
    model.startWatchTime  = @"0";
    int currentTime       = floor(CMTimeGetSeconds([_player.view.player currentTime]));
    NSString *pointString = [NSString stringWithFormat:@"%d",(int)currentTime];

    model.endWatchTime    = pointString;
    model.bannerImg       = StringNotEmpty(self.watchEntity.posterAddr)?self.watchEntity.posterAddr:video.img;
    model.verticalImg     = StringNotEmpty(self.watchEntity.verticalPosterAddr)?self.watchEntity.verticalPosterAddr:video.img;

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
            NSString* content = [NSString stringWithFormat:@"type=%@&uuid=%@&programSeriesId=%@&programseriesname=%@",@"看点", isNullString(self.watchEntity.channelUuid), isNullString(self.watchEntity.programSeriesId), isNullString(self.watchEntity.programSeriesName)];
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
    model.businessType = @"watchtv";
    model.playType     = @"vod";
    model.objectId     = StringNotEmpty(self.watchEntity.programSeriesId)?self.watchEntity.programSeriesId:self.categoryID;
    model.startTime    = [NSString stringWithFormat:@"%ld",(long)self.watchEntity.startTime];
    model.endTime      = [NSString stringWithFormat:@"%ld",(long)self.watchEntity.endTime];
    model.templateId   = WATCHTVGROUPID;
    model.deviceType   = @"MOBILE";

    WEAKSELF
    [BaseAFHTTPManager postRequestOperationForHost:WXSEEN forParam:@"/integration/2.0/deleteCollection" forParameters:[model mj_keyValues]  completion:^(id responseObject) {

        DDLogInfo(@"-----%@",responseObject);
        NSNumber *code = responseObject[@"code"];
        if (code.integerValue == 0) {
            _toolView.collected = NO;
            _player.view.isCollected = NO;
            [MBProgressHUD showSuccess:@"取消收藏" toView:weakSelf.view];

        }else{
            [MBProgressHUD showError:@"取消失败" toView:weakSelf.view];
        }

    }failure:^(NSString *error) {
        [MBProgressHUD showError:@"请求出错" toView:weakSelf.view];
        DDLogError(@"-----%@",error);
        _toolView.collected = YES;
        _player.view.isCollected = YES;
    }];
}

//vod

- (NSString *)shortVedioString:(NSString *)string andJudgeString:(NSString *)typeString{

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
#pragma mark - 详情页分享

-(void)playerDidClickShare{

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
    _shareView =[[SJPortraitShareView alloc]initWithTpye:0];

    [[UIApplication sharedApplication].keyWindow addSubview:_shareView];
    [_shareView showInView:[UIApplication sharedApplication].keyWindow];
    [self watchTVshareMethod];


}
-(SMSRequestParams *)watchTvGengerateSmsParams{
    NSString *aa = [NSString stringWithFormat:@"%f",self.player.currentPlayedSeconds];
    SMSRequestParams *smsparams = [SMSRequestParams new];
    smsparams.uid = [HiTVGlobals sharedInstance].uid;
    smsparams.userName = [HiTVGlobals sharedInstance].nickName;
    smsparams.userImgUrl = [HiTVGlobals sharedInstance].faceImg;
    smsparams.phoneNo = [HiTVGlobals sharedInstance].phoneNo;
    smsparams.domain = [HiTVGlobals sharedInstance].domain;
    smsparams.psId = self.watchEntity.programSeriesId;
    smsparams.pId =self.programId;
    //smsparams.uuid = program.uuid;
    //smsparams.uuid = @"testtest";
    smsparams.contentName = self.programname;
    smsparams.mediaType = @"watchTv";
    smsparams.contentType = self.watchEntity.contentType;
    smsparams.startTime = [NSString stringWithFormat:@"%ld",(long)[aa integerValue]];
    smsparams.shareSeconds = @"30";
    return smsparams;
}
-(void)watchTVshareMethod{

    SJ30SVedioRequestModel *model = [SJ30SVedioRequestModel new];
     NSString *aa = [NSString stringWithFormat:@"%f",self.player.currentPlayedSeconds];
     model.videoTime = [aa integerValue];

     model.videoType =[[self.player.actionUrl absoluteString] containsString:@"/media/"]? @"looktv":@"lookback";

     model.videoId = [self shortVedioString:[self.player.actionUrl absoluteString] andJudgeString:model.videoType];

     model.userName = [HiTVGlobals sharedInstance].nickName;
     model.userHeadImageUrl = [HiTVGlobals sharedInstance].faceImg;
     model.videoSecond = 30;

    WEAKSELF
    //    WatchFocusVideoProgramEntity *vvv =video.programes[self.currentVideoIndex];
    WatchFocusVideoEntity *vvv = video;
    NSInteger cccc = self.currentVideoIndex;

    _shareView.shareButtonBlock = ^(UIButton *button){

        if (button.tag==10) {
            weakSelf.hidesBottomBarWhenPushed = YES;
            SJShareVideoViewController *shareVC = [[SJShareVideoViewController alloc] init];

            SJShareVideoViewModel *viewModel = [[SJShareVideoViewModel alloc] initWithController:shareVC];
            viewModel.watchEntity = vvv;

            if (video.programes.count > self.currentVideoIndex) {

                //当前播放
                WatchFocusVideoProgramEntity *data = vvv.programes[cccc];
                viewModel.watchProgramEntity = data;
            }

            viewModel.videoType = TPShareVideoTypeWatchTV;
            viewModel.currentPlayedSeconds = weakSelf.player.currentPlayedSeconds;

            shareVC.viewModel = viewModel;

            [weakSelf.navigationController pushViewController:shareVC animated:YES];


            // add log.
            NSString* content = [NSString stringWithFormat:@"state=%@&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&way=%@&sharetime=%@&sharepoint=%@",@"%d", @"看点", weakSelf.watchEntity.contentId, weakSelf.watchEntity.programSeriesId, weakSelf.watchEntity.contentId, weakSelf.watchEntity.programSeriesName, weakSelf.watchEntity.channelName, @"和家庭好友", [[NSUserDefaults standardUserDefaults] objectForKey:LOG_SHARE_VIDEO_LENGTH], [Utils getCurrentTime]];
            [NSUserDefaultsManager saveObject:content forKey:LOG_SHARE_CONTENT];

        }else{

            WatchFocusVideoProgramEntity *data =vvv.programes[cccc];
            [weakSelf.shareAlertView showAlertViewIn:weakSelf.view];
            weakSelf.shareAlertView.shareType = button.tag-10;
//            weakSelf.shareAlertView.theModel = model;
            weakSelf.shareAlertView.smsModel = [weakSelf watchTvGengerateSmsParams];
            weakSelf.shareAlertView.titleText.text = data.programName;
            
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
    //
    //    [self.view addSubview:_shareView];
    //
    //    [_shareView showInView:self.view];
    //
    //    [self watchTVshareMethod];
}


#pragma mark - 查询收藏过

- (void)checkWatchTVHasCollected
{

    SJLiveRequestIsCollectModel *model =[SJLiveRequestIsCollectModel new];

    model.uid = [HiTVGlobals sharedInstance].uid;
    model.businessType = self.watchEntity.businessType;
    if (model.businessType.length==0) {
        model.businessType = @"watchtv";
    }
    model.objectId =  StringNotEmpty(self.watchEntity.programSeriesId)?self.watchEntity.programSeriesId:self.categoryID;
    // model.startTime = [NSString stringWithFormat:@"%ld",(long)self.watchEntity.startTime];
    //model.endTime = [NSString stringWithFormat:@"%ld",(long)self.watchEntity.endTime];
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

        DDLogError(@"-----%@",error);


    }];

}

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

    // add log.
    NSString* content = [NSString stringWithFormat:@"state=%@&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&way=%@&sharetime=%@&sharepoint=%@",@"%d", @"看点", self.watchEntity.contentId, self.watchEntity.programSeriesId, self.watchEntity.contentId, self.watchEntity.programSeriesName, self.watchEntity.channelName, way, [[NSUserDefaults standardUserDefaults] objectForKey:LOG_SHARE_VIDEO_LENGTH], [Utils getCurrentTime]];
    [NSUserDefaultsManager saveObject:content forKey:LOG_SHARE_CONTENT];


}

-(void)chooseOneWatchEntityFromGuestList:(WatchListEntity *)model{

    /*if ([model.contentType isEqualToString:@"watchtv"]) {
        self.videoID = model.programSeriesId;
        [self refreshData];
    }
    else{*/
        if ([self.delegate respondsToSelector:@selector(watchTVDetail:didSelectRecommendItem:)]) {
            [self.delegate watchTVDetail:self didSelectRecommendItem:model];
        }
    //}

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

#pragma -mark OrientationDidChange
-(void)deviceOrientationDidChange{

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    //    CGSize layoutSize ;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;

    if ((orientation == UIDeviceOrientationLandscapeLeft ||  orientation == UIDeviceOrientationLandscapeRight) && screenSize.width > screenSize.height) {
        [_chatRoomView.inputView resignFirstResponder];
        guestVC.view.frame = self.player.view.frame;
        [guestVC.view layoutIfNeeded];
        [_shareView hiddleFromSuperView];
        [_shareListView hiddleFromSuperView];
         [_shareAlertView hiddenAlertView];
        [_player.view setStyle:SJVideoPlayerViewStyleFullScreen];
    }else if(orientation == UIDeviceOrientationPortrait  && screenSize.width < screenSize.height){
        [_chatRoomView.inputView resignFirstResponder];
        guestVC.view.frame = self.player.view.frame;
        [guestVC.view layoutIfNeeded];
        [_shareView hiddleFromSuperView];
         [_shareAlertView hiddenAlertView];
         [_player.view setStyle:SJVideoPlayerViewStyleMini];
    }
    [_videoDetailView.seriesTableView hiddenFullView];

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
#pragma -mark follow好友加入聊天室
- (void)joinRoom:(NSNotification *)notification
{
    _segmentedControl.selectedSegmentIndex = 1;
    [self segmentedControlValueChanged:nil];
}
#pragma -mark 遥控器
- (void)goRemoteVC:(NSNotification *)notification
{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:NSStringFromSelector(@selector(orientation))];
    SJRemoteControlViewController *remoteVC = [[SJRemoteControlViewController alloc] init];
    [self.navigationController pushViewController:remoteVC animated:YES];

}
#pragma -mark 影片鉴权
-(void)queryPriceRequest
{
    if ([[HiTVGlobals sharedInstance].disable_moudles containsObject:@"vip"]) {
        return;
    }
    if ([self.watchEntity.contentType isEqualToString:@"watchtv"]) {
        //return;
    }

    NSString *contentId = StringNotEmpty(self.watchEntity.programSeriesId)?self.watchEntity.programSeriesId:self.categoryID;
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


#pragma mark 新版分享View
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

     model.videoType =[[self.player.actionUrl absoluteString] containsString:@"/media/"]? @"looktv":@"lookback";

     model.videoId = [self shortVedioString:[self.player.actionUrl absoluteString] andJudgeString:model.videoType];

     model.userName = [HiTVGlobals sharedInstance].nickName;
     model.userHeadImageUrl = [HiTVGlobals sharedInstance].faceImg;
     model.videoSecond = 30;

    WatchFocusVideoEntity *vvv = video;
    NSInteger cccc = self.currentVideoIndex;
    if (name==ShiJia) {

        self.hidesBottomBarWhenPushed = YES;
        SJShareVideoViewController *shareVC = [[SJShareVideoViewController alloc] init];

        SJShareVideoViewModel *viewModel = [[SJShareVideoViewModel alloc] initWithController:shareVC];
        viewModel.watchEntity = vvv;

        if (video.programes.count > self.currentVideoIndex) {

            //当前播放
            WatchFocusVideoProgramEntity *data = vvv.programes[cccc];
            viewModel.watchProgramEntity = data;
        }

        viewModel.videoType = TPShareVideoTypeWatchTV;
        viewModel.currentPlayedSeconds = self.player.currentPlayedSeconds;

        shareVC.viewModel = viewModel;

        [self.navigationController pushViewController:shareVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;

        // add log.
        NSString* content = [NSString stringWithFormat:@"state=%@&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&way=%@&sharetime=%@&sharepoint=%@",@"%d", @"看点", self.watchEntity.contentId, self.watchEntity.programSeriesId, self.watchEntity.contentId, self.watchEntity.programSeriesName, self.watchEntity.channelName, @"和家庭好友", [[NSUserDefaults standardUserDefaults] objectForKey:LOG_SHARE_VIDEO_LENGTH], [Utils getCurrentTime]];
        [NSUserDefaultsManager saveObject:content forKey:LOG_SHARE_CONTENT];

    }else{

        WatchFocusVideoProgramEntity *data =vvv.programes[cccc];
        [self.shareAlertView showAlertViewIn:self.view];
        self.shareAlertView.shareType = name;
//        self.shareAlertView.theModel = model;
        self.shareAlertView.titleText.text = data.programName;
        self.shareAlertView.smsModel = [self watchTvGengerateSmsParams];
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
#pragma mark  电视未关联状态
-(void)showNoDeviceAlert{
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您未关联电视设备，先打开“扫一扫”页面进行关联！" message:nil delegate:self cancelButtonTitle:@"前往扫一扫" otherButtonTitles:@"取消", nil];
//    alert.tag=1001;
//    [alert show];
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
@end
