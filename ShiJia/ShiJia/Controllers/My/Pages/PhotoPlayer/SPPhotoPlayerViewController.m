//  TWPhotoPickerController.m
//  InstagramPhotoPicker
//
//  Created by Emar on 12/4/14.
//  Copyright (c) 2014 wenzhaot. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "SPPhotoPlayerViewController.h"
#import "SPPhotoCollectionViewCell.h"
#import "SPPhotoPlayerView.h"
#import "HiTVConstants.h"
#import "HiTVDeviceManager.h"
#import "HiTVWebServer.h"
#import "MBProgressHUD.h"
#import "UKIMage.h"
#import "ScreenManager.h"
#import "SJLocailFileScreen.h"
#import "SJLocailFileResponseModel.h"
#import "MBProgressHUD+AddHUD.h"
#import "TPIMContentModel.h"



@interface photoModel : NSObject

@property (nonatomic,strong) UIImage  *thumbnail;//缩略图
@property (nonatomic,copy)   NSURL    *imageURL; //原图url
@property (nonatomic,strong) NSString *imageName;//图片名字

@end

@implementation photoModel

@end

//
static const float PHOTO_SLIDE_TIME = 3.0;
//顶部大图的位置
static const int SLIDE_SHOW_IMAGE_HEIGHT = 200;
static  NSString *CELL_IDENTIFIER = @"SPPhotoCollectionViewCell";

@interface SPPhotoPlayerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    BOOL photoProjecting;
    BOOL photoPlaying;
    CGFloat beginOriginY;
//    SPPhotoPlayerView  *photoPlayerView;
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIImageView *maskView;

@property (strong, nonatomic) UIImageView *ShowImageView;

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *assetsSource;

//
@property (readonly, nonatomic) NSUInteger currentIndex;

@property (nonatomic, strong) ScreenManager *screenManager;

@property (nonatomic, strong) UIImage *upImage;
@property (nonatomic, strong) SJLocailFileResponseModel *responseFileModel;

@property (nonatomic, strong) UIImageView *photoImageView;

@end



@implementation SPPhotoPlayerViewController

@synthesize photoPlayerView;

#pragma mark --初始化相关
// screenManager
-(ScreenManager *)screenManager{
    if (_screenManager== nil) {
        _screenManager  = [ScreenManager new];
    }
    return _screenManager;
}
// assetsSource
- (NSMutableArray *)assetsSource {
    if (_assetsSource == nil) {
        _assetsSource = [[NSMutableArray alloc] init];
    }
    return _assetsSource;
}
//responseFileModel
-(SJLocailFileResponseModel *)responseFileModel{
    if (!_responseFileModel) {
        _responseFileModel = [SJLocailFileResponseModel new];
    }
    return _responseFileModel;
}
//assets
- (NSMutableArray *)assets {
    if (_assets == nil) {
        _assets = [[NSMutableArray alloc] init];
    }
    return _assets;
}

-(ALAssetsLibrary *)assetsLibrary{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,
                  ^{
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}


#pragma mark --获取相册资源
//获取手机根目录相册下的图片
-(void)filterImageWithGroup:(ALAssetsGroup *)group
{
    ALAssetsGroupEnumerationResultsBlock groupEnumerAtion =^(ALAsset *result,NSUInteger index, BOOL *stop)
    {
        if (result!=NULL){
            
            if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto]){
                photoModel *model = [photoModel new];
                model.thumbnail = [UIImage imageWithCGImage:result.thumbnail];
                model.imageURL  = result.defaultRepresentation.url;
                model.imageName = [[result defaultRepresentation]filename];
                [self.assets addObject:model];
                
                [self.assetsSource addObject:result];
            }
        }else{
            //主线程中刷新UI
            [self.collectionView reloadData];
            [self setDefaultSelectedIndex:0];
            
        }
        
    };
    [group enumerateAssetsUsingBlock:groupEnumerAtion];
}

/**
 *  获取手机系统相册
 */
