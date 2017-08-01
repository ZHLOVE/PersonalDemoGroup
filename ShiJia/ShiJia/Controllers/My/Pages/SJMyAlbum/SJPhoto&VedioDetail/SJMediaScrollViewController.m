//
//  SJMediaScrollViewController.m
//  ShiJia
//
//  Created by 峰 on 16/9/18.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJMediaScrollViewController.h"
#import "UIImage+Orientation.h"
#import "SJMediaCollectionCell.h"
#import "SJAlbumModel.h"
#import "SJAlbumToolViewController.h"
#import "TPShortVideoPlayerView.h"
#import "SJPhotoInfoViewController.h"
#import "PhotoOrientation.h"
#import "SJMediaPlayViewModel.h"
#import "SJAlbumToolViewModel.h"

@interface SJMediaScrollViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) UIScrollView              *mediaScrollView;
@property (nonatomic, strong) TRTopNavgationView        *naviView;
@property (nonatomic, strong) NSString                  *navgationTitle;

@property (nonatomic, strong) UICollectionView          *collectView;
@property (nonatomic, strong) SJAlbumToolViewController *toolViewController;
@property (nonatomic, strong) TPShortVideoPlayerView    *playView;
@property (nonatomic, strong) SJPhotoInfoViewController *infoView;
@property (nonatomic, strong) PhotoOrientation          *changeOrtationView;
@property (nonatomic, strong) SJMediaPlayViewModel      *viewModel;
@property (nonatomic, strong) DeletePhotoRequestModel   *deleteRequestPhotoModel;
@property (nonatomic, strong) SJAlbumToolViewModel      *toolViewModel;
@property (nonatomic, strong) NSString                  *photoUrlString;


@end

@implementation SJMediaScrollViewController

#pragma mark 播放器视图
-(TPShortVideoPlayerView *)playView{
    if (!_playView) {
        _playView = [TPShortVideoPlayerView sharedPlayerView];
    }
    return _playView;
}
#pragma mark  信息视图
-(SJPhotoInfoViewController *)infoView{
    if (!_infoView) {
        _infoView = [[SJPhotoInfoViewController alloc]initWithNibName:@"SJPhotoInfoViewController" bundle:nil];

    }
    return _infoView;
}
#pragma mark 方向按钮视图
-(PhotoOrientation *)changeOrtationView{
    if (!_changeOrtationView) {
        _changeOrtationView = [[PhotoOrientation alloc]init];


    }
    return _changeOrtationView;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [MBProgressHUD showMessag:nil toView:self.navigationController.view];
    self.title = @"详情";
    [self.view addSubview:self.toolViewController.view];
    
    __weak __typeof(self)weakSelf = self;
    
    [_toolViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.left.right.bottom.mas_equalTo(strongSelf.view);
        make.height.mas_equalTo(50);
    }];
    _viewModel = [[SJMediaPlayViewModel alloc]init];
    
    _toolViewController.screenHandleBlock = ^(BOOL result,NSString *url){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (result) {
            strongSelf.changeOrtationView.hidden = NO;
            strongSelf.photoUrlString = url;
        }else{
            strongSelf.changeOrtationView.hidden = YES;
        }

    };

    _toolViewModel = [SJAlbumToolViewModel new];

    
    self.changeOrtationView.ChangeOrientationBlock = ^(UIButton *button){
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        NSString *string = nil;
        switch (button.tag) {
            case 0:
                [MBProgressHUD showMessag:@"向右转" toView:nil];
                string = @"rotateR";
                break;
            case 1:
                [MBProgressHUD showMessag:@"向左转" toView:nil];
                string = @"rotateL";
                break;
            default:
                break;
        }

        [[strongSelf.toolViewModel changeThePhotoOrotate:string
                                     andPhotoModel:strongSelf.photoUrlString] subscribeNext:^(id x) {

            [MBProgressHUD hideHUD];
        } error:^(NSError *error) {

            [MBProgressHUD hideHUD];
        } completed:^{

            [MBProgressHUD hideHUD];
        }];

    };
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//    [self initNavigationViewAction];
    if (_album_type==0) {
        [self initNavgationRightItem];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *index = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
        [_collectView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    });
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}

