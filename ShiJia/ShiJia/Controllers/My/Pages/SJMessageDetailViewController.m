//
//  SJMessageDetailViewController.m
//  ShiJia
//
//  Created by yy on 16/6/23.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJMessageDetailViewController.h"
#import "SJMessageVideoView.h"
#import "TPIMContentModel.h"
#import "TPIMMessageModel.h"
#import "TPMessageCenterDataModel.h"

#import "TPIMGroup.h"
#import "TPXmppRoomManager.h"
#import <XMPPFramework/XMPPRoom.h>
#import "TPXmppManager.h"
#import "SJPayViewController.h"
#import "ProductEntity.h"
#import "TPShortVideoPlayerView.h"
#import "SJVIPViewController.h"
#import "SJAlbumToolViewModel.h"
#import "SJAlbumModel.h"
#import "SJCouponViewController.h"
#import "DmsDataPovider.h"
#import "HotsVideoModel.h"

static CGFloat kHorizontalSpacing = 15.0;
static CGFloat kVerticalSpacing = 10.0;
static CGFloat kLabelHeight = 20.0;

static NSString *msgType = @"24";
static NSString *yhqType = @"25";

@interface SJMessageDetailViewController ()

@property (nonatomic, strong) TRTopNavgationView *naviView;

@property (nonatomic, weak) IBOutlet UIScrollView *scroll;
@property (nonatomic, weak) IBOutlet UIButton      *bottomButton;

@property (nonatomic, strong) UIView                  *contentView;
@property (nonatomic, strong) UILabel                 *titleLabel;
@property (nonatomic, strong) UILabel                 *dateLabel;
@property (nonatomic, strong) UILabel                 *contentLabel;
@property (nonatomic, strong) SJMessageVideoView      *videoView;
@property (nonatomic, strong) UIView                  *albumShareView;
@property (nonatomic, strong) UIImageView             *albumBackImgView;
@property (nonatomic, strong) UIImageView             *shareImgView;
@property (nonatomic, strong) TPShortVideoPlayerView  *playerView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, retain) TPIMContentModel *msgContentModel;
@property (nonatomic, strong) SJAlbumToolViewModel *toolViewModel;

@end

@implementation SJMessageDetailViewController{

    BOOL joinRoom;
    NSTimer *verTimer;

}
#pragma mark - Lifecycle
- (instancetype)init{

    self = [super init];

    if (self) {

        // main view
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];

        // title label
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.adjustsFontSizeToFitWidth = YES;

        // date label
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.font = [UIFont systemFontOfSize:12.0];
        _dateLabel.textColor = [UIColor lightGrayColor];

        // content label
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = [UIFont systemFontOfSize:13.0];
        _contentLabel.numberOfLines = NSIntegerMax;


        // video view
        _videoView = [[SJMessageVideoView alloc] init];
        [_videoView.playSignal subscribeNext:^(id x) {
            [self bottmonButtonClicked:nil];
        }];

        // album share view
        _albumShareView = [[UIView alloc] init];
        _albumShareView.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:_albumShareView];

        _albumBackImgView = [[UIImageView alloc] init];
        _albumBackImgView.image = [UIImage imageNamed:@"message_video_background"];
        [_albumShareView addSubview:_albumBackImgView];
        _albumShareView.hidden = YES;


    }
    return self;
}

