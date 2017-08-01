//
//  SJAlbumToolViewController.m
//  ShiJia
//
//  Created by 峰 on 16/9/1.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//[[ model valueForProperty:ALAssetPropertyDuration ] integerValue]

#import "SJAlbumToolViewController.h"
#import "SJToolButton.h"
#import "SJAlbumToolViewModel.h"
#import "MBProgressHUD.h"
#import "SJAlbumModel.h"
#import "SJ30SVedioRequestModel.h"
#import "HiTVGlobals.h"
#import "SJShareVideoViewController.h"
#import "SJShareVideoViewModel.h"
#import "SJShareAlertView.h"
#import "SJCloudPhotoViewModel.h"
#import "SJLocailFileScreen.h"
#import "UIImage+Orientation.h"
#import "AlbumShareView.h"
#import "PhotoShareDelegate.h"
#import "TogetherManager.h"
#import "SJLocalPhotoViewModel.h"
#import "HiTVWebServer.h"
#import "TPIMAlertView.h"
#import "SJShareManager.h"



@interface SJAlbumToolViewController ()<PhotoShareDelegate>

/**
 *  云资源按钮
 */
@property (weak, nonatomic  ) IBOutlet SJToolButton           *cloudScreenButton;
@property (weak, nonatomic  ) IBOutlet SJToolButton           *cloudShareButton;
@property (weak, nonatomic  ) IBOutlet SJToolButton           *downloadButton;
/**
 *  本地投屏按钮
 */
@property (weak, nonatomic  ) IBOutlet SJToolButton           *localScreenButton;
@property (weak, nonatomic  ) IBOutlet SJToolButton           *localShareButton;

@property (nonatomic, strong) AlbumShareView         *shareListView;
@property (nonatomic, strong) SJAlbumToolViewModel   *toolViewModel;
@property (nonatomic, strong) SJCloudPhotoViewModel  *cloudViewModel;
@property (nonatomic, strong) NSString               *md5String;
@property (nonatomic, strong) ALAsset                *localAsset;
@property (nonatomic, strong) __block  CloudPhotoModel        *thecloudModel;
@property (nonatomic, strong) SJ30SVedioRequestModel *requestModel1;//本地的资源
@property (nonatomic, strong) SJ30SVedioRequestModel *requestModel2;//云资源
@property (nonatomic, strong) SJLocailFileScreen     *fileupload;
@property (nonatomic, assign) NSInteger              videoLength;
@property (nonatomic, assign) BOOL                   ShareLocalVideo;
@property (nonatomic, strong) NSMutableArray        *devicesIDArray;
@property (nonatomic, strong) SJLocalPhotoViewModel *localPhotoViewModel;
@property (nonatomic, strong) SJShareManager        *shareManager;


@property (nonatomic, assign) Platform   socailName;
@property (nonatomic, assign) Album_Type albumType;

@property (nonatomic) BOOL       isDownLoad;
@property (nonatomic) BOOL       autoScreen;

@end

@implementation SJAlbumToolViewController

