//
//  SJLocalVideoViewController.m
//  ShiJia
//
//  Created by 峰 on 16/8/11.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJLocalVideoViewController.h"
#import "SJLocalVedioViewModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SJLocalVedioCell.h"
#import "SJMediaScrollViewController.h"

@interface SJLocalVideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray        *assetsData;
@property (nonatomic, strong) SJLocalVedioViewModel *viewModel;
@property (nonatomic, assign) NSInteger             currentIndex;
@property (nonatomic, strong) NSURL                 *vedioUrl;
@property (nonatomic, strong) UICollectionView *vedioCollectionView;
@property (nonatomic, strong) UIView *noDataView;


@end

@implementation SJLocalVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kColorLightGrayBackground;
    [self.view addSubview:self.vedioCollectionView];
    [self bindSJLocalVedioViewModel];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)bindSJLocalVedioViewModel{
    __weak __typeof(self)weakSelf = self;
    _viewModel = [SJLocalVedioViewModel new];
    
    [_viewModel loadLocalVediosFiles];
    
    [_viewModel.dataSourceSubject subscribeNext:^(NSMutableArray *x) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.assetsData = [NSMutableArray arrayWithArray:[x copy]];
        //        [self.videoTableView reloadData];
        if (strongSelf.assetsData.count==0) {
             [strongSelf.view addSubview:strongSelf.noDataView];
            [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(133, 112));
                make.centerX.mas_equalTo(strongSelf.view);
                make.top.mas_equalTo(strongSelf.view).offset(100);
            }];
        }else{
            [_noDataView removeFromSuperview];
           [strongSelf.vedioCollectionView reloadData];
        }
        
    } error:^(NSError *error) {
        [MBProgressHUD showError:[error localizedDescription] toView:self.view];
    }];
}


-(NSMutableArray *)assetsData{
    if (!_assetsData) {
        _assetsData  = [NSMutableArray new];
    }
    return _assetsData;
}
-(UICollectionView *)vedioCollectionView{
    if (!_vedioCollectionView) {
        CGFloat spacing = 1.0;
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize                     = CGSizeMake((SCREEN_WIDTH-3)/3,(SCREEN_WIDTH-3)/3);
        layout.minimumInteritemSpacing      = spacing;
        layout.minimumLineSpacing           = spacing;
        CGRect rect = self.view.bounds;
        _vedioCollectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _vedioCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _vedioCollectionView.dataSource = self;
        _vedioCollectionView.delegate = self;
        _vedioCollectionView.backgroundColor = kColorLightGrayBackground;
        [_vedioCollectionView setAllowsSelection:YES];
        [_vedioCollectionView registerClass:[SJLocalVedioCell class] forCellWithReuseIdentifier:@"SJLocalVedioCell"];
    }
    return _vedioCollectionView;
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.assetsData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SJLocalVedioCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SJLocalVedioCell" forIndexPath:indexPath];
    ALAsset *model = [_assetsData objectAtIndex:indexPath.row];
    [cell setCellValueWithModel:model];
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    SJMediaScrollViewController *scrollView = [[SJMediaScrollViewController alloc]init];
    scrollView.album_type = 1;
    [self.superNavgation pushViewController:scrollView animated:YES];
    [scrollView setLocalSourceArray:_assetsData];
    [scrollView setCurrentIndex:indexPath.row];
    
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
