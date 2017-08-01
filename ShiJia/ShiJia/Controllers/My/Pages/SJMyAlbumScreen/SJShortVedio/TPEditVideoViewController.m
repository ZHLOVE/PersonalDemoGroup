//
//  TPEditVideoViewController.m
//  ChatDemo
//
//  Created by yy on 15/10/22.
//  Copyright © 2015年 yy. All rights reserved.
//

#import "TPEditVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"
#import "TPMessageRequest.h"
#import "TPFileOperation.h"
#import "SJLocailFileScreen.h"
#import "SJCloudPhotoViewModel.h"
#import "SJLocailFileResponseModel.h"
#import "TogetherManager.h"

#define LightButtonBackgroundColor [UIColor colorWithRed:57/255.0 green:131/255.0 blue:176/255.0 alpha:1.0]
#define DarkButtonBackgroundColor [UIColor colorWithRed:43/255.0 green:96/255.0 blue:128/255.0 alpha:1.0]
#define ShootButtonBackgroundColor [UIColor colorWithRed:44/255.0 green:106/255.0 blue:145/255.0 alpha:1.0]

NSString * const kTPEditVideoViewControllerDidFinishRecordingVideoNotificationName = @"TPEditVideoViewControllerDidFinishRecordingVideoNotificationName";

NSString * const kTPEditVideoViewControllerVideoUrlKey = @"TPEditVideoViewControllerVideoUrlKey";

@interface TPEditVideoViewController ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *shootButton;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, copy)   NSString *mp4Path;
@property (nonatomic, strong) NSData *videoData;
@property (nonatomic, strong) SJLocailFileScreen *fileupload;
@property (nonatomic, assign) NSInteger videoLength;
@property (nonatomic, strong) UIImage *imageThum;
@property (nonatomic, strong) NSString *thumUrlString;
@property (nonatomic, strong) NSMutableArray *devicesIDArray;
@end

@implementation TPEditVideoViewController
{
    MBProgressHUD *HUD;
}
#pragma mark - view
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogoutNotification:) name:TPXMPPOfflineNotification object:nil];
    
    //add subviews
    [self.view.layer addSublayer:self.playerLayer];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
    [self.topView addSubview:self.backButton];
    [self.bottomView addSubview:self.cancelButton];
    [self.bottomView addSubview:self.doneButton];
//    [self.bottomView addSubview:self.shootButton];

    
    if (self.videoURL != nil) {
        [self convertMovToMP4];
    }
    _fileupload = [SJLocailFileScreen new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    //set autolayout
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(64);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView).with.offset(28);
        make.left.equalTo(self.topView).with.offset(10);
        make.width.mas_equalTo(51);
        make.height.mas_equalTo(44);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(120);
    }];
    
//    [self.shootButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.bottomView).with.offset(0);
//        make.width.mas_equalTo(60);
//        make.height.mas_equalTo(60);
//    }];

    
    CGFloat originx = ([UIScreen mainScreen].bounds.size.width-80-50)/4.0;
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).with.offset(originx);
        make.centerY.equalTo(self.bottomView).with.offset(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).with.offset(-originx);
        make.centerY.equalTo(self.bottomView).with.offset(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    UIImageView *backImgView = [[UIImageView alloc] init];
    backImgView.backgroundColor = [UIColor blackColor];
    backImgView.alpha = 0.6;
    [self.bottomView addSubview:backImgView];
    [self.bottomView sendSubviewToBack:backImgView];
    [backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_playerItem seekToTime:kCMTimeZero];
    [_player play];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - notification
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
//    AVPlayerItem *p = [notification object];
//    [p seekToTime:kCMTimeZero];
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wconversion"
- (void)convertMovToMP4
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:self.videoURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality])
    {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        _mp4Path = [self.videoURL.absoluteString stringByReplacingOccurrencesOfString:@"mov" withString:@"mp4"];
        exportSession.outputURL = [NSURL URLWithString:_mp4Path];
        self.imageThum = [self thumbnailImageForVideo:self.videoURL atTime:1];
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        self.videoLength = avAsset.duration.value / avAsset.duration.timescale; // 获取视频总时长,单位秒
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                    
                case AVAssetExportSessionStatusFailed:
                case AVAssetExportSessionStatusCancelled:
                {
                    [HUD hide:YES];
                    HUD.mode = MBProgressHUDModeText;
                    HUD.labelText = @"视频生成失败";
                    [HUD show:YES];
                    [HUD hide:NO afterDelay:2.0];
                    
                }
                    break;
                    
                case AVAssetExportSessionStatusCompleted:
                {
                    
                    DDLogInfo(@"Successful!");
                    self.videoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_mp4Path]];
                    [TPFileOperation removeItemAtURL:self.videoURL];
                }
                    break;
                default:
                    break;
            }
            
        }];
    }
    else
    {
        //Error:AVAsset doesn't support mp4 quality
        
    }
    
}

