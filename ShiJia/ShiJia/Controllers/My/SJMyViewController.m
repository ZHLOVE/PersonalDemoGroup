//
//  SJMyViewController.m
//  ShiJia
//
//  Created by yy on 16/2/2.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJMyViewController.h"
#import "SJRemoteControlViewController.h"
#import "SJMessageCenterViewController.h"
#import "MyFriendsController.h"
#import "MyDetailViewController.h"
#import "SJLoginViewController.h"
#import "RecentViewController.h"
#import "FavoriteViewController.h"
#import "QRCodeController.h"
#import "RelationDeviceController.h"
#import "SJSettingViewController.h"
#import "SJPayViewController.h"
#import "SJMyPhotoViewController.h"
#import "OrderListViewController.h"
#import "SJVIPViewController.h"
#import "SJCouponViewController.h"
#import "UITabBar+badge.h"
#import "ShareAppViewController.h"

@interface SJMyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak) IBOutlet UIImageView *headView;
@property(nonatomic,weak) IBOutlet UIImageView *headImg;
@property(nonatomic,weak) IBOutlet UILabel *nameLab;
@property(nonatomic,weak) IBOutlet UIImageView *line;
@property(nonatomic,weak) IBOutlet UIImageView *topLine;
@property(nonatomic,weak) IBOutlet UITableView *contentTabView;
@property(nonatomic,weak) IBOutlet UIButton *vipBtn;
@property(nonatomic,weak) IBOutlet UILabel *msgNumLabel;
@property(nonatomic,weak) IBOutlet UILabel *marketingDescLabel;

@property(nonatomic,strong) NSArray *titleArray;
@property(nonatomic,strong) NSArray *imgArray;

@property(nonatomic,strong) NSMutableArray *titleArray2;
@property(nonatomic,strong) NSMutableArray *imgArray2;

@property(nonatomic,strong) NSArray *titleArray3;
@property(nonatomic,strong) NSArray *imgArray3;
@end

