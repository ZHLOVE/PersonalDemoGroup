//
//  SJAboutViewController.m
//  ShiJia
//
//  Created by yy on 16/3/15.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJAboutViewController.h"

@interface SJAboutViewController ()

@property (nonatomic, strong) TRTopNavgationView *naviView;
@property (nonatomic, weak) IBOutlet UILabel *vesionLab;
@property (weak, nonatomic) IBOutlet UIImageView *aboutLogoImage;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation SJAboutViewController

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorLightGrayBackground;
    
    self.rightLabel.text = SJRight;
    self.companyLabel.text = SJCompanyName;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    /* NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];*/
    self.vesionLab.text = APPVersion;
    self.aboutLogoImage.image = [UIImage imageNamed:AboutImageName];
    
    
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    self.title = [NSString stringWithFormat:@"关于%@",app_Name];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Subview
- (void)initNavigationView
{
    _naviView = [TRTopNavgationView navgationView];
    [self.view addSubview:_naviView];
    _naviView.backgroundColor = kColorBlueTheme;
    
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
    [_naviView setLeftView:backBt];
    
    // title
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
 NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    UILabel* lbl = [UIHelper createTitleLabel:[NSString stringWithFormat:@"关于%@",app_Name]];
    lbl.textColor = [UIColor whiteColor];
    [_naviView setTitleView:lbl];
    
    
}


@end
