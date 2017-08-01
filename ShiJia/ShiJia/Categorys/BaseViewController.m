//
//  BaseViewController.m
//  ShiJia
//
//  Created by 蒋海量 on 16/6/30.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "BaseViewController.h"
#import "SJRemoteControlViewController.h"
#import "WatchListViewController.h"
#import "ChannelViewController.h"
#import "VideoHomeCollectionViewController.h"
#import "TalkingData.h"

@interface BaseViewController ()
@property (nonatomic, strong) TRTopNavgationView *naviView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = klightGrayColor;
    
    /*if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }*/
    //delete by jhl 20170301  显示导航栏下面的黑线
}
-(void)viewWillAppear:(BOOL)animated{
    //DDLogInfo(@"controllerName=%@",NSStringFromClass([self class]));
     [TalkingData trackPageBegin:NSStringFromClass([self class])];
}
-(void)viewWillDisappear:(BOOL)animated{
     [TalkingData trackPageEnd:NSStringFromClass([self class])];
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
    if (![self isKindOfClass:[WatchListViewController class]]) {
        [_naviView setLeftView:backBt];
    }
    
    // title
    UILabel* lbl = [UIHelper createTitleLabel:self.title];
    lbl.textColor = kNavTitleColor;
    [_naviView setTitleView:lbl];
    
    
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
