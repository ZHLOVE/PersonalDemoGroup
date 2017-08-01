//
//  SJVIPViewController.m
//  ShiJia
//
//  Created by 峰 on 16/9/2.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJVIPViewController.h"
#import "SJVIPCell.h"
#import "SJVIPViewModel.h"
#import "UIImageView+WebCache.h"
#import "SJLoginViewController.h"
#import "SJPayViewController.h"
#import "SJVIPProtocolViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SJVIPViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView      *userView;
@property (strong, nonatomic) IBOutlet UIImageView *userHeadImage;
@property (strong, nonatomic) IBOutlet UIButton    *userName;
@property (strong, nonatomic) IBOutlet UIImageView *vipImage;
@property (strong, nonatomic) IBOutlet UILabel     *vipDescription;

@property (strong, nonatomic) IBOutlet UITableView *VIPTableView;
@property (strong, nonatomic) IBOutlet UIView      *VIPRightView;

@property (weak, nonatomic) IBOutlet UIImageView *VIPRightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *combinedvipImg;

@property (strong, nonatomic) SJVIPViewModel *viewModel;
@property (strong, nonatomic) NSMutableArray <SJVIPPackageModel *>*tableViewData;
@property (strong, nonatomic) SJGetVIPModel  *requestModel;
@property (weak, nonatomic) IBOutlet UILabel *agreeTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (nonatomic) BOOL isAgree;

@end

@implementation SJVIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
/*
    self.title = @"开通VIP";
    _VIPTableView.tableHeaderView = _userView;
 */
    self.userHeadImage.layer.masksToBounds = YES;
    [_VIPTableView registerNib:[UINib nibWithNibName:@"SJVIPCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self VIPProtocalButton];

    self.combinedvipImg.image = [UIImage imageNamed:@"combinedvip"];
//    self.agreeButton.hidden = YES;
//    self.agreeTitleLabel.hidden = YES;
}

-(void)VIPProtocalButton{
    self.isAgree = YES;
    NSString *str = AgreeProtocal;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,2)];
    [attr addAttribute:NSForegroundColorAttributeName value:kColorBlueTheme range:NSMakeRange(2,str.length-2)];
    self.agreeTitleLabel.attributedText = attr;

    self.agreeButton.selected = YES;
    [self.agreeButton setImage:[UIImage imageNamed:@"protocal_selected"] forState:UIControlStateNormal];
    self.agreeTitleLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [self.agreeTitleLabel addGestureRecognizer:labelTapGestureRecognizer];
    
}
-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    SJVIPProtocolViewController *VIPProtocolView = [[SJVIPProtocolViewController alloc]init];
    [self.navigationController pushViewController:VIPProtocolView animated:YES];
    self.navigationController.navigationBarHidden = NO;

}

- (IBAction)choose:(id)sender {
    self.agreeButton.selected = !self.agreeButton.selected;
    self.isAgree = self.agreeButton.selected;
    if (self.agreeButton.selected) {
        [self.agreeButton setImage:[UIImage imageNamed:@"protocal_selected"] forState:UIControlStateNormal];
    }else{
        [self.agreeButton setImage:[UIImage imageNamed:@"protocal_select"] forState:UIControlStateNormal];
    }
}
- (IBAction)navgationBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self bindViewModel];
    self.navigationController.navigationBarHidden = YES;
//    [self.navigationController.navigationBar UserDefine_setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"combinedvip"]]];
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
}

-(SJGetVIPModel *)requestModel{
    _requestModel = [SJGetVIPModel new];
    _requestModel.uid = [HiTVGlobals sharedInstance].uid;
    _requestModel.source = @"PHONE";
    return _requestModel;
}

//lazy load
-(NSMutableArray *)tableViewData{
    if (!_tableViewData) {
        _tableViewData = [NSMutableArray new];
    }
    return _tableViewData;
}