- (void)viewDidLoad{

    [super viewDidLoad];
    self.view.backgroundColor = kColorLightGrayBackground;
    [self initNavigationView];
    //self.title = @"消息详情";
    [_scroll addSubview:_contentView];
    [_contentView addSubview:_titleLabel];
    [_contentView addSubview:_dateLabel];
    [_contentView addSubview:_contentLabel];
    [_contentView addSubview:_videoView];

    [self refreshDataWithMsgId:self.msgId messageModel:self.msgModel];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = YES;
    joinRoom = NO;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self closeTimer];
}
- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];

    // 标题
    _titleLabel.frame = CGRectMake(kHorizontalSpacing,
                                   kVerticalSpacing,
                                   _scroll.frame.size.width - kHorizontalSpacing * 2,
                                   kLabelHeight);
    // 日期
    _dateLabel.frame = CGRectMake(kHorizontalSpacing,
                                  _titleLabel.frame.size.height + _titleLabel.frame.origin.y,
                                  _scroll.frame.size.width - kHorizontalSpacing * 2,
                                  kLabelHeight);

    if (_contentLabel.height == 0) {

        CGSize size = CGSizeMake(_scroll.frame.size.width - kHorizontalSpacing * 2, FLT_MAX);

        CGRect contentRect = [_contentLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_contentLabel.font,NSFontAttributeName, nil] context:nil];
        // 消息内容
        _contentLabel.frame = CGRectMake(kHorizontalSpacing,
                                         _dateLabel.frame.origin.y + _dateLabel.frame.size.height + kVerticalSpacing,
                                         _scroll.frame.size.width - kHorizontalSpacing * 2,
                                         contentRect.size.height);

    }

    CGFloat originy = _contentLabel.frame.origin.y + _contentLabel.frame.size.height;


    if ([self.msgModel.type isEqualToString:@"11"]||[self.msgModel.type isEqualToString:@"28"]) {


        _albumShareView.frame = CGRectMake(0,
                                           originy,
                                           self.view.frame.size.width,
                                           self.view.frame.size.width);

        _albumBackImgView.frame = _albumShareView.bounds;


        _playerView.frame = CGRectMake(20, 20, _albumShareView.frame.size.width - 20 * 2, _albumShareView.frame.size.height - 20 *2);;

        _contentView.frame = CGRectMake(0,
                                        0,
                                        _scroll.frame.size.width,
                                        _playerView.frame.origin.y + _playerView.frame.size.height + kVerticalSpacing);

    }
    else if ([self.msgModel.type isEqualToString:@"26"]){

        _albumShareView.frame = CGRectMake(0,
                                           originy,
                                           self.view.frame.size.width,
                                           self.view.frame.size.width);

        _albumBackImgView.frame = _albumShareView.bounds;

        _shareImgView.frame = CGRectMake(20, 20, _albumShareView.frame.size.width - 20 * 2, _albumShareView.frame.size.height - 20 *2);

        _activityView.center = _shareImgView.center;

        _contentView.frame = CGRectMake(0,
                                        0,
                                        _scroll.frame.size.width,
                                        _playerView.frame.origin.y + _playerView.frame.size.height + kVerticalSpacing);
    }
    else{
        _videoView.frame = CGRectMake(0,
                                      originy,
                                      self.view.frame.size.width,
                                      kSJMessageVideoViewHeight);

        _contentView.frame = CGRectMake(0,
                                        0,
                                        _scroll.frame.size.width,
                                        _videoView.frame.origin.y + kSJMessageVideoViewHeight + kVerticalSpacing);

    }

    _scroll.contentSize = _contentView.size;


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event
- (IBAction)bottmonButtonClicked:(id)sender
{
    if ([_msgModel.type isEqualToString:@"7"]) {
        //约片
        [self acceptInvitation];
    }
    else if ([_msgModel.type isEqualToString:@"6"]){
        //观看影片
        AppDelegate *delegate = [AppDelegate appDelegate];
        [delegate.appdelegateService pushToVideoDetailController:self.msgContentModel];
    }
    else if([_msgModel.type isEqualToString:msgType]){
        SJVIPViewController *VIPVC =[[SJVIPViewController alloc]initWithNibName:@"SJVIPViewController" bundle:nil];
        [self.navigationController pushViewController:VIPVC animated:YES];

    }
    else if([_msgModel.type isEqualToString:yhqType]){
        SJCouponViewController *couponVC = [[SJCouponViewController alloc] init];
        [self.navigationController pushViewController:couponVC animated:YES];
    }
    else if ([_msgModel.type isEqualToString:@"11"]){
        [_playerView downloadShortVideoToAlbum];
    }
    else if ([_msgModel.type isEqualToString:@"26"]){
        [self saveImageToAlbum];
    }else if ([_msgModel.type isEqualToString:@"28"]){
        [_playerView downloadShortVideoToAlbum];
    }
}