#pragma mark PhotoShareDelegate
-(void)PhotoShareToSocailName:(Platform)name{

    self.socailName = name;
    switch (_albumType) {
        case CLOUD_TYPE:

            [self shareCloudSource:_mediatype andSocailName:name];
            break;
        case LOCAL_TYPE:
            [self shareLocalSourceWith:_mediatype andSocailName:name];
            break;
        default:
            break;
    }
}
#pragma 生成web页面分享
-(void)localVideoMakeWebH5:(SJ30SVedioRequestModel *)Model2 toSocail:(Platform)name{

    @weakify(self)
   [[_toolViewModel shortVideoToH5:Model2] subscribeNext:^(id x) {
        @strongify(self)
        [MBProgressHUD hideHUD];

        SJ30SVedioModel *model = (SJ30SVedioModel *)x;
        SJShareMessage *shareMessage = [SJShareMessage new];
        shareMessage.platform = name;
        shareMessage.messageType = ShareMessageTypeUrl;
        shareMessage.messageTitle = model.title;
        shareMessage.messageContent = model.content;
        shareMessage.messageSourceLink =model.link;
        shareMessage.messageThumbImageUrl = Model2.videoImg;
        [self.shareManager shareObject:shareMessage];

    } error:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[error localizedDescription] toView:nil];

    } completed:^{

    }];/*
    SMSLocalRequestParams *params = [SMSLocalRequestParams new];
    params.contentType = Model2.videoType;
    params.shareUrl = Model2.videoId;
    params.uid = [HiTVGlobals sharedInstance].uid;
    params.userName = [HiTVGlobals sharedInstance].nickName;
    params.userImgUrl = [HiTVGlobals sharedInstance].faceImg;
    params.phoneNo = [HiTVGlobals sharedInstance].phoneNo;
    params.domain = [HiTVGlobals sharedInstance].domain;
    [[_toolViewModel SMSShareLoaclSourceGenerationH5WebURL:params] subscribeNext:^(id x) {
        @strongify(self)

        SMSResponseModel *model = (SMSResponseModel *)x;
        SJShareMessage *shareMessage = [SJShareMessage new];
        shareMessage.platform = name;
        shareMessage.messageType = ShareMessageTypeUrl;
        shareMessage.messageTitle = model.title;
        shareMessage.messageContent = model.title;
        shareMessage.messageSourceLink =model.visitUrl;
        shareMessage.messageThumbImageUrl = Model2.videoImg;
        [self.shareManager shareObject:shareMessage];
    } error:^(NSError *error) {

    } completed:^{

    }];*/
 

}




#pragma mark 本地分享
-(void)shareLocalSourceWith:(Media_TYPE)sourceType andSocailName:(Platform)name{

    @weakify(self)
    switch (sourceType) {
        case Media_Vedio:{
            SJShareAlertView *alertView = [SJShareAlertView alertViewDefault];
            alertView.title = @"视频分享";
            alertView.buttonTtileArray= @[@"取消",@"确定"];
            alertView.deterColor = kColorBlueTheme;
            alertView.alertImage = [UIImage imageWithCGImage:[_localAsset thumbnail]];
            [alertView show];
            alertView.alertBlock = ^(id sender,NSString *text){

                UIButton *button = (UIButton *)sender;
                if (button.tag ==0) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"取消分享" toView:nil];
                }else{
                    [MBProgressHUD showMessag:@"正在分享" toView:nil];
                    [[_toolViewModel UpLoadLocalSourceModel:_localAsset andMediaType:Media_Vedio]subscribeNext:^(id x) {
                        [MBProgressHUD hideHUD];
                        @strongify(self)
                        SJLocailFileResponseModel *result =(SJLocailFileResponseModel *)x ;
                        if (name==ShiJia) {

                            SJShareVideoViewController *shareVC = [[SJShareVideoViewController alloc] init];
                            SJShareVideoViewModel *viewModel = [[SJShareVideoViewModel alloc] initWithController:shareVC];
                            shareVC.viewModel = viewModel;
                            viewModel.videoThumImgUrl = result.thumUrl;
                            viewModel.shortVideoUrl = result.url;
                            [self.superNavgation pushViewController:shareVC animated:YES];

                        }else{
                            SJ30SVedioRequestModel *Model2 = [SJ30SVedioRequestModel new];
                            Model2.videoSecond = [[ _localAsset valueForProperty:ALAssetPropertyDuration ] integerValue];
                            Model2.videoTitle = @"和家庭视频分享";
                            Model2.videoId = result.url;
                            Model2.videoType = @"rec";
                            Model2.userName = [HiTVGlobals sharedInstance].nickName;
                            Model2.userHeadImageUrl = [HiTVGlobals sharedInstance].faceImg;
                            Model2.videoTitle = text;
                            Model2.videoImg = result.thumUrl;
                            [self localVideoMakeWebH5:Model2 toSocail:name];
                        }
                    } error:^(NSError *error) {
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:[error localizedDescription] toView:nil];
                    } completed:^{

                    }];

                }
            };
        }
            break;
        case Media_Photo:{
            SJShareAlertView *alertView = [SJShareAlertView alertViewDefault];
            alertView.title = @"图片分享";
            alertView.buttonTtileArray= @[@"取消",@"确定"];
            alertView.deterColor = kColorBlueTheme;
            alertView.alertImage = [UIImage imageWithCGImage:[_localAsset thumbnail]];
            [alertView show];
            alertView.alertBlock = ^(id sender,NSString *text){
                UIButton *button = (UIButton *)sender;
                if (button.tag ==0) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"取消分享" toView:nil];
                }else{
                    [MBProgressHUD showMessag:@"正在分享" toView:nil];

                    [[_toolViewModel UpLoadLocalSourceModel:_localAsset andMediaType:Media_Photo]subscribeNext:^(id x) {
                        @strongify(self)
                        [MBProgressHUD hideHUD];

                        SJLocailFileResponseModel *result =(SJLocailFileResponseModel *)x ;
                        if (name==ShiJia) {

                            SJShareVideoViewController *shareVC = [[SJShareVideoViewController alloc] init];
                            SJShareVideoViewModel *viewModel = [[SJShareVideoViewModel alloc] initWithController:shareVC];
                            viewModel.imageUrl = result.url;
                            shareVC.viewModel = viewModel;
                            [self.superNavgation pushViewController:shareVC animated:YES];
                        }else{

                            SJ30SVedioRequestModel *Model2 = [SJ30SVedioRequestModel new];
                            Model2.videoSecond = [[ _localAsset valueForProperty:ALAssetPropertyDuration ] integerValue];
                            Model2.videoId = [NSString stringWithFormat:@"%@!/quality/80/sq/580",result.url];
                            Model2.videoType = @"photo";
                            Model2.userName = [HiTVGlobals sharedInstance].nickName;
                            Model2.userHeadImageUrl = [HiTVGlobals sharedInstance].faceImg;
                            Model2.videoImg = result.thumUrl;
                            [self localVideoMakeWebH5:Model2 toSocail:name];

                        }
                    } error:^(NSError *error) {
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:[error localizedDescription] toView:nil];
                    } completed:^{
                        [MBProgressHUD hideHUD];
                    }];
                }
            };

        }
            break;
        default:
            break;
    }
}
#pragma mark 云资源分享