@implementation SJMyViewController

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    self.headView.backgroundColor = [UIColor whiteColor];
    self.line.backgroundColor = kTabLineColor;
    self.topLine.backgroundColor = kTabLineColor;
    self.contentTabView.separatorColor = kTabLineColor;
    self.contentTabView.backgroundColor = klightGrayColor;

    // self.headView.image = [UIImage imageNamed:@"combined"];


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_refreshAfterUserLogin:)
                                                 name:TPIMNotification_ReloadUser
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_refreshAfterUserLogin:)
                                                 name:TPIMNotification_VIPINFO
                                               object:nil];

   /* UIBarButtonItem *scanItem = [[UIBarButtonItem alloc] initWithImage:[[ UIImage imageNamed : @"扫一扫" ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(scan)];
    self.navigationItem.rightBarButtonItem = scanItem;*/

    //    UIBarButtonItem *remoteItem = [[UIBarButtonItem alloc] initWithImage:[[ UIImage imageNamed : @"遥控器" ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(remoteItem)];
    //self.navigationItem.leftBarButtonItem = remoteItem;
    if ([[HiTVGlobals sharedInstance].disable_moudles containsObject:@"vip"]) {
        self.vipBtn.hidden = YES;
        self.marketingDescLabel.hidden = YES;
    }
    else{
        self.vipBtn.hidden = NO;
        self.marketingDescLabel.hidden = NO;
    }
    _titleArray = @[@"最近观看",@"我的收藏",@"我的相册",@"家庭电视"];
    _imgArray = @[@"recentlogo",@"collectionlogo",@"albumlogo",@"wdqyq"];

    _titleArray2 = [NSMutableArray arrayWithObjects:@"我的订单",@"优惠券",@"推荐有礼", nil];
    _imgArray2 = [NSMutableArray arrayWithObjects:@"myorderlogo",@"yhq", @"tuijianyouli", nil];

    if ([[HiTVGlobals sharedInstance].disable_moudles containsObject:@"order"]) {
        [_titleArray2 removeObject:@"我的订单"];
        [_imgArray2 removeObject:@"myorderlogo"];
    }
    if ([[HiTVGlobals sharedInstance].disable_moudles containsObject:@"coupon"]) {
        [_titleArray2 removeObject:@"优惠券"];
        [_imgArray2 removeObject:@"yhq"];
    }
    if ([[HiTVGlobals sharedInstance].disable_moudles containsObject:@"award"]) {
        [_titleArray2 removeObject:@"推荐有礼"];
        [_imgArray2 removeObject:@"tuijianyouli"];
    }

    /*
     =======



     //江苏Taipan上线，隐藏vip相关
     if (1) {
     self.vipBtn.hidden = YES;
     self.marketingDescLabel.hidden = YES;
     [_titleArray2 removeObject:@"我的订单"];
     [_imgArray2 removeObject:@"myorderlogo"];
     [_titleArray2 removeObject:@"优惠券"];
     [_imgArray2 removeObject:@"yhq"];
     }

     [_titleArray2 addObject:@"推荐有礼"];
     [_imgArray2 addObject:@"tuijianyouli"];


     >>>>>>> c7140cd3... 江苏app无后台进程fix.
     */

    _titleArray3 = @[@"设置"];
    _imgArray3 = @[@"setlogo"];
    /*else{
     _titleArray = @[@"最近观看",@"我的收藏",@"我的相册",@"我的亲友圈",@"我的订单",@"优惠券",@"设置"];
     _imgArray = @[@"recentlogo",@"collectionlogo",@"albumlogo",@"wdqyq",@"myorderlogo",@"yhq",@"setlogo"];
     }*/
    self.contentTabView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    self.headImg.layer.cornerRadius = self.headImg.frame.size.height/2;
    self.headImg.layer.borderColor = UIColorHex(d8d8d8).CGColor;
    //self.headImg.layer.borderWidth = 3.0f;
    self.headImg.layer.masksToBounds = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageNumberRequest) name:TPIMNotification_ReceiveMessages object:nil];
    self.marketingDescLabel.text = [HiTVGlobals sharedInstance].marketingDesc;


}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.clipsToBounds = YES;

    if ([HiTVGlobals sharedInstance].isLogin) {
        [self p_refreshAfterUserLogin:nil];
    }
    else{
        [self.headImg setImage:[UIImage imageNamed:DEFAULTHEADICON]];
    }
    [AppDelegate appDelegate].appdelegateService.coinView.hidden = NO;

    //    //获取未读消息条数
    //    [self getMessageNumberRequest];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.clipsToBounds = NO;

}
-(void)p_refreshAfterUserLogin:(NSNotification*)notification
{
    if ([notification.object isEqualToString:@"loginOut"]) {
        self.nameLab.text = @"未登录";
        [self.headImg setImage:[UIImage imageNamed:DEFAULTHEADICON]];
        [self.vipBtn setImage:[UIImage imageNamed:@"notvipicon"] forState:UIControlStateNormal];

    }else{
        self.nameLab.text = [HiTVGlobals sharedInstance].nickName;
        [self.headImg setImageWithURL:[NSURL URLWithString:[HiTVGlobals sharedInstance].faceImg] placeholderImage:[UIImage imageNamed:LIGHTHEADICON]];
        if ([HiTVGlobals sharedInstance].VIP) {
            [self.vipBtn setImage:[UIImage imageNamed:@"vipicon"] forState:UIControlStateNormal];
        }else{
            [self.vipBtn setImage:[UIImage imageNamed:@"notvipicon"] forState:UIControlStateNormal];
        }
        self.marketingDescLabel.text = [HiTVGlobals sharedInstance].marketingDesc;
    }
    //获取未读消息条数
    [self getMessageNumberRequest];

}
- (BOOL)validateCamera {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){

        DDLogWarn(@"相机权限受限");
        return NO;
    }
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}
-(IBAction)scan{
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
-(IBAction)myDetailClick:(id)sender{
    
    if ([HiTVGlobals sharedInstance].isLogin) {
        self.hidesBottomBarWhenPushed = YES;
        MyDetailViewController *myDetailViewVC = [[MyDetailViewController alloc] init];
        [self.navigationController pushViewController:myDetailViewVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else{
        [self showLoginVC];
    }
}
-(void)showLoginVC{
    SJLoginViewController *sjVC = [[SJLoginViewController alloc]init];
    [self presentViewController:sjVC animated:YES completion:nil];
}
-(IBAction)friendsClick:(id)sender{
    if ([HiTVGlobals sharedInstance].isLogin) {
        self.hidesBottomBarWhenPushed = YES;
        MyFriendsController *MyFriendsVC = [[MyFriendsController alloc] init];
        [self.navigationController pushViewController:MyFriendsVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else{
        [self showLoginVC];
    }

}
- (IBAction)test:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    SJPayViewController *pay = [[SJPayViewController alloc]initWithNibName:@"SJPayViewController" bundle:nil];
    [self.navigationController pushViewController:pay animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
-(IBAction)messageClick:(id)sender{
    if ([HiTVGlobals sharedInstance].isLogin) {
        self.hidesBottomBarWhenPushed = YES;
        SJMessageCenterViewController *messageVC = [[SJMessageCenterViewController alloc] init];
        [self.navigationController pushViewController:messageVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else{
        [self showLoginVC];
    }


}
-(void)remoteItem{
    self.hidesBottomBarWhenPushed = YES;
    SJRemoteControlViewController *remoteVC = [[SJRemoteControlViewController alloc] init];
    [self.navigationController pushViewController:remoteVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
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
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return _titleArray.count;
    }
    else if (section==1){
        return _titleArray2.count;
    }
    return _titleArray3.count;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor whiteColor];
    }
    /*cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
     cell.contentView.backgroundColor = [UIColor clearColor];
     cell.backgroundColor = [UIColor clearColor];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     cell.accessoryView = nil;*/
    UIImageView *moreImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_arrow"]];
    cell.accessoryView = moreImg;

    if (indexPath.section==0) {
        cell.textLabel.text = _titleArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:_imgArray[indexPath.row]];
    }
    else if (indexPath.section==1){
        cell.textLabel.text = _titleArray2[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:_imgArray2[indexPath.row]];
    }
    else{
        cell.textLabel.text = _titleArray3[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:_imgArray3[indexPath.row]];
    }
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section==0) {
        if (row==0) {
            self.hidesBottomBarWhenPushed = YES;
            RecentViewController *recentVC = [[RecentViewController alloc]init];
            [self.navigationController pushViewController:recentVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        else if (row==1) {
            self.hidesBottomBarWhenPushed = YES;
            FavoriteViewController *favoriteViewVC = [[FavoriteViewController alloc]init];
            [self.navigationController pushViewController:favoriteViewVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }

        else if (row==2){
            self.hidesBottomBarWhenPushed = YES;
            SJMyPhotoViewController *cloudPhoto = [[SJMyPhotoViewController alloc]init];
            [self.navigationController pushViewController:cloudPhoto animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
        }

        else if (row==3) {
            self.hidesBottomBarWhenPushed = YES;
            RelationDeviceController *relationDeviceVC = [[RelationDeviceController alloc]init];
            [self.navigationController pushViewController:relationDeviceVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }

    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            self.hidesBottomBarWhenPushed = YES;
            if ([[HiTVGlobals sharedInstance].disable_moudles containsObject:@"order"] == NO) {
                OrderListViewController *orderListVC = [[OrderListViewController alloc] init];
                [self.navigationController pushViewController:orderListVC animated:YES];
            } else if ([[HiTVGlobals sharedInstance].disable_moudles containsObject:@"coupon"] == NO) {
                SJCouponViewController *couponVC = [[SJCouponViewController alloc] init];
                [self.navigationController pushViewController:couponVC animated:YES];
            } else if ([[HiTVGlobals sharedInstance].disable_moudles containsObject:@"award"] == NO) {
                ShareAppViewController *shareAppVC = [[ShareAppViewController alloc]initWithNibName:@"ShareAppViewController" bundle:nil];;
                [self.navigationController pushViewController:shareAppVC animated:YES];
            }
            self.hidesBottomBarWhenPushed = NO;
        }
        else if (indexPath.row == 1){
            
            self.hidesBottomBarWhenPushed = YES;
            if ([[HiTVGlobals sharedInstance].disable_moudles containsObject:@"coupon"] == NO) {
                SJCouponViewController *couponVC = [[SJCouponViewController alloc] init];
                [self.navigationController pushViewController:couponVC animated:YES];
            } else if ([[HiTVGlobals sharedInstance].disable_moudles containsObject:@"award"] == NO) {
                ShareAppViewController *shareAppVC = [[ShareAppViewController alloc]initWithNibName:@"ShareAppViewController" bundle:nil];;
                [self.navigationController pushViewController:shareAppVC animated:YES];
            }
            self.hidesBottomBarWhenPushed = NO;
        }
        else{
            self.hidesBottomBarWhenPushed = YES;
            ShareAppViewController *shareAppVC = [[ShareAppViewController alloc]initWithNibName:@"ShareAppViewController" bundle:nil];;
            [self.navigationController pushViewController:shareAppVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        
    }
    else if (indexPath.section == 2){
        self.hidesBottomBarWhenPushed = YES;
        SJSettingViewController *settingVC = [[SJSettingViewController alloc] init];
        [self.navigationController pushViewController:settingVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)BuyVIPAction:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    SJVIPViewController *VIPVC =[[SJVIPViewController alloc]initWithNibName:@"SJVIPViewController" bundle:nil];
    [self.navigationController pushViewController:VIPVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - Request
//获取未读消息条数
- (void)getMessageNumberRequest
{
    if (![HiTVGlobals sharedInstance].isLogin) {
        self.msgNumLabel.hidden = YES;
        [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
        return;
    }

    WEAKSELF
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters setValue:[HiTVGlobals sharedInstance].uid forKey:@"uid"];
    [parameters setValue:@"0" forKey:@"readed"];

    //获取消息列表
    [BaseAFHTTPManager getRequestOperationForHost:MSGCENTERHOST
                                         forParam:@"/message/msgCnt"
                                    forParameters:parameters
                                       completion:^(id responseObject) {
                                           if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                               NSString *cnt = [responseObject objectForKey:@"cnt"];
                                               if ([cnt integerValue] > 0) {
                                                   //显示
                                                   [weakSelf.tabBarController.tabBar showBadgeOnItemIndex:3];

                                                   weakSelf.msgNumLabel.text = cnt;
                                                   weakSelf.msgNumLabel.hidden = NO;
                                                   CGRect rect = [cnt boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:weakSelf.msgNumLabel.font,NSFontAttributeName, nil] context:nil];
                                                   //self.msgNumLabel.frame = CGRectMake(313, 150, rect.size.width, rect.size.height);
                                                   if (rect.size.width < rect.size.height) {
                                                       rect.size.width = rect.size.height;
                                                   }
                                                   weakSelf.msgNumLabel.layer.cornerRadius = rect.size.height / 2.0;
                                                   weakSelf.msgNumLabel.layer.masksToBounds = YES;
                                                   [weakSelf.msgNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                                                       make.width.mas_equalTo(rect.size.width);
                                                       make.height.mas_equalTo(rect.size.height);
                                                   }];
                                               }
                                               else{
                                                   weakSelf.msgNumLabel.hidden = YES;
                                                   //隐藏
                                                   [weakSelf.tabBarController.tabBar hideBadgeOnItemIndex:3];
                                               }
                                           }
                                           else{
                                               weakSelf.msgNumLabel.hidden = YES;
                                               [weakSelf.tabBarController.tabBar hideBadgeOnItemIndex:3];

                                           }
                                       }failure:^(AFHTTPRequestOperation *operation, NSString *error){
                                           weakSelf.msgNumLabel.hidden = YES;
                                           [weakSelf.tabBarController.tabBar hideBadgeOnItemIndex:3]; }];
}
- (void) insertTransparentGradient {
    UIColor *colorOne =  RGB(107, 132, 144, 1);;
    UIColor *colorTwo = RGB(76, 90, 98, 1);;
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];

    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.startPoint = CGPointMake(0, 0);
    headerLayer.endPoint = CGPointMake(1.0, 0);
    headerLayer.frame = self.headView.bounds;
    [self.headView.layer addSublayer:headerLayer];
    
    CAGradientLayer *navLayer = [CAGradientLayer layer];
    navLayer.colors = colors;
    navLayer.locations = locations;
    navLayer.startPoint = CGPointMake(0, 0);
    navLayer.endPoint = CGPointMake(1.0, 0);
    navLayer.frame = self.navigationController.navigationBar.bounds;
    [self.navigationController.navigationBar.layer addSublayer:navLayer];
}
@end
