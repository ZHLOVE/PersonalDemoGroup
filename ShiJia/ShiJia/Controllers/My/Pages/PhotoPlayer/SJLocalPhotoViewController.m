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
#import "SJMediaPlayViewController.h"

@interface SJLocalPhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

//@property (nonatomic, strong) UIView                *photoView;
//@property (nonatomic, strong) UIImageView           *photoImageV;
@property (nonatomic, strong) UICollectionView      *photoCollectionView;
//@property (nonatomic, strong) UIButton              *screenButton;
@property (nonatomic, strong) SJLocalPhotoViewModel *localPhotoViewModel;

@property (nonatomic, assign) NSInteger             currentIndex;
@property (nonatomic, strong) NSMutableArray        *dataArray;

@end


@implementation SJLocalPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图片投屏";
    
//    [self.view addSubview:self.photoView];
    [self.view addSubview:self.photoCollectionView];
//    [self.view addSubview:self.screenButton];
//    [self SJLocalAddSubViewsConstraints];
    
    [self bindLocalPhotoViewModel];
}

-(void)bindLocalPhotoViewModel{
    @weakify(self)
    _localPhotoViewModel = [SJLocalPhotoViewModel new];
    
    //获取相片资源
    [_localPhotoViewModel loadLocalPhotoFiles];
    
    [_localPhotoViewModel.dataSourceSubject subscribeNext:^(NSMutableArray *x) {
        @strongify(self)
        self.dataArray = [NSMutableArray arrayWithArray:[x copy]];
        [self.photoCollectionView reloadData];
    } error:^(NSError *error) {
        [MBProgressHUD showError:[error localizedDescription] toView:self.view];
    }];
    
    //投屏事件
//    [[self.screenButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self)
//        
//        if (![HiTVGlobals sharedInstance].isLogin) {
//            [MBProgressHUD showError:@"请先登录" toView:self.view];
//            return;
//        }
//        if (![TogetherManager sharedInstance].connectedDevice) {
//            [MBProgressHUD show:@"亲，没有关联设备，请添加" icon:nil view:nil];
//            return;
//        }
//        else if (self.currentIndex==0) {
//            [MBProgressHUD showError:@"选择投屏照片" toView:self.view];
//            return;
//        }else{
//            
//            [MBProgressHUD showMessag:@"正在上传" toView:self.view];
//            
//            [[self.localPhotoViewModel screenCurrentPhotoToTV:(_currentIndex-1)]subscribeNext:^(id x) {
//                
//                
//            } error:^(NSError *error) {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                [MBProgressHUD showError:[error localizedDescription] toView:self.view];
//                
//            } completed:^{
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//               // [MBProgressHUD showSuccess:@"投屏成功" toView:self.view];
//            }];
//        }
//        
//    }];
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
    
//    _currentIndex = indexPath.row+1;
//    [self showCurrentPhotoImage:indexPath.row];SJMediaPlayViewController
    SJMediaPlayViewController *mediaShowVC = [[SJMediaPlayViewController alloc]init];
    mediaShowVC.media_type = 0;
    [self.superNavgation pushViewController:mediaShowVC animated:YES];
    
}

-(void)showCurrentPhotoImage:(NSInteger)index{
    ALAsset *asset = self.dataArray[index];
    CGImageRef imageRef = asset.defaultRepresentation.fullScreenImage;
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:asset.defaultRepresentation.scale
                                   orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];

//    self.photoImageV.image = [image imageRotate:image rotation:UIImageOrientationUp];
    
}


#pragma  mark - UI part

//-(UIView *)photoView{
//    if (!_photoView) {
//        _photoView = [UIView new];
//        _photoImageV = [UIImageView new];
//        [_photoView addSubview:_photoImageV];
//        [_photoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(_photoView);
//        }];
//        _photoImageV.backgroundColor = [UIColor clearColor];
//        _photoImageV.image = [UIImage imageNamed:@"default_image"];
//        _photoImageV.contentMode = UIViewContentModeScaleAspectFit;
//        
//    }
//    return _photoView;
//}

-(UICollectionView *)photoCollectionView{
    if (!_photoCollectionView) {
        //指定列数及Cell间隔大小
        CGFloat spacing = 1.0;
        //指定CollectionView的Padding Size
//        CGFloat paddingX = 5.0;
        //动态计算出Cell Size
//        CGFloat value = floorf((CGRectGetWidth(self.view.bounds) - (colum - 1) * spacing - paddingX*2) / colum);
        
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize                     = CGSizeMake((SCREEN_WIDTH-3)/3,(SCREEN_WIDTH-3)/3);
        layout.minimumInteritemSpacing      = spacing;
        layout.minimumLineSpacing           = spacing;
        
//        layout.sectionInset = UIEdgeInsetsMake(1,1,1,1);
        
        CGRect rect = self.view.bounds;
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
//-(UIButton *)screenButton{
//    if (!_screenButton) {
//        _screenButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        _screenButton.backgroundColor = [UIColor whiteColor];
//        [_screenButton setTitle:@"投屏到电视" forState:UIControlStateNormal];
//        
//    }
//    return _screenButton;
//}

#pragma mark -addSubViewsConstraints
//FIXME:按比例適配？？

//-(void)SJLocalAddSubViewsConstraints{
//    [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.mas_equalTo(self.view);
//        make.height.mas_equalTo(210.);
//    }];
//    
//    [_screenButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.mas_equalTo(self.view);
//        make.height.mas_equalTo(50.);
//    }];
//}
@end
