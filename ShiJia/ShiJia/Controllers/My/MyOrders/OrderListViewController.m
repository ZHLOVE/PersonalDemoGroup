//
//  OrderListViewController.m
//  ShiJia
//
//  Created by 蒋海量 on 16/9/1.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "OrderListViewController.h"
#import "SJVideoDetailSegmentedControl.h"
#import "OrderListTableViewCell.h"
#import "PayInfoViewController.h"
#import "OrderDetailViewController.h"
#import "OrderEntity.h"
#import "SJMultiVideoDetailViewController.h"
#import "WatchListEntity.h"
#import "SJPayViewController.h"
#import "SJIAPManager.h"
#import "SJVIPNetWork.h"
#import "SJPurchaseModel.h"
#import "SJVIPViewController.h"
#import "BIMSManager.h"
#import "SJPayFinishViewController.h"
#import "SJChoosePayTypeViewController.h"
#import "SJPayDetailViewController.h"

typedef enum : NSUInteger {
    OrderListALL,
    OrderListPAID,
    OrderListPEND
} OrderType;

@interface OrderListViewController ()<OrderListTableViewCellDelegate,SJIAPManagerDelegate>
@property (nonatomic, assign) OrderType orderType;
@property (nonatomic, strong) SJVideoDetailSegmentedControl *segmentedControl;   //分段开关
@property(nonatomic,weak) IBOutlet UITableView *contentTabView;
@property (nonatomic, assign) BOOL editing;
@property (strong, nonatomic) UIButton* editButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteAllButton;
@property (nonatomic, retain) NSMutableArray *selectedIndexs;


@property (nonatomic, strong) NSMutableArray *orderALLArray;
@property (nonatomic, strong) NSMutableArray *orderPAIDArray;
@property (nonatomic, strong) NSMutableArray *orderPENDArray;

@property (nonatomic, strong) NSMutableArray *currentArray;

@property (nonatomic, strong) NSString *currentSequenceId;//当前的流水单号
@property (nonatomic, strong) NSString *currentProductId;//当前的产品编号
@property (nonatomic, strong) NSString *serviceId;

@property (strong, nonatomic)  UIView *defaultView;

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationController.navigationBarHidden = YES;
    
    self.title = @"我的订单";
    [self initNavigationView];
    
    [self initUI];
    self.selectedIndexs = [NSMutableArray new];
    
    // 下拉刷新
    __weak __typeof(self)weakSelf = self;
    self.contentTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //if (self.orderType == OrderListALL) {
            [strongSelf findAllOrdersRequest];
        //}
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
   // self.defaultView.hidden = NO;
    [self.contentTabView.mj_header beginRefreshing];

}

