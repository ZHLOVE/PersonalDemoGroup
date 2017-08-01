//
//  SJCloudPhotoViewController.m
//  ShiJia
//
//  Created by 峰 on 16/8/31.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJCloudPhotoViewController.h"
#import "SJCloudPhotoCell.h"
#import "SJCloudPhotoViewModel.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "TPRecordShortVideoViewController.h"
#import "SJLocailFileScreen.h"
#import "SJLocailFileResponseModel.h"
#import "TogetherManager.h"
#import "SJMediaScrollViewController.h"
#import "UIImage+Orientation.h"


@interface SJCloudPhotoViewController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIView                   *topView;
@property (nonatomic, strong) UIImageView              *topImageView;
@property (nonatomic, strong) UIButton                 *uploadButton;

@property (nonatomic, strong) UITableView              *photoTableView;
@property (nonatomic, strong) UIView                   *noDataView;


@property (nonatomic, strong) SJCloudPhotoViewModel    *ViewModel;
@property (nonatomic, strong) NSMutableArray <CloudPhotoModel *>*photoModelsArray;
@property (nonatomic, assign) NSInteger                 pageNumber;

@property (nonatomic, strong) CloudRequestPhotoModel   *requestPhotoModel;
@property (nonatomic, strong) DeletePhotoRequestModel  *deleteRequestPhotoModel;
@property (nonatomic, strong) AddPhotoRequestModel     *addRequestPhotoModel;
@property (nonatomic, strong) CloudPhotoModel          *currentSourceModel;
@property (nonatomic, strong) NSIndexPath              *delePath;

@end

@implementation SJCloudPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.cloudAlbumName;

    [self.view addSubview:self.topView];
    [self.view addSubview:self.noDataView];
    [self.view addSubview:self.photoTableView];
    [self addSubViewsContrain];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadAfterUploadVideo) name:@"FinishUpLoadVideo" object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.photoModelsArray removeAllObjects];
    self.pageNumber = 1;
    [self bindViewModel];
}

-(void)loadAfterUploadVideo{
    [self.photoModelsArray removeAllObjects];
    self.pageNumber = 1;
    [self loadTableViewData];
}

#pragma  mark VC 请求model
#pragma  mark 获取照片
-(CloudRequestPhotoModel *)requestPhotoModel{
    _requestPhotoModel = [CloudRequestPhotoModel new];
    _requestPhotoModel.albumCode = self.AlbumModel.code;
    _requestPhotoModel.uid = [HiTVGlobals sharedInstance].uid;
    _requestPhotoModel.pageNo = self.pageNumber;
    _requestPhotoModel.pageSize = 9;
    _requestPhotoModel.caller = @"APP";
    _requestPhotoModel.albumUid =self.AlbumModel.uid;
    _requestPhotoModel.domain =BIMS_DOMAIN;
    return _requestPhotoModel;
}
#pragma  mark //删除资源 Model
-(DeletePhotoRequestModel *)deleteRequestPhotoModel{
    _deleteRequestPhotoModel = [DeletePhotoRequestModel new];
    _deleteRequestPhotoModel.resourceCode = self.currentSourceModel.code;
    _deleteRequestPhotoModel.caller = @"APP";
    _deleteRequestPhotoModel.domain = BIMS_DOMAIN;
    _deleteRequestPhotoModel.uid = [HiTVGlobals sharedInstance].uid;
    return _deleteRequestPhotoModel;
}

-(void)bindViewModel{

    _ViewModel = [[SJCloudPhotoViewModel alloc]init];

    [self loadTableViewData];

    self.photoTableView.mj_footer = [MJRefreshBackNormalFooter
                                     footerWithRefreshingTarget:self
                                     refreshingAction:@selector(loadTableViewData)];
}
#pragma  mark 加载tableView
-(void)loadTableViewData{
   @weakify(self)
    [MBProgressHUD showMessag:nil toView:self.view];
    [[_ViewModel QueryPhotoAndVedios:self.requestPhotoModel]subscribeNext:^(id x) {
        @strongify(self)
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.photoModelsArray addObjectsFromArray:[x copy]];

        if (self.photoModelsArray.count==0) {
            [self.view addSubview:self.noDataView];
            [self.photoTableView removeFromSuperview];
            [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(133, 112));
                make.centerX.mas_equalTo(self.view);
                make.top.mas_equalTo(self.topView.mas_bottom).offset(47);
            }];
        }else{
            NSArray *tempArray = [NSArray arrayWithArray:x];

            if (tempArray.count<9) {
                [self.photoTableView.mj_footer endRefreshingWithNoMoreData];
                [self.noDataView removeFromSuperview];
                [self.photoTableView reloadData];
            }else{
            [self.noDataView removeFromSuperview];
            [self.photoTableView reloadData];
            }
        }
    } error:^(NSError *error) {
       @strongify(self)
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:[error localizedDescription] toView:self.view];
    }completed:^{

    }];
    self.pageNumber++;
    [self.photoTableView.mj_footer endRefreshing];
}