#pragma clang diagnostic pop
//获取视频某一帧图片
-(UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        DDLogInfo(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}
/*
 - (void)uploadVideo
 {
 HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
 [self.navigationController.view addSubview:HUD];
 
 if (self.videoData != nil) {
 
 HUD.mode = MBProgressHUDModeIndeterminate;
 HUD.labelText = @"视频发送中...";
 [HUD show:YES];
 
 [TPMessageRequest uploadVideoFile:self.videoData completion:^(NSString *responseString, NSError *error) {
 if (responseString.length != 0) {
 DDLogInfo(@"视频上传成功");
 [HUD hide:YES];
 //[TPFileOperation removeFileAtPath:_mp4Path];
 [TPFileOperation removeItemAtURL:[NSURL URLWithString:self.mp4Path]];
 [[NSNotificationCenter defaultCenter] postNotificationName:kTPEditVideoViewControllerDidFinishRecordingVideoNotificationName object:self userInfo:@{kTPEditVideoViewControllerVideoUrlKey:responseString}];
 }
 else{
 DDLogInfo(@"视频上传失败");
 [HUD hide:YES];
 HUD.mode = MBProgressHUDModeText;
 HUD.labelText = @"视频发送失败";
 [HUD show:YES];
 [HUD hide:YES afterDelay:2];
 }
 }];
 }
 else{
 HUD.mode = MBProgressHUDModeText;
 HUD.labelText = @"视频转码失败";
 [HUD show:YES];
 [HUD hide:YES afterDelay:2];
 }
 
 
 }*/

- (void)handleLogoutNotification:(NSNotification *)notification
{
    //[self backToMainViewController];
}

#pragma mark - button click
- (IBAction)cancelButtonClicked:(id)sender
{
    [TPFileOperation removeItemAtURL:self.videoURL];
    [TPFileOperation removeItemAtURL:[NSURL URLWithString:self.mp4Path]];
    [self clearPlayer];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)receiveImage:(UIImage *)image{
    WEAKSELF
    [_fileupload upLocalFile:image type:0 Block:^(id result, NSError *error, CGFloat percent) {
        if (result) {
            SJLocailFileResponseModel *model = (SJLocailFileResponseModel *)result;
            weakSelf.thumUrlString = model.thumUrl;
            [weakSelf upLoadVideoToServer];
        }
        if(error){
            [MBProgressHUD showError:[error localizedDescription] toView:self.navigationController.view];
        }
    }];
    
}



-(NSMutableArray *)devicesIDArray{
    if (!_devicesIDArray) {
        _devicesIDArray = [NSMutableArray new];
        for ( HiTVDeviceInfo *entity in [TogetherManager sharedInstance].detectedDevices) {
            [self.devicesIDArray addObject:entity.ownerUserId];
        }
    }
    return _devicesIDArray;
}


-(void)upLoadVideoToServer{
    
    SJCloudPhotoViewModel *viewModel = [SJCloudPhotoViewModel new];
    __weak __typeof(self)weakSelf = self;
    [_fileupload upLocalFile:self.videoData type:2 Block:^(id result, NSError *error, CGFloat percent) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (result) {
            SJLocailFileResponseModel *model = (SJLocailFileResponseModel *)result;
            AddPhotoRequestModel *requestModel = [AddPhotoRequestModel new];
            requestModel.faceImg = [HiTVGlobals sharedInstance].faceImg;
            requestModel.uid = [HiTVGlobals sharedInstance].uid;
            requestModel.shareUid = _AlbumModel.uid;
            requestModel.uploadUid = [HiTVGlobals sharedInstance].uid;
            requestModel.uploadNickName =[HiTVGlobals sharedInstance].nickName;
            requestModel.source = @"APP";
            requestModel.faceImg = [HiTVGlobals sharedInstance].faceImg;
            requestModel.thumbnailUrl = strongSelf.thumUrlString ;
            requestModel.resourceLength =strongSelf.videoLength;
            requestModel.resourceUrl = model.url;
            requestModel.resourceType = @"VIDEO";
            requestModel.md5 = [strongSelf.videoData md5String];
            requestModel.domain = BIMS_DOMAIN;
            requestModel.caller = @"APP";
            [[viewModel AddPhotoOrVedios:requestModel] subscribeNext:^(id x) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
            } error:^(NSError *error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
                [MBProgressHUD showError:@"上传失败" toView:strongSelf.view];
            } completed:^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
                
                
                [strongSelf.navigationController dismissViewControllerAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"FinishUpLoadVideo" object:nil];
                    [MBProgressHUD showSuccess:@"上传成功" toView:nil];
                }];
                [strongSelf performSelectorInBackground:@selector(clearPlayer) withObject:nil];
                
            }];
        }
        if (error) {
            
        }
    }];
    
    
}

