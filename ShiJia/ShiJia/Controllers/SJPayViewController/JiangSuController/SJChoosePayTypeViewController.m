//
//  SJChoosePayTypeViewController.m
//  ShiJia
//
//  Created by 峰 on 2016/12/14.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJChoosePayTypeViewController.h"
#import "SJPayTypeCell.h"
#import "SJCouponCell.h"
#import "SJMoneyCell.h"
#import "SJVertifyCodeViewController.h"
#import "SJPhoneFareModel.h"
#import "SJPhoneFareViewModel.h"
#import "SJIAPManager.h"
#import "SJPurchaseModel.h"
#import "SJVIPNetWork.h"
#import "SJPayFinishViewController.h"
#import "SwitchBtn.h"
#import "H5PayViewController.h"


@interface SJChoosePayTypeViewController ()<UITableViewDelegate,UITableViewDataSource,PhoneFareDelegate,SJIAPManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *payTypeTableView;
@property (nonatomic, strong) SJPhoneFareViewModel *viewmodel;
@property (nonatomic, strong) PayRequestParam *params1;
@property (nonatomic, strong) confirmRequsetParams *params2;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *currentSequenceId;//当前的流水单号
@property (nonatomic, strong) requestH5Params *h5requestParams;
@end

@implementation SJChoosePayTypeViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
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



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择支付方式";
    [self registerCell];
    [self bindViewMolde];
    _params1 = self.params1;
    _params2 = self.params2;
    [_viewmodel GetOrderDetailWithSequenceId:_sequenceId];
    [SJIAPManager sharedManager].delegate = self;

}

-(void)bindViewMolde{

    _viewmodel  = [SJPhoneFareViewModel new];
    _viewmodel.phonefaredelegate = self;

}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = NO;

}
- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];

}
-(void)registerCell{
    self.payTypeTableView.tableHeaderView = [UIView new];
    [self.payTypeTableView registerNib:[UINib nibWithNibName:@"SJMoneyCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.payTypeTableView registerNib:[UINib nibWithNibName:@"SJPayTypeCell" bundle:nil] forCellReuseIdentifier:@"cell2"];

}

#pragma  mark -tableView  Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{


    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return _dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:
            return 60.;
            break;
        case 1:
            return 50.;
            break;

        default:
            return 0;
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {

        case 0:{
            SJMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.priceLabel.text = [NSString stringWithFormat:@"¥ %@",self.dictParams.payPrice];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }
            break;
        case 1:{
            SJPayTypeCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            NSString *stringType = [_dataArray objectAtIndex:indexPath.row];
            if ([stringType isEqualToString:@"PHONE"]) {
                cell.imageView.image = [UIImage imageNamed:@"phonefare_1"];
                cell.textLabel.text = @"话费支付";
            }else if ([stringType isEqualToString:@"ALIPAY"]){
                cell.imageView.image = [UIImage imageNamed:@"phonefare_2"];
                cell.textLabel.text = @"支付宝支付";
            }else if ([stringType isEqualToString:@"WEIXIN"]){
                cell.imageView.image = [UIImage imageNamed:@"phonefare_3"];
                cell.textLabel.text = @"微信支付";
            }else if ([stringType isEqualToString:@"APPSTORE"]){
                cell.imageView.image = [UIImage imageNamed:@"phonefare_4"];
                cell.textLabel.text = @"AppStore支付";
            }else if ([stringType isEqualToString:@"H5PAY"]){
                cell.imageView.image = [UIImage imageNamed:@"phonefare_5"];
                cell.textLabel.text = @"电商支付";
            }
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

        case 1:{
            NSString *stringType = [_dataArray objectAtIndex:indexPath.row];
            if ([stringType isEqualToString:@"PHONE"]) {
                [MBProgressHUD showMessag:nil toView:self.view];
                [_viewmodel payDealByPhoneFare:_params1];

            }else if ([stringType isEqualToString:@"ALIPAY"]){

            }else if ([stringType isEqualToString:@"WEIXIN"]){

            }else if ([stringType isEqualToString:@"APPSTORE"]){
                [MBProgressHUD showMessag:@"加载中" toView:nil];
                [[SJIAPManager sharedManager] requestProductWithId:_params1.productId];

            }else if ([stringType isEqualToString:@"H5PAY"]){
                [MBProgressHUD showMessag:@"请求支付" toView:self.view];
                [_viewmodel PhoneFare_receiveH5PayParams:_h5requestParams];
               /*H5PayViewController *H5PayView = [[H5PayViewController alloc]init];
                H5PayParams *params = [H5PayParams new];
                params.redirectUrl = @"http://183.213.31.9:61004/wps/service/WapFormTrans.xhtml";
                params.sessionId = @"20170407201506210030100393267620";
                H5PayView.payParams = params;
                [self.navigationController pushViewController:H5PayView animated:YES];*/

            }

        }
            break;

        default:
            break;
    }

}

-(void)initNavgationRightItem{

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.backgroundColor =[UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];

    [button addTarget:self
               action:@selector(backAction:)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}


-(void)backAction:(id)sender{

    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)payDeal{
    SJVertifyCodeViewController *vertifyCodeViewController = [[SJVertifyCodeViewController alloc]initWithNibName:@"SJVertifyCodeViewController" bundle:nil];
    vertifyCodeViewController.stringID = _params2.linkId;
    vertifyCodeViewController.dictParams = _dictParams;
    vertifyCodeViewController.recommArray = _recommArray;
    [self.navigationController pushViewController:vertifyCodeViewController animated:YES];

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
            [self.dataArray addObject:@"APPSTORE"];
        }else{
            self.dataArray = temp;
        }

        for (NSString *name in _dataArray) {
            if ([name isEqualToString:@"WEIXIN"]) {
                [_dataArray removeObject:name];
            }

            if ([name isEqualToString:@"ALIPAY"]) {
                [_dataArray removeObject:name];
            }
        }
        [self.payTypeTableView reloadData];
//构建h5支付页面请求参数
        _h5requestParams = self.h5requestParams;
       //!!!: 测试价格为1分钱
        _h5requestParams.totalAmount = [dataEntity.payPrice integerValue]*100;
       // _h5requestParams.totalAmount = 1;
        _h5requestParams.productName = dataEntity.productName;
        //_h5requestParams.productName = @"name";
        _h5requestParams.productId = dataEntity.productId;
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
        [self payDeal];

    }

}


-(void)PhoneFare_payDealResponse:(BOOL)response{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    if (response==YES) {
        SJPayFinishViewController *payFinishVC = [[SJPayFinishViewController alloc]init];
        payFinishVC.productServiceID = _dictParams.serviceId ;
        payFinishVC.productEntity = _dictParams;
        payFinishVC.recommArray = self.recommArray;
        [self.navigationController pushViewController:payFinishVC animated:YES];
    }
}

-(void)HandPhoneFareError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showError:[error localizedDescription] toView:self.view];
}