-(void)loadPhoneAssetGroups{
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop){
        if (group) {
            [self filterImageWithGroup:group];
        }
    } failureBlock:^(NSError *error) {
        [MBProgressHUD showError:@"获取图片失败" toView:self.view];
    }];
}
#pragma mark lifeCycle
- (void)loadView {
    [super loadView];
    //初始化界面
    [self setTitle:@"图片投屏"];
    
    [self.view addSubview:self.topView];
    [self.view insertSubview:self.collectionView belowSubview:self.topView];
    //设置屏投初始状态
    photoProjecting = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self setTitle:@"图片投屏"];
    //
    //    [self.view addSubview:self.topView];
    //    [self.view insertSubview:self.collectionView belowSubview:self.topView];
    //
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[ UIImage imageNamed:@"player_screen_btn" ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(screenShare:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self loadPhoneAssetGroups];
}

- (void)viewWillUnload
{
    NSLog(@"Photo player view controll unload");
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    NSLog(@"viewDidDisappear");
    [self stopSlidePlay];
    [self stopRemotePlay];
    
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}
- (void)screenShare:(id)sender{
    photoProjecting = YES;
    [self remoteShowPhoto:_currentIndex ];
}
#pragma mark 创建 图片播放器
- (SPPhotoPlayerView*) getSPPlayerViewController{
    if (!self.photoPlayerView) {
        self.photoPlayerView = [[[NSBundle mainBundle] loadNibNamed:@"SPPhotoPlayerView" owner:self options:nil] firstObject];
        [self.photoPlayerView setBackgroundColor:[UIColor clearColor]];
        self.photoPlayerView.delegate = self;
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds),SLIDE_SHOW_IMAGE_HEIGHT);
        self.photoPlayerView.frame = rect;
    }
    return  self.photoPlayerView;
    
}

- (UIView *)topView {
    if (_topView == nil) {
        
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds),SLIDE_SHOW_IMAGE_HEIGHT);
        self.topView = [[UIView alloc] initWithFrame:rect];
        self.topView.backgroundColor = [UIColor clearColor];
        self.topView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        self.topView.clipsToBounds = YES;
        [self.topView addSubview:[self getSPPlayerViewController]];
        
    }
    return _topView;
}

#pragma mark 创建CollectionView
// 创建CollectionView
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        //指定列数及Cell间隔大小
        CGFloat colum = 4.0, spacing = 1.0;
        //指定CollectionView的Padding Size
        CGFloat paddingX = 10.0;
        //动态计算出Cell Size
        CGFloat value = floorf((CGRectGetWidth(self.view.bounds) - (colum - 1) * spacing - paddingX*2) / colum);
        
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize                     = CGSizeMake(value, value);
        //layout.sectionInset                 = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing      = spacing;
        layout.minimumLineSpacing           = spacing;
        
        layout.sectionInset = UIEdgeInsetsMake(paddingX,paddingX,paddingX,paddingX);
        
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.topView.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.topView.bounds));
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView setAllowsSelection:YES];
        
        [_collectionView registerClass:[SPPhotoCollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
        
    }
    return _collectionView;
}