-(void)shareCloudSource:(Media_TYPE)sourceType andSocailName:(Platform)name{

    switch (_mediatype) {
        case Media_Photo:{
            if (name==ShiJia) {
                SJ30SVedioModel *model = [SJ30SVedioModel new];
                model.imgUrl = _thecloudModel.resourceUrl;
                SJShareVideoViewController *shareVC = [[SJShareVideoViewController alloc] init];
                SJShareVideoViewModel *viewModel = [[SJShareVideoViewModel alloc] initWithController:shareVC];
                viewModel.imageUrl = model.imgUrl;
                shareVC.viewModel = viewModel;
                [self.superNavgation pushViewController:shareVC animated:YES];

            }else{
                SJShareAlertView *alertView = [SJShareAlertView alertViewDefault];
                alertView.title = @"分享";
                alertView.alertImageString =_thecloudModel.resourceUrl;
                alertView.buttonTtileArray= @[@"取消",@"确定"];
                alertView.deterColor = kColorBlueTheme;
                [alertView show];
                WEAKSELF
                alertView.alertBlock = ^(id sender,NSString *text){
                    UIButton *button = (UIButton *)sender;

                    if (button.tag ==0) {
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"取消分享" toView:nil];
                    }else{
                        SJ30SVedioRequestModel *Model2 = [SJ30SVedioRequestModel new];
                        Model2.videoSecond = 0;
                        Model2.videoId = [NSString stringWithFormat:@"%@!/quality/80/sq/580",_thecloudModel.resourceUrl];
                        Model2.videoType = @"photo";
                        Model2.userName = [HiTVGlobals sharedInstance].nickName;
                        Model2.userHeadImageUrl = [HiTVGlobals sharedInstance].faceImg;
                        Model2.videoImg = [NSString stringWithFormat:@"%@!/fw/125/fh/80",_thecloudModel.resourceUrl];
                        [weakSelf localVideoMakeWebH5:Model2 toSocail:name];
                    }
                };

            }
        }
            break;
        case Media_Vedio:
            [MBProgressHUD showMessag:@"正在分享" toView:nil];
            if (name==ShiJia) {
                SJShareVideoViewController *shareVC = [[SJShareVideoViewController alloc] init];
                SJShareVideoViewModel *viewModel = [[SJShareVideoViewModel alloc] initWithController:shareVC];
                viewModel.shortVideoUrl = self.requestModel2.videoId;
                viewModel.videoThumImgUrl = _thecloudModel.thumbnailUrl;
                shareVC.viewModel = viewModel;
                [self.superNavgation pushViewController:shareVC animated:YES];
            }else{

                SJShareAlertView *alertView = [SJShareAlertView alertViewDefault];
                alertView.title = @"分享";
                alertView.alertImageString =_thecloudModel.thumbnailUrl;
                alertView.buttonTtileArray= @[@"取消",@"确定"];
                alertView.deterColor = kColorBlueTheme;
                [alertView show];
                @weakify(self)
                WEAKSELF
                alertView.alertBlock = ^(id sender,NSString *text){

                    UIButton *button = (UIButton *)sender;

                    if (button.tag ==0) {
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"取消分享" toView:nil];
                    }else{

                        weakSelf.requestModel2.videoTitle = text;
                        [[_toolViewModel shortVideoToH5:weakSelf.requestModel2] subscribeNext:^(id x) {
                            @strongify(self)
                            [MBProgressHUD hideHUD];
                            SJ30SVedioModel *model = (SJ30SVedioModel *)x;

                            SJShareMessage *shareMessage = [SJShareMessage new];
                            shareMessage.platform = name;
                            shareMessage.messageType = ShareMessageTypeUrl;
                            shareMessage.messageTitle = model.title;
                            shareMessage.messageContent = model.content;
                            shareMessage.messageSourceLink =model.link;
                            shareMessage.messageThumbImageUrl = self.requestModel2.videoImg;
                            [weakSelf.shareManager shareObject:shareMessage];


                        } error:^(NSError *error) {
                            [MBProgressHUD hideHUD];
                            [MBProgressHUD showError:[error localizedDescription] toView:nil];

                        } completed:^{


                        }];

                    }

                };
            }

            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    self.fileupload = [SJLocailFileScreen new];
    _cloudViewModel = [SJCloudPhotoViewModel new];
    _localPhotoViewModel = [SJLocalPhotoViewModel new];
    self.autoScreen = NO;
    self.isDownLoad = NO;
    self.shareManager = [[SJShareManager alloc]init];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