- (IBAction)doneButtonClicked:(id)sender
{
    
    
    [MBProgressHUD showMessag:@"正在上传" toView:self.view];
    [self performSelectorInBackground:@selector(receiveImage:) withObject:self.imageThum];
    
}

- (IBAction)shootVideoButtonClicked:(id)sender
{
    
}

#pragma mark - Operation
- (void)clearPlayer
{
    // 播放器暂停
    [self.player pause];
    
    // 停止加载，清空数据
    [_playerItem cancelPendingSeeks];
    [_playerItem.asset cancelLoading];
    [_player.currentItem cancelPendingSeeks];
    [_player.currentItem.asset cancelLoading];
    
    [_playerLayer.player.currentItem cancelPendingSeeks];
    [_playerLayer.player.currentItem.asset cancelLoading];
    [_playerLayer.player.currentItem cancelPendingSeeks];
    [_playerLayer.player.currentItem.asset cancelLoading];
    
    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;
    
    [self.player replaceCurrentItemWithPlayerItem:nil];
    
    //[self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
    
    //[self removeObserver:self forKeyPath:@"playing" context:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [TPFileOperation removeFileAtPath:_mp4Path];
    self.player = nil;
    self.playerItem = nil;
}

#pragma mark - getter
- (AVPlayerLayer *)playerLayer
{
    if (_playerLayer == nil) {
        AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:self.videoURL options:nil];
        self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        self.player = [AVPlayer playerWithPlayerItem:_playerItem];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[self.player currentItem]];
    }
    return _playerLayer;
}

- (UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor clearColor];
    }
    return _topView;
}

- (UIButton *)backButton
{
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_backButton setImage:[UIImage imageNamed:@"white_back_btn"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor clearColor];
        
    }
    return _bottomView;
}

- (UIButton *)cancelButton
{
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"shortvideo_delete_btn"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)doneButton
{
    if (_doneButton == nil) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setBackgroundImage:[UIImage imageNamed:@"shortvideo_ok_btn"] forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _doneButton;
}

- (UIButton *)shootButton
{
    
    if (_shootButton == nil) {
        _shootButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shootButton setBackgroundImage:[UIImage imageNamed:@"shortvideo_shoot_btn"] forState:UIControlStateNormal];
        
        [_shootButton addTarget:self action:@selector(shootVideoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _shootButton;
}

@end
