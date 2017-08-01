//
//  VideoHomeCollectionViewController.m
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "VideoHomeCollectionViewController.h"
#import "VideoCategoryHeader.h"
#import "VideoCollectionViewCell.h"
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
#import "SJMultiVideoDetailViewController.h"

@interface VideoHomeCollectionViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong)BannersViewController* bannerController;

@end

@implementation VideoHomeCollectionViewController


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
    
    [self.collectionView registerNib:[UINib nibWithNibName:cVideoCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:cVideoCollectionViewCellID];
    [self.collectionView registerNib:[UINib nibWithNibName:cVideoTopCollectionViewID bundle:nil] forCellWithReuseIdentifier:cVideoTopCollectionViewID];
    [self.collectionView registerNib:[UINib nibWithNibName:cVideoCategoryHeaderID bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cVideoCategoryHeaderID];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[[ UIImage imageNamed : @"搜索white" ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goSearchVC)];
    self.navigationItem.rightBarButtonItem = searchItem;

    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self p_refresh];
    }];

    [self.collectionView.mj_header beginRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.hidesBottomBarWhenPushed = NO;
    self.navigationController.navigationBarHidden = NO;
    [AppDelegate appDelegate].appdelegateService.coinView.hidden = NO;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.bannerController.recommends == nil && ![self.collectionView.mj_header isRefreshing]) {
        [self.collectionView.mj_header beginRefreshing];
    }
}

-(void)goSearchVC
{
    self.hidesBottomBarWhenPushed = YES;
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (void)p_refresh{
    __weak __typeof__(self) weakSelf = self;
    
    [[VideoDataProvider sharedInstance] getTopRecommendlistWithCompletion:^(id responseObject) {
        weakSelf.bannerController.recommends = (NSArray*)responseObject;
        [[VideoDataProvider sharedInstance] getCategories:1 pageNumber: 1
                                               completion:^(id responseObject) {
                                                   [weakSelf p_reloadCollectionView];
                                                   [weakSelf.collectionView.mj_header endRefreshing];
                                               } failure:^(NSString *error) {
                                                   
                                                   [weakSelf.collectionView.mj_header endRefreshing];
                                                   [weakSelf p_handleNetworkError];
                                               }];
        
    } failure:^(NSString *error) {
        [[VideoDataProvider sharedInstance] getCategories:1 pageNumber: 1
                                               completion:^(id responseObject) {
                                                   [weakSelf p_reloadCollectionView];
                                                   [weakSelf.collectionView.mj_header endRefreshing];
                                               } failure:^(NSString *error) {
                                                   
                                                   [weakSelf.collectionView.mj_header endRefreshing];
                                                   [weakSelf p_handleNetworkError];
                                               }];
        
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf p_handleNetworkError];
    }];
}
- (BannersViewController*)bannerController{
    if (_bannerController == nil) {
        _bannerController = [[BannersViewController alloc] init];
        _bannerController.view.frame = CGRectMake(0, 0, W, BannerHeight);
    }
    return _bannerController;
}

- (void)p_getRecommendlistWithCategory:(VideoCategory*) category{
    if (category.recommandedVideosArray.count == 0 && category.shouldRetryGetRecommandedList) {
        __weak typeof(self) weakSelf = self;
        __weak typeof(category) weakCategory = category;
        [[VideoDataProvider sharedInstance] getRecommendlistWithCategoryID:category.cetegoryId completion:^(id responseObject) {
            weakCategory.recommandedVideosArray = responseObject;
            if (weakCategory.recommandedVideosArray.count == 0) {
                weakCategory.shouldRetryGetRecommandedList = YES;
            }

            [weakSelf p_reloadCollectionViewForCategoryID:weakCategory.cetegoryId];
        } failure:^(NSString *error) {
            [weakSelf p_handleNetworkError];
            weakCategory.shouldRetryGetRecommandedList = YES;
        }];

    }
}

- (void)p_reloadCollectionView{
    [self.collectionView reloadData];

    for (int index = 0; index < [VideoCategoryManager sharedInstance].categories.count; index ++) {
        VideoCategory* category = [VideoCategoryManager sharedInstance].categories[index];
        if (category.recommandedVideosArray.count == 0) {
            [self p_getRecommendlistWithCategory:category];
        }
    }
    
    if ([VideoCategoryManager sharedInstance].hasNextPage) {
        if (self.collectionView.mj_footer == nil) {
            __weak typeof(self) weakSelf = self;
            self.collectionView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{

                [[VideoDataProvider sharedInstance] getCategories:0 pageNumber:[VideoCategoryManager sharedInstance].pageNumber + 1
                                                           completion:^(id responseObject) {
                                                               [self.collectionView.mj_footer endRefreshing];
                                                               [weakSelf p_reloadCollectionView];
                                                           } failure:^(NSString *error) {

                                                               [self.collectionView.mj_footer endRefreshing];
                                                               [weakSelf p_handleNetworkError];
                                                           }];
            }];
        }
    }else {
    }
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
    
    SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
    detailVC.videoID = video.videoID;
    //    detailVC.categoryID = self.videoCategory.cetegoryId;
    [self.navigationController pushViewController:detailVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section <= [VideoCategoryManager sharedInstance].categories.count) {
        VideoCategory* category = [VideoCategoryManager sharedInstance].categories[section - 1];
        //[self p_getRecommendlistWithCategory:category];
        return category.recommandedVideosArray.count;
    }
    return  0;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return [[VideoCategoryManager sharedInstance].categories count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        VideoTopCollectionView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cVideoTopCollectionViewID forIndexPath:indexPath];
        cell.frame = CGRectMake(0, 0, W, BannerHeight);
        UIView* bannerView = [cell.contentView viewWithTag:100];
        if (bannerView == nil) {
            self.bannerController.view.tag = 100;
            [cell.contentView addSubview:self.bannerController.view];
        }
        return cell;
    }

    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cVideoCollectionViewCellID forIndexPath:indexPath];
    VideoCategory* category = [VideoCategoryManager sharedInstance].categories[indexPath.section - 1];
    cell.video = category.recommandedVideosArray[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return nil;
    }
    
    VideoCategoryHeader* header = (VideoCategoryHeader*)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:cVideoCategoryHeaderID forIndexPath:indexPath];
    header.videoCategory = [VideoCategoryManager sharedInstance].categories[indexPath.section - 1];
    return header;
}

#pragma mark - UICollectionViewDelegate (GODETAIL 点播首页)
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCategory* category = [VideoCategoryManager sharedInstance].categories[indexPath.section - 1];
    VideoSummary* video = category.recommandedVideosArray[indexPath.row];

    if (video.action != nil && video.actionUrl != nil) {
        
        
       // [self showMoiveDetailOrList:video.action withActionURL:video.actionUrl];
    }
   // [self showMoiveDetailOrList:video.action withVideoID:video.videoID];
    
    self.hidesBottomBarWhenPushed = YES;
    SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
    detailVC.videoID = video.videoID;
    detailVC.categoryID = category.cetegoryId;
    [self.navigationController pushViewController:detailVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(W, BannerHeight);
    }
    return CGSizeMake(W/3-10,180);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(W,32);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 12, 0);
    }
    return UIEdgeInsetsMake(0, 7, 12, 7);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0f;
}
@end
