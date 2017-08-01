//
//  RelationDeviceController.m
//  HiTV
//
//  Created by 蒋海量 on 15/8/10.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "RelationDeviceController.h"
#import "TogetherManager.h"
#import "HiTVDeviceInfo.h"
#import "TPXmppRoomManager.h"
#import "QRCodeController.h"
#import "SJLoginViewController.h"
#import "SJAdView.h"

static CGFloat kX3InfoImageAspectRatio = 375.0/1305.0;//X3介绍图片高度

@interface RelationDeviceController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) TRTopNavgationView *naviView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UITableView *devicesTabView;
@property (nonatomic, strong) IBOutlet UIView *bottomView;
@property (nonatomic, strong) UIImageView *bottomImgView;

@property (nonatomic, strong) SJAdView *adView;

@property (nonatomic, strong) NSArray     *devicesArray;
@property (nonatomic, strong) UIView      *noDataView;

@property (nonatomic, strong) HiTVDeviceInfo      *tempEntity;
@property (weak, nonatomic)  UITextField *textField;

@end

@implementation RelationDeviceController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        self.devicesTabView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.devicesTabView.backgroundColor = [UIColor clearColor];
        self.devicesTabView.dataSource = self;
        self.devicesTabView.delegate = self;
        [self.scrollView addSubview:self.devicesTabView];
        
        self.bottomView = [[UIView alloc] init];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:self.bottomView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.title = @"家庭电视";
    self.view.backgroundColor = klightGrayColor;
    
    [self initNavigationView];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(64);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.scrollView).with.offset(0);
        make.height.mas_equalTo(200);
    }];
    
    [self.devicesTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.scrollView).with.offset(0);
        make.bottom.equalTo(self.bottomView.mas_top).with.offset(0);
    }];
    if ([[HiTVGlobals sharedInstance].disable_moudles containsObject:@"x3shop"]) {
        self.bottomView.hidden = YES;
    }
    self.devicesTabView.separatorColor = kTabLineColor;
    [self setExtraCellLineHidden:self.devicesTabView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_refreshRelationList:)
                                                 name:TPIMNotification_NOTI21
                                               object:nil];
    
    UIBarButtonItem *scanItem = [[UIBarButtonItem alloc] initWithImage:[[ UIImage imageNamed : @"scan_white" ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(scan)];
    self.navigationItem.rightBarButtonItem = scanItem;
    
    

}
-(void)p_refreshRelationList:(NSNotification*)notification
{
    [[TogetherManager sharedInstance]getDeviceDetectionRequestForCompletion:^(NSArray *devices,NSString *error){
        self.devicesArray = devices;
        [self reframeSubviews];
        [self.devicesTabView reloadData];
        
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[TogetherManager sharedInstance]getDeviceDetectionRequestForCompletion:^(NSArray *devices,NSString *error){
        self.devicesArray = devices;
        [self reframeSubviews];
        [self.devicesTabView reloadData];
        
    }];
}
-(void)scan{
    if ([HiTVGlobals sharedInstance].isLogin) {
        self.hidesBottomBarWhenPushed = YES;
        QRCodeController *qrVC = [[QRCodeController alloc]init];
        qrVC.type = @"2";
        [self.navigationController pushViewController:qrVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else{
        
        SJLoginViewController *sjVC = [[SJLoginViewController alloc]init];
        [self.navigationController presentViewController:sjVC animated:YES completion:nil];
        return;
    }
}
#pragma mark - RelationDevicesCellDelegate
- (void)removeDevice:(HiTVDeviceInfo *)entity{
    if ([CHANNELID isEqualToString:taipanTest63]) {
        NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
        [parameters setValue:entity.userId forKey:@"tvAnonymousUid"];
        [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"phoneUid"];
        //[parameters setObject:BIMS_DOMAIN forKey:@"phoneArea"];
        //[parameters setObject:BIMS_DOMAIN forKey:@"tvArea"];
        
        __weak typeof(self) weakSelf = self;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [MsProtocol removeRelationRequest:parameters completion:^(id responseObject) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            if ([[resultDic objectForKey:@"code"] intValue] == 0) {
                [OMGToast showWithText:@"删除成功"];
            }
            
            [[TogetherManager sharedInstance]setRemoteStatus];

            self.devicesArray = [TogetherManager sharedInstance].detectedDevices;
            [self.devicesTabView reloadData];
            
            [[TogetherManager sharedInstance]getDeviceDetectionRequestForCompletion:^(NSArray *devices,NSString *error){
                [[TPXmppRoomManager defaultManager] setDeviceArray:[NSArray arrayWithArray:[TogetherManager sharedInstance].detectedDevices]];
                [self setRemoteStatus];
                self.devicesArray = devices;
                [self.devicesTabView reloadData];
            }];
        } failure:^(NSString *error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [OMGToast showWithText:@"删除失败"];
        }];
    }
    else{
       /* if ([entity.ownerUid isEqualToString:[TogetherManager sharedInstance].connectedDevice.ownerUid]) {
            [TogetherManager sharedInstance].connectedDevice = nil;
        }*/
        NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
        [parameters setValue:entity.ownerUserId forKey:@"ownerUid"];
        [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"familyUid"];
        [parameters setObject:BIMS_DOMAIN forKey:@"phoneArea"];
        [parameters setObject:BIMS_DOMAIN forKey:@"tvArea"];
        [parameters setObject:VERSION forKey:@"version"];

        __weak typeof(self) weakSelf = self;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [MsProtocol removeFamilyRelationRequest:parameters completion:^(id responseObject) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            if ([[resultDic objectForKey:@"code"] intValue] == 0) {
                [OMGToast showWithText:@"删除成功"];
            }
            
            [[TogetherManager sharedInstance]getDeviceDetectionRequestForCompletion:^(NSArray *devices,NSString *error){
                [[TPXmppRoomManager defaultManager] setDeviceArray:[NSArray arrayWithArray:[TogetherManager sharedInstance].detectedDevices]];
                [self setRemoteStatus];
                
                self.devicesArray = devices;
                [self.devicesTabView reloadData];
            }];
            
        } failure:^(NSString *error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [OMGToast showWithText:@"删除失败"];
        }];
    }
    
    
}

- (void)updateDevice:(HiTVDeviceInfo *)entity{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:_textField];
    _tempEntity = entity;
    UIAlertView *altView = [[UIAlertView alloc]initWithTitle:nil
                                                     message:@"修改家庭备注名称"
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
    [altView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    _textField = [altView textFieldAtIndex:0];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_textField];
    [altView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
         UITextField *tf = [alertView textFieldAtIndex:0];
        if ([Utils isIncludeSpecialCharact:tf.text]) {
            [OMGToast showWithText:@"不超过10个字符，只支持数字、中英文，不支持符号"];
        }
        else if (tf.text.length == 0) {
            [OMGToast showWithText:@"不能为空！"];
        }
        else{
            NSDictionary *deviceDic = [NSUserDefaultsManager getObjectForKey:DEVICESDIC];
            
            NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
            [newDic addEntriesFromDictionary:deviceDic];
            if (_tempEntity.userId) {
                [newDic setValue:tf.text forKey:_tempEntity.userId];
                [NSUserDefaultsManager saveObject:newDic forKey:DEVICESDIC];
                
                [self.devicesTabView reloadData];
            }
        }
        
    }
}
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    NSString *lang = [[self textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 10) {
                textField.text = [toBeString substringToIndex:10];
                [OMGToast showWithText:@"超过最大字数不能输入了"];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 8) {
            textField.text = [toBeString substringToIndex:8];
        }
    }
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *headLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, W, 30)];
    headLab.backgroundColor = [UIColor clearColor];
    headLab.textColor = [UIColor lightGrayColor];
    headLab.font = [UIFont systemFontOfSize:12.0f];
    headLab.textAlignment = NSTextAlignmentLeft;
    headLab.text =(self.devicesArray.count==0? nil:@"   请选择默认家庭");
    
    return headLab;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (_devicesArray.count==0) {
//        [self addOrRemoveNoDataView];
//    }else{
//        [_noDataView removeFromSuperview];
//    }
    return self.devicesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RelationDevicesCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"RelationDevicesCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.m_delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    HiTVDeviceInfo *entity = self.devicesArray[row];
    cell.entity = entity;
    NSMutableDictionary *deviceDic = [NSUserDefaultsManager getObjectForKey:DEVICESDIC];
    NSString *tvName = [deviceDic objectForKey:entity.userId];
    if (tvName) {
        cell.nameLab.text = tvName;
    }
    else{
        cell.nameLab.text = entity.tvName;
    }
    if ([entity.relationType isEqualToString:@"DEFAULTUSER"]) {
        cell.removeBtn.hidden = YES;
        cell.defautLab.hidden = YES;
    }
    else{
        cell.removeBtn.hidden = NO;
        cell.defautLab.hidden = YES;
    }
    NSString *uid = entity.ownerUid;
    NSString *connectUid = [TogetherManager sharedInstance].connectedDevice.ownerUid;

    if (!entity.ownerUid) {
        uid = entity.userId;
        connectUid = [TogetherManager sharedInstance].connectedDevice.userId;
    }
    if ([uid isEqualToString:connectUid]) {
        [cell.chooseImg setImage:[UIImage imageNamed:@"选择"]];
       // cell.nameLab.textColor = kNavColor;
        cell.chooseImg.hidden = NO;
    }
    else{
        cell.chooseImg.hidden = YES;
        [cell.chooseImg setImage:[UIImage imageNamed:@"全选"]];
    }
    //判断关联家庭下没有电视或者电视没有登录
    if ([entity.state isEqualToString:@"UNTOGETHER_ONLINE"]||[entity.state isEqualToString:@"UNTOGETHER_OFFLINE"]||entity.state==nil) {
        cell.nameLab.textColor = [UIColor lightGrayColor];
    }
    else{
        cell.nameLab.textColor = [UIColor blackColor];
    }
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    //RelationDevicesCell *cell = (RelationDevicesCell *)[tableView cellForRowAtIndexPath:indexPath];
    for (HiTVDeviceInfo *entity in self.devicesArray) {
        entity.IsConnected = NO;
    }
    HiTVDeviceInfo *entity = self.devicesArray[row];
    entity.IsConnected = YES;
    [TogetherManager sharedInstance].connectedDevice = entity;
    
    //沙盒保存当前选中的家庭
    NSString *uid = [NSString stringWithFormat:@"%d",[HiTVGlobals sharedInstance].uid.intValue];
    [NSUserDefaultsManager saveObject:entity.ownerUid forKey:uid];
    [[TogetherManager sharedInstance]setRemoteStatus];

    [self.devicesTabView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark NOData View
-(UIView *)noDataView{
    
    if (!_noDataView) {
        _noDataView = [UIView new];
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_devices_null"]];
        [_noDataView addSubview:imageV];
        
        UILabel *label =[UILabel new];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = 1;
        label.font = [UIFont systemFontOfSize:15.0f];
        label.text = @"您还没有关联任何家庭";
        [_noDataView addSubview:label];
        
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_noDataView);
            make.size.mas_equalTo(CGSizeMake(85, 85));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_noDataView);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(imageV.mas_bottom).offset(10);
        }];
        
        
    }
    return _noDataView;
}