- (void)acceptInvitation
{
    //加入聊天室
    if (self.msgContentModel.roomId.length == 0) {
        return ;
    }

    TPIMGroup *group = [[TPIMGroup alloc] init];
    group.groupName = self.msgContentModel.roomId;

    XMPPRoom *room = [[TPXmppManager defaultManager] xmppRoomWithRoomName:group.groupName isPublicRoom:NO];
    [[TPXmppRoomManager defaultManager] setCurrentRoom:room];

    [MBProgressHUD showMessag:@"正在加入" toView:self.scroll];
    if (!verTimer) {
        verTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(verUpdate) userInfo:nil repeats:NO];
    }
    
    [TPIMGroup createGroup:group completionHandler:^(id responseObject, NSError *error) {
        [self closeTimer];
        if (error == nil) {
            
            if (!joinRoom) {
                joinRoom = YES;
                
                TPIMMessageModel *data = [[TPIMMessageModel alloc] init];
                data.contentModel = self.msgContentModel;
                data.videoname = self.msgContentModel.programName;;
                [[TPXmppRoomManager defaultManager] setInvitedMessageModel:data];
                
                if ([responseObject isKindOfClass:[XMPPRoom class]]) {
                    [[TPXmppRoomManager defaultManager] setCurrentRoom:(XMPPRoom *)responseObject];
                    [[TPXmppRoomManager defaultManager] joinRoom];
                }
                
            }
        }
        else{
            /*[OMGToast showWithText:@"加入失败"];
            //观看影片
            AppDelegate *delegate = [AppDelegate appDelegate];
            [delegate.appdelegateService pushToVideoDetailController:self.msgContentModel];*/
        }
    }];
}
-(void)verUpdate{
    [self closeTimer];
    [self pushToVideoDetailVC];
}
-(void)pushToVideoDetailVC{
    [OMGToast showWithText:@"加入失败"];
    //观看影片
    AppDelegate *delegate = [AppDelegate appDelegate];
    [delegate.appdelegateService pushToVideoDetailController:self.msgContentModel];
}
-(void)closeTimer{
    [MBProgressHUD hideHUDForView:self.scroll animated:NO];
    [verTimer invalidate];
    verTimer = nil;
}
#pragma mark - download data
- (void)downloadMessageDetailWithMsgId:(NSString *)msgid messageModel:(TPMessageCenterDataModel *)msgmodel
{
    if (msgid.length == 0) {
        return;
    }

    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:msgid forKey:@"msgId"];

    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    //获取消息列表
    [BaseAFHTTPManager getRequestOperationForHost:MSGCENTERHOST forParam:@"/message/detail" forParameters:parameters completion:^(id responseObject) {

        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];

        if ([responseObject isKindOfClass:[NSDictionary class]]) {

            NSDictionary *dic = (NSDictionary *)responseObject;
            id contentData = [dic valueForKey:@"content"];

            NSError *error = nil;
            NSDictionary *contentDic = [NSJSONSerialization JSONObjectWithData:[contentData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
            self.msgContentModel = [TPIMContentModel mj_objectWithKeyValues:contentDic];
            self.msgContentModel.content =  [self.msgContentModel.content stringByReplacingOccurrencesOfString:@"视加" withString:CurrentAppName];
            
            _dateLabel.text = [responseObject objectForKey:@"msgTime"];

            // 更新video view
            _videoView.programName = self.msgContentModel.programName;
            _videoView.actor = self.msgContentModel.actors;


            _videoView.director = self.msgContentModel.directors;



            _videoView.posterImgUrl = self.msgContentModel.thumPath;
            [_videoView setNeedsLayout];

            if ([msgmodel.type isEqualToString:@"6"]){
                _contentLabel.text = [NSString stringWithFormat:@"%@你好，《%@》这个节目很不错!送给你，希望你会喜欢。",[HiTVGlobals sharedInstance].nickName,self.msgContentModel.programName];
            }
            else if ([msgmodel.type isEqualToString:@"7"]){
                _contentLabel.text = @"";
            }
            else if ([msgmodel.type isEqualToString:msgType]||[msgmodel.type isEqualToString:yhqType]){
                _contentLabel.text = [NSString stringWithFormat:@"%@",self.msgContentModel.content];
                _videoView.hidden = YES;
            }
            else if ([msgmodel.type isEqualToString:@"11"]){

                if (_playerView == nil) {
                    _playerView = [[TPShortVideoPlayerView alloc] initWithVideoUrl:self.msgContentModel.path andVideoType:CLOUD_TYPE];

                }
                _videoView.hidden = YES;
                _albumShareView.hidden = NO;
                [_playerView removeFromSuperview];
                [_albumShareView addSubview:_playerView];
                [self.view setNeedsLayout];
            }
            else if ([msgmodel.type isEqualToString:@"26"]){

                if (_shareImgView == nil) {
                    _shareImgView = [[UIImageView alloc] init];
                    _shareImgView.contentMode = UIViewContentModeScaleAspectFit;

                    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

                }

                _toolViewModel = [[SJAlbumToolViewModel alloc] init];

                [_activityView startAnimating];
                __weak __typeof(self)weakSelf = self;
                [_shareImgView setImageWithURL:[NSURL URLWithString:self.msgContentModel.path]
                                   placeholder:nil
                                       options:YYWebImageOptionShowNetworkActivity
                                    completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                        __strong __typeof(weakSelf)strongSelf = weakSelf;
                                        [strongSelf.activityView stopAnimating];
                                    }];

                _videoView.hidden = YES;
                _albumShareView.hidden = NO;
                [_shareImgView removeFromSuperview];
                [_albumShareView addSubview:_shareImgView];

                [_activityView removeFromSuperview];
                [_albumShareView addSubview:_activityView];

                [self.view setNeedsLayout];

            }else if ([msgmodel.type isEqualToString:@"28"]){
                //根据消息中消息的中的视频的ID 来获取视频详情
                WEAKSELF
                [DmsDataPovider getHotVideoDetailWithVideoID:self.msgContentModel.hotspotID
                                             CompletionBlock:^(id responseObject) {

                                                 hotVideoDetail *detail = [hotVideoDetail mj_objectWithKeyValues:responseObject];

                                                 if (_playerView == nil) {

                                                     _playerView = [[TPShortVideoPlayerView alloc] initWithVideoUrl:[detail.videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] andVideoType:CLOUD_TYPE];

                                                 }
                                                 _videoView.posterImgUrl = detail.poster;
                                                 _contentLabel.text = [NSString stringWithFormat:@"%@你好，《%@》这个小视频很不错!送给你，希望你会喜欢。",[HiTVGlobals sharedInstance].nickName,detail.title];
                                                 _videoView.hidden = YES;
                                                 _albumShareView.hidden = NO;
                                                 [_playerView removeFromSuperview];
                                                 [_albumShareView addSubview:_playerView];
                                                 [weakSelf.view setNeedsLayout];

                                             } failure:^(NSString *message) {
                                                 [MBProgressHUD showError:message toView:self.view];

                                             }];



            }

        }

    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];

}

