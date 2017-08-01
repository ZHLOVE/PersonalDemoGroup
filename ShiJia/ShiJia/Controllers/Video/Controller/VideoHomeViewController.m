//
//  VideoHomeViewController.m
//  ShiJia
//
//  Created by 蒋海量 on 16/6/6.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "VideoHomeViewController.h"
#import "VideoCategoryHeader.h"
#import "VideoHomeCollectionViewCell.h"
#import "VideoDataProvider.h"
#import "VideoCategoryManager.h"
#import "VideoCategory.h"
#import "VideoTopCollectionView.h"
#import "BannersViewController.h"
#import "BannerViewController.h"
#import "MJRefresh.h"
#import "VideoSummary.h"
#import "SearchViewController.h"
#import "SJVideoDetailViewController.h"
#import "SJRemoteControlViewController.h"
#import "VideoCategoryDetailViewController.h"
#import "ChooseCategoryViewController.h"

@interface VideoHomeViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *videoArray;
@property (strong, nonatomic)  UIView *defaultView;

@end

@implementation VideoHomeViewController

//消息推送使用
-(void)push:(NSNotification *)sender
{
    //设置为有推送
    /*[HiTVGlobals sharedInstance].IsPush = YES;
     DetailViewController* detailVC = [[DetailViewController alloc] init];
     detailVC.videoID = [HiTVGlobals sharedInstance].epg_id;
     [self showController:detailVC];*/
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(p_showDetailController:)
     name:[HiTVConstants HiTVConstantsShowViewControllerNotificationName]
     object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushVideoDetailController:) name:kBannerViewControllerPushDetailNotification object:nil];
    
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(push:)
                                                 name:[HiTVConstants HiTVConstantsPlayFromPushNotificationName]
                                               object:nil];
    
    [self.collectionView registerNib:[UINib nibWithNibName:cVideoHomeCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:cVideoHomeCollectionViewCellID];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[[ UIImage imageNamed : @"搜索white" ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goSearchVC)];

    self.navigationItem.rightBarButtonItems = @[searchItem];
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self p_refresh];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
}

