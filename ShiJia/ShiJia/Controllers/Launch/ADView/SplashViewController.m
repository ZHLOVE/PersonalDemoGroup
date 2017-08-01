//
//  SplashViewController.m
//  ShiJia
//
//  Created by 蒋海量 on 2017/2/19.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "SplashViewController.h"
#import "UIImageView+WebCache.h"
#import "DmsDataPovider.h"
#import "UIImage+GIF.h"
#import "HomeJumpWebViewController.h"
#import "SJMultiVideoDetailViewController.h"
#import "launchAdModel.h"
#import "SplashViewModel.h"


#define APP_VERCODE_LIMIT 3

@interface SplashViewController ()
{
    NSTimer *verTimer;              //验证码计时器
    NSUInteger verTimeLimit;        //验证码计数
}
@property (weak, nonatomic) IBOutlet UIImageView *ADView;
@property (strong, nonatomic) UIButton *passBtn;
@property (nonatomic, strong) launchAdModel *adModel;
@property (nonatomic, strong) SplashViewModel *ViewModel;
@property (strong, nonatomic) UIImageView *loadingImg;

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ViewModel=[[SplashViewModel alloc]init];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(launchAD)
                                                 name:TPIMNotification_LaunchAD
                                               object:nil];
    [self initUI];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(clickAdAction)];
    [_ADView addGestureRecognizer:tap];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    if (_isSecondTime) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_ShowMainViewController object:nil];
        [verTimer invalidate];
        verTimer=nil;;
    }

}
-(void)launchAD{
#ifdef BeiJing
    [self performSelector:@selector(startToLoadingAD) withObject:nil afterDelay:2.0];
#else
    [self startToLoadingAD];
#endif

}
-(void)startToLoadingAD{
#ifdef BeiJing
    [self.loadingImg removeFromSuperview];
#else
#endif
    
    if (_ViewModel.cacheModel) {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
        if (!_ViewModel.downLoadSuccess) {
            if ([_ViewModel.cacheModel.resourceType isEqualToString:@"gif"]) {
                dispatch_queue_t concurrentQueue =
                dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(concurrentQueue, ^{
                    __block NSData *data=nil;
                    dispatch_sync(concurrentQueue, ^{
                        data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:_ViewModel.cacheModel.resourceUrl]];
                    });
                    dispatch_sync(dispatch_get_main_queue(), ^{
                         self.ADView.image = [UIImage sd_animatedGIFWithData:data];
                    });
                });
            }else{

                [self.ADView sd_setImageWithURL:[NSURL URLWithString:_ViewModel.cacheModel.resourceUrl]];
            }

        }else{
            if ([_ViewModel.cacheModel.resourceType isEqualToString:@"gif"]) {
                self.ADView.image = [UIImage sd_animatedGIFWithData:_ViewModel.CacheData];
            }else{
                //self.ADView.image =[UIImage imageWithData:_ViewModel.CacheData];
                self.ADView.image =[UIImage sd_animatedGIFWithData:_ViewModel.CacheData];

            }
        }

            verTimeLimit = [_ViewModel.cacheModel.timeCount integerValue];
            NSString *str = [NSString stringWithFormat:@"%ld 跳过",(unsigned long)verTimeLimit];
            [_passBtn setTitle:str forState:UIControlStateNormal];
            verTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(verUpdate) userInfo:nil repeats:YES];
            [_ADView addSubview:_passBtn];

    }else{
        [self removeADView];
    }
}
-(void)initUI{
    if (W>320) {
        self.defaultImg.image = [UIImage imageNamed:@"lanchdefault"];
    }
    _passBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _passBtn.frame = CGRectMake(SCREEN_WIDTH-100, 15, 80, 35);
    _passBtn.layer.masksToBounds = YES;
    _passBtn.layer.cornerRadius = 17.5;
    _passBtn.backgroundColor = [UIColor blackColor];
    _passBtn.alpha = .7;
    [_passBtn addTarget:self action:@selector(passBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_passBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _passBtn.titleLabel.font = [UIFont systemFontOfSize:14];
#ifdef BeiJing
    [self.view addSubview:self.loadingImg];
#else
#endif

}
-(void)passBtnClick{
    [self removeADView];
    [UMengManager event:@"U_PassAdv"];
}
-(void)removeADView
{

    /*  [UIView animateWithDuration:1.0f delay:0.5f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
     self.view.alpha = 0.0f;
     self.view.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5f, 1.5f, 1.0f);
     } completion:^(BOOL finished) {
     [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_ShowMainViewController object:nil];
     [verTimer invalidate];
     verTimer=nil;;
     }];*/

   [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_ShowMainViewController object:nil];
    [verTimer invalidate];
    verTimer=nil;

}
- (void)verUpdate
{
    verTimeLimit--;
    if (verTimeLimit == 0) {
        if ([verTimer isValid]) {
            [verTimer invalidate];
            verTimer=nil;
            NSString *str = [NSString stringWithFormat:@"%ld 跳过",(unsigned long)verTimeLimit];
            [_passBtn setTitle:str forState:UIControlStateNormal];
            if (!_isSecondTime) {
                [self removeADView];
            }
        }
    }
    else{
        NSString *str = [NSString stringWithFormat:@"%ld 跳过",(unsigned long)verTimeLimit];
        [_passBtn setTitle:str forState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)loadADData{
//
//    [DmsDataPovider getBootAdRequestCompletion:^(id responseObject) {
//        NSDictionary *dict = (NSDictionary *)responseObject;
//        self.adModel = [launchAdModel mj_objectWithKeyValues:dict];
//        [_ViewModel setSourceURL:self.adModel.resourceUrl];
//        [[NSUserDefaults standardUserDefaults] setObject:self.adModel forKey:kCacheObject];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//
//    } failure:^(NSString *message) {
//
//    }];
//}

-(void)clickAdAction{

    if ([HiTVGlobals sharedInstance].isLogin) {
        if ([_ViewModel.cacheModel.actionType isEqualToString:@"inner"]) {

            SJMultiVideoDetailViewController *detailVC = [[SJMultiVideoDetailViewController alloc] initWithVideoType:SJVideoTypeVOD];
            detailVC.videoID = _ViewModel.cacheModel.programSeriesId;
            detailVC.categoryID = _ViewModel.cacheModel.programSeriesId;
            self.isSecondTime = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        if ([_ViewModel.cacheModel.actionType isEqualToString:@"outter"]) {
            HomeJumpWebViewController *jumpVC = [[HomeJumpWebViewController alloc]init];
            jumpVC.urlStr =_ViewModel.cacheModel.actionUrl;
            self.isSecondTime = YES;
            [self.navigationController pushViewController:jumpVC animated:YES];
        }
    }else{
        [self passBtnClick];
    }
    [UMengManager event:@"U_ClickAdv"];
}
-(UIImageView *)loadingImg{
    if (!_loadingImg) {
        _loadingImg = [[UIImageView alloc]initWithFrame:CGRectMake((W-40)/2, H-100, 40, 40)];
        _loadingImg.backgroundColor = [UIColor clearColor];
        NSString  *name = @"startLoading.gif";
        NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:name ofType:nil];
        NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
        UIImage *img = [UIImage sd_animatedGIFWithData:imageData];
        
        _loadingImg.image = img;
    }
    return _loadingImg;
}
@end