#pragma mark setter 本地相册对象
-(void)setLocalModel:(ALAsset *)localModel {
    self.albumType = LOCAL_TYPE;
    self.localAsset = localModel;
    if (self.autoScreen) {
        [self screenLocalSource];
    }

}
#pragma mark 云资源model
-(void)setCloudModel:(CloudPhotoModel *)Model {
    self.albumType = CLOUD_TYPE;
    self.isDownLoad = NO;
    [self.downloadButton setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    self.thecloudModel = Model;
    if (self.autoScreen) {
        [self screenCloundSource];
    }
}
#pragma mark 绑定ViewModel
-(void)bindViewModel{
    _toolViewModel  = [[SJAlbumToolViewModel alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
#pragma mark getter local
-(ALAsset *)localAsset{
    if (!_localAsset) {
        _localAsset = [[ALAsset alloc]init];
    }
    return _localAsset;
}

#pragma mark 分享View
-(AlbumShareView *)shareListView{

    _shareListView = [[AlbumShareView alloc]init];
    _shareListView.photoShareDelegate = self;
    [_shareListView setTitleString:@"分享到微信、朋友圈、微博、通讯录"];
    //    [_shareListView setTitleString:nil];
    [[UIApplication sharedApplication].keyWindow addSubview:_shareListView];
    [_shareListView AlbumShareShowInView:[UIApplication sharedApplication].keyWindow];
    return _shareListView;
}

#pragma mark  本地投屏
- (IBAction)screenAction:(id)sender {

    if (![TogetherManager sharedInstance].connectedDevice) {
        [MBProgressHUD show:@"亲，没有关联设备，请添加" icon:nil view:nil];
        return;
    }

    self.localScreenButton.selected =!self.localScreenButton.selected;
    self.autoScreen = self.localScreenButton.selected;
    if (self.localScreenButton.selected) {

        [self.localScreenButton setImage:[UIImage imageNamed:@"screen_selected"] forState:UIControlStateNormal];
        [self screenLocalSource];
    }else{
        [self.localScreenButton setImage:[UIImage imageNamed:@"screen"] forState:UIControlStateNormal];
    }

}
#pragma mark  本地投屏
-(void)screenLocalSource{

    [MBProgressHUD showMessag:@"投屏..." toView:nil];

    if ([CHANNELID isEqualToString:@"taipanTest63"]) {

        if (![HiTVGlobals sharedInstance].isLogin) {
            [MBProgressHUD showError:@"请先登录" toView:self.view];
            return;
        }
        if (![TogetherManager sharedInstance].connectedDevice) {
            [MBProgressHUD show:@"亲，没有关联设备，请添加" icon:nil view:nil];
            return;
        }else{

            //            [MBProgressHUD showMessag:@"正在上传" toView:self.view];

            [[self.localPhotoViewModel screenCurrentPhotoToTV:_localAsset andMediaType:_mediatype]subscribeNext:^(id x) {


            } error:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [MBProgressHUD showError:[error localizedDescription] toView:self.view];

            } completed:^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                // [MBProgressHUD showSuccess:@"投屏成功" toView:self.view];
            }];
        }
        return;
    }

    id object ;
    if (_mediatype==0) {
        CGImageRef imageRef = _localAsset.defaultRepresentation.fullScreenImage;
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:_localAsset.defaultRepresentation.scale
                                       orientation:(UIImageOrientation)_localAsset.defaultRepresentation.orientation];
        object = [image imageRotate:image rotation:UIImageOrientationUp];

        NSData *data =  [NSData dataWithContentsOfURL:[_localAsset valueForProperty:ALAssetPropertyAssetURL]];
        self.md5String = [data md5String];
        //        self.md5String = [SJFileGenerateMD5 LocalFileToMD5:[[_localAsset valueForProperty:ALAssetPropertyAssetURL] description]];
        [self UploadAlasetToUPCloudAndScreen:0 and:object];
    }else{
        NSData *data =  [NSData dataWithContentsOfURL:[_localAsset valueForProperty:ALAssetPropertyAssetURL]];
        self.md5String = [data md5String];
        //        self.md5String = [SJFileGenerateMD5 LocalFileToMD5:[[_localAsset valueForProperty:ALAssetPropertyAssetURL] description]];
        [ self UploadAlasetToUPCloudAndScreen:1 and:_localAsset];

    }

}

#pragma mark 关联设备ID 数组
-(NSMutableArray *)devicesIDArray{
    if (!_devicesIDArray) {
        _devicesIDArray = [NSMutableArray new];
        for ( HiTVDeviceInfo *entity in [TogetherManager sharedInstance].detectedDevices) {
            [self.devicesIDArray addObject:entity.ownerUserId];
        }
    }
    return _devicesIDArray;
}


#pragma mark 本地alaset 上传到又拍云 传到云相册  投屏
//计算文件大小
#define PER_MB_BYTES (1024.0*1024.0)
//1兆提示：1KB = 1024 B, 1MB = 1024 KB

-(void)UploadAlasetToUPCloudAndScreen:(Media_TYPE)type and:(id)object{
    @weakify(self)
    __block NSString* contentFailed = [NSString stringWithFormat:@"state=%d&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&networkType=%@", -1,@"文件",isNullString(self.thecloudModel.resourceUrl),isNullString(self.thecloudModel.albumUid),isNullString(self.thecloudModel.code),isNullString(self.thecloudModel.albumCode), isNullString(self.thecloudModel.source), @"%@"];
    __block NSString* contentSucc = [NSString stringWithFormat:@"state=%d&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@&networkType=%@", 0,@"文件",isNullString(self.thecloudModel.resourceUrl),isNullString(self.thecloudModel.albumUid),isNullString(self.thecloudModel.code),isNullString(self.thecloudModel.albumCode), isNullString(self.thecloudModel.source), @"%@"];


    if ([[TogetherManager sharedInstance].connectedDevice.state isEqualToString:TOGETHER_SAME_NET]) {

        if ([_localAsset defaultRepresentation].size>(1024*1024*10)){
            TPIMAlertView *alert = [[TPIMAlertView alloc]initWithTitle:@"温馨提示" message:@"由于文件大于10M，仅支持投屏无法同步到云相册" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
            [alert show];
            [alert setRightButtonClickBlock:^{

                [[HiTVWebServer sharedInstance]start];
                NSString *tempUrlString =[[object valueForProperty:ALAssetPropertyAssetURL] description];
                [[HiTVWebServer sharedInstance] webURLForLocalUrl:tempUrlString];

                [HiTVWebServer sharedInstance].block = ^(NSString* urlString) {
                    NSMutableDictionary *dict = [NSMutableDictionary new];
                    [dict setValue:@(200) forKey:@"code"];
                    [dict setValue:@"shijia" forKey:@"sign"];
                    [dict setValue:@"成功" forKey:@"message"];
                    [dict setValue:urlString forKey:@"url"];
                    SJLocailFileResponseModel *model = [SJLocailFileResponseModel mj_objectWithKeyValues:dict];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[_toolViewModel localSourceScreenToTV:model.url andSourceType:_mediatype ] subscribeNext:^(id x) {
                            @strongify(self)
                            [MBProgressHUD hideAllHUDsForView:self.superNavgation.view animated:YES];
                        } error:^(NSError *error) {
                            @strongify(self)
                            if (_screenHandleBlock) {
                                self.screenHandleBlock(NO,nil);
                            }

                            [Utils BDLog:1 module:@"605" action:@"ScreenMapping" content:[NSString stringWithFormat:contentFailed, @"局域网"]];

                            [MBProgressHUD hideAllHUDsForView:self.superNavgation.view animated:YES];
                            [MBProgressHUD showError:[error localizedDescription] toView:self.superNavgation.view];
                        } completed:^{
                            @strongify(self)
                            [Utils BDLog:1 module:@"605" action:@"ScreenMapping" content:[NSString stringWithFormat:contentSucc, @"局域网"]];

                            [MBProgressHUD hideAllHUDsForView:self.superNavgation.view animated:YES];

                            if (_screenHandleBlock) {
                                self.screenHandleBlock(YES,model.url);
                            }
                        }];
                    });
                };

            }];


        }else{

            [[_toolViewModel UpLoadLocalSourceModel:_localAsset andMediaType:Media_Vedio]subscribeNext:^(id x) {
                @strongify(self)
                SJLocailFileResponseModel *model =(SJLocailFileResponseModel *)x ;

                AddPhotoRequestModel *requestModel = [AddPhotoRequestModel new];
                requestModel.faceImg = [HiTVGlobals sharedInstance].faceImg;
                requestModel.uid = [HiTVGlobals sharedInstance].uid;
                requestModel.uploadUid =[HiTVGlobals sharedInstance].uid;
                requestModel.shareUid = [TogetherManager sharedInstance].connectedDevice.ownerUserId;
                requestModel.uploadNickName = [HiTVGlobals sharedInstance].nickName;
                requestModel.source = @"APP";
                requestModel.thumbnailUrl = model.thumUrl;
                requestModel.resourceUrl = model.url;
                requestModel.md5 = self.md5String;
                requestModel.resourceType = _mediatype==0?@"PHOTO":@"VIDEO";
                requestModel.resourceLength =[[_localAsset valueForProperty:ALAssetPropertyDuration ] integerValue];
                requestModel.domain = BIMS_DOMAIN;
                requestModel.caller = @"APP";
                [[_cloudViewModel AddPhotoOrVedios:requestModel] subscribeNext:^(id x) {

                } error:^(NSError *error) {

                    [Utils BDLog:1 module:@"605" action:@"ScreenMapping" content:[NSString stringWithFormat:contentFailed, @"互联网"]];

                } completed:^{
                    [Utils BDLog:1 module:@"605" action:@"ScreenMapping" content:[NSString stringWithFormat:contentSucc, @"互联网"]];

                }];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [[_toolViewModel localSourceScreenToTV:model.url andSourceType:_mediatype ] subscribeNext:^(id x) {
                        @strongify(self)
                        [MBProgressHUD hideAllHUDsForView:self.superNavgation.view animated:YES];
                    } error:^(NSError *error) {
                        @strongify(self)
                        if (_screenHandleBlock) {
                            self.screenHandleBlock(NO,nil);
                        }
                        [Utils BDLog:1 module:@"605" action:@"ScreenMapping" content:[NSString stringWithFormat:contentFailed, @"互联网"]];

                        [MBProgressHUD hideAllHUDsForView:self.superNavgation.view animated:YES];
                        [MBProgressHUD showError:[error localizedDescription] toView:self.superNavgation.view];
                    } completed:^{
                        @strongify(self)

                        [Utils BDLog:1 module:@"605" action:@"ScreenMapping" content:[NSString stringWithFormat:contentSucc, @"互联网"]];

                        [MBProgressHUD hideAllHUDsForView:self.superNavgation.view animated:YES];

                        if (_screenHandleBlock) {
                            self.screenHandleBlock(YES,model.url);
                        }
                    }];
                });

            } error:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:[error localizedDescription] toView:nil];
            } completed:^{

            }];


        }

    }else{

        if ([_localAsset defaultRepresentation].size>(1024*1024*10)){

            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"由于文件大于10M，仅支持投屏无法同步到云相册"
                                                          delegate:self cancelButtonTitle:@"知道了"
                                                 otherButtonTitles:nil, nil];
            [alert show];

        }else{


            [[_toolViewModel UpLoadLocalSourceModel:_localAsset andMediaType:Media_Vedio]subscribeNext:^(id x) {
                @strongify(self)
                SJLocailFileResponseModel *model =(SJLocailFileResponseModel *)x ;

                AddPhotoRequestModel *requestModel = [AddPhotoRequestModel new];
                requestModel.faceImg = [HiTVGlobals sharedInstance].faceImg;
                requestModel.uid = [HiTVGlobals sharedInstance].uid;
                requestModel.uploadUid =[HiTVGlobals sharedInstance].uid;
                requestModel.shareUid = [TogetherManager sharedInstance].connectedDevice.ownerUserId;
                requestModel.uploadNickName = [HiTVGlobals sharedInstance].nickName;
                requestModel.source = @"APP";
                requestModel.thumbnailUrl = model.thumUrl;
                requestModel.resourceUrl = model.url;
                requestModel.md5 = self.md5String;
                requestModel.resourceType = _mediatype==0?@"PHOTO":@"VIDEO";
                requestModel.resourceLength = [[ _localAsset valueForProperty:ALAssetPropertyDuration ] integerValue];
                requestModel.domain = BIMS_DOMAIN;
                requestModel.caller = @"APP";
                [[_cloudViewModel AddPhotoOrVedios:requestModel] subscribeNext:^(id x) {

                } error:^(NSError *error) {
                    [Utils BDLog:1 module:@"605" action:@"ScreenMapping" content:[NSString stringWithFormat:contentFailed, @"互联网"]];

                } completed:^{
                    [Utils BDLog:1 module:@"605" action:@"ScreenMapping" content:[NSString stringWithFormat:contentSucc, @"互联网"]];

                }];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [[_toolViewModel localSourceScreenToTV:model.url andSourceType:_mediatype ] subscribeNext:^(id x) {
                        @strongify(self)
                        [MBProgressHUD hideAllHUDsForView:self.superNavgation.view animated:YES];
                    } error:^(NSError *error) {
                        @strongify(self)
                        if (_screenHandleBlock) {
                            self.screenHandleBlock(NO,nil);
                        }

                        [Utils BDLog:1 module:@"605" action:@"ScreenMapping" content:[NSString stringWithFormat:contentFailed, @"互联网"]];
                        [MBProgressHUD hideAllHUDsForView:self.superNavgation.view animated:YES];
                        [MBProgressHUD showError:[error localizedDescription] toView:self.superNavgation.view];
                    } completed:^{
                        @strongify(self)

                        [Utils BDLog:1 module:@"605" action:@"ScreenMapping" content:[NSString stringWithFormat:contentSucc, @"互联网"]];
                        [MBProgressHUD hideAllHUDsForView:self.superNavgation.view animated:YES];

                        if (_screenHandleBlock) {
                            self.screenHandleBlock(YES,model.url);
                        }
                    }];
                });

            } error:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:[error localizedDescription] toView:nil];
            } completed:^{

            }];
        }

    }
}
#pragma mark 云资源投屏
/**
 * 云投屏
 */