- (void)modifyMessageStateWithMsgId:(NSString *)msgid
{
    if (msgid.length == 0) {
        return;
    }

    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:msgid forKey:@"msgId"];
    [parameters setValue:@"1" forKey:@"readed"];

    //获取消息列表
    [BaseAFHTTPManager postRequestOperationForHost:MSGCENTERHOST forParam:@"/message/modifyReadState" forParameters:parameters completion:^(id responseObject) {

    } failure:^(NSString *error) {

    }];

}

- (void)saveImageToAlbum
{
    [MBProgressHUD showMessag:@"下载中" toView:nil];

    CloudPhotoModel *thecloudModel = [[CloudPhotoModel alloc] init];
    thecloudModel.resourceUrl = self.msgContentModel.path;

    [_toolViewModel downLoadCloudSource:thecloudModel andSourceType:Media_Photo];

    _toolViewModel.downprecent = ^(NSInteger precent){
        DDLogInfo(@"---下载了-----%ld",(long)precent);

    };

    [_toolViewModel.downSubject subscribeNext:^(id x) {

        //[MBProgressHUD hideAllHUDsForView:nil animated:YES];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"已保存到相册" toView:nil];
    } error:^(NSError *error) {

        //[MBProgressHUD hideAllHUDsForView:nil animated:YES];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"保存失败" toView:nil];
    }];
}

