//
//  SJSetFavoriteViewController.m
//  ShiJia
//
//  Created by yy on 16/6/14.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJSetFavoriteViewController.h"

#import "AppDelegate.h"

#import "SJSetFavoriteCell.h"
#import "WatchListEntity.h"

@interface SJSetFavoriteViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionview;
@property (nonatomic, weak) IBOutlet UIButton *bottomButton;
@property (nonatomic, weak) IBOutlet UILabel *infoLabel;

@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSMutableArray *programIdList;

@end

@implementation SJSetFavoriteViewController

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
    
        _list = [[NSMutableArray alloc] init];
        _programIdList = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = kColorLightGrayBackground;
    
    // register nib
    [_collectionview registerNib:[UINib nibWithNibName:kSJSetFavoriteCellIdentifier bundle:nil] forCellWithReuseIdentifier:kSJSetFavoriteCellIdentifier];
    _infoLabel.adjustsFontSizeToFitWidth = YES;
    
    // 下载我的看单
    if ([HiTVGlobals sharedInstance].anonymousUid) {
        [self loadWatchListRequest];
    }
    else{
        [[HiTVGlobals sharedInstance] addObserver:self forKeyPath:NSStringFromSelector(@selector(anonymousUid)) options:NSKeyValueObservingOptionNew context:nil];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppDelegate appDelegate].appdelegateService.coinView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    DDLogInfo(@"%zd",_list.count);
    return _list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SJSetFavoriteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSJSetFavoriteCellIdentifier forIndexPath:indexPath];
    WatchListEntity *data = _list[indexPath.row];
    [cell showData:data];
    
    if ([_programIdList containsObject:data.programSeriesId]) {
        cell.checked = YES;
    }
    else{
        cell.checked = NO;
    }
    
    [cell setCheckButtonClickBlock:^(SJSetFavoriteCell *sender) {
        sender.checked = !sender.checked;
        NSIndexPath *senderIndexPath = [collectionView indexPathForCell:sender];
        WatchListEntity *entity = _list[senderIndexPath.row];
        [self handleSelectEvent:entity selected:sender.checked];
        
    }];
    
//    [RACObserve(cell, checked) subscribeNext:^(NSNumber *x) {
//        
//        WatchListEntity *data = _list[indexPath.row];
//        
//        if (x.integerValue == 1) {
//            
//            if (![_programIdList containsObject:data.programSeriesId]) {
//                [_programIdList addObject:data.programSeriesId];
//            }
//            
//            if (_programIdList.count > 0 && !_bottomButton.enabled) {
//                _bottomButton.enabled = YES;
//                [_bottomButton setBackgroundColor:kColorBlueTheme];
//                [_bottomButton setTitle:@"确 定" forState:UIControlStateNormal];
//            }
//        }
//        else{
//            
//            if ([_programIdList containsObject:data.programSeriesId]) {
//                [_programIdList removeObject:data.programSeriesId];
//            }
//            
//            if (_programIdList.count == 0) {
//                _bottomButton.enabled = NO;
//                [_bottomButton setBackgroundColor:[UIColor darkGrayColor]];
//                [_bottomButton setTitle:@"请选择" forState:UIControlStateNormal];
//            }
//
//        }
//    }];

    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SJSetFavoriteCell *cell = (SJSetFavoriteCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.checked = !cell.checked;
    WatchListEntity *data = _list[indexPath.row];
    [self handleSelectEvent:data selected:cell.checked];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (collectionView.frame.size.width - 10 * 3) / 2.0;
    return CGSizeMake(width, 150);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)collectionView:(UICollectionView * )collectionView
                   layout:(UICollectionViewLayout * )collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

