//
//  SJPayDetailViewController.m
//  ShiJia
//
//  Created by 蒋海量 on 2017/5/27.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "SJPayDetailViewController.h"
#import "SJChoosePayTypeViewController.h"
#import "SJIAPManager.h"
#import "SJPurchaseModel.h"
#import "SJVIPNetWork.h"
#import "SJPayFinishViewController.h"
#import "VideoCollectionViewCell.h"
#import "VideoCategory.h"
#import "SJMultiVideoDetailViewController.h"
#import "WatchListEntity.h"

@interface SJPayDetailViewController ()<SJIAPManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;

@property (nonatomic, strong) NSString *currentSequenceId;//当前的流水单号
@property (nonatomic, strong) NSString *currentProductId;//当前的产品编号

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray* videosArray;
@property (strong, nonatomic) NSArray* temp;
@property (nonatomic) BOOL hasMore;
@property (nonatomic) BOOL loading;
@property (nonatomic) int nextPageNumber;
@end

@implementation SJPayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"产品包订阅";
    self.navigationController.navigationBarHidden = NO;
    [SJIAPManager sharedManager].delegate = self;
    [self initUI];
    
    if ([self.productEntity.businessType isEqualToString:@"VIDEO"]) {//影片单点
        [self.goodsImage setImageWithURL:[NSURL URLWithString:self.productEntity.imgAddr] placeholderImage:[UIImage imageNamed:@"dpgmdefault"]];
    }
    else{
        [self.goodsImage setImageWithURL:[NSURL URLWithString:self.productEntity.imgAddr] placeholderImage:[UIImage imageNamed:@"hygmdefault"]];
    }
    self.goodsName.text = self.productEntity.name;
    self.goodsPrice.text = [NSString stringWithFormat:@"¥ %@",self.productEntity.payPrice];
    self.currentProductId = self.productEntity.productId;

}
-(void)initUI{
    [self.collectionView registerNib:[UINib nibWithNibName:cVideoCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:cVideoCollectionViewCellID];
    self.collectionView.alwaysBounceVertical = YES;
    
    
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self p_refresh];
    }];
    
    // 上拉加载更多
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self p_loadMore];
    }];

    [self p_refresh];
}
-(IBAction)payClick:(id)sender{
    [self orderCreateRequest];
}
#pragma mark - private methods

- (void)p_reloadData{
    [self.collectionView reloadData];
}



- (void)p_refresh{
    __weak __typeof(self)weakSelf = self;
    self.loading = YES;
    
    [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    NSString* url = [NSString stringWithFormat:@"%@/epg/findPsListByCp.shtml?cpCode=%@&start=%d&limit=20&abilityString=%@",FUSE_EPG,self.productEntity.cpCode, 0,T_STBext];
    
    /*url = [NSString stringWithFormat:@"%@/epg/findPsListByCp.shtml?ppvCode=%@&start=%d&limit=20&abilityString=%@",@"http://192.168.13.43:8080/ysten-cos-api/",@"200000904", 0,@"{%22deviceGroupIds%22:[%22842%22],%22userGroupIds%22:[],%22districtCode%22:%22360100%22,%22abilities%22:[%224K-1|cp-TENCENT%22,%224K-1%22],%22businessGroupIds%22:[]}"];*/
    
    [BaseAFHTTPManager getRequestOperationForHost:url forParam:@"" forParameters:nil completion:^(id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.collectionView animated:YES];
        
        NSArray* categories = responseObject[@"content"][@"data"];
        int currentPageNumber = 0;
        
        strongSelf.videosArray = [NSMutableArray arrayWithArray:[strongSelf p_parseVideos:categories]];
        strongSelf.hasMore = YES;
        strongSelf.nextPageNumber = currentPageNumber + 1;
        [strongSelf p_reloadData];
        strongSelf.loading = NO;
        [strongSelf.collectionView.mj_header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.collectionView animated:YES];
        [strongSelf p_handleNetworkError];
        strongSelf.loading = NO;
        [strongSelf.collectionView.mj_header endRefreshing];
        strongSelf.nextPageNumber = 0;
    }];
    
}

- (NSArray*)p_parseVideos:(id)responseObject{
    NSMutableArray* returnMenus = [[NSMutableArray alloc] init];
    if ([responseObject isKindOfClass:[NSArray class]]) {
        for (NSDictionary* aMenu in responseObject) {
            [returnMenus addObject:[[VideoSummary alloc] initWithDict:aMenu]];
        }
    }else{
        // [returnMenus addObject:[[VideoSummary alloc] initWithDict:(NSDictionary*)responseObject]];
    }
    return returnMenus;
}
- (void)p_loadMore{
    __weak __typeof(self)weakSelf = self;
    if (self.nextPageNumber == 0) {
        [self.collectionView.mj_header beginRefreshing];
    }else{
        [self.collectionView.mj_footer endRefreshing];
        
    }
    
    [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    NSString* url = [NSString stringWithFormat:@"%@/epg/findPsListByCp.shtml?cpCode=%@&start=%d&limit=20&abilityString=%@",FUSE_EPG, self.productEntity.cpCode, self.nextPageNumber,T_STBext];
    
    
    [BaseAFHTTPManager getRequestOperationForHost:url forParam:@"" forParameters:nil completion:^(id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.collectionView animated:YES];
        
        NSArray* categories = responseObject[@"content"][@"data"];
        int currentPageNumber = self.nextPageNumber;
        
        if (strongSelf.nextPageNumber == 0) {
            [strongSelf.collectionView.mj_header endRefreshing];
            strongSelf.videosArray = [[NSMutableArray alloc] init];
        }else{
            [strongSelf.collectionView.mj_footer endRefreshing];
        }
        if (categories.count>0) {
            [strongSelf.videosArray addObjectsFromArray:[strongSelf p_parseVideos:categories]];
            
            strongSelf.hasMore = YES;
            strongSelf.nextPageNumber = currentPageNumber + 1;
            [strongSelf p_reloadData];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.collectionView animated:YES];
        if (strongSelf.nextPageNumber == 0) {
            [strongSelf.collectionView.mj_header endRefreshing];
        }else{
            
            [strongSelf.collectionView.mj_footer endRefreshing];
        }
        [strongSelf p_handleNetworkError];
    }];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.videosArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cVideoCollectionViewCellID forIndexPath:indexPath];
    cell.layer.cornerRadius = 3;
    cell.layer.borderColor = RGB(240, 237, 240, 1).CGColor;
    cell.layer.borderWidth = 1.0f;
    cell.layer.masksToBounds = YES;
    cell.video = self.videosArray[indexPath.row];
    return cell;
}


#pragma mark - UICollectionViewDelegate (GODETAIL 点播二级菜单)

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoSummary* video = self.videosArray[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
    detailVC.videoID = video.psId;
    [self.navigationController pushViewController:detailVC animated:YES];

}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(W/3-10,200);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0,12);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(7, 7, 7, 7);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2.0f;
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
            
            SJChoosePayTypeViewController *chooseTypeViewController =[[SJChoosePayTypeViewController alloc]initWithNibName:@"SJChoosePayTypeViewController" bundle:nil];
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
            [weakSelf.navigationController pushViewController:chooseTypeViewController animated:YES];
            
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
