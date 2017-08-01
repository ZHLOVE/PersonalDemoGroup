//
//  VideoCategoryDetailCollectionViewController.m
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "VideoCategoryDetailCollectionViewController.h"
#import "VideoCollectionViewCell.h"
#import "VideoDataProvider.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"

#import "SJVideoDetailViewController.h"
#import "SJMultiVideoDetailViewController.h"
#import "WatchListEntity.h"

@interface VideoCategoryDetailCollectionViewController ()<UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray* videosArray;
@property (strong, nonatomic) NSArray* temp;
@property (strong, nonatomic) VideoCategory* videoCategory;
@property (nonatomic) BOOL hasMore;
@property (nonatomic) BOOL loading;
@property (nonatomic) int nextPageNumber;
@property (strong, nonatomic) UINavigationController* nav;

@end

@implementation VideoCategoryDetailCollectionViewController



- (instancetype)initWithVideoCategory:(VideoCategory*)videoCategory{
    if (self = [super init]) {
        self.videoCategory = videoCategory;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.delegate = self;
    self.nav = self.navigationController;
    DDLogInfo(@"VideoCategoryDetailCollectionViewController : vewDidLoad");
    
    [self.collectionView registerNib:[UINib nibWithNibName:cVideoCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:cVideoCollectionViewCellID];
    self.collectionView.alwaysBounceVertical = YES;
    
    self.title = self.videoCategory.name;
        
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self p_refresh];
    }];
    
    // 上拉加载更多
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self p_loadMore];
    }];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    // 忽略掉底部inset
    self.collectionView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.clipsToBounds = NO;
    self.collectionView.clipsToBounds = NO;
    [self p_refresh];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)setHasMore:(BOOL)hasMore{
    _hasMore = hasMore;
}

#pragma mark - private methods

- (void)p_reloadData{
    [self.collectionView reloadData];
}

- (void)p_loadMore{
    __weak __typeof(self)weakSelf = self;
    if (self.nextPageNumber == 1) {
        [self.collectionView.mj_header beginRefreshing];
    }else{
        [self.collectionView.mj_footer endRefreshing];
        
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString* url = [NSString stringWithFormat:@"%@/epg/getPsList.shtml?templateId=%@&catgId=%@&pageNo=%d&pageSize=30&abilityString=%@",FUSE_EPG, [HiTVGlobals sharedInstance].getEpg_groupId,self.videoCategory.catgId, self.nextPageNumber,T_STBext];
    
    
    [BaseAFHTTPManager getRequestOperationForHost:url forParam:@"" forParameters:nil completion:^(id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        
        NSArray* categories = responseObject[@"programSeries"];
        int currentPageNumber = [[(NSDictionary *)responseObject objectForKey:@"pageNo"] intValue];
        
        if (strongSelf.nextPageNumber == 1) {
            [strongSelf.collectionView.mj_header endRefreshing];
            strongSelf.videoCategory.videos = [[NSMutableArray alloc] init];
        }else{
            [strongSelf.collectionView.mj_footer endRefreshing];
        }
        if (categories.count>0) {
            [strongSelf.videoCategory.videos addObjectsFromArray:[strongSelf p_parseVideos:categories]];
            
            strongSelf.hasMore = YES;
            strongSelf.nextPageNumber = currentPageNumber + 1;
            [strongSelf p_reloadData];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        if (strongSelf.nextPageNumber == 1) {
            [strongSelf.collectionView.mj_header endRefreshing];
        }else{
            
            [strongSelf.collectionView.mj_footer endRefreshing];
        }
        [strongSelf p_handleNetworkError];
    }];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.videoCategory.videos.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cVideoCollectionViewCellID forIndexPath:indexPath];
    cell.video = self.videoCategory.videos[indexPath.row];
    return cell;
}


#pragma mark - UICollectionViewDelegate (GODETAIL 点播二级菜单)

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoSummary* video = self.videoCategory.videos[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
   
    /*if ([video.contentType isEqualToString:@"newWatchTv"]){
        SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeReplay];
        WatchListEntity *entity = [[WatchListEntity alloc]init];
        entity.programSeriesId = video.psId;
        entity.channelLogo = video.channelLogo;
        entity.contentType = video.contentType;
        detailVC.watchEntity = entity;
        if (!self.navigationController) {
            [self.nav pushViewController:detailVC animated:YES];
        }
        else{
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    else{*/
        SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
        detailVC.videoID = video.psId;
        detailVC.categoryID = self.videoCategory.catgId;
        WatchListEntity *entity = [[WatchListEntity alloc]init];
        entity.contentType = video.contentType;
        detailVC.watchEntity = entity;
        if (!self.navigationController) {
            [self.nav pushViewController:detailVC animated:YES];
        }
        else{
            [self.navigationController pushViewController:detailVC animated:YES];
        }
   // }
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(W/3-10,200);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0,12);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(7, 7, 7, 7);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2.0f;
}



- (void)p_refresh{
    __weak __typeof(self)weakSelf = self;
    self.loading = YES;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString* url = [NSString stringWithFormat:@"%@/epg/getPsList.shtml?templateId=%@&catgId=%@&pageNo=%d&pageSize=30&abilityString=%@",FUSE_EPG, [HiTVGlobals sharedInstance].getEpg_groupId,self.videoCategory.catgId, 1,T_STBext];
    
    
    [BaseAFHTTPManager getRequestOperationForHost:url forParam:@"" forParameters:nil completion:^(id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        
        NSArray* categories = responseObject[@"programSeries"];
        int currentPageNumber = [[(NSDictionary *)responseObject objectForKey:@"pageNo"] intValue];
    
        strongSelf.videoCategory.videos = [NSMutableArray arrayWithArray:[strongSelf p_parseVideos:categories]];
        strongSelf.hasMore = YES;
        strongSelf.nextPageNumber = currentPageNumber + 1;
        [strongSelf p_reloadData];
        strongSelf.loading = NO;
        [strongSelf.collectionView.mj_header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        [strongSelf p_handleNetworkError];
        strongSelf.loading = NO;
        [strongSelf.collectionView.mj_header endRefreshing];
    }];

}

- (NSArray*)p_parseVideos:(id)responseObject{
    NSMutableArray* returnMenus = [[NSMutableArray alloc] init];
    if ([responseObject isKindOfClass:[NSArray class]]) {
        for (NSDictionary* aMenu in responseObject) {
            [returnMenus addObject:[[VideoSummary alloc] initWithDict:aMenu]];
        }
    }else{
       // [returnMenus addObject:[[VideoSummary alloc] initWithDict:(NSDictionary*)responseObject]];
    }
    return returnMenus;
}

@end