#pragma  mark 当前VC 资源model 数组

-(NSMutableArray *)photoModelsArray{
    if (!_photoModelsArray) {
        _photoModelsArray = [NSMutableArray new];
    }
    return _photoModelsArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark -tableView  Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.photoModelsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 97.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SJCloudPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellContentWithModel:self.photoModelsArray[indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SJMediaScrollViewController *scrollView = [[SJMediaScrollViewController alloc]init];
    scrollView.album_type = 0;
    [self.navigationController pushViewController:scrollView animated:YES];
    [scrollView setCloudSourceArray:self.photoModelsArray];
    [scrollView setCurrentIndex:indexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPat{
    self.delePath =indexPat;
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.currentSourceModel = self.photoModelsArray[indexPath.row];

        if (self.currentSourceModel.delete) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"你确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1;
            [alert show];

        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您不是该资源的主人,不能删除！" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 2;
            [alert show];

        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1) {
        if (buttonIndex==1) {
            __weak __typeof(self)weakSelf = self;
            [MBProgressHUD showMessag:@"正在删除" toView:self.view];
            [[_ViewModel DeletePhotoOrVedios:self.deleteRequestPhotoModel] subscribeNext:^(id x) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
            } error:^(NSError *error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
                [MBProgressHUD showError:[error localizedDescription] toView:strongSelf.view];
                strongSelf.photoTableView.editing = NO;
            } completed:^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
                [MBProgressHUD showSuccess:@"删除成功" toView:strongSelf.view];
                [strongSelf.photoModelsArray removeObjectAtIndex:strongSelf.delePath.row];
                [strongSelf.photoTableView reloadData];
            }];
        }else{

            [self.photoTableView setEditing:NO animated:YES];
        }
    }
    if (alertView.tag ==2 ) {
        [self.photoTableView setEditing:NO animated:YES];
    }

}
#pragma  界面UI
//顶部
-(UIView *)topView{
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor whiteColor];
        UIView *line = [UIView new];
        line.backgroundColor = RGB(229, 229, 229, 0.8);

        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:14.];
        label.textColor = RGB(87, 87, 87, 1);
        label.text  = @"现在上传";
        [label sizeToFit];

        [_topView addSubview:self.topImageView];
        [_topView addSubview:self.uploadButton];
        [_topView addSubview:label];
        [_topView addSubview:line];

        [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(_topView);
            make.height.mas_equalTo(AutoSize_H_IP6(132.));
        }];

        [_uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_topView).offset(11);
            make.size.mas_equalTo(CGSizeMake(32, 32));
            make.top.mas_equalTo(_topImageView.mas_bottom).offset(12);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_uploadButton.mas_right).offset(10);
            make.centerY.mas_equalTo(_uploadButton);

        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(_topView);
            make.height.mas_equalTo(1);
        }];
    }
    return _topView;
}