//???:??????
- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            CGRect topFrame = self.topView.frame;
            CGFloat endOriginY = self.topView.frame.origin.y;
            if (endOriginY > beginOriginY) {
                topFrame.origin.y = (endOriginY - beginOriginY) >= 20 ? 0 : -(CGRectGetHeight(self.topView.bounds)-20-44);
            } else if (endOriginY < beginOriginY) {
                topFrame.origin.y = (beginOriginY - endOriginY) >= 20 ? -(CGRectGetHeight(self.topView.bounds)-20-44) : 0;
            }
            
            CGRect collectionFrame = self.collectionView.frame;
            collectionFrame.origin.y = CGRectGetMaxY(topFrame);
            collectionFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(topFrame);
            [UIView animateWithDuration:.3f animations:^{
                self.topView.frame = topFrame;
                self.collectionView.frame = collectionFrame;
            }];
            break;
        }
        case UIGestureRecognizerStateBegan:
        {
            beginOriginY = self.topView.frame.origin.y;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGesture translationInView:self.view];
            CGRect topFrame = self.topView.frame;
            topFrame.origin.y = translation.y + beginOriginY;
            
            CGRect collectionFrame = self.collectionView.frame;
            collectionFrame.origin.y = CGRectGetMaxY(topFrame);
            collectionFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(topFrame);
            
            if (topFrame.origin.y <= 0 && (topFrame.origin.y >= -(CGRectGetHeight(self.topView.bounds)-20-44))) {
                self.topView.frame = topFrame;
                self.collectionView.frame = collectionFrame;
            }
            
            break;
        }
        default:
            break;
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture {
    CGRect topFrame = self.topView.frame;
    topFrame.origin.y = topFrame.origin.y == 0 ? -(CGRectGetHeight(self.topView.bounds)-20-44) : 0;
    
    CGRect collectionFrame = self.collectionView.frame;
    collectionFrame.origin.y = CGRectGetMaxY(topFrame);
    collectionFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(topFrame);
    [UIView animateWithDuration:.3f animations:^{
        self.topView.frame = topFrame;
        self.collectionView.frame = collectionFrame;
    }];
}

#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *CellIdentifier = @"TWPhotoCollectionViewCell";
    
    SPPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    photoModel *model = [self.assets objectAtIndex:indexPath.row];
    cell.imageView.image = model.thumbnail;
    
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    _currentIndex = indexPath.row;
    
    [self showImage: _currentIndex];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void) setDefaultSelectedIndex:(NSInteger)index{
    //将指定Index选中
    if(_collectionView){
        [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    };
    
    //
    [self showImage:0];
}
#pragma mark ----投屏事件
//停止远程投屏
- (void) stopRemotePlay
{
    [[HiTVDeviceManager sharedInstance] playStop];
    
}

- (void) remoteShowPhoto:(NSUInteger)index{
    
    if(!photoProjecting) return;
    if(index < [self.assetsSource count]){
        
        [MBProgressHUD showMessag:@"正在投屏" toView:self.view];
        [[self screenManager] reset];
        WEAKSELF
        ALAsset *asset = [self.assetsSource objectAtIndex:_currentIndex];

        
        [SJLocailFileScreen SJ_locailFileScreen:asset
                                    andFileType:0
                                          Block:^(id result, NSError *error, CGFloat percent) {
                                              
                                              if (result) {
                                                  SJLocailFileResponseModel *model = (SJLocailFileResponseModel*)result;
                                                  
                                                  TPIMContentModel *xmppModel =[TPIMContentModel new];
                                                  xmppModel.playerType = @"photo";
                                                  xmppModel.action = @"play";
                                                  xmppModel.url = [NSString stringWithFormat:@"%@",model.url];
                                                  
                                                  [weakSelf.screenManager remoteLoacalFileWith:xmppModel andType:2];
                                                  
                                                  
                                              }
                                              if (error) {
                                                  [MBProgressHUD showError:@"失败" toView:weakSelf.view];
                                              }
                                          }];
        
    }
    
    [self screenManager].remoteLoacalFileBlock = ^(BOOL isSuccess){
        if (isSuccess) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showSuccess:@"投屏成功" toView:self.view];
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:@"投屏失败" toView:self.view];
        }
    };
}


#pragma mark - Photo Player View Delegate
-(void)playAction:(SPPhotoPlayerAction) action{
    switch(action)
    {
        case SPPhotoPlayerProjectionAction:
            NSLog(@"Screen Projetion");
            photoProjecting = [self.photoPlayerView isPhotoProjecting];
            if(photoPlaying){
                [self showImage:_currentIndex];
            }
            
            //            [self remoteShowPhoto:_currentIndex];
            break;
            
        case SPPhotoPlayerPreviousAction:
            [self stopSlidePlay];
            [self previous];
            break;
            
        case SPPhotoPlayerClockwiseAction:
            [self showOrientationImage:UIImageOrientationRight];
            break;
            
        case SPPhotoPlayerContrarotateAction:
            [self showOrientationImage:UIImageOrientationLeft];
            break;
            
        case SPPhotoPlayerNextAction:
            [self stopSlidePlay];
            [self next];
            break;
            
        case SPPhotoPlayerStartAction:
            //播放按钮变为暂停状态
            [self startSlidePlay];
            break;
            
        case SPPhotoPlayerStopAction:
            [self stopSlidePlay];
            //播放按钮变为可播放状态
            break;
            
        default:
            NSLog(@"PhotoPlayerView Play state error");
            break;
    }
    
}