-(void)chooseView{

    ChooseCategoryViewController *chooseViewController = [[ChooseCategoryViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chooseViewController animated:YES];
     self.hidesBottomBarWhenPushed = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.hidesBottomBarWhenPushed = NO;
    self.navigationController.navigationBarHidden = NO;
    [AppDelegate appDelegate].appdelegateService.coinView.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)goSearchVC
{
    self.hidesBottomBarWhenPushed = YES;
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}


- (void)p_refresh{
    /*__weak __typeof__(self) weakSelf = self;
    
    [[VideoDataProvider sharedInstance] getCategories:1 pageNumber: 1
                                           completion:^(id responseObject) {
                                               [weakSelf p_reloadCollectionView];
                                               [weakSelf.collectionView.mj_header endRefreshing];
                                           } failure:^(NSString *error) {
                                               
                                               [weakSelf.collectionView.mj_header endRefreshing];
                                               [weakSelf p_handleNetworkError];
                                           }];*/
    __weak __typeof(self)weakSelf = self;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString* url = [NSString stringWithFormat:@"%@/epg/getCatgInfo.shtml?templateId=%@&abilityString=%@",FUSE_EPG, [HiTVGlobals sharedInstance].getEpg_groupId,T_STBext];
    
    
    [BaseAFHTTPManager getRequestOperationForHost:url forParam:@"" forParameters:nil completion:^(id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        
        NSMutableArray* resultCategories = [NSMutableArray array];

        NSArray *resultArray = (NSArray *)responseObject;
        for (NSDictionary *videoCategory in resultArray) {
            NSArray *channelIdList = [[HiTVGlobals sharedInstance].offline_COLUMN componentsSeparatedByString:NSLocalizedString(@",", nil)];
            NSString *catgId = [NSString stringWithFormat:@"%@",videoCategory[@"catgId"]];
            BOOL IsOffline = [channelIdList containsObject:catgId];
            
            if (!IsOffline) {
                VideoCategory *entity = [[VideoCategory alloc] initWithDictionary:videoCategory];
                if (entity.subCategoriesArray.count==0) {
                    NSMutableArray *arr = [NSMutableArray new];
                    VideoCategory *videoCategory = [VideoCategory new];
                    videoCategory.catgId = entity.catgId;
                    videoCategory.catgName = entity.catgName;
                    [arr addObject:videoCategory];
                    
                    entity.subCategoriesArray = arr;
                }
                [resultCategories addObject:entity];
            }
        }
        strongSelf.videoArray = resultCategories;
        [strongSelf.collectionView.mj_header endRefreshing];
        strongSelf.defaultView.hidden = YES;

    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.videoArray = nil;

        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        [strongSelf p_handleNetworkError];
        [strongSelf.collectionView.mj_header endRefreshing];
        strongSelf.defaultView.hidden = NO;

    }];
}

-(void)setVideoArray:(NSMutableArray *)videoArray{
    _videoArray = videoArray;
    [self p_reloadCollectionView];
}
- (void)p_reloadCollectionView{
    [self.collectionView reloadData];
    
   
}

- (void)p_internallyReload{
    [self.collectionView reloadData];
}

- (void)p_reloadCollectionViewForCategoryID:(NSString *)categoryID{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(p_internallyReload)
                                               object:nil];
    [self performSelector:@selector(p_internallyReload)
               withObject:nil
               afterDelay:0.15];
}
#pragma mark - private methods
- (void)p_showDetailController:(NSNotification*)notification{
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:notification.userInfo[[HiTVConstants HiTVConstantsShowViewControllerNotificationController]] animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - Notification
- (void)pushVideoDetailController:(NSNotification *)notification
{
    VideoSummary *video = notification.userInfo[kBannerViewControllerSelectedVideoKey];
    self.hidesBottomBarWhenPushed = YES;
    SJVideoDetailViewController *detailVC = [[SJVideoDetailViewController alloc] init];
    detailVC.videoID = video.videoID;
    //    detailVC.categoryID = self.videoCategory.cetegoryId;
    [self.navigationController pushViewController:detailVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {

    return  _videoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    VideoHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cVideoHomeCollectionViewCellID forIndexPath:indexPath];

    VideoCategory *categoryEntity = _videoArray[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",[categoryEntity.catgId intValue]]];
    if (!cell.imgView.image) {
        cell.imgView.image = [UIImage imageNamed:@"discoverdefault"];
    }
   
    cell.titleLab.text = categoryEntity.catgName;
    

    return cell;
}

#pragma mark - UICollectionViewDelegate (GODETAIL 点播首页)
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCategory* category = _videoArray[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    category.parentCatgId = category.catgId;
    [self.navigationController pushViewController:[[VideoCategoryDetailViewController alloc] initWithVideoCategory:category] animated:YES];
    self.hidesBottomBarWhenPushed = NO;
 }

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(W/3-10,W/3-10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    return CGSizeMake(W,10);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(0, 7, 12, 7);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0f;
}

-(UIView *)defaultView{
    if (!_defaultView) {
        
        _defaultView = [UIView new];
        _defaultView.userInteractionEnabled = YES;
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nonetwork"]];
        [_defaultView addSubview:imageV];
        
        
        UILabel *label =[UILabel new];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = 1;
        label.font = [UIFont systemFontOfSize:14];
        NSString *str = @"网络连接失败,点击重试";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,8)];
        [attr addAttribute:NSForegroundColorAttributeName value:kColorBlueTheme range:NSMakeRange(9,2)];
        label.attributedText = attr;
        label.userInteractionEnabled = YES;
        [_defaultView addSubview:label];
        
        UIButton *retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        retryBtn.backgroundColor = [UIColor clearColor];
        [retryBtn addTarget:self action:@selector(p_refresh) forControlEvents:UIControlEventTouchUpInside];
        [_defaultView addSubview:retryBtn];

        
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_defaultView);
            make.size.mas_equalTo(CGSizeMake(85, 85));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_defaultView);
            make.size.mas_equalTo(CGSizeMake(150, 50));
            make.top.mas_equalTo(imageV.mas_bottom).offset(10);
        }];
        
        [retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(label.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(40, 30));
            make.top.mas_equalTo(imageV.mas_bottom).offset(10);
        }];
        
        [self.view addSubview:_defaultView];
        [_defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(180, 180));
            make.top.mas_equalTo(self.view).offset(160);
        }];
    }
    
    return _defaultView;
}

@end