#pragma mark - Data
- (void)handleSelectEvent:(WatchListEntity *)data selected:(BOOL)selected
{
    if (selected) {
        
        if (![_programIdList containsObject:data.programSeriesId]) {
            [_programIdList addObject:data.programSeriesId];
        }
        
        if (_programIdList.count > 0 && !_bottomButton.enabled) {
            _bottomButton.enabled = YES;
            [_bottomButton setBackgroundColor:kColorBlueTheme];
            [_bottomButton setTitle:@"确 定" forState:UIControlStateNormal];
        }
    }
    else{
        
        if ([_programIdList containsObject:data.programSeriesId]) {
            [_programIdList removeObject:data.programSeriesId];
        }
        
        if (_programIdList.count == 0) {
            _bottomButton.enabled = NO;
            [_bottomButton setBackgroundColor:[UIColor darkGrayColor]];
            [_bottomButton setTitle:@"请选择" forState:UIControlStateNormal];
        }
        
    }
}

#pragma mark -  Request
- (void)loadWatchListRequest
{
    
    __weak __typeof(self)weakSelf = self;
    
    NSString *uid = [HiTVGlobals sharedInstance].uid;
    if ([uid isKindOfClass:[NSNumber class]]) {
        
        if (uid.integerValue == 0) {
            uid = [HiTVGlobals sharedInstance].anonymousUid;
        }
        
    }
    else{
        if ([uid isKindOfClass:[NSString class]] && uid.length == 0) {
            uid = [HiTVGlobals sharedInstance].anonymousUid;
        }
    }
    NSString* url = [NSString stringWithFormat:@"%@/personal/getDefalutList",
                     MYEPG];
    /*1,
    NSDictionary *param = @{
                            @"userId" : uid,
                            @"tvTemplateId" : WATCHTVGROUPID,
                            @"vodTemplateId" : [[HiTVGlobals sharedInstance]getEpg_groupId],
                            @"limitNum" : @"0",
                            };*/

    [MBProgressHUD showMessag:nil toView:self.view];
    [BaseAFHTTPManager getRequestOperationForHost:url forParam:@"" forParameters:nil completion:^(id responseObject) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        if (!strongSelf) {
            return;
        }
        
        NSMutableArray *resultArray = [NSMutableArray array];
        NSArray *array = responseObject[@"resultList"];
        if (array.count == 0) {
            array = responseObject[@"defaultList"];
        }
        for (NSDictionary *dic in array) {
            WatchListEntity* entity = [[WatchListEntity alloc]initWithDictionary:dic];
            //if ([entity.categoryId intValue]!=5824) {
            [resultArray addObject:entity];
            //}
        }
        strongSelf.list = [NSMutableArray arrayWithArray:resultArray];
        _bottomButton.hidden = NO;
        _bottomButton.enabled = NO;
        [_bottomButton setBackgroundColor:[UIColor darkGrayColor]];
        [_bottomButton setTitle:@"请选择" forState:UIControlStateNormal];
        [strongSelf.collectionview reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
         [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        [strongSelf p_handleNetworkError];
    }];
    
    
}

#pragma mark - Event
- (IBAction)bottomButtonClicked:(id)sender
{
    
    NSString *programIds = [_programIdList componentsJoinedByString:@"|"];
    
    [MBProgressHUD showMessag:nil toView:self.view];
    [BaseAFHTTPManager postRequestOperationForHost:MYEPG forParam:@"/personal/addUserInterested" forParameters:@{@"userId":[HiTVGlobals sharedInstance].uid,@"programSeriesId":programIds} completion:^(id responseObject) {
        
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        
        if (responseObject == nil) {
            return;
        }
        
        NSString *code = responseObject[@"code"];
        
        
        if (code.integerValue == 0) {
            [AppDelegate appDelegate].appdelegateService.SetF = YES;
            if ([AppDelegate appDelegate].appdelegateService.hasMainVC) {
                [self dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_UserInterested object:nil];
            }
            else{
                [[AppDelegate appDelegate].appdelegateService showMainViewController];
            }
        }
        
    } failure:^(NSString *error) {
        
       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];    
    
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(anonymousUid))]) {
        [self loadWatchListRequest];
    }
}

@end