#pragma mark - Subview
- (void)refreshDataWithMsgId:(NSString *)msgid messageModel:(TPMessageCenterDataModel *)msgmodel
{
    // show detail
    if ([self.msgModel.type isEqualToString:msgType]||[self.msgModel.type isEqualToString:yhqType]){
        _titleLabel.text = _msgModel.from.nickname;
    }
    else{
        _titleLabel.text = _msgModel.title;
    }
    //    NSTimeInterval time = [_msgModel.time floatValue]/1000;
    //    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    //    NSDateFormatter *fotmatter = [[NSDateFormatter alloc] init];
    //    [fotmatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    _dateLabel.text = [fotmatter stringFromDate:date];

    if ([_msgModel.type isEqualToString:@"7"]) {
        [_bottomButton setTitle:@"接受邀请" forState:UIControlStateNormal];
    }
    else if([_msgModel.type isEqualToString:@"6"]){
        [_bottomButton setTitle:@"观 看" forState:UIControlStateNormal];
    }
    else if([_msgModel.type isEqualToString:msgType]){
        [_bottomButton setTitle:@"马上续费" forState:UIControlStateNormal];
    }
    else if([_msgModel.type isEqualToString:yhqType]){
        [_bottomButton setTitle:@"查看" forState:UIControlStateNormal];
    }
    else if ([_msgModel.type isEqualToString:@"11"] || [_msgModel.type isEqualToString:@"26"]){
        [_bottomButton setTitle:@"下载到本地" forState:UIControlStateNormal];
    }else{
        _bottomButton.hidden = YES;
    }
    self.msgId = msgid;
    self.msgModel = msgmodel;
    [self downloadMessageDetailWithMsgId:msgid messageModel:msgmodel];
    [self modifyMessageStateWithMsgId:msgid];
}

- (void)initNavigationView
{
    _naviView = [TRTopNavgationView navgationView];
    [self.view addSubview:_naviView];
    _naviView.backgroundColor = kNavgationBarColor;
    
    // back button
    UIButton* backBt = [UIHelper createBtnfromSize:kBackButtonSize
                                             image:[UIImage imageNamed:@"white_back_btn"]
                                      highlightImg:[UIImage imageNamed:@"white_back_btn"]
                                       selectedImg:nil
                                            target:self
                                          selector:nil];
    __weak __typeof(self)weakSelf = self;
    [[backBt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.playerView) {
            [strongSelf.playerView clearPlayer];
        }
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
    [_naviView setLeftView:backBt];
    
    // title
    UILabel* lbl = [UIHelper createTitleLabel:@"消息详情"];
    lbl.textColor = [UIColor whiteColor];
    [_naviView setTitleView:lbl];
    
    
}


@end