-(BOOL)hasPrevious
{
    NSLog(@"has previous");
    return (_currentIndex == 0 ) ? NO : YES;
}

-(BOOL)hasNext
{
    NSLog(@"has next");
    return (_currentIndex == [self.assets count]-1) ? NO : YES;
}

- (void) startSlidePlay
{
    [self performSelector:@selector(next) withObject:nil afterDelay:PHOTO_SLIDE_TIME];
}


- (void) next
{
    [[self screenManager] reset];
    
    NSInteger index = (_currentIndex+1)%[self.assets count];
    _currentIndex = index;
    [self showImage:index];
}

- (void) previous
{
    // Previous image
    NSUInteger prevIndex;
    if(_currentIndex == 0){
        prevIndex = [self.assets count] - 1;
    }else{
        prevIndex = (_currentIndex-1)%[self.assets count];
    }
    
    _currentIndex = prevIndex;
    [self showImage:prevIndex];
}


- (void) showOrientationImage:(UIImageOrientation) orientation
{
    
    NSString *fileName = [self.photoPlayerView getShowImageFileName];
    UIImage *preShowImage = [self.photoPlayerView getShowImage];
    if(!preShowImage){
        
        photoModel *model = [self.assets objectAtIndex:_currentIndex];
        fileName = model.imageName;
        
    }
    
    UIImage *showImage = [UKImage imageRotate:preShowImage rotation:orientation];
    
    [self.photoPlayerView setShowImageData:showImage ImageName:fileName];
    
    if([self.photoPlayerView isPhotoProjecting]){
        [self remoteSetRotation:(orientation == UIImageOrientationLeft)? 270 :90];
        
        // [self remoteShowPhoto:_currentIndex];
    }
}

- (void) showImage:(NSInteger) index
{
    if([self.assetsSource count] > 0
       && index < [self.assetsSource count]){
        [self.photoPlayerView.topImageView setBackgroundColor:[UIColor clearColor]];
        
        ALAsset *asset = self.assetsSource[index];
        CGImageRef imageRef = asset.defaultRepresentation.fullScreenImage;
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:asset.defaultRepresentation.scale
                                       orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
        
        [self.photoPlayerView setShowImageData:image ImageName:[[asset defaultRepresentation] filename]];
        
    }
    
    //屏投显示???????? CF 注释
    //    [self remoteShowPhoto:index];
    
    if([self.photoPlayerView isPlaying]){
        [self performSelector:@selector(next) withObject:nil afterDelay:PHOTO_SLIDE_TIME];
    }else{
        [self stopSlidePlay];
    }
}

- (void) stopSlidePlay
{
    // _doStop = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(next) object:nil];
}

//-(BOOL)canScreenProjection
//{
//    NSLog(@"play canScreenProjection");
//
//#if NOT_SUPPORT_REMOTE_PROJECT
//    if (![HiTVDeviceManager sharedInstance].isConnected ){
//        [self showAllTextDialog: [HiTVConstants disconnectBoxText]];
//        return NO;
//    }
//#endif
//
//    return YES;
//}

-(void) remoteSetRotation:(int) rotation
{
    [[HiTVDeviceManager sharedInstance] setRotation:rotation] ;
}


//-(void)showAllTextDialog:(NSString *)str
//{
//    HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    HUD.labelText = str;
//    HUD.mode = MBProgressHUDModeText;
//
//    [HUD showAnimated:YES whileExecutingBlock:^{
//        sleep(2);
//    } completionBlock:^{
//        [HUD removeFromSuperview];
//        HUD = nil;
//    }];
//
//}

@end
