//
//  FriendInfoController.m
//  HiTV
//
//  Created by 蒋海量 on 15/7/24.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#import "FriendInfoController.h"
#import "RecordView.h"
#import "RecordEntity.h"
#import "RecentViewController.h"
#import "CollectionVideo.h"
#import "WatchFocusVideoEntity.h"
#import "JSON.h"
#import "QRCodeController.h"
#import "FriendInfoCell.h"
#import "SwitchBtn.h"
#import "OMGToast.h"
#import "FavoriteViewController.h"
#import "SJMultiVideoDetailViewController.h"
#import "SJWatchTVDetailController.h"
#import "SJVideoDetailViewController.h"
#import "SJLiveTVDetailViewController.h"

#define RECORDWIDTH       100
#define RECORDHEIGHT      150

//#define HISTORYTAG        100
//#define COLLECTIONTAG     1000

@interface FriendInfoController ()<ModifyremarksControllerDelegate>
@property(nonatomic,weak) IBOutlet UIScrollView *contentScrollView;
@property(nonatomic,weak) IBOutlet UIImageView *headImg;
@property(nonatomic,weak) IBOutlet UILabel *nameLab;
@property(nonatomic,weak) IBOutlet UIScrollView *historyRecordScrView;
@property(nonatomic,weak) IBOutlet UIScrollView *collectionRecordScrView;
@property(nonatomic,weak) IBOutlet UILabel *zanwuHisoryLab;
@property(nonatomic,weak) IBOutlet UILabel *zanwuCollectionLab;
@property(nonatomic,weak) IBOutlet UIImageView *line;
@property(nonatomic,weak) IBOutlet UIImageView *line2;
@property(nonatomic,weak) IBOutlet UITableView *tabView;

@property(nonatomic,weak) IBOutlet UIImageView *wlogo;
@property(nonatomic,weak) IBOutlet UILabel *watchingLab;
@property(nonatomic,weak) IBOutlet UIButton *watchingBtn;


@property(nonatomic) BOOL IsPullDown;

@property(nonatomic,strong) NSMutableArray *collectionArray;
@property(nonatomic,strong) NSMutableArray *historysArray;
@property (nonatomic, strong) WatchFocusVideoEntity* selectedEntity;
@property (nonatomic) NSInteger currentVideoIndex;
@property (nonatomic) NSString* selectedAssortId;

@property(nonatomic,strong)  UILabel *modifyLab;
@property(nonatomic,strong) UILabel *ysLab;
@property(nonatomic,strong) UILabel *contentLab;
@property(nonatomic,strong) SwitchBtn *switchBtn;
@end