-(void)initUI{
    _segmentedControl = [[SJVideoDetailSegmentedControl alloc] initWithItems:@[@"全部订单",@"已支付",@"未支付"]];
    _segmentedControl.frame = CGRectMake(0, 64, W, 42);
    _segmentedControl.activeController = self;
    [_segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
    
    //self.contentTabView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    self.contentTabView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W, CGFLOAT_MIN)];

    _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editButton addTarget:self
                    action:@selector(p_updateEditing)
          forControlEvents:UIControlEventTouchUpInside];
    [_editButton setTitleColor:kNavTitleColor forState:UIControlStateNormal];
    [self.editButton setTitle:@"删除" forState:UIControlStateNormal];
    _editButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    _editButton.frame = CGRectMake(W-70, 20, 60, 44);
    
    [self.view addSubview:_editButton];
    _editButton.hidden = YES;
    
    self.editing = NO;
    [self setEditing:NO animated:NO];
}
-(void)setEditing:(BOOL)editing{
    _editing = editing;
    if (editing) {
        [self.editButton setImage:nil forState:UIControlStateNormal];
        [self.editButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.deleteAllButton setHidden:NO];
    }else{
        [self.editButton setTitle:@"删除" forState:UIControlStateNormal];
        [self.deleteAllButton setHidden:YES];
    }
}
//- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
//    [super setEditing:editing animated:animated];
//    // [self.tableView setEditing:editing animated:animated];
//    if (editing) {
//        [self.editButton setImage:nil forState:UIControlStateNormal];
//        [self.editButton setTitle:@"取消" forState:UIControlStateNormal];
//        [self.deleteAllButton setHidden:NO];
//    }else{
//        [self.editButton setTitle:@"删除" forState:UIControlStateNormal];
//        [self.deleteAllButton setHidden:YES];
//    }
//}
-(UIView *)defaultView{
    if (!_defaultView) {
        /*_defaultView = [[UIView alloc]initWithFrame:CGRectMake(W/2-45, 180, 90, 150)];
        _defaultView.backgroundColor = [UIColor clearColor];
        
        UIImageView *zwddImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
        zwddImg.image = [UIImage imageNamed:@"zwdd"];
        [_defaultView addSubview:zwddImg];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 90, 30)];
        lab.backgroundColor = [UIColor clearColor];
        lab.text = @"暂无订单";
        lab.textColor = [UIColor lightGrayColor];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentCenter;
        [_defaultView addSubview:lab];
        
        
        [self.view addSubview:_defaultView];*/
        
        
        
        
        _defaultView = [UIView new];
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zwdd"]];
        [_defaultView addSubview:imageV];
        
        
        UILabel *label =[UILabel new];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = 1;
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"暂无订单";
        [_defaultView addSubview:label];
        
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_defaultView);
            make.size.mas_equalTo(CGSizeMake(85, 85));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_defaultView);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(imageV.mas_bottom).offset(10);
        }];
        
        [self.view addSubview:_defaultView];
        [_defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(200, 120));
            make.top.mas_equalTo(self.view).offset(220);
        }];
    }
    
    return _defaultView;
}
#pragma mark - Event
- (void)segmentedControlValueChanged:(id)sender
{
    if (_segmentedControl.selectedSegmentIndex == 0) {
        self.orderType = OrderListALL;
        if (self.orderALLArray.count==0) {
            self.defaultView.hidden = NO;
        }
        else{
            self.defaultView.hidden = YES;
        }
    }
    else if (_segmentedControl.selectedSegmentIndex == 1){
        self.orderType = OrderListPAID;
        if (self.orderPAIDArray.count==0) {
            self.defaultView.hidden = NO;
        }
        else{
            self.defaultView.hidden = YES;
        }
    }
    else{
        self.orderType = OrderListPEND;
        if (self.orderPENDArray.count==0) {
            self.defaultView.hidden = NO;
        }
        else{
            self.defaultView.hidden = YES;
        }
    }
    [self.contentTabView reloadData];
}
#pragma mark - private
- (void)p_updateEditing{
    //    [self setEditing:!self.editing animated:YES];
    self.editing = !self.editing;
    if (self.editing) {
        [self.editButton setImage:nil forState:UIControlStateNormal];
        [self.editButton setTitle:@"取消" forState:UIControlStateNormal];
        self.deleteAllButton.hidden = NO;
    }else{
        [self.editButton setTitle:@"删除" forState:UIControlStateNormal];
        self.deleteAllButton.hidden = YES;
    }
    [self.contentTabView reloadData];
    
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
    return self.currentArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 190;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"OrderListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.m_delegate = self;
    
    if (self.editing) {
        cell.imageLeftLayout.constant = 40;
        [cell.selectBtn setHidden:NO];
        if ([self.selectedIndexs containsObject:indexPath]) {
            [cell.selectBtn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
        }
        else{
            [cell.selectBtn setImage:[UIImage imageNamed:@"contact_list_uncheck"] forState:UIControlStateNormal];
        }
        
    }
    else
    {
        cell.imageLeftLayout.constant = 0;
        [cell.selectBtn setHidden:YES];
    }
    OrderEntity *entity = self.currentArray[indexPath.section];
    cell.entity = entity;
    
    cell.priceLab.text = [NSString stringWithFormat:@"¥ %.2f",[entity.payPrice floatValue]];
    
    if ([entity.businessType isEqualToString:@"VIDEO"]) {//影片单点
        [cell.logoImg setImageWithURL:[NSURL URLWithString:entity.imgAddr] placeholderImage:[UIImage imageNamed:@"dpgmdefault"]];
        cell.titleLab.text = @"单片购买";
        cell.contentNameLab.text = entity.contentName;
        
        if ([entity.state isEqualToString:@"PEND"]) {
            cell.leftBtn.hidden = NO;
            cell.statusLab.text = @"待支付";
            [cell.leftBtn setImage:[UIImage imageNamed:@"shikan"] forState:UIControlStateNormal];
            [cell.rightBtn setImage:[UIImage imageNamed:@"zhifu"] forState:UIControlStateNormal];
            cell.dateLab.text = @"";
            cell.endTimeLab.text = @"";
        }
        else if ([entity.state isEqualToString:@"PAID"]||[entity.state isEqualToString:@"REFUND"]){
            cell.leftBtn.hidden = YES;
            if ([entity.state isEqualToString:@"PAID"]) {
                cell.statusLab.text = @"已订购";
            }
            else{
                cell.statusLab.text = @"已退订";
                
            }
            if ([entity.isExpire isEqualToString:@"YES"]) {
                [cell.rightBtn setImage:[UIImage imageNamed:GoumaiImage] forState:UIControlStateNormal];
            }
            else{
                [cell.rightBtn setImage:[UIImage imageNamed:@"guankan"] forState:UIControlStateNormal];
            }
            cell.dateLab.text = [NSString stringWithFormat:@"剩余有效期:%@",entity.expireNum];
            cell.endTimeLab.text = [NSString stringWithFormat:@"有效期至:%@",entity.endTime];
            
        }
        else{
            cell.leftBtn.hidden = YES;
            cell.statusLab.text = @"交易关闭";
            [cell.rightBtn setImage:[UIImage imageNamed:GoumaiImage] forState:UIControlStateNormal];
            cell.dateLab.text = @"";
            cell.endTimeLab.text = @"";
        }
    }
    else{
        [cell.logoImg setImageWithURL:[NSURL URLWithString:entity.imgAddr] placeholderImage:[UIImage imageNamed:@"hygmdefault"]];
        cell.titleLab.text = @"会员购买";
        cell.contentNameLab.text = entity.productName;
        
        cell.leftBtn.hidden = YES;
        if ([entity.state isEqualToString:@"PEND"]) {
            cell.statusLab.text = @"待支付";
            [cell.rightBtn setImage:[UIImage imageNamed:@"zhifu"] forState:UIControlStateNormal];
            cell.dateLab.text = @"";
            cell.endTimeLab.text = @"";
        }
        else if ([entity.state isEqualToString:@"PAID"]||[entity.state isEqualToString:@"REFUND"]){
            cell.leftBtn.hidden = YES;

            [cell.rightBtn setImage:[UIImage imageNamed:GoumaiImage] forState:UIControlStateNormal];
            
            if ([entity.state isEqualToString:@"PAID"]) {
                cell.statusLab.text = @"已订购";
            }
            else{
                cell.statusLab.text = @"已退订";
                
            }
            cell.dateLab.text = [NSString stringWithFormat:@"剩余有效期:%@",entity.expireNum];
            cell.endTimeLab.text = [NSString stringWithFormat:@"有效期至:%@",entity.endTime];
            
        }
        else{
            cell.statusLab.text = @"交易关闭";
            [cell.rightBtn setImage:[UIImage imageNamed:GoumaiImage] forState:UIControlStateNormal];
            cell.dateLab.text = @"";
            cell.endTimeLab.text = @"";
        }
        if ([entity.businessType isEqualToString:@"GAME"]){
            cell.titleLab.text = @"游戏购买";
            cell.leftBtn.hidden = YES;
            cell.rightBtn.hidden = YES;
        }
        
    }
    if ([entity.isCmsProduct isEqualToString:@"NO"]) {
        cell.leftBtn.hidden = YES;
        cell.rightBtn.hidden = NO;
        [cell.rightBtn setImage:[UIImage imageNamed:@"chakan"] forState:UIControlStateNormal];
    }
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.editing) {
        OrderListTableViewCell *cell = (OrderListTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        if ([self.selectedIndexs containsObject:indexPath]) {
            [cell.selectBtn setImage:[UIImage imageNamed:@"contact_list_uncheck"] forState:UIControlStateNormal];
            [self.selectedIndexs removeObject:indexPath];
        }
        else{
            [cell.selectBtn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
            [self.selectedIndexs addObject:indexPath];
        }
    }
    else{
        OrderDetailViewController *payInfoVC = [[OrderDetailViewController alloc]init];
        OrderEntity *entity = self.currentArray[indexPath.section];
        payInfoVC.orderEntity = entity;
        [self.navigationController pushViewController:payInfoVC animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)deleteOrdersBtnClick:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"删除订单" message:@"确定删除订单？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSMutableArray *selectedIdsArray = [NSMutableArray array];
        for (NSIndexPath *indexPath in self.selectedIndexs) {
            OrderEntity *entity = self.currentArray[indexPath.section];
            [selectedIdsArray addObject:entity.sequenceId];
        }
        [self deleteOrdersRequest:selectedIdsArray];
    }
}
#pragma -mark OrderListTableViewCellDelegate
//观看｜试看
- (void)watchVideo:(OrderEntity *)entity{
    SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
    detailVC.videoID = entity.contentId;
    WatchListEntity *watchListEntity = [[WatchListEntity alloc]init];
    watchListEntity.setNumber = @"";
    detailVC.watchEntity = watchListEntity;
    [self.navigationController pushViewController:detailVC animated:YES];
}
//支付
- (void)payProduct:(OrderEntity *)entity{
    /*[MBProgressHUD showMessag:nil toView:nil];
    self.currentSequenceId = entity.sequenceId;
    self.currentProductId = entity.productId;
    [SJIAPManager sharedManager].delegate = self;
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
    chooseTypeViewController.merchantCodeString = entity.merchantCode;
    chooseTypeViewController.dictParams = productEntity;
    chooseTypeViewController.recommArray = nil;
    chooseTypeViewController.fromOrderVC = YES;
    [self.navigationController pushViewController:chooseTypeViewController animated:YES];


}
//购买
- (void)orderProduct:(OrderEntity *)entity{
    /*SJPayViewController *payVC = [[SJPayViewController alloc]initWithNibName:@"SJPayViewController" bundle:nil];
     ProductEntity *productEntity = [ProductEntity new];
     productEntity.productId = entity.productId;
     productEntity.name = entity.productName;
     productEntity.price = entity.price;
     productEntity.payPrice = entity.payPrice;
     productEntity.endTime = entity.endTime;
     productEntity.businessType = entity.businessType;
     
     payVC.productEntity = productEntity;
     UINavigationController *payNav = [[UINavigationController alloc] initWithRootViewController:payVC];
     [self presentViewController:payNav animated:YES completion:nil];*/
    if ([entity.businessType isEqualToString:@"VIDEO"]) {//影片单点
        [self queryPriceRequest:entity.contentId];
    }
    else{
        SJVIPViewController *VIPVC =[[SJVIPViewController alloc]initWithNibName:@"SJVIPViewController" bundle:nil];
        [self.navigationController pushViewController:VIPVC animated:YES];
    }
}
//退订
- (void)refundOrderProduct:(OrderEntity *)entity{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:entity.sequenceId forKey:@"orderNo"];
    [parameters setValue:entity.merchantCode forKey:@"merchantCode"];
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
            [self performSelector:@selector(findAllOrdersRequest) withObject:nil afterDelay:1.0];
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
- (void)queryCPProduct:(OrderEntity *)entity{
    SJPayDetailViewController *payDetailVC = [[SJPayDetailViewController alloc]init];
    ProductEntity *productEntity = [ProductEntity new];
    productEntity.productId = entity.productId;
    productEntity.name = entity.productName;
    productEntity.price = entity.price;
    productEntity.payPrice = entity.payPrice;
    productEntity.endTime = entity.endTime;
    productEntity.businessType = entity.businessType;
    productEntity.isCmsProduct = entity.isCmsProduct;
    productEntity.cpCode = entity.cpCode;
    productEntity.cpName = entity.cpName;
    productEntity.cpImageAdd = entity.cpImageAdd;

    payDetailVC.productEntity = productEntity;
    [self.navigationController pushViewController:payDetailVC animated:YES];
}
#pragma -mark 查询订单列表
-(NSMutableArray *)orderALLArray{
    if (!_orderALLArray) {
        _orderALLArray = [NSMutableArray array];
    }
    return _orderALLArray;
}
-(NSMutableArray *)orderPAIDArray{
    if (!_orderPAIDArray) {
        _orderPAIDArray = [NSMutableArray array];
    }
    return _orderPAIDArray;
}
-(NSMutableArray *)orderPENDArray{
    if (!_orderPENDArray) {
        _orderPENDArray = [NSMutableArray array];
    }
    return _orderPENDArray;
}
-(NSMutableArray *)currentArray{
    NSMutableArray *tempArray = nil;
    if (self.orderType == OrderListALL) {
        tempArray = _orderALLArray;
    }
    else if(self.orderType == OrderListPAID){
        tempArray = _orderPAIDArray;
    }
    else{
        tempArray = _orderPENDArray;
    }

    return tempArray;
}

-(void)findAllOrdersRequest
{
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    // [parameters setValue:@"hanks-uid" forKey:@"uid"];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    
    //[parameters setValue:@"VIDEO" forKey:@"businessType"];
    //[parameters setValue:@"2015" forKey:@"beginTime"];
    //[parameters setValue:@"2016" forKey:@"endTime"];
    [parameters setValue:@"PHONE" forKey:@"source"];
    
    [parameters setValue:@"1" forKey:@"pageNo"];
    [parameters setValue:@"50" forKey:@"pageSize"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [BaseAFHTTPManager postRequestOperationForHost:BUSINESSHOST forParam:@"/order/findAllOrders" forParameters:parameters  completion:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];

        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"result"];
        if ([code isEqualToString:@"ORD-000"]) {
            NSMutableArray *tempAllArray = [NSMutableArray array];
            NSMutableArray *tempPAIDArray = [NSMutableArray array];
            NSMutableArray *tempPENDArray = [NSMutableArray array];
            
            NSArray *productlist = responseDic[@"orderList"];
            for (NSDictionary *dic in productlist) {
                OrderEntity *entity = [[OrderEntity alloc]initWithDictionary:dic];
                entity.merchantCode = responseDic[@"merchantCode"];
                if ([entity.state isEqualToString:@"PAID"]) {
                    [tempPAIDArray addObject:entity];
                }
                else /*if ([entity.state isEqualToString:@"PEND"])*/{
                    [tempPENDArray addObject:entity];
                }
                [tempAllArray addObject:entity];
            }
            self.orderALLArray = tempAllArray;
            self.orderPAIDArray = tempPAIDArray;
            self.orderPENDArray = tempPENDArray;
            
            if (self.orderALLArray.count==0) {
                self.defaultView.hidden = NO;
                _editButton.hidden = YES;
            }
            else{
                self.defaultView.hidden = YES;
                _editButton.hidden = NO;
            }
            
            [self.contentTabView reloadData];
        }
        [self.contentTabView.mj_header endRefreshing];

    }failure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.contentTabView.mj_header endRefreshing];
    }];
}
//删除选中订单
-(void)deleteOrdersRequest:(NSMutableArray *)array
{
    NSString *sequenceIds = [array componentsJoinedByString:@","];
    
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:sequenceIds forKey:@"sequenceIds"];
    [parameters setValue:@"" forKey:@"token"];
    
    [BaseAFHTTPManager postRequestOperationForHost:BUSINESSHOST forParam:@"/phone/order/deleteOrders" forParameters:parameters  completion:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSString *code = [responseDic objectForKey:@"result"];
        if ([code isEqualToString:@"ORD-000"]) {
            [OMGToast showWithText:@"删除成功"];
            [self.selectedIndexs removeAllObjects];
            self.editing = NO;
            [self findAllOrdersRequest];
        }
        else{
            [OMGToast showWithText:@"删除失败"];
        }
    }failure:^(NSString *error) {
        
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

#pragma mark - Navigation
#pragma mark - ****************Delegate
- (void)receiveProduct:(SKProduct *)product {
//    [MBProgressHUD hideHUDForView:nil animated:YES];
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