-(UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [UIImageView new];
        _topImageView.image = [UIImage imageNamed:@"ablum_back"];
    }
    return _topImageView;
}
#pragma  mark 上传按钮
-(UIButton *)uploadButton{
    if (!_uploadButton) {
        _uploadButton = [UIButton new];
        _uploadButton.layer.cornerRadius = 16;
        _uploadButton.backgroundColor = RGB(85, 85, 85, 1);
        [_uploadButton setImage:[UIImage imageNamed:@"iconfont-xiangce"] forState:UIControlStateNormal];
        [_uploadButton addTarget:self action:@selector(callCamera:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadButton;
}
#pragma mark // 列表
-(UITableView *)photoTableView{
    if (!_photoTableView) {
        _photoTableView = [UITableView new];
        _photoTableView.delegate = self;
        _photoTableView.dataSource = self;
        [_photoTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_photoTableView registerNib:[UINib nibWithNibName:@"SJCloudPhotoCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    }
    return _photoTableView;
}
#pragma mark //约束条件
-(void)addSubViewsContrain{
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(AutoSize_H_IP6(132.)+55+1);
    }];
    [_photoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(_topView.mas_bottom);
    }];

    [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(133, 112));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(47);
    }];
}
#pragma mark //空视图
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
        label.font = [UIFont systemFontOfSize:18.];
        [_noDataView addSubview:label];

        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_noDataView);
            make.height.mas_equalTo(65);
            make.width.mas_equalTo(74);
            make.centerX.mas_equalTo(_noDataView);
        }];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_noDataView);
            make.centerX.mas_equalTo(_noDataView);
            make.height.mas_equalTo(26);
        }];

    }
    return _noDataView;
}
#pragma mark // 调取相机
- (void)callCamera:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"录制10秒短视频" ,nil];

    [sheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                TPRecordShortVideoViewController *shortvideoVC = [[TPRecordShortVideoViewController alloc] init];
                shortvideoVC.AlbumModel = self.AlbumModel;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:shortvideoVC];
                [self presentViewController:nav animated:YES completion:nil];

            }

        }];
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

         if (authStatus == AVAuthorizationStatusDenied){
            UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请前往设置->隐私->相相授权应用访问相机权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else if (buttonIndex == 0) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {



                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                
                imagePickerController.allowsEditing = NO;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self.navigationController presentViewController:imagePickerController animated:NO completion:^{
                    imagePickerController.navigationBarHidden = YES;
                }];
            }


        }];
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

         if (authStatus == AVAuthorizationStatusDenied){

            UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请前往设置->隐私->相相授权应用访问相机权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else if (authStatus == AVAuthorizationStatusNotDetermined){

                DDLogInfo(@"系统还未知是否访问，第一次开启相机时");
        }
    }
}

-(void)uploadPhotoWith:(UIImage *)image{
    SJLocailFileScreen *fileupload = [SJLocailFileScreen new];
    __weak __typeof(self)weakSelf = self;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
    [fileupload upLocalFile:imageData type:0 Block:^(id result, NSError *error, CGFloat percent) {
        if (result) {

            SJLocailFileResponseModel *model = (SJLocailFileResponseModel *)result;
            AddPhotoRequestModel *requestModel = [AddPhotoRequestModel new];
            requestModel.uid = [HiTVGlobals sharedInstance].uid;
            requestModel.shareUid =_AlbumModel.uid;
            requestModel.uploadUid =[HiTVGlobals sharedInstance].uid;
            requestModel.uploadNickName = [HiTVGlobals sharedInstance].nickName;
            requestModel.source = @"APP";
            requestModel.faceImg = [HiTVGlobals sharedInstance].faceImg;
            requestModel.thumbnailUrl = model.url;
            requestModel.resourceUrl = model.url;
            requestModel.resourceType = @"PHOTO";
            requestModel.md5 = [imageData md5String];
            requestModel.domain = BIMS_DOMAIN;
            requestModel.caller = @"APP";
            [[_ViewModel AddPhotoOrVedios:requestModel] subscribeNext:^(id x) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [MBProgressHUD hideAllHUDsForView:strongSelf.navigationController.view animated:YES];
            } error:^(NSError *error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [MBProgressHUD hideAllHUDsForView:strongSelf.navigationController.view animated:YES];
                [MBProgressHUD showError:@"上传失败" toView:strongSelf.navigationController.view];
            } completed:^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [MBProgressHUD hideAllHUDsForView:strongSelf.navigationController.view animated:YES];
                [MBProgressHUD showSuccess:@"上传成功" toView:strongSelf.navigationController.view];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"FinishUpLoadVideo" object:nil];

            }];
        }
        if (error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [MBProgressHUD hideAllHUDsForView:strongSelf.navigationController.view animated:YES];
            [MBProgressHUD showError:[error localizedDescription] toView:strongSelf.navigationController.view];
        }
    }];
}
#pragma  mark  保存完成之后 即刻 上传
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [image imageRotate:image rotation:UIImageOrientationRight];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [picker dismissViewControllerAnimated:YES completion:^{
     [MBProgressHUD showMessag:@"正在上传" toView:self.navigationController.view];
        [self uploadPhotoWith:image];
    }];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    UIAlertView *alert;
    if (error){
        alert = [[UIAlertView alloc] initWithTitle:@"保存失败"
                                           message:[error localizedDescription]
                                          delegate:self cancelButtonTitle:@"知道了"
                                 otherButtonTitles:nil];
        [alert show];
    }
}
@end
