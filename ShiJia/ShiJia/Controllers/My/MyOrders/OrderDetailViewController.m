//
//  OrderDetailViewController.m
//  ShiJia
//
//  Created by 蒋海量 on 16/9/2.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "PayDetailTableViewCell.h"
#import "OrderDetailEntity.h"
#import "SJMultiVideoDetailViewController.h"
#import "WatchListEntity.h"
#import "SJIAPManager.h"
#import "SJVIPNetWork.h"
#import "SJPurchaseModel.h"
#import "SJVIPViewController.h"
#import "SJPayViewController.h"
#import "BIMSManager.h"
#import "SJPayFinishViewController.h"
#import "SJChoosePayTypeViewController.h"

@interface OrderDetailViewController ()<PayDetailTableViewCellDelegate,SJIAPManagerDelegate>
@property(nonatomic,weak) IBOutlet UITableView *contentTabView;
@property(nonatomic,strong)  OrderDetailEntity *orderDetailEntity;

@property (nonatomic, strong) NSString *currentSequenceId;//当前的流水单号
@property (nonatomic, strong) NSString *currentProductId;//当前的产品编号
@property (nonatomic, strong) NSString *serviceId;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单详情";
    [self initNavigationView];
    [SJIAPManager sharedManager].delegate = self;
    [self initUI];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    

}