- (void)addOrRemoveNoDataView{
    
    
    [self.scrollView addSubview:self.noDataView];
    [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 120));
        make.top.mas_equalTo(self.view).offset(120);
    }];
}
-(void)setRemoteStatus{
    HiTVDeviceInfo *deviceEntity = [TogetherManager sharedInstance].connectedDevice;
    if ([deviceEntity.state isEqualToString:@"TOGETHER_SAME_NET"]||[deviceEntity.state isEqualToString:@"TOGETHER_DIFF_NET"]) {
        if (![AppDelegate appDelegate].appdelegateService.isConnect) {
            [AppDelegate appDelegate].appdelegateService.isConnect = YES;
        }
    }
    else{
        if ([AppDelegate appDelegate].appdelegateService.isConnect) {
            [AppDelegate appDelegate].appdelegateService.isConnect = NO;
            
        }
    }
}

#pragma mark - Subview
- (void)initNavigationView
{
    _naviView = [TRTopNavgationView navgationView];
    [self.view addSubview:_naviView];
    _naviView.backgroundColor = kNavgationBarColor;
    
    // back button
    UIButton* backBt = [UIHelper createBtnfromSize:kBackButtonSize
                                             image:[UIImage imageNamed:@"white_back_btn"]
                                      highlightImg:[UIImage imageNamed:@"white_back_btn"]
                                       selectedImg:nil
                                            target:self
                                          selector:nil];
    __weak __typeof(self)weakSelf = self;
    [[backBt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
    [_naviView setLeftView:backBt];
    
    UIButton* scanBtn = [UIHelper createBtnfromSize:kBackButtonSize
                                             image:[UIImage imageNamed:@"扫一扫"]
                                      highlightImg:[UIImage imageNamed:@"扫一扫"]
                                       selectedImg:nil
                                            target:self
                                          selector:nil];
    [[scanBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [strongSelf scan];
    }];
    [_naviView setRightView:scanBtn];
    
    // title
    UILabel* lbl = [UIHelper createTitleLabel:@"家庭电视"];
#ifdef BeiJing
    lbl.textColor = [UIColor whiteColor];
#else
    lbl.textColor = [UIColor blackColor];
#endif
    [_naviView setTitleView:lbl];
    
    
}

- (void)reframeSubviews
{
    if (self.devicesArray.count > 0) {
#ifdef BeiJing
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view).with.offset(0);
            make.height.mas_equalTo(0);
        }];
#else
        if (self.adView == nil) {
            
            self.adView = [[SJAdView alloc] init];
            self.adView.activeController = self;
            [self.bottomView addSubview:self.adView];
            [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
        }
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view).with.offset(0);
            make.height.mas_equalTo(200);
        }];