#pragma mark - ****************Delegate

- (void)receiveProduct:(SKProduct *)product {
    [MBProgressHUD hideHUD];
//product
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
    [MBProgressHUD hideHUD];
    if ([transactionReceiptString length] > 0) {
        APPStoreVerModel *model = [APPStoreVerModel new];
        model.receipt = transactionReceiptString;
        model.productId =_dictParams.productId;
        model.uid = [HiTVGlobals sharedInstance].uid;
        model.sequenceId = [NSString stringWithFormat:@"%@_%@",self.merchantCodeString,_sequenceId];
        [SJVIPNetWork SJ_ValiteAppleStore:model Block:^(id result, NSString *error) {
            if (error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:error toView:nil];
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                ServerVerModel *model = [ServerVerModel mj_objectWithKeyValues:result];
                if ([model.result isEqualToString:@"PAY-000"]) {
                    SJPayFinishViewController *payFinishVC = [[SJPayFinishViewController alloc]init];
                    payFinishVC.productServiceID = _dictParams.serviceId ;
                    payFinishVC.productEntity = _dictParams;
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
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"失败" message:errorDescripiton delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)receiveH5PayParams:(H5PayParams *)params{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    if ([params.result isEqualToString:@"PAY-000"]) {
        H5PayViewController *H5PayView = [[H5PayViewController alloc]init];
        H5PayView.payParams = params;
        //params.redirectUrl = @"http://183.213.31.9:61004/wps/service/WapFormTrans.xhtml";
        //params.sessionId = @"20170329201506090029734527186278";
        H5PayView.dictParams = _dictParams;
        H5PayView.recommArray = _recommArray;
        H5PayView.orderNoString = _sequenceId;
        H5PayView.merchantCodeString = self.merchantCodeString;
        H5PayView.fromOrderPay = self.fromOrderVC;

        [self.navigationController pushViewController:H5PayView animated:YES];
    }else{
       [MBProgressHUD showError:params.detailMessage toView:self.view];
    }

}


@end
