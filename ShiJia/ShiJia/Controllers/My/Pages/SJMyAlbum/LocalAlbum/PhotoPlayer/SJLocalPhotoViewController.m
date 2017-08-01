//
//  SJLocalPhotoViewController.m
//  ShiJia
//
//  Created by 峰 on 16/7/21.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//



#import "SJLocalPhotoViewController.h"
#import "SJLocalPhotoViewModel.h"
#import "SPPhotoCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD+AddHUD.h"
#import "UIImage+Orientation.h"
#import "TogetherManager.h"
#import "SJMediaScrollViewController.h"

@interface SJLocalPhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView      *photoCollectionView;
@property (nonatomic, strong) SJLocalPhotoViewModel *localPhotoViewModel;
@property (nonatomic, assign) NSInteger             currentIndex;
@property (nonatomic, strong) NSMutableArray        *dataArray;
@property (nonatomic, strong) UIView *noDataView;

@end


@implementation SJLocalPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.photoCollectionView];
    [self bindLocalPhotoViewModel];
}

-(void)bindLocalPhotoViewModel{
    __weak __typeof(self)weakSelf = self;
    _localPhotoViewModel = [SJLocalPhotoViewModel new];

    //获取相片资源
    [_localPhotoViewModel loadLocalPhotoFiles];

    [_localPhotoViewModel.dataSourceSubject subscribeNext:^(NSMutableArray *x) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.dataArray = [NSMutableArray arrayWithArray:[x copy]];

        if (strongSelf.dataArray.count==0) {
            [strongSelf.view addSubview:strongSelf.noDataView];
            [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(133, 112));
                make.centerX.mas_equalTo(strongSelf.view);
                make.top.mas_equalTo(strongSelf.view).offset(100);
            }];
        }else{
            [_noDataView removeFromSuperview];
            [strongSelf.photoCollectionView reloadData];
        }



    } error:^(NSError *error) {
        [MBProgressHUD showError:[error localizedDescription] toView:self.view];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark data

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    SPPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SPPhotoCollectionViewCell" forIndexPath:indexPath];
    ALAsset *asset =[self.dataArray objectAtIndex:indexPath.row];
    cell.imageView.image =  [UIImage imageWithCGImage:asset.thumbnail];
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    SJMediaScrollViewController *scrollView = [[SJMediaScrollViewController alloc]init];
    [scrollView setAlbum_type:1];
    [self.superNavgation pushViewController:scrollView animated:YES];
    [scrollView setLocalSourceArray:self.dataArray];
    [scrollView setCurrentIndex:indexPath.row];
}

-(UICollectionView *)photoCollectionView{
    if (!_photoCollectionView) {
        CGFloat spacing = 1.0;
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize                     = CGSizeMake((SCREEN_WIDTH-3)/3,(SCREEN_WIDTH-3)/3);
        layout.minimumInteritemSpacing      = spacing;
        layout.minimumLineSpacing           = spacing;
        CGRect rect = self.view.frame;

        _photoCollectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _photoCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _photoCollectionView.dataSource = self;
        _photoCollectionView.delegate = self;
        _photoCollectionView.backgroundColor = kColorLightGrayBackground;
        [_photoCollectionView setAllowsSelection:YES];
        [_photoCollectionView registerClass:[SPPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"SPPhotoCollectionViewCell"];
    }
    return _photoCollectionView;
}

-(UIView *)noDataView{
    if (!_noDataView) {
        _noDataView = [UIView new];
        UIImageView *image = [UIImageView new];
        image.image = [UIImage imageNamed:@"nophotos"];
        [_noDataView addSubview:image];

        UILabel *label = [UILabel new];
        label.text = @"未找到任何内容";
        label.textAlignment = 1;
        label.textColor = RGB(154, 154, 154, 1);
        label.font = [UIFont systemFontOfSize:19.];
        [_noDataView addSubview:label];

        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_noDataView);
            make.height.mas_equalTo(65);
            make.width.mas_equalTo(74);
            make.centerX.mas_equalTo(_noDataView);
        }];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_noDataView);
            make.height.mas_equalTo(26);
        }];


    }
    return _noDataView;
}
@end