- (IBAction)cloudPhotoScreenAction:(id)sender {
    if (![TogetherManager sharedInstance].connectedDevice) {
        [MBProgressHUD show:@"亲，没有关联设备，请添加" icon:nil view:nil];
        return;
    }

    self.cloudScreenButton.selected =!self.localScreenButton.selected;
    self.autoScreen = self.cloudScreenButton.selected;
    if (self.cloudScreenButton.selected) {
        [self.cloudScreenButton setImage:[UIImage imageNamed:@"screen_selected"] forState:UIControlStateNormal];
        [self screenCloundSource];
    }else{
        [self.cloudScreenButton setImage:[UIImage imageNamed:@"screen"] forState:UIControlStateNormal];
    }

}
#pragma mark 云资源投屏
-(void)screenCloundSource{

    [MBProgressHUD showMessag:@"正在投屏" toView:nil];
    @weakify(self);
    [[_toolViewModel cloudSourceScreenToTV:_thecloudModel andSourceType:_mediatype] subscribeNext:^(id x) {
        [MBProgressHUD hideAllHUDsForView:nil animated:YES];
    } error:^(NSError *error) {
        @strongify(self)

        [MBProgressHUD hideAllHUDsForView:nil animated:YES];
        if (_screenHandleBlock) {
            self.screenHandleBlock(NO,_thecloudModel.resourceUrl);
        }
        [MBProgressHUD showError:[error localizedDescription] toView:nil];
        NSString* content = [NSString stringWithFormat:@"state=%d&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@", -1,@"文件",isNullString(_thecloudModel.resourceUrl),isNullString(_thecloudModel.albumUid),isNullString(_thecloudModel.code),isNullString(_thecloudModel.albumCode), isNullString(_thecloudModel.source)];

        [Utils BDLog:1 module:@"605" action:@"ScreenMapping" content:content];

    } completed:^{
        @strongify(self)

        [MBProgressHUD hideAllHUDsForView:nil animated:YES];
        if (_screenHandleBlock) {
            self.screenHandleBlock(YES,_thecloudModel.resourceUrl);
        }
        NSString* content = [NSString stringWithFormat:@"state=%d&type=%@&uuid=%@&programSeriesId=%@&programId=%@&programseriesname=%@&programname=%@",0,@"文件",isNullString(_thecloudModel.resourceUrl),isNullString(_thecloudModel.albumUid),isNullString(_thecloudModel.code),isNullString(_thecloudModel.albumCode), isNullString(_thecloudModel.source)];

        [Utils BDLog:1 module:@"605" action:@"ScreenMapping" content:content];

    }];

}

