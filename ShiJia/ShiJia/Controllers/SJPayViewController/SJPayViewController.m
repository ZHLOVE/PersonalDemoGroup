//
//  SJPayViewController.m
//  ShiJia
//
//  Created by 峰 on 16/8/29.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJPayViewController.h"
#import "AppDelegate.h"
#import "SJUserInfoCell.h"
#import "SJGoodsCell.h"
#import "SJCouponCell.h"
#import "SJCouponViewController.h"
#import "SJPayFinishViewController.h"
#import "SJLoginViewController.h"
#import "SJIAPManager.h"
#import "SJVIPNetWork.h"
#import "SJPurchaseModel.h"
#import "BIMSManager.h"

#import "TPIMAlertView.h"
#import "SJChoosePayTypeViewController.h"
#import "SJPayTypeCell.h"
#import "OMGToast.h"
#import "SJVertifyCodeViewController.h"
#import "SJPayDetailViewController.h"
#import "SJPayTypeCell.h"
#import "SJPhoneFarePayCell.h"
#import "SJPhoneFareViewModel.h"
#import "H5PayViewController.h"

typedef NS_ENUM(NSInteger, PaymentType){
    PaymentTypePHONE,
    PaymentTypeALIPAY,
    PaymentTypeWEIXIN,
    PaymentTypeAPPSTORE,
    PaymentTypeH5PAY
};

@interface SJPayViewController ()<SJIAPManagerDelegate,PhoneFareDelegate,SJIAPManagerDelegate,SJPhoneFarePayCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *OrderInfoTableview;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (nonatomic, strong) NSString *AppleStroeProductID;//产品ID 对应APPLE Sever上的种类
@property (nonatomic, strong) NSString *currentSequenceId;//当前的流水单号
@property (nonatomic, strong) NSString *currentProductId;//当前的产品编号
@property(nonatomic,strong) ProductEntity*productEntity;

@property(nonatomic,strong) NSIndexPath *currentIndexPath;  //产品包

/*
 *快速支付(6.6 [20160623])
 */
@property (nonatomic, assign) NSInteger sectionCount;
@property (nonatomic, assign) PaymentType payType;

@property (nonatomic, strong) NSMutableArray *payTypeArray;
@property (nonatomic, strong) SJPhoneFareViewModel *viewmodel;
@property (nonatomic, strong) PayRequestParam *params1;
@property (nonatomic, strong) confirmRequsetParams *params2;
@property (nonatomic, strong) requestH5Params *h5requestParams;
@property (nonatomic, strong) NSString *sequenceId;
@property (nonatomic, strong) NSString *merchantCodeString;

@property (weak, nonatomic)  UITextField *codeNumber;
@property(nonatomic,strong) NSIndexPath *currentPayTypeIndexPath;  //支付方式
@property (nonatomic, assign) BOOL  canPay;


@end