#endif
        
        
        
        
        [self.devicesTabView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view).with.offset(0);
            make.bottom.equalTo(self.bottomView.mas_top).with.offset(0);
            make.top.equalTo(self.view).with.offset(64);
        }];
        
        [_noDataView removeFromSuperview];
        self.scrollView.scrollEnabled = NO;

    }
    else{
        if (self.bottomImgView == nil) {
            self.bottomImgView = [[UIImageView alloc] init];
            self.bottomImgView.image = [UIImage imageNamed:@"X3_info_image_375"];
            if (self.view.frame.size.width < 375) {
                self.bottomImgView.image = [UIImage imageNamed:@"X3_info_image_320"];
            }
            [self.bottomView addSubview:self.bottomImgView];
            [self.bottomImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.equalTo(self.bottomView).with.offset(0);
            }];
            
        }
        [self.noDataView removeFromSuperview];
        [self.scrollView addSubview:self.noDataView];
        [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.scrollView);
            make.size.mas_equalTo(CGSizeMake(200, 120));
            make.top.mas_equalTo(self.scrollView).offset(20);
        }];
        
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.scrollView).with.offset(0);
            make.top.equalTo(_noDataView.mas_bottom).with.offset(50);
            //make.height.mas_equalTo(1305);
            
        }];
        CGFloat height = self.view.frame.size.width / kX3InfoImageAspectRatio;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.noDataView.size.height + height);
        
        self.scrollView.scrollEnabled = YES;
    }
}


@end