#pragma mark 本地分享

- (IBAction)shareAction:(id)sender {

    _shareListView = self.shareListView;
}
#pragma mark 构建云分享请求参数
-(SJ30SVedioRequestModel *)requestModel2{
    _requestModel2 = [SJ30SVedioRequestModel new];
    _requestModel2.videoSecond = self.thecloudModel.resourceLength;
    _requestModel2.videoTitle = @"云相册视频分享";
    _requestModel2.videoId = self.thecloudModel.resourceUrl;
    _requestModel2.videoType = @"rec";
    _requestModel2.videoImg = self.thecloudModel.thumbnailUrl;
    _requestModel2.userName = [HiTVGlobals sharedInstance].nickName;
    _requestModel2.userHeadImageUrl = [HiTVGlobals sharedInstance].faceImg;
    return _requestModel2;
}

# pragma mark  云分享

- (IBAction)cloudPhotoShareAction:(id)sender {
    
    _shareListView = self.shareListView;
    
}
# pragma mark 下载
# pragma 下载
- (IBAction)downloadAction:(id)sender {
    
    if (_isDownLoad) {
        [MBProgressHUD showError:@"已经下载了" toView:self.superNavgation.view];
        return;
    }
    [MBProgressHUD showMessag:@"下载中" toView:self.superNavgation.view];
    [_toolViewModel downLoadCloudSource:self.thecloudModel andSourceType:_mediatype];
    
    _toolViewModel.downprecent = ^(NSInteger precent){
        
    };
    @weakify(self)
    [_toolViewModel.downSubject subscribeNext:^(id x) {
        @strongify(self)
        self.isDownLoad = YES;
        [self.downloadButton setImage:[UIImage imageNamed:@"download_selected"] forState:UIControlStateNormal];
        [MBProgressHUD hideAllHUDsForView:self.superNavgation.view animated:YES];
        [MBProgressHUD showSuccess:@"已保存到相册" toView:self.superNavgation.view];
    } error:^(NSError *error) {
        @strongify(self)
        [MBProgressHUD hideAllHUDsForView:self.superNavgation.view animated:YES];
        [MBProgressHUD showError:@"保存失败" toView:self.superNavgation.view];
    }];
}
@end