@implementation SJPayViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"购买信息";
    [self initNavgationRightItem];

    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;

    [self.view addGestureRecognizer:tapGr];
    
    self.sectionCount = 4;
    
    self.OrderInfoTableview.contentInset=UIEdgeInsetsMake(-30, 0, 0, 0);
    
    self.productEntity = self.productList.firstObject;
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    self.currentPayTypeIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];

    [self registerCell];
    [SJIAPManager sharedManager].delegate = self;

    [self resetPayInfo];
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self.codeNumber resignFirstResponder];
}
-(void)registerCell{
    [self.OrderInfoTableview registerNib:[UINib nibWithNibName:@"SJUserInfoCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.OrderInfoTableview registerNib:[UINib nibWithNibName:@"SJGoodsCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    [self.OrderInfoTableview registerNib:[UINib nibWithNibName:@"SJCouponCell" bundle:nil] forCellReuseIdentifier:@"cell3"];
    [self.OrderInfoTableview registerNib:[UINib nibWithNibName:@"SJPayTypeCell" bundle:nil] forCellReuseIdentifier:@"cell4"];
    //[self.OrderInfoTableview registerNib:[UINib nibWithNibName:@"SJPayTypeCell" bundle:nil] forCellReuseIdentifier:@"cell5"];
    [self.OrderInfoTableview registerNib:[UINib nibWithNibName:@"SJPhoneFarePayCell" bundle:nil] forCellReuseIdentifier:@"cell5"];


}
-(void)resetPayInfo{
    self.totalMoney.text = [NSString stringWithFormat:@"¥ %@",self.productEntity.payPrice];
    self.currentProductId = self.productEntity.productId;
    
    [self orderCreateRequest];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //    self.navigationController.navigationBar.titleTextAttributes = @{
    //                                                                    NSForegroundColorAttributeName : [UIColor blackColor],
    //                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
    //                                                                    };

    [AppDelegate appDelegate].appdelegateService.coinView.hidden = YES;

}


-(void)initNavgationRightItem{

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.backgroundColor =[UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"white_back_btn"] forState:UIControlStateNormal];

    [button addTarget:self
               action:@selector(backAction:)
     forControlEvents:UIControlEventTouchUpInside];
    // button.contentHorizontalAlignment = 0;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];

    self.navigationItem.leftBarButtonItem = item;
}

-(void)backAction:(id)sender{

    //[self.navigationController popViewControllerAnimated:YES];


    TPIMAlertView *alert = [[TPIMAlertView alloc]initWithTitle:@"影片购买" message:@"佳片已恭候多时，真的不约？" leftButtonTitle:@"默默离开" rightButtonTitle:@"继续购买"];
    [alert show];
    WEAKSELF
    [alert setLeftButtonClickBlock:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];

}
-(NSMutableArray *)payTypeArray{
    if (!_payTypeArray) {
        _payTypeArray = [NSMutableArray array];
    }
    return _payTypeArray;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    [[UINavigationBar appearance] setBarTintColor:kColorBlueTheme];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(void)setCurrentPayTypeIndexPath:(NSIndexPath *)currentPayTypeIndexPath{
    _currentPayTypeIndexPath = currentPayTypeIndexPath;
    if (self.payTypeArray.count>_currentPayTypeIndexPath.row) {
        NSString *stringType = [self.payTypeArray objectAtIndex:_currentPayTypeIndexPath.row];
        if ([stringType isEqualToString:@"PHONE"]) {
            self.payType = PaymentTypePHONE;
        }else if ([stringType isEqualToString:@"ALIPAY"]){
            self.payType = PaymentTypeALIPAY;
        }else if ([stringType isEqualToString:@"WEIXIN"]){
            self.payType = PaymentTypeWEIXIN;
        }else if ([stringType isEqualToString:@"APPSTORE"]){
            self.payType = PaymentTypeAPPSTORE;
        }else if ([stringType isEqualToString:@"H5PAY"]){
            self.payType = PaymentTypeH5PAY;
        }
    }
    
}
#pragma  mark -tableView  Delegate & DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        return self.productList.count;
    }
    else if(section==2){
        return self.payTypeArray.count;
    }
    return 1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:
            return 74.;
            break;
        case 1:
            return 105.;
            break;
        case 2:
        {
            NSString *stringType = [self.payTypeArray objectAtIndex:indexPath.row];
            if ([stringType isEqualToString:@"PHONE"]) {
                return 140;
            }
        }
            return 53;
            break;
        case 3:
            return 50;
            break;
        default:
            return 0;
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:{
            SJUserInfoCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:{
            
            SJGoodsCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.productEntity = self.productList[indexPath.row];
            
            if (self.productList.count>1) {
                cell.selectBtn.hidden = NO;
                cell.imageLeftLayout.constant = 45;
                if (self.currentIndexPath == indexPath) {
                    [cell.selectBtn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
                }
                else{
                    [cell.selectBtn setImage:[UIImage imageNamed:@"contact_list_uncheck"] forState:UIControlStateNormal];
                }
                cell.goodsCellCheckBlock = ^(){
                    self.currentIndexPath = indexPath;
                    [self.OrderInfoTableview reloadData];
                    self.productEntity = self.productList[self.currentIndexPath.row];
                    [self resetPayInfo];
                };
            }
            else{
                cell.selectBtn.hidden = YES;
                cell.imageLeftLayout.constant = 20;
            }
            
            return cell;
        }
            break;
        case 2:{
            NSString *stringType = [self.payTypeArray objectAtIndex:indexPath.row];
            if ([stringType isEqualToString:@"PHONE"]) {
                SJPhoneFarePayCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell5" forIndexPath:indexPath];
                cell.m_delegate = self;
                self.codeNumber = cell.codeNumber;
                cell.params1 = self.params1;
                
                if (self.currentPayTypeIndexPath == indexPath) {
                    cell.isCheck = YES;
                    self.currentPayTypeIndexPath = indexPath;
                }
                else{
                    cell.isCheck = NO;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                return cell;
                //cell.imageView.image = [UIImage imageNamed:@"phonefare_1"];
                //cell.textLabel.text = @"话费支付";
            }
            else{
                SJPayTypeCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
                cell.title.hidden = NO;
                if ([stringType isEqualToString:@"ALIPAY"]){
                    cell.title.text = @"支付宝支付";
                }else if ([stringType isEqualToString:@"WEIXIN"]){
                    cell.title.text = @"微信支付";
                }else if ([stringType isEqualToString:@"APPSTORE"]){
                    cell.title.text = @"AppStore支付";
                }else if ([stringType isEqualToString:@"H5PAY"]){
                    cell.title.text = @"现金支付";
                }
                
                if (self.currentPayTypeIndexPath == indexPath) {
                    self.currentPayTypeIndexPath = indexPath;
                    cell.isCheck = YES;
                }
                else{
                    cell.isCheck = NO;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
            break;
        case 3:{

            SJCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //TODO: 传入可用的优惠券 信息 预留的label 中
            if (self.productEntity.ticketPrice.length>0) {
                cell.couponName.text = [NSString stringWithFormat:@"%@元观影抵扣券",self.productEntity.ticketPrice];
                self.totalMoney.text = [NSString stringWithFormat:@"¥ 0.00"];
                [self.payButton setTitle:@"立即支付" forState:UIControlStateNormal];
            }
            else{
                cell.couponName.text = [NSString stringWithFormat:@"暂无可用优惠券"];
                [self.payButton setTitle:@"立即支付" forState:UIControlStateNormal];
            }
            return cell;
            
        }
            break;
        case 4:{
            SJPayTypeCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }
            break;
        default:
            return nil;
            break;
    }


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:

            break;
        case 1:
        {
            ProductEntity *entity = self.productList[indexPath.row];
            if ([entity.isCmsProduct isEqualToString:@"NO"]) {
                SJPayDetailViewController *payDetailVC = [[SJPayDetailViewController alloc]init];
                payDetailVC.productEntity = self.productList[indexPath.row];
                payDetailVC.recommArray = self.recommArray;
                [self.navigationController pushViewController:payDetailVC animated:YES];
            }
        }
            break;
        case 2:{
            /*NSString *stringType = [self.payTypeArray objectAtIndex:indexPath.row];
            if ([stringType isEqualToString:@"PHONE"]) {
                self.payType = PaymentTypePHONE;
            }else if ([stringType isEqualToString:@"ALIPAY"]){
                self.payType = PaymentTypeALIPAY;
            }else if ([stringType isEqualToString:@"WEIXIN"]){
                self.payType = PaymentTypeWEIXIN;
            }else if ([stringType isEqualToString:@"APPSTORE"]){
                self.payType = PaymentTypeAPPSTORE;
            }else if ([stringType isEqualToString:@"H5PAY"]){
                self.payType = PaymentTypeH5PAY;
            }*/

            self.currentPayTypeIndexPath = indexPath;
            [self.OrderInfoTableview reloadData];
        }
            break;
        default:
            break;
    }

}
- (IBAction)payAction:(id)sender {
    //    SJPayFinishViewController *payFinishVC = [[SJPayFinishViewController alloc]init];
    //    payFinishVC.productServiceID = self.productEntity.serviceId ;
    //    payFinishVC.recommArray = self.recommArray;
    //    [self.navigationController pushViewController:payFinishVC animated:YES];

    //如果下单失败，不能支付
    if (!self.canPay) {
        return;
    }
    if (self.productEntity.ticketPrice.length>0) {
        [self payETICKETRequest];
    }else{
       // [self orderCreateRequest];
        switch (self.payType) {
            case PaymentTypePHONE:
            {
                if (_codeNumber.text.length==0) {
                    [MBProgressHUD showError:@"请输入验证码" toView:self.view];
                    return;
                }
                [MBProgressHUD showMessag:nil toView:self.view];
                self.params2.smsCode =self.codeNumber.text;

                [_viewmodel confirmPayDealByPhoneFare:self.params2];
            }
                break;
            case PaymentTypeALIPAY:
            {
                
            }
                break;
            case PaymentTypeWEIXIN:
            {
                
            }
                break;
            case PaymentTypeAPPSTORE:
            {
                [MBProgressHUD showMessag:@"加载中" toView:nil];
                [[SJIAPManager sharedManager] requestProductWithId:_params1.productId];
                
            }
                break;
            case PaymentTypeH5PAY:
            {
                [MBProgressHUD showMessag:@"请求支付" toView:self.view];
                [_viewmodel PhoneFare_receiveH5PayParams:_h5requestParams];
                
            }
                break;
            default:
                break;
        }
    }

}

#pragma -mark 下单
-(void)orderCreateRequest
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:@"" forKey:@"deviceId"];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:[HiTVGlobals sharedInstance].phoneNo forKey:@"phone"];
    [parameters setValue:@"" forKey:@"token"];
    [parameters setValue:@"" forKey:@"spToken"];
    
    [parameters setValue:self.productEntity.productId forKey:@"productId"];
    [parameters setValue:self.productEntity.contentId forKey:@"contentId"];
    [parameters setValue:@"IOS" forKey:@"source"];
    [parameters setValue:self.productEntity.businessType forKey:@"businessType"];
    [parameters setValue:@"IOS" forKey:@"phoneType"];
    [parameters setValue:@"APPSTORE" forKey:@"payType"];
    [parameters setValue:@"" forKey:@"reserve"];
    
    
    
    [MBProgressHUD showMessag:nil toView:self.view];
    
    WEAKSELF
    
    //BUSINESSHOST @"http://192.168.50.97:8080/yst-ord-mpi/"
    [BaseAFHTTPManager postRequestOperationForHost:BUSINESSHOST forParam:@"/phone/order/create" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"result"];
        if ([code isEqualToString:@"ORD-000"]) {
            
            //此处是6.6新增的快速支付
            self.canPay = YES;  //创建订单成功才可以支付
            if ([[[responseDic objectForKey:@"sequenceId"]description] containsString:@"_"]) {
                NSArray *array = [[[responseDic objectForKey:@"sequenceId"]description] componentsSeparatedByString:@"_" ];
                weakSelf.merchantCodeString = array[0];
                weakSelf.sequenceId = array[1];
                
            }else{
                weakSelf.sequenceId =[[responseDic objectForKey:@"sequenceId"] description];
                weakSelf.merchantCodeString = [[responseDic objectForKey:@"merchantCode"] description];
            }
            [weakSelf getPayTypes];
            
            
            
            //以下是6.6之前的支付方式
            
           /* SJChoosePayTypeViewController *chooseTypeViewController =[[SJChoosePayTypeViewController alloc]initWithNibName:@"SJChoosePayTypeViewController" bundle:nil];
            if ([[[responseDic objectForKey:@"sequenceId"]description] containsString:@"_"]) {
                NSArray *array = [[[responseDic objectForKey:@"sequenceId"]description] componentsSeparatedByString:@"_" ];
                chooseTypeViewController.merchantCodeString = array[0];
                chooseTypeViewController.sequenceId = array[1];
                
            }else{
                chooseTypeViewController.sequenceId =[[responseDic objectForKey:@"sequenceId"] description];
                chooseTypeViewController.merchantCodeString = [[responseDic objectForKey:@"merchantCode"] description];
            }
            chooseTypeViewController.dictParams = weakSelf.productEntity;
            chooseTypeViewController.recommArray = weakSelf.recommArray;
            [weakSelf.navigationController pushViewController:chooseTypeViewController animated:YES];*/
            
        }else if ([code isEqualToString:@"ORD-355"]) {
            NSString *string = [NSString stringWithFormat:@"%@\n%@",[responseDic objectForKey:@"message"],@"可尝试购买单月套餐"];
            [OMGToast showWithText:string bottomOffset:SCREEN_HEIGHT/2-50 duration:3.0];
        }else{
            [OMGToast showWithText:[responseDic objectForKey:@"message"] bottomOffset:SCREEN_HEIGHT/2-50 duration:3.0];
        }
    }failure:^(NSString *error) {
        [MBProgressHUD hideHUD];
    }];
    
}
#pragma -mark 支付
-(void)payETICKETRequest
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:self.productEntity.ticketNo forKey:@"payCode"];
    [parameters setValue:@"ETICKET" forKey:@"payType"];
    [parameters setValue:@"" forKey:@"token"];
    [parameters setValue:@"" forKey:@"spToken"];
    [parameters setValue:self.productEntity.businessType forKey:@"businessType"];

    [parameters setValue:@"" forKey:@"deviceId"];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:[HiTVGlobals sharedInstance].phoneNo forKey:@"phone"];

    [parameters setValue:self.productEntity.productId forKey:@"productId"];
    [parameters setValue:self.productEntity.contentId forKey:@"contentId"];
    [parameters setValue:@"IOS" forKey:@"phoneType"];
    [parameters setValue:self.productEntity.serviceId forKey:@"serviceId"];
    [parameters setValue:@"" forKey:@"reserve"];


    [BaseAFHTTPManager postRequestOperationForHost:BUSINESSHOST forParam:@"/phone/order/pay" forParameters:parameters  completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"result"];
        if ([code isEqualToString:@"ORD-000"]) {
            [MBProgressHUD showSuccess:@"购买成功" toView:nil];
            SJPayFinishViewController *payFinishVC = [[SJPayFinishViewController alloc]init];
            payFinishVC.productServiceID = self.productEntity.serviceId ;
            payFinishVC.productEntity = self.productEntity;
            payFinishVC.recommArray = self.recommArray;
            [self.navigationController pushViewController:payFinishVC animated:YES];

        }

    }failure:^(NSString *error) {

    }];
}



