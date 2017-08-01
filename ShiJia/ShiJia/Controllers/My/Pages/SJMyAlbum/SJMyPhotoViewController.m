//
//  SJMyPhotoViewController.m
//  ShiJia
//
//  Created by 峰 on 16/8/30.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJMyPhotoViewController.h"
#import "SJPhotoHelpViewController.h"
#import "SJMyPhotoCollectionCell.h"
#import "SJPhotoListViewController.h"
#import "SJMyPhotoViewModel.h"
#import "SJCloudPhotoViewController.h"
#import "MBProgressHUD+AddHUD.h"
#import "MBProgressHUD.h"
#import "TogetherManager.h"

@interface SJMyPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView    *photoALAssetView;
@property (nonatomic, strong) NSMutableArray      *alasestArray;
@property (nonatomic, strong) SJMyPhotoViewModel  *ViewModel;
@property (nonatomic, strong) SJAlbumRequestModel *requestModel;
@property (nonatomic, strong) NSMutableArray      *devicesIDArray;
@property (nonatomic, strong) NSString            *TVIdString;

@end

@implementation SJMyPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.title = @"我的相册";
    [self initNavgationRightItem];
    [self.view addSubview:self.photoALAssetView];

    _alasestArray = self.alasestArray;

    [_photoALAssetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.ViewModel =[[SJMyPhotoViewModel alloc]init];
    [self bindViewModel];
}
#pragma mark 获取关联设备的ID 数组
-(NSMutableArray *)devicesIDArray{
    if (!_devicesIDArray) {
        _devicesIDArray = [NSMutableArray new];
        for ( HiTVDeviceInfo *entity in [TogetherManager sharedInstance].detectedDevices) {
            [self.devicesIDArray addObject:entity.ownerUserId];
        }
    }
    return _devicesIDArray;
}
#pragma mark 构造云相册请求参数
-(SJAlbumRequestModel *)requestModel{
    _requestModel = [[SJAlbumRequestModel alloc]init];
    _requestModel.uid = [self.devicesIDArray componentsJoinedByString:@","];
    _requestModel.caller = @"APP";
    return _requestModel;
}
#pragma mark 绑定ViewModel
-(void)bindViewModel{
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[_ViewModel getUserCloudSingle:[CHANNELID isEqualToString:taipanTest63]?nil:self.requestModel] subscribeNext:^(id x) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        [_alasestArray addObjectsFromArray:[x mutableCopy]];
        [strongSelf.photoALAssetView reloadData];
    } error:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];

    } completed:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
    }];
}

-(NSMutableArray *)alasestArray{
    if (!_alasestArray) {
        _alasestArray = [NSMutableArray new];
    }
    return _alasestArray;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
#pragma mark Collection View DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _alasestArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    SJMyPhotoCollectionCell *cell = (SJMyPhotoCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    [cell setCellWithDict:_alasestArray[indexPath.row]];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    CloudAlbumModel *currentModel = _alasestArray[indexPath.row];
    if (currentModel.albumType ==1) {
        SJPhotoListViewController *photoListVC = [[SJPhotoListViewController alloc]init];
        [self.navigationController pushViewController:photoListVC animated:YES];
    }else{
        SJCloudPhotoViewController *cloudVC = [[SJCloudPhotoViewController alloc]init];

        if ([currentModel.name containsString:@"用户已退圈"]) {
            cloudVC.cloudAlbumName = [NSString stringWithFormat:@"%@家的相册",currentModel.uid];
        }else{
            cloudVC.cloudAlbumName = currentModel.name;
        }
        cloudVC.AlbumModel =currentModel;
        [self.navigationController pushViewController:cloudVC animated:YES];

    }
}

#pragma mark 帮助界面
- (void)goHelpVC {
    SJPhotoHelpViewController *helpVC = [[SJPhotoHelpViewController alloc]init];
    [self.navigationController pushViewController:helpVC animated:YES];
}

#pragma mark UI Part
/**
 *  导航栏 右边按钮
 */
-(void)initNavgationRightItem{

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 60, 23)];
    [button setTitle:@"帮助" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button addTarget:self
               action:@selector(goHelpVC)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:kNavTitleColor forState:UIControlStateNormal];
    button.contentHorizontalAlignment = 2;
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

-(UICollectionView *)photoALAssetView{
    if (!_photoALAssetView) {

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize =CGSizeMake(SCREEN_WIDTH/2-20, SCREEN_WIDTH/2);
        _photoALAssetView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _photoALAssetView.backgroundColor = [UIColor clearColor];
        _photoALAssetView.delegate = self;
        _photoALAssetView.dataSource = self;
        [_photoALAssetView registerClass:[SJMyPhotoCollectionCell class] forCellWithReuseIdentifier:@"cellId"];
        
    }
    return _photoALAssetView;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [self.alasestArray removeAllObjects];
}
@end
