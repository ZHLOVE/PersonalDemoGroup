//
//  SJPayFinishViewController.m
//  ShiJia
//
//  Created by 峰 on 16/9/3.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJPayFinishViewController.h"
#import "BIMSManager.h"
#import "TRTopNavgationView.h"
#import "SJVideoRecommendView.h"

@interface SJPayFinishViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeInvale;
@property (weak, nonatomic) IBOutlet UILabel *movieLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic, strong) TRTopNavgationView  *naviView;
@property (weak, nonatomic) IBOutlet SJVideoRecommendView *recommendView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollvrViewHeiht;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recommendHeight;


@end

@implementation SJPayFinishViewController

//-(SJVideoRecommendView *)recommView{
//    if (!_recommView) {
//        _recommView = [[SJVideoRecommendView alloc]init];
//        _recommView.canSelected = YES;
//        _recommView.collectionview.scrollEnabled = YES;
//        _recommView.list = [_recommArray copy];
//    }
//    return _recommView;
//}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买完成";
    self.navigationController.navigationBarHidden = YES;
    [self initNavigationViewAction];
    if (_recommArray.count>0) {
        self.recommendView.list = [_recommArray copy];
        self.recommendView.collectionview.scrollEnabled = NO;
        self.scrollvrViewHeiht.constant = 360+self.recommendView.height;
        self.recommendHeight.constant =self.recommendView.height;
        NSString *title =[NSString stringWithFormat:@"    剩余有效期：%@   有效期至：%@",_productEntity.expireDateDesc,_productEntity.endTime];
        
        self.timeInvale.text = title;
    }else{
        self.recommendView.hidden = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if ([_productServiceID isEqualToString:@"iOS_TaiPan_Movie_1_6.0"]) {
        
        [self.backButton setTitle:@"返回影片，继续观看" forState:UIControlStateNormal];
        
    }else{
        [[BIMSManager sharedInstance] queryPriceRequest];
        [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
        self.movieLabel.text = nil;
        NSString *title =[NSString stringWithFormat:@"有效期至：%@",[HiTVGlobals sharedInstance].expireDate];

        self.timeInvale.text = title;
//        self.timeInvale.text = [HiTVGlobals sharedInstance].expireDate;
    }
}

- (void)initNavigationViewAction{
    _naviView = [TRTopNavgationView navgationView];
    _naviView.backgroundColor = kColorBlueTheme;
    [self.view addSubview:_naviView];
    
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
        //        [self.VedioPlayerView.playerview clearPlayer];
        
          [strongSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    [_naviView setLeftView:backBt];
    UILabel* lbl = [UIHelper createTitleLabel:@"购买完成"];
    [lbl setTextColor:[UIColor whiteColor]];
    [_naviView setTitleView:lbl];
}

- (IBAction)goBack:(id)sender {
    
    if (_isFromOrderPay) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
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