-(void)initUI{
    self.contentTabView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);

}
-(void)loadData{
    [self getOrderDetailRequest];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 286;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"PayDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.m_delegate = self;
    cell.entity = self.orderDetailEntity;
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark 查询订单详情
-(void)getOrderDetailRequest
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:self.orderEntity.sequenceId forKey:@"sequenceId"];
    [parameters setValue:@"" forKey:@"token"];
    
    
    [BaseAFHTTPManager postRequestOperationForHost:BUSINESSHOST forParam:@"/phone/order/getOrderDetail" forParameters:parameters  completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"result"];
        if ([code isEqualToString:@"ORD-000"]) {
            OrderDetailEntity *entity = [[OrderDetailEntity alloc]initWithDictionary:responseDic];
            entity.sequenceId = self.orderEntity.sequenceId;
            entity.expireNum = self.orderEntity.expireNum;
            entity.businessType = self.orderEntity.businessType;
            entity.state = self.orderEntity.state;
            entity.renewStatus = self.orderEntity.renewStatus;
            entity.custId = self.orderEntity.custId;

            self.orderDetailEntity = entity;
            [self.contentTabView reloadData];
        }
        
    }failure:^(NSString *error) {
        
    }];
}
#pragma -mark PayDetailTableViewCellDelegate
//观看｜试看
- (void)watchVideo:(OrderDetailEntity *)entity{
    SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
    detailVC.videoID = entity.contentId;
    WatchListEntity *watchListEntity = [[WatchListEntity alloc]init];
    watchListEntity.setNumber = @"";
    detailVC.watchEntity = watchListEntity;
    [self.navigationController pushViewController:detailVC animated:YES];
}
//支付
- (void)payProduct:(OrderDetailEntity *)entity{
    /*[MBProgressHUD showMessag:nil toView:nil];
    self.currentSequenceId = entity.sequenceId;
    self.currentProductId = entity.productId;
    self.serviceId = entity.serviceId;
    [[SJIAPManager sharedManager] requestProductWithId:self.serviceId];*/
    
    ProductEntity *productEntity = [ProductEntity new];
    productEntity.productId = entity.productId;
    productEntity.name = entity.productName;
    productEntity.price = entity.price;
    productEntity.payPrice = entity.payPrice;
    productEntity.endTime = entity.endTime;
    productEntity.businessType = entity.businessType;
    
    SJChoosePayTypeViewController *chooseTypeViewController =[[SJChoosePayTypeViewController alloc]initWithNibName:@"SJChoosePayTypeViewController" bundle:nil];
    chooseTypeViewController.sequenceId = entity.sequenceId;
    chooseTypeViewController.merchantCodeString = self.orderEntity.merchantCode;
    chooseTypeViewController.dictParams = productEntity;
    chooseTypeViewController.recommArray = nil;
    [self.navigationController pushViewController:chooseTypeViewController animated:YES];
}
//购买
- (void)orderProduct:(OrderDetailEntity *)entity{
    if ([entity.businessType isEqualToString:@"VIDEO"]) {//影片单点
        [self queryPriceRequest:entity.contentId];
    }
    else{
        SJVIPViewController *VIPVC =[[SJVIPViewController alloc]initWithNibName:@"SJVIPViewController" bundle:nil];
        [self.navigationController pushViewController:VIPVC animated:YES];
    }
}
//退订
- (void)refundOrderProduct:(OrderDetailEntity *)entity
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:entity.sequenceId forKey:@"orderNo"];
    [parameters setValue:self.orderEntity.merchantCode forKey:@"merchantCode"];
    [parameters setValue:entity.productId forKey:@"productId"];
    [parameters setValue:@"" forKey:@"token"];
    [parameters setValue:@"" forKey:@"spToken"];
    [parameters setValue:@"API" forKey:@"accessType"];
    [parameters setValue:@"" forKey:@"sign"];
    [parameters setValue:entity.custId forKey:@"custId"];
    
    [BaseAFHTTPManager postRequestOperationForHost:BUSINESSHOST forParam:@"/order/refundOrder.json" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *result = [responseDic objectForKey:@"result"];
        if ([result isEqualToString:@"PAY-000"]) {
            [MBProgressHUD show:@"退订成功" icon:@"img_success" view:nil];
            self.orderDetailEntity.renewStatus = @"CLOSE_RENEW";
            [self.contentTabView reloadData];
            //[self performSelector:@selector(getOrderDetailRequest) withObject:nil afterDelay:1.0];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"退订失败" message:@"发起退订失败，请稍后重试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    }failure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"退订失败" message:@"发起退订失败，请稍后重试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        
    }];
}
#pragma -mark 影片鉴权
-(void)queryPriceRequest:(NSString *)contentId
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    //[parameters setValue:TestUID forKey:@"uid"];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:@"VIDEO" forKey:@"businessType"];
    //[parameters setValue:self.videoID forKey:@"contentId"];
    [parameters setValue:contentId forKey:@"contentId"];
    [parameters setValue:[HiTVGlobals sharedInstance].phoneNo forKey:@"phone"];
    [parameters setValue:@"PHONE" forKey:@"source"];
    
    [parameters setValue:@"" forKey:@"token"];
    [parameters setValue:@"" forKey:@"deviceId"];
    [parameters setValue:@"" forKey:@"spToken"];
    
    
    [BaseAFHTTPManager postRequestOperationForHost:BUSINESSHOST forParam:@"/phone/queryPrice" forParameters:parameters  completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"result"];
        if ([code isEqualToString:@"ORD-000"]) {
            [OMGToast showWithText:@"无需购买"];
        }
        else if ([code isEqualToString:@"ORD-400"]){
            NSArray *productlist = responseDic[@"productlist"];
            NSMutableArray *productArray = [NSMutableArray array];

            for (NSDictionary *dic in productlist) {
                ProductEntity *entity = [[ProductEntity alloc]initWithDictionary:dic];
                entity.contentId = contentId;
                [productArray addObject:entity];
#ifdef BeiJing
                break;
#else
#endif
            }
            
            SJPayViewController *payVC = [[SJPayViewController alloc]initWithNibName:@"SJPayViewController" bundle:nil];
            payVC.productList = productArray;
            UINavigationController *payNav = [[UINavigationController alloc] initWithRootViewController:payVC];
            [self presentViewController:payNav animated:YES completion:nil];
        }
        else{
            [OMGToast showWithText:@"鉴权失败"];
        }
        
    }failure:^(NSString *error) {
        
    }];
}

- (void)receiveProduct:(SKProduct *)product {
    
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
//                    [[BIMSManager sharedInstance] queryPriceRequest];
                    SJPayFinishViewController *payFinishVC = [[SJPayFinishViewController alloc]init];
                    payFinishVC.productServiceID = self.serviceId ;
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

@end