#pragma mark - ****************Delegate

- (void)receiveProduct:(SKProduct *)product {
    //     [MBProgressHUD hideHUDForView:nil animated:YES];

    if (product != nil) {
        //购买商品
        if (![[SJIAPManager sharedManager] purchaseProduct:product]) {
            [MBProgressHUD hideHUD];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"您禁止了应用内购买权限,请到设置中开启" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [alert show];
        }
    } else {
        [MBProgressHUD hideHUD];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"失败" message:@"无法连接App store!" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)successfulPurchaseOfId:(NSString *)productId andReceipt:(NSData *)transactionReceipt {

    NSString  *transactionReceiptString = [transactionReceipt base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    if ([transactionReceiptString length] > 0) {
        APPStoreVerModel *model = [APPStoreVerModel new];
        model.receipt = transactionReceiptString;
        model.productId =self.currentProductId;
        model.uid = [HiTVGlobals sharedInstance].uid;
        model.sequenceId = self.currentSequenceId;
        [SJVIPNetWork SJ_ValiteAppleStore:model Block:^(id result, NSString *error) {
            if (error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:error toView:nil];
            }else{
                [MBProgressHUD hideHUD];
                ServerVerModel *model = [ServerVerModel mj_objectWithKeyValues:result];
                if ([model.result isEqualToString:@"PAY-000"]) {
                    [MBProgressHUD showSuccess:@"购买成功" toView:nil];
                    SJPayFinishViewController *payFinishVC = [[SJPayFinishViewController alloc]init];
                    payFinishVC.productServiceID = self.productEntity.serviceId ;
                    payFinishVC.productEntity = self.productEntity;
                    payFinishVC.recommArray = self.recommArray;
                    [self.navigationController pushViewController:payFinishVC animated:YES];

                }else{
                    [MBProgressHUD showError:model.message toView:nil];
                }

            }
        }];
    }
}

- (void)failedPurchaseWithError:(NSString *)errorDescripiton {
    DDLogError(@"购买失败");
    [MBProgressHUD hideHUD];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"失败" message:errorDescripiton delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - 快速支付
-(void)getPayTypes{
    [self bindViewMolde];
    _params1 = self.params1;
    _params2 = self.params2;
    [_viewmodel GetOrderDetailWithSequenceId:_sequenceId];
}
-(PayRequestParam *)params1{
    if (!_params1) {
        _params1 = [PayRequestParam new];
        _params1.orderNo = _sequenceId;
        _params1.merchantCode = self.merchantCodeString;
        _params1.source = @"PHONE";
    }
    return _params1;
}

-(confirmRequsetParams *)params2{
    if (!_params2) {
        _params2 = [confirmRequsetParams new];
        _params2.smsCode = @"";
        _params2.source = @"PHONE";
        // _params2.linkId = @"";
    }
    return _params2;
}

-(requestH5Params *)h5requestParams{
    if (!_h5requestParams) {
        _h5requestParams = [requestH5Params new];
        _h5requestParams.uid = [HiTVGlobals sharedInstance].uid;
        _h5requestParams.merchantCode = self.merchantCodeString;
        _h5requestParams.payCode =  [HiTVGlobals sharedInstance].phoneNo;
        _h5requestParams.accessType = @"HTML";
        _h5requestParams.orderNo = _sequenceId;
    }
    return _h5requestParams;
}
-(void)bindViewMolde{
    
    _viewmodel  = [SJPhoneFareViewModel new];
    _viewmodel.phonefaredelegate = self;
    
}
#pragma mark PhoneFareDelegate
-(void)PhoneFare_getChooseTypeRespone:(OrderDetailEntity *)dataEntity andError:(NSError *)error{
    [MBProgressHUD hideHUD];
    if (error) {
        [MBProgressHUD showError:[error localizedDescription] toView:self.view];
    }else{
        _params1.totalAmount = [dataEntity.payPrice integerValue]*100;
        _params1.productId = dataEntity.serviceId;
        _params1.contentId = dataEntity.contentId;
        _params1.productName = dataEntity.productName;
        _params1.custId = dataEntity.custId;
        _params1.uid = [HiTVGlobals sharedInstance].uid;
        _params1.phoneNum = [HiTVGlobals sharedInstance].phoneNo;
        _params1.userSource =dataEntity.userSource;
        
        NSMutableArray *temp=[[dataEntity.payType componentsSeparatedByString:@"|"] mutableCopy];
        
        if (dataEntity.payType.length==0) {
            [self.payTypeArray addObject:@"APPSTORE"];
        }else{
            self.payTypeArray = temp;
        }
        
        for (NSString *name in self.payTypeArray) {
            if ([name isEqualToString:@"WEIXIN"]) {
                [self.payTypeArray removeObject:name];
            }
            
            if ([name isEqualToString:@"ALIPAY"]) {
                [self.payTypeArray removeObject:name];
            }
        }
        //如果只有话费支付，屏蔽优惠券选项
        if ([dataEntity.payType isEqualToString:@"PHONE"]) {
            self.sectionCount = 3;
        }
        [self.OrderInfoTableview reloadData];
        
        //构建h5支付页面请求参数
        _h5requestParams = self.h5requestParams;
        //!!!: 测试价格为1分钱
         _h5requestParams.totalAmount = [dataEntity.payPrice integerValue]*100;
        //_h5requestParams.totalAmount = 1;
        _h5requestParams.productName = dataEntity.productName;
        //_h5requestParams.productName = @"name";
        _h5requestParams.productId = dataEntity.productId;
        
        //如果只有话费支付，直接发送验证码
        if ([dataEntity.payType isEqualToString:@"PHONE"]) {
            self.sectionCount = 3;
            SJPhoneFarePayCell *cell = [self.OrderInfoTableview cellForRowAtIndexPath:self.currentPayTypeIndexPath];
            [cell getCodeAction:nil];
        }
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        //        [MBProgressHUD showMessag:@"" toView:self.view];
        [MBProgressHUD show:nil icon:nil view:self.view];
        [_viewmodel confirmPayDealByPhoneFare:_params2];
    }
}

-(void)PhoneFare_makeDealResopnse:(BOOL)success withData:(PhoneFareResponse *)data{
    [MBProgressHUD hideHUD];
    if ([data.isNeedSmsCode isEqualToString:@"1"]) {
        _params2.linkId = data.linkId;
        //[_viewmodel confirmPayDealByPhoneFare:_params2];
        //_viewmodel
        //[self payDeal];
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"连续包月" message:@"确认开通连续包包月业务？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 0;
        [alert show];
        
    }else{
        /*
         smsCodeParams *params = [smsCodeParams new];
         params.linkId = data.linkId;
         [_viewmodel getSmsCode:params];*/
        _params2.linkId = data.linkId;
       // [self payDeal];
        
    }
    
}


-(void)PhoneFare_payDealResponse:(BOOL)response{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    if (response==YES) {
        SJPayFinishViewController *payFinishVC = [[SJPayFinishViewController alloc]init];
        payFinishVC.productServiceID = self.productEntity.serviceId ;
        payFinishVC.productEntity = self.productEntity;
        payFinishVC.recommArray = self.recommArray;
        [self.navigationController pushViewController:payFinishVC animated:YES];
    }
}

-(void)HandPhoneFareError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showError:[error localizedDescription] toView:self.view];
}
-(void)receiveH5PayParams:(H5PayParams *)params{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    if ([params.result isEqualToString:@"PAY-000"]) {
        H5PayViewController *H5PayView = [[H5PayViewController alloc]init];
        H5PayView.payParams = params;
        //params.redirectUrl = @"http://183.213.31.9:61004/wps/service/WapFormTrans.xhtml";
        //params.sessionId = @"20170329201506090029734527186278";
        H5PayView.dictParams = self.productEntity;
        H5PayView.recommArray = _recommArray;
        H5PayView.orderNoString = _sequenceId;
        H5PayView.merchantCodeString = self.merchantCodeString;
        H5PayView.fromOrderPay = NO;
        
        [self.navigationController pushViewController:H5PayView animated:YES];
    }else{
        [MBProgressHUD showError:params.detailMessage toView:self.view];
    }
    
}
-(void)PhoneFare_receiveSmsCode:(BOOL)codesuccess{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showSuccess:@"验证码已发送" toView:self.view];
    
}


#pragma mark SJPhoneFarePayCellDelegate
-(void)noticeLinkId:(NSString *)linkId{
    self.params2.linkId = linkId;
}
-(void)payFinished{
    SJPayFinishViewController *payFinishVC = [[SJPayFinishViewController alloc]init];
    payFinishVC.productServiceID = self.productEntity.serviceId ;
    payFinishVC.productEntity = self.productEntity;
    payFinishVC.recommArray = self.recommArray;
    [self.navigationController pushViewController:payFinishVC animated:YES];
}
@end