#pragma mark collectionView
-(UICollectionView *)collectView{
    if (!_collectView) {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-50-NAVIGATION_BAR_HEIGHT)];
        layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing=0;
        layout.minimumLineSpacing=0;
        [layout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];

        _collectView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectView.pagingEnabled=YES;
        _collectView.showsHorizontalScrollIndicator=NO;
        _collectView.showsVerticalScrollIndicator=NO;
        _collectView.backgroundColor=[UIColor clearColor];
        _collectView.bounces=NO;
        _collectView.delegate=self;
        _collectView.dataSource=self;
        [_collectView registerClass:[SJMediaCollectionCell class] forCellWithReuseIdentifier:@"SJMediaCollectionCell"];
        [self.view addSubview:_collectView];
        [_collectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view).offset(2);
            make.bottom.mas_equalTo(self.view).offset(-50);
        }];
    }
    return _collectView;
}


#pragma mark navgationView

//- (void)initNavigationViewAction{
//    _naviView = [TRTopNavgationView navgationView];
//    _naviView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_naviView];
//
//    // back button
//    UIButton* backBt = [UIHelper createBtnfromSize:kBackButtonSize
//                                             image:[UIImage imageNamed:@"white_back_btn"]
//                                      highlightImg:[UIImage imageNamed:@"white_back_btn"]
//                                       selectedImg:nil
//                                            target:self
//                                          selector:nil];
//    __weak __typeof(self)weakSelf = self;
//    [[backBt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        //        [self.VedioPlayerView.playerview clearPlayer];
//        [strongSelf.playView resetPlayer];
//        [strongSelf.navigationController popViewControllerAnimated:YES];
//
//    }];
//    [_naviView setLeftView:backBt];
//    self.navgationTitle = @"详情";
//    UILabel* lbl = [UIHelper createTitleLabel:self.navgationTitle];
//    [lbl setTextColor:[UIColor whiteColor]];
//    [_naviView setTitleView:lbl];
//}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.playView resetPlayer];
}
#pragma mark  导航栏 右边按钮

-(void)initNavgationRightItem{

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 20, 51, 44)];

    [button setImage:[UIImage imageNamed:@"Albumdelete"] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button addTarget:self
               action:@selector(deleteCloudFile:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = 2;
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;


}

#pragma mark 底部按钮栏
-(SJAlbumToolViewController *)toolViewController{
    if (!_toolViewController) {

        switch (_album_type) {
            case CLOUD_TYPE:
                _toolViewController = [[SJAlbumToolViewController alloc]initWithNibName:@"SJAlbumToolViewController" bundle:nil];

                break;
            case LOCAL_TYPE:
                _toolViewController = [[SJAlbumToolViewController alloc]initWithNibName:@"SJAlbumToolViewController_II" bundle:nil];
                break;

            default:
                break;
        }
    }
    _toolViewController.superNavgation = self.navigationController;
    return _toolViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark   setter 本地的资源
-(void)setLocalSourceArray:(NSMutableArray *)localSourceArray{

    _localSourceArray = localSourceArray;
    [self.collectView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *index = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
        [_collectView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    });

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}


#pragma mark  setter 当前index
-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    if (_album_type==0) {

        CloudPhotoModel *currentCloudModel = _cloudSourceArray[currentIndex];
        Media_TYPE type;
        if ([currentCloudModel.resourceType isEqualToString:@"VIDEO"]) {
            type = Media_Vedio;
            [self.infoView.view removeFromSuperview];
        }else{
            type = Media_Photo;

            [self.view addSubview:self.infoView.view];
            _infoView.cloudModel = currentCloudModel;
            [_infoView.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.view);
                make.height.mas_equalTo(50);
                make.bottom.mas_equalTo(self.view).offset(-50);
            }];
            [self.view addSubview:self.changeOrtationView];
            [_changeOrtationView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.view);
                make.size.mas_equalTo(CGSizeMake(46, 150));
                make.bottom.mas_equalTo(self.view).offset(-100);
            }];
            self.changeOrtationView.hidden = YES;
        }
        _toolViewController.mediatype = type;
        [_toolViewController setCloudModel:currentCloudModel];
    }else{
        ALAsset *asset = _localSourceArray[currentIndex];
        Media_TYPE type;
        if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
            type =Media_Photo;
            [self.view addSubview:self.changeOrtationView];
            [_changeOrtationView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.view);
                make.size.mas_equalTo(CGSizeMake(46, 150));
                make.bottom.mas_equalTo(self.view).offset(-50);
            }];
            self.changeOrtationView.hidden = YES;
        }else{
            type = Media_Vedio;
        }
        _toolViewController.mediatype = type;
        [_toolViewController setLocalModel:_localSourceArray[currentIndex]];

    }
}

