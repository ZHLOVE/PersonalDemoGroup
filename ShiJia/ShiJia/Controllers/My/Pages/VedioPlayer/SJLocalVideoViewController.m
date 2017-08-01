//
//  SJLocalVideoViewController.m
//  ShiJia
//
//  Created by 峰 on 16/8/11.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJLocalVideoViewController.h"
#import "SJScreenVedioCell.h"
#import "SJLocalVedioViewModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
//#import "SPPhotoCollectionViewCell.h"
#import "SJLocalVedioCell.h"
//#import "TogetherManager.h"
//#import "SJVideoPlayerKit.h"
//#import "SJVideoPlayerView.h"

@interface SJLocalVideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

//@property (nonatomic, strong) UITableView           *videoTableView;
//@property (nonatomic, strong) UIButton              *screenButton;
//@property (nonatomic, strong) UIView                *playerView;
//@property (nonatomic, strong) AVPlayer              *Vedioplayer;

@property (nonatomic, strong) NSMutableArray        *assetsData;
@property (nonatomic, strong) SJLocalVedioViewModel *viewModel;
@property (nonatomic, assign) NSInteger             currentIndex;
@property (nonatomic, strong) NSURL                 *vedioUrl;
//@property (nonatomic, strong) SJVideoPlayerKit      *player;
//@property (nonatomic, strong) UIImageView           *playerImageView;
@property (nonatomic, strong) UICollectionView *vedioCollectionView;


@end

@implementation SJLocalVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"视频投屏";
    self.view.backgroundColor = kColorLightGrayBackground;
    
    
    //    [self.view addSubview:self.playerView];
    //    [self.view addSubview:self.playerImageView];
    //    [self.view addSubview:self.videoTableView];
    //    [self.view addSubview:self.screenButton];
    //    [self addSubViewsConstraints];
    [self.view addSubview:self.vedioCollectionView];
    [self bindSJLocalVedioViewModel];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)bindSJLocalVedioViewModel{
    @weakify(self)
    _viewModel = [SJLocalVedioViewModel new];
    
    [_viewModel loadLocalVediosFiles];
    
    [_viewModel.dataSourceSubject subscribeNext:^(NSMutableArray *x) {
        @strongify(self)
        self.assetsData = [NSMutableArray arrayWithArray:[x copy]];
        //        [self.videoTableView reloadData];
        [self.vedioCollectionView reloadData];
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
    //            [MBProgressHUD show:@"亲，没有关联设备，请添加" icon:nil view:self.view];
    //            return;
    //        }
    //        else if (self.currentIndex==0) {
    //            [MBProgressHUD showError:@"请选择视频" toView:self.view];
    //            return;
    //        }else{
    //
    //            [MBProgressHUD showMessag:@"正在投屏" toView:self.view];
    //
    //            [[self.viewModel screenCurrentVedioToTV:(_currentIndex-1)]subscribeNext:^(id x) {
    //
    //
    //            } error:^(NSError *error) {
    //                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //                [MBProgressHUD showError:[error localizedDescription] toView:self.view];
    //
    //            } completed:^{
    //                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //            }];
    //        }
    //
    //    }];
    
}


-(NSMutableArray *)assetsData{
    if (!_assetsData) {
        _assetsData  = [NSMutableArray new];
    }
    return _assetsData;
}
-(UICollectionView *)vedioCollectionView{
    if (!_vedioCollectionView) {
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
    
    _currentIndex = indexPath.row+1;
    //    [self showCurrentPhotoImage:indexPath.row];
    
}
//#pragma  mark TableView Delegate & DataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
//    return (_assetsData) ? [_assetsData count] : 0;
//
//}
//
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
//        [cell setPreservesSuperviewLayoutMargins:NO];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    SJScreenVedioCell *cell = [SJScreenVedioCell cellWithTableView:tableView];
//    ALAsset *model = [_assetsData objectAtIndex:indexPath.row];
//    [cell setCellValueWithModel:model];
//    return cell;
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 74.;
//}
//
//#pragma mark - Table view delegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    _currentIndex = indexPath.row+1;
//    self.playerImageView.hidden = YES;
//    ALAsset *asset = [_assetsData objectAtIndex:indexPath.row];
//    self.vedioUrl = [ asset valueForProperty:ALAssetPropertyAssetURL];
////    [_player setActionUrl:[ asset valueForProperty:ALAssetPropertyAssetURL]];
//
//}


#pragma mark UI Part
//-(UIImageView *)playerImageView{
//    if (!_playerImageView) {
//        _playerImageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"screenvedio"]];
//
//    }
//    return _playerImageView;
//}
//
//-(UIView *)playerView{
//    if (!_playerView) {
//        _playerView = [UIView new];
//        [_playerView addSubview:self.player.view];
//
//    }
//    return _playerView;
//}

//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
////    [self.player clearPlayer];
//}

//-(SJVideoPlayerKit *)player{
//    if (!_player) {
//        _player = [[SJVideoPlayerKit alloc] init];
//        [_player.view setUserInteractionEnabled:NO];
//        _player.view.allControlsHidden = YES;
////        _player.delegate = self;
////        _player.activeController = self;
//    }
//    return _player;
//}
//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//
//}
//-(UITableView *)videoTableView{
//    if (!_videoTableView) {
//
//        _videoTableView = [UITableView new];
//        _videoTableView.dataSource = self;
//        _videoTableView.delegate = self;
//        _videoTableView.backgroundColor = [UIColor clearColor];
//        _videoTableView.autoresizingMask =  UIViewAutoresizingFlexibleHeight;
//        _videoTableView.separatorInset = UIEdgeInsetsMake(0,0,0,0);
//        _videoTableView.separatorColor = [UIColor grayColor];
//
//        _videoTableView.tableFooterView = [UIView new];
//        _videoTableView.tableHeaderView = [UIView new];
//    }
//    return _videoTableView;
//}

//-(UIButton *)screenButton{
//    if (!_screenButton) {
//        _screenButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        _screenButton.backgroundColor = [UIColor whiteColor];
//        [_screenButton setTitle:@"投屏到电视" forState:UIControlStateNormal];
//    }
//    return _screenButton;
//}

#pragma mark
//-(void)addSubViewsConstraints{
//    [_playerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.mas_equalTo(self.view);
//        make.height.mas_equalTo(SCREEN_WIDTH*9/16+1);
//    }];
//    [_playerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.mas_equalTo(self.view);
//        make.height.mas_equalTo(SCREEN_WIDTH*9/16);
//    }];

//    [_videoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.view);
//        make.bottom.mas_equalTo(self.view).offset(-53.);
//        make.top.mas_equalTo(self.view).offset(SCREEN_WIDTH*9/16);
//    }];
//
//    [_screenButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.mas_equalTo(self.view);
//        make.height.mas_equalTo(50.);
//    }];
//}


@end