@implementation FriendInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFriendInfo:) name:@"modifyremarks" object:nil];

    // Do any additional setup after loading the view from its nib.
    self.title = @"好友资料";
    self.view.backgroundColor = klightGrayColor;
    self.tabView.separatorColor = klightGrayColor;
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.headImg addGestureRecognizer:tapGr];
    self.headImg.layer.masksToBounds = YES;
    // 其實就是設定圓角，只是圓角的弧度剛好就是圖片尺寸的一半
    self.headImg.layer.cornerRadius = 80 / 2.0;
    [self.headImg setImageWithURL:[NSURL URLWithString:self.userEntity.faceImg] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
    
    self.line.backgroundColor = klightGrayColor;
    self.line2.backgroundColor = klightGrayColor;

    self.contentScrollView.bounces = NO;
    //FIXME: 没有用到 是否可以删除？？？？？
    //!!!:
    //???:
    
//    NSString *nickname = self.userEntity.name.length == 0 ? self.userEntity.nickName : self.userEntity.name;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    if (self.userEntity.nickName==nil ||[self.userEntity.nickName isEqualToString:@""]) {
        self.nameLab.text = self.userEntity.name;
    }
    else{
        self.nameLab.text = self.userEntity.nickName;
    }
    [self loadDetail];
}
-(void)loadDetail{
    [self.historysArray removeAllObjects];
    [self.collectionArray removeAllObjects];
    for (UIView *view in self.historyRecordScrView.subviews) {
        if ([view isKindOfClass:[RecordView class]]) {
            [view removeFromSuperview];
        }
    }
    for (UIView *view in self.collectionRecordScrView.subviews) {
        if ([view isKindOfClass:[RecordView class]]) {
            [view removeFromSuperview];
        }
    }
    if ([self.userEntity.authorType intValue] == 0) {
        [self queryBehavior];
    }
    else {
        self.zanwuHisoryLab.hidden = NO;
        self.zanwuCollectionLab.hidden = NO;
    }
    
    NSString *watchingStr = self.userEntity.watchingEntity.lastProgramName;
    if (watchingStr.length == 0) {
        self.wlogo.hidden = YES;
    }
    else{
        self.wlogo.hidden = NO;
        if ([self.userEntity.watchingEntity.deviceType isEqualToString:@"MOBILE"]) {
            [self.wlogo setImage:[UIImage imageNamed:@"sjwk"]];
        }else{
            [self.wlogo setImage:[UIImage imageNamed:@"dsgk"]];
        }
    }
    self.watchingLab.text = watchingStr;
    self.watchingLab.textColor = kColorBlueTheme;
   // [self.watchingBtn setTitle:watchingStr forState:UIControlStateNormal];
    //[self.watchingBtn setTitleColor:kNavColor forState:UIControlStateNormal];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.contentScrollView.contentSize = CGSizeMake(W, 690+140);

}
-(void)viewWillLayoutSubviews{
    UIFont *font = [UIFont fontWithName:@"Arial" size:13];
    CGSize size = CGSizeMake(W,2000);
    CGSize labelsize = [self.watchingLab.text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.watchingLab setFrame:CGRectMake(0,0, labelsize.width+10, labelsize.height)];
    self.watchingLab.center = CGPointMake(W / 2, 145);
    self.wlogo.frame = CGRectMake(self.watchingLab.frame.origin.x-20,138, self.wlogo.frame.size.width, self.wlogo.frame.size.height);
    
    self.contentScrollView.contentSize = CGSizeMake(W, 690+140);
    
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
 
}
-(void)p_backButtonTapped{
    NSArray *vcs = self.navigationController.viewControllers;
    if ([vcs count]>1) {
        UIViewController *lastVC = [vcs objectAtIndex:[vcs count]-2];
        if ([lastVC isKindOfClass:[QRCodeController class]]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)loadHistoryRecordScrView{
    float space = (W-RECORDWIDTH*3)/4;

    float width = space;
    for (int i = 0; i<self.historysArray.count; i++) {
        if (i==3) {
            break;
        }
        RecentVideo *entity = self.historysArray[i];
        RecordView *recordView  = [[[NSBundle mainBundle] loadNibNamed:@"RecordView" owner:self options:nil] firstObject];
        recordView.frame = CGRectMake(width, 0, RECORDWIDTH, RECORDHEIGHT);
        if (entity.verticalImg.length == 0) {
            [recordView.videoLogo setImageWithURL:[NSURL URLWithString:entity.bannerImg] placeholderImage:[UIImage imageNamed:@"loadingImage"]];

        }else{
            [recordView.videoLogo setImageWithURL:[NSURL URLWithString:entity.verticalImg] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
        }

        recordView.videoName.text = entity.objectName;
        
        recordView.tag = i;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTapInHistory:)];
        recordView.userInteractionEnabled = YES;
        [recordView addGestureRecognizer:singleTap];
        [self.historyRecordScrView addSubview:recordView];
        width += RECORDWIDTH+space;
    }
    self.historyRecordScrView.contentSize = CGSizeMake(width, RECORDHEIGHT);
    
}

-(void)loadCollectionRecordScrView{
    float space = (W-RECORDWIDTH*3)/4;
    
    float width = space;
    for (int i = 0; i<self.collectionArray.count; i++) {
        if (i==3) {
            break;
        }
        RecentVideo *entity = self.collectionArray[i];

        RecordView *recordView  = [[[NSBundle mainBundle] loadNibNamed:@"RecordView" owner:self options:nil] firstObject];
        recordView.frame = CGRectMake(width, 0, RECORDWIDTH, RECORDHEIGHT);
        if (entity.verticalImg.length == 0) {
            [recordView.videoLogo setImageWithURL:[NSURL URLWithString:entity.bannerImg] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
            
        }else{
            [recordView.videoLogo setImageWithURL:[NSURL URLWithString:entity.verticalImg] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
        }
        
        recordView.videoName.text = entity.objectName;
        recordView.tag = i;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTapInCollection:)];
        recordView.userInteractionEnabled = YES;
        [recordView addGestureRecognizer:singleTap];
        [self.collectionRecordScrView addSubview:recordView];
        width += RECORDWIDTH+space;
    }
    self.collectionRecordScrView.contentSize = CGSizeMake(width, RECORDHEIGHT);
    
}
-(NSMutableArray *)collectionArray
{
    if (!_collectionArray) {
        _collectionArray = [NSMutableArray array];
    }
    return _collectionArray;
}
-(NSMutableArray *)historysArray
{
    if (!_historysArray) {
        _historysArray = [NSMutableArray array];
    }
    return _historysArray;
}
//!!!:
//!!!:修复？
//!!!:
-(void)handleTapInHistory:(UITapGestureRecognizer *)sender{
    RecentVideo *video = self.historysArray[sender.view.tag];
    [self playVideo:video];

}
-(void)handleTapInCollection:(UITapGestureRecognizer *)sender{
    RecentVideo *video = self.collectionArray[sender.view.tag];
    [self playVideo:video];
}
-(void)playVideo:(RecentVideo *)content{
    if ([content.businessType isEqualToString:@"watchtv"]) {
        if ([content.playType isEqualToString:@"live"]) {
            {
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
            //detailVC.videoDatePoint = content.endWatchTime.floatValue;
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
            // detailVC.videoDatePoint = content.endWatchTime.floatValue;
            
            WatchListEntity *entity = [[WatchListEntity alloc]init];
            entity.programSeriesId = content.objectId;
            entity.categoryId = content.assortId;
            entity.contentId = content.lastProgramId;
            entity.programSeriesName = content.objectName;
            entity.startTime = [content.startTime longLongValue];
            entity.endTime = [content.endTime longLongValue];
            entity.setNumber = content.seriesNumber;
            detailVC.watchEntity = entity;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        
    }
    else if ([content.businessType isEqualToString:@"vod"]){
        
        // 点播
        self.hidesBottomBarWhenPushed = YES;
        SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
        detailVC.videoID = content.objectId;
        //detailVC.videoDatePoint = content.endWatchTime.floatValue;
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
        // detailVC.videoDatePoint = content.endWatchTime.floatValue;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
- (void)modifyRemarks{
    ModifyremarksController *modifyVC = [[ModifyremarksController alloc]init];
    modifyVC.m_delegate = self;
    modifyVC.userEntity = self.userEntity;
    [self.navigationController pushViewController:modifyVC animated:YES];
}
-(IBAction)goFavoriteViewController:(id)sender{
    if ([self.userEntity.authorType intValue] == 0) {
        FavoriteViewController *controller = [[FavoriteViewController alloc] init];
        controller.pUid = self.userEntity.uid;
        controller.editView.hidden = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
-(IBAction)goRecentViewViewController:(id)sender{
    if ([self.userEntity.authorType intValue] == 0) {
        RecentViewController *controller = [[RecentViewController alloc] init];
        controller.pUid = self.userEntity.uid;
        controller.editView.hidden = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
-(IBAction)watchFriendVideo:(id)sender{
    [self goVideoDetailVC:self.userEntity.watchingEntity];
}
#pragma mark - 好友正在观看
-(void)goVideoDetailVC:(RecentVideo *)content{

    if ([content.businessType isEqualToString:@"watchtv"]) {
        if ([content.playType isEqualToString:@"live"]) {
            {
                // 直播
                
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
        }
        else{
            // 看点
            //self.hidesBottomBarWhenPushed = YES;
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
            entity.setNumber = content.seriesNumber;
            
            detailVC.watchEntity = entity;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    else if ([content.businessType isEqualToString:@"vod"]){
        // 点播
       // self.hidesBottomBarWhenPushed = YES;
        SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
        detailVC.videoID = content.objectId;
        WatchListEntity *entity = [[WatchListEntity alloc]init];
        entity.setNumber = content.seriesNumber;

        detailVC.watchEntity = entity;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    else if ([content.businessType isEqualToString:@"livereplay"]){
        // 直播
        
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
        // detailVC.videoDatePoint = content.endWatchTime.floatValue;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
#pragma mark - 批量查询行为纪录
-(void)queryBehavior
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:@([self.userEntity.uid longLongValue]) forKey:@"uid"];

    [parameters setValue:@"1" forKey:@"pageNo"];
    [parameters setValue:@"100" forKey:@"pageSize"];
    [parameters setValue:@"MOBILE" forKey:@"deviceType"];
    
    __weak typeof(self) weakSelf = self;
    
   // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   // [MBProgressHUD showMessag:@"加载中" toView:self.view.window];

    [BaseAFHTTPManager getRequestOperationForHost:WXSEEN forParam:@"/integration/2.0/queryBehavior" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        NSDictionary *resultDic = (NSDictionary *)responseObject;

        if ([[resultDic objectForKey:@"code"] intValue] == 0) {
            NSArray *historyList =  [[responseObject objectForKey:@"history"]objectForKey:@"data"];
            NSMutableArray *historyAry = [NSMutableArray array];
            for (NSDictionary *dic in historyList) {
                [historyAry addObject:[[RecentVideo alloc]initWithDict:dic]];
            }
            self.historysArray  = historyAry;
            [self loadHistoryRecordScrView];
            
            
            NSArray *collectionList =  [[responseObject objectForKey:@"collection"]objectForKey:@"data"];
            NSMutableArray *collectionAry = [NSMutableArray array];
            for (NSDictionary *dic in collectionList) {
                [collectionAry addObject:[[RecentVideo alloc]initWithDict:dic]];
            }
            self.collectionArray  = collectionAry;
            [self loadCollectionRecordScrView];

        }
        if (self.collectionArray.count == 0) {
            self.zanwuCollectionLab.hidden = NO;
        }
        else{
            self.zanwuCollectionLab.hidden = YES;
        }
        if (self.historysArray.count == 0) {
            self.zanwuHisoryLab.hidden = NO;
        }
        else{
            self.zanwuHisoryLab.hidden = YES;
        }

    }failure:^(AFHTTPRequestOperation *operation,NSString *error) {
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        [weakSelf p_handleNetworkError];
    }];
}
//批量查询收藏
-(void)batchQueryCollection
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:self.userEntity.uid forKey:@"uid"];

    [parameters setValue:@"all" forKey:@"type"];
    
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BaseAFHTTPManager getRequestOperationForHost:[HiTVGlobals sharedInstance].getUic forParam:@"/integration/batchQueryCollection" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSMutableArray *array = [NSMutableArray array];
        NSArray *arr = (NSArray *)responseObject;
        if(arr.count > 0){
            for (NSDictionary * dic in responseObject) {
                NSDictionary * title_data = [dic objectForKey:@"title_data"];
                NSString *type = [title_data objectForKey:@"objecttype"];
                if ([type isEqualToString:@"watchtv"]) {
                    NSDictionary *titleData = [[title_data objectForKey:@"data"] JSONFragmentValue];
                    CollectionVideo *video = [[CollectionVideo alloc]initWatchtvWithDict:titleData];
                    [array addObject:video];
                }
                else{
                    CollectionVideo *video = [[CollectionVideo alloc]initWithDict:title_data];
                    [array addObject:video];
                }
                
            }
        }
            weakSelf.collectionArray = array;
        [self loadCollectionRecordScrView];
    }failure:^(AFHTTPRequestOperation *operation,NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf p_handleNetworkError];
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
        [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
        [parameters setValue:self.userEntity.uid forKey:@"friendUid"];
        
        __weak typeof(self) weakSelf = self;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [BaseAFHTTPManager postRequestOperationForHost:SOCIALHOST forParam:@"/taipan/delUserFriend" forParameters:parameters  completion:^(id responseObject) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            if ([[resultDic objectForKey:@"code"] intValue] == 0) {
                [OMGToast showWithText:@"删除好友成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [OMGToast showWithText:[resultDic objectForKey:@"message"]];
            }
        }failure:^(NSString *error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
        }];
    }
}
- (IBAction)unConcernFriend{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除好友吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];   
}
#pragma mark - ModifyremarksControllerDelegate
- (void)refreshFriendInfo:(NSNotification*)aNotification{
    NSString* nickname = [aNotification object];
    self.userEntity.nickName = nickname ;
    [self.tabView reloadData];
}

/*
 代码创建record视图（暂不用）
 */
-(UIView *)recordView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RECORDWIDTH, RECORDHEIGHT)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *videoLog = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, RECORDWIDTH-10, RECORDWIDTH-10)];
    videoLog.image = [UIImage imageNamed:@"图层-18 copy.png"];
    [view addSubview:videoLog];
    
    UILabel *videoName = [[UILabel alloc]initWithFrame:CGRectMake(10, RECORDWIDTH-10, 50, 30)];
    videoName.backgroundColor = [UIColor clearColor];
    videoName.font = [UIFont systemFontOfSize:12];
    videoName.textColor = [UIColor whiteColor];
    videoName.textAlignment = NSTextAlignmentCenter;
    videoName.text = @"许三多";
    [view addSubview:videoName];
    
    return view;
}
-(void )setOpenOrClose:(SwitchBtn *)sender{
    sender.isPressed = !sender.isPressed;
    if (sender.isPressed) {
        [self updateFriendAuthorityRequest:@"0"];
    }
    else{
        [self updateFriendAuthorityRequest:@"1"];
    }
}
//[NSNumber numberWithInt:1]
- (void)updateFriendAuthorityRequest:(NSString *)authorType{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:self.userEntity.uid forKey:@"friendUid"];
    [parameters setValue:authorType forKey:@"authorType"];
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BaseAFHTTPManager postRequestOperationForHost:SOCIALHOST forParam:@"/taipan/updateFriendAuthority" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"code"] intValue] == 0) {
        }
        [OMGToast showWithText:[resultDic objectForKey:@"message"]];
    }failure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
    }];
}
#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==3) {
        return 70;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"FriendInfoCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView = nil;
    
    NSInteger row = indexPath.row;
    if (row == 0) {
        cell.lab.text = @"手机号";
        cell.contentLab.text = self.userEntity.phoneNo;
        cell.moreImg.hidden = YES;
    }
    else if (row == 1) {
        cell.lab.text = @"昵  称";
        cell.contentLab.text = self.userEntity.name;
        cell.moreImg.hidden = YES;
    }
    else if (row == 2) {
        cell.lab.text = @"备  注";
//        if (self.userEntity.nickName.length==0) {
//            cell.contentLab.text = self.userEntity.name;
//        }
//        else{
            cell.contentLab.text = self.userEntity.nickName;
//        }
        cell.moreImg.hidden = NO;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

       /* if (!_modifyLab) {
            _modifyLab = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width-150, 0, 130, 44)];
            _modifyLab.text = self.userEntity.name;
            _modifyLab.backgroundColor = [UIColor clearColor];
            _modifyLab.font = [UIFont systemFontOfSize:14];
            _modifyLab.textColor = [UIColor lightGrayColor];
            [cell addSubview:_modifyLab];
            
        }*/
    }
    else if (row == 3) {
        cell.moreImg.hidden = YES;
        if (!_ysLab) {
            _ysLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 250, 30)];
            _ysLab.text = @"允许他看我的观看和收藏记录";
            _ysLab.backgroundColor = [UIColor clearColor];
            _ysLab.font = [UIFont systemFontOfSize:14];
            _ysLab.textColor = [UIColor blackColor];
            [cell addSubview:_ysLab];
            
            _contentLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 250, 15)];
            _contentLab.text = @"关闭后对方将无法看到你的观看和收藏记录";
            _contentLab.backgroundColor = [UIColor clearColor];
            _contentLab.font = [UIFont systemFontOfSize:10];
            _contentLab.textColor = [UIColor lightGrayColor];
            [cell addSubview:_contentLab];
            
            _switchBtn = [[SwitchBtn alloc]init];
            _switchBtn.frame = CGRectMake(W-60, 24, 40, 22);
            [_switchBtn addTarget:self action:@selector(setOpenOrClose:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:_switchBtn];
        }
        if ([self.userEntity.friendAuthorType intValue] == 0) {
            _switchBtn.isPressed = YES;
        }
        else{
            _switchBtn.isPressed = NO;
        }
    }
    
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {
        ModifyremarksController *modifyVC = [[ModifyremarksController alloc]init];
        modifyVC.m_delegate = self;
        modifyVC.userEntity = self.userEntity;
        [self.navigationController pushViewController:modifyVC animated:YES];
    }
   
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    CGPoint position = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
    
    [self.contentScrollView setContentOffset:position animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshFriendInfo
{}
@end

#pragma clang diagnostic pop