-(void)setCloudSourceArray:(NSMutableArray *)cloudSourceArray{
    _cloudSourceArray = cloudSourceArray;
    [self.collectView reloadData];

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _album_type==0?_cloudSourceArray.count:_localSourceArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    SJMediaCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"SJMediaCollectionCell" forIndexPath:indexPath];
    cell.currentIndex = indexPath;
    switch (_album_type) {

        case CLOUD_TYPE:{
            CloudPhotoModel * currentCloudModel = _cloudSourceArray[indexPath.row];
            Media_TYPE type;
            if ([currentCloudModel.resourceType isEqualToString:@"VIDEO"]) {
                type = Media_Vedio;
                self.playView.hidden = NO;
            }else{
                type = Media_Photo;
                self.playView.hidden = YES;
            }
            [cell creatWithCloudModel:currentCloudModel andSourceType:type];

            WEAKSELF

            cell.playVideo = ^(NSIndexPath *index){

                SJMediaCollectionCell *targetCell = (SJMediaCollectionCell*)[collectionView cellForItemAtIndexPath:index];
                CloudPhotoModel * CloudModel = _cloudSourceArray[index.row];

                [weakSelf.playView setVideoURL:[NSURL URLWithString:CloudModel.resourceUrl]
                            withCollectionView:_collectView
                                   AtIndexPath:index
                              withImageViewTag:index.row];

                [weakSelf.playView addPlayerToCell:targetCell];
                // 自动播放
                [weakSelf.playView autoPlayTheVideo];
            };

        }
            break;
        case LOCAL_TYPE:{
            ALAsset *asset = _localSourceArray[indexPath.row];
            Media_TYPE type;
            if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                type =Media_Photo;
                self.playView.hidden = YES;
            }else{
                type = Media_Vedio;
                self.playView.hidden = NO;
            }

            [cell creatWithLocalModel:asset andSourceType:type];

            WEAKSELF
            cell.playVideo = ^(NSIndexPath *index){
                SJMediaCollectionCell *targetCell = (SJMediaCollectionCell*)[collectionView cellForItemAtIndexPath:index];
                ALAsset *assetModel = _localSourceArray[index.row];
                [weakSelf.playView setVideoURL:[assetModel valueForProperty:ALAssetPropertyAssetURL]
                            withCollectionView:_collectView
                                   AtIndexPath:index
                              withImageViewTag:index.row];
                [weakSelf.playView addPlayerToCell:targetCell];

                // 自动播放
                [weakSelf.playView autoPlayTheVideo];
            };

        }
            break;
        default:
            break;
    }


    return cell;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    for (SJMediaCollectionCell *cell in [self.collectView visibleCells]) {
        NSIndexPath *indexPath = [self.collectView indexPathForCell:cell];
        [self setCurrentIndex:indexPath.row];
    }
}

#pragma mark 删除请求参数
-(DeletePhotoRequestModel *)deleteRequestPhotoModel{
    CloudPhotoModel *currentCloudModel = _cloudSourceArray[_currentIndex];
    _deleteRequestPhotoModel = [DeletePhotoRequestModel new];
    _deleteRequestPhotoModel.resourceCode = currentCloudModel.code;
    _deleteRequestPhotoModel.caller = @"APP";
    _deleteRequestPhotoModel.domain = BIMS_DOMAIN;
    _deleteRequestPhotoModel.uid = [HiTVGlobals sharedInstance].uid;
    return _deleteRequestPhotoModel;
}
#pragma mark 删除
- (void)deleteCloudFile:(id)sender {
    CloudPhotoModel *currentCloudModel = _cloudSourceArray[_currentIndex];
    if (currentCloudModel.delete) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"你确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1;
        [alert show];

    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您不是该资源的主人,不能删除！" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];

        return;
    }

}
#pragma mark 删除成功跳转动作
-(void)afterDeleteAction{
    //只剩最后一张
    if (_cloudSourceArray.count==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    //删除的是最后一张
    if (_currentIndex==_cloudSourceArray.count-1) {
        [_cloudSourceArray removeObjectAtIndex:_currentIndex];
        _cloudSourceArray = nil;
        [self.collectView reloadData];

    }

    if (_currentIndex<_cloudSourceArray.count-1) {
        [_cloudSourceArray removeObjectAtIndex:_currentIndex];
        [self.collectView reloadData];

    }
}
#pragma mark AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        __weak __typeof(self)weakSelf = self;
        [MBProgressHUD showMessag:@"正在删除" toView:self.view];
        [[_viewModel DeletePhotoOrVedios:self.deleteRequestPhotoModel] subscribeNext:^(id x) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        } error:^(NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
            [MBProgressHUD showError:[error localizedDescription] toView:strongSelf.view];
        } completed:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
            [MBProgressHUD showSuccess:@"删除成功" toView:strongSelf.view];
            [strongSelf afterDeleteAction];
        }];
    }
}
@end