-(void)bindViewModel{
    _viewModel = [SJVIPViewModel new];
    
    __weak __typeof(self)weakSelf = self;
    [[_userName rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        SJLoginViewController *sjVC = [[SJLoginViewController alloc]init];
        [strongSelf.navigationController presentViewController:sjVC animated:YES completion:nil];
    }];;

    [RACObserve([HiTVGlobals sharedInstance], isLogin) subscribeNext:^(id x) {
        
        if ([x boolValue]) {
            _userName.enabled = NO;
            [_userName setTitle:[HiTVGlobals sharedInstance].nickName forState:UIControlStateNormal];
            [_userHeadImage sd_setImageWithURL:[NSURL URLWithString:[HiTVGlobals sharedInstance].faceImg] placeholderImage:[UIImage imageNamed:LIGHTHEADICON]];
            _vipImage.image =[HiTVGlobals sharedInstance].VIP?[UIImage imageNamed:@"vip_2"]:[UIImage imageNamed:@"vip_"];
#ifdef BeiJing
            _vipDescription.text =[HiTVGlobals sharedInstance].VIP?[NSString stringWithFormat:@"有效期：%@", [HiTVGlobals sharedInstance].expireDate]:@"您还不是VIP会员";
#else
            _vipDescription.text =[HiTVGlobals sharedInstance].VIP?[NSString stringWithFormat:@"有效期：%@", [HiTVGlobals sharedInstance].expireDate]:@"开通会员可享受全平台VIP服务";
#endif
        }else{
            _userName.enabled = YES;
            [_userName setTitle:@"点击登录" forState:UIControlStateNormal];
            _vipImage.image = [UIImage imageNamed:@"vip_"];
            _userHeadImage.image =[UIImage imageNamed:DEFAULTHEADICON];

            _vipDescription.text = @"登录购买可享受全平台VIP服务";
        }
        
    }];
    
    [[_viewModel requestVIPPackage:self.requestModel] subscribeNext:^(id x) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSArray *array = (NSArray *)x;
        strongSelf.tableViewData = [array mutableCopy];
        [strongSelf.VIPTableView reloadData];
    } error:^(NSError *error) {
        
        
    } completed:^{
        
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 39;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 9.+230;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableViewData.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    return self.tableViewData.count>0?self.VIPRightView:nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor clearColor];
    UILabel *label = [UILabel new];
    label.backgroundColor= [UIColor whiteColor];
    label.frame = CGRectMake(0, 0, SCREEN_WIDTH, 38);
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:17.];
    label.text = @"VIP会员套餐";
    [headView addSubview:label];

    UIView *line =[UIView new];
    line.backgroundColor =[UIColor colorWithHexString:@"E5E5E5"];
    line.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    [headView addSubview:line];

    return self.tableViewData.count>0?headView:nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    SJVIPCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    SJVIPPackageModel *model =self.tableViewData[indexPath.row];
    [cell setCellInfoWithModel:self.tableViewData[indexPath.row]];
    if (indexPath.row==self.tableViewData.count-1) {
//        [self.VIPRightImageView setImage:[UIImage imageNamed:@"vipright"]];
            [self.VIPRightImageView sd_setImageWithURL:[NSURL URLWithString:model.phoneMemberRight] placeholderImage:[UIImage imageNamed:@"vipright"]];
    }
WEAKSELF
    [cell setVipBlock:^(id sender){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!weakSelf.isAgree) {
            NSString *title = [NSString stringWithFormat:@"请先同意%@会员协议，再继续购买会员",CurrentAppName];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:title delegate:strongSelf cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            
            
        }else{
        
        
        if ([HiTVGlobals sharedInstance].isLogin) {
            SJVIPPackageModel *model = strongSelf.tableViewData[indexPath.row];
            ProductEntity *productEntity = [ProductEntity new];
            productEntity.productId = model.productId;
            productEntity.name = model.productName;
            productEntity.price = model.price;
            productEntity.payPrice = model.payPrice;
            productEntity.expireDateDesc = model.expireDateDesc;
            productEntity.startTime = model.startTime;
            productEntity.introduce = model.introduce;
            productEntity.expireDateDesc = model.expireDateDesc;
            productEntity.businessType = @"MEMBER";
            productEntity.serviceId = model.serviceId;
            productEntity.imgAddr = model.imgAddr;
            productEntity.ppCycleUnit = model.ppCycleUnit;
            productEntity.ppCycleNu = model.ppCycleNum;

            productEntity.endTime = model.endTime;

            
            NSMutableArray *productArray = [NSMutableArray arrayWithObjects:productEntity, nil];
            SJPayViewController *payVC = [[SJPayViewController alloc]initWithNibName:@"SJPayViewController" bundle:nil];
            payVC.productList = productArray;
            UINavigationController *payNav = [[UINavigationController alloc] initWithRootViewController:payVC];
            [strongSelf presentViewController:payNav animated:YES completion:^{
               strongSelf.navigationController.navigationBarHidden = NO;
            }];
            
//            strongSelf.navigationController.navigationBarHidden = NO;
        }
        else{
            SJLoginViewController *sjVC = [[SJLoginViewController alloc]init];
            [strongSelf presentViewController:sjVC animated:YES completion:nil];
        }
        }
    }];
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSInteger row = indexPath.row;
    
    
}
@end
