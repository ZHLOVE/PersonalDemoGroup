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




@interface SJMyPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView   *photoALAssetView;
@property (nonatomic, strong) NSMutableArray     *alasestArray;
@property (nonatomic, strong) SJMyPhotoViewModel *ViewModel;

@end

@implementation SJMyPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.title = @"我的相册";
    
    [self bindViewModel];
}
-(void)bindViewModel{
    @weakify(self)
    self.ViewModel =[[SJMyPhotoViewModel alloc]init];
    [_ViewModel getGroup];

    [self.ViewModel.photoModelSubject subscribeNext:^(id x) {
        @strongify(self)
        NSDictionary *dict = (NSDictionary *)x;
        [self.alasestArray addObject:dict];
        [self.photoALAssetView reloadData];
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
    [self initNavgationRightItem];
    
    [self.view addSubview:self.photoALAssetView];
    [_photoALAssetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark Data



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.alasestArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SJMyPhotoCollectionCell *cell = (SJMyPhotoCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    [cell setCellWithDict:self.alasestArray[indexPath.row]];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *dict = self.alasestArray[indexPath.row];
    if ([dict objectForKey:@"photoType"]==0) {
        SJPhotoListViewController *photoListVC = [[SJPhotoListViewController alloc]init];
        [self.navigationController pushViewController:photoListVC animated:YES];
    }else{
    
    
    }

}




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
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = 2;
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)goHelpVC {
    SJPhotoHelpViewController *helpVC = [[SJPhotoHelpViewController alloc]init];
    [self.navigationController pushViewController:helpVC animated:YES];
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



@end
