//
//  SJShareVideoViewController.m
//  ShiJia
//
//  Created by yy on 16/3/7.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJShareVideoViewController.h"
#import "SJContactListView.h"
#import "SJGetUserDataAPI.h"
#import "SJShareVideoViewModel.h"

@interface SJShareVideoViewController ()
{
    NSArray *_shareArray;
    
}

@property (nonatomic, strong) SJContactListView  *contactView;
@property (nonatomic, strong) TRTopNavgationView *naviView;
@property (nonatomic, strong) UIView *defaultView;//缺省页

@end

@implementation SJShareVideoViewController

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {

        _contactView = [[SJContactListView alloc] initWithUsers:nil];
        _contactView.bottomButtonTitle = @"发送分享";
        _viewModel = [SJShareVideoViewModel new];
    }
    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"分享";
    self.view.backgroundColor = kColorLightGrayBackground;
//    self.navigationController.navigationBarHidden = YES;
//    [self initNavigationView];

    //好友列表view
    [SJGetUserDataAPI getFriendListWithSuccess:^(NSArray<UserEntity *> *responseObject) {
        
        _contactView.userList = [NSArray arrayWithArray:responseObject];
        if (_contactView.userList.count == 0) {
            self.defaultView.hidden = NO;
            _contactView.hidden = YES;
        }
        else{
            self.defaultView.hidden = YES;
            _contactView.hidden = NO;
        }
        
    } failed:^(NSString *error) {
        
    }];
    
   
    // 发送分享消息
    __weak __typeof(self)weakSelf = self;
    [self.contactView setBottomButtonClickBlock:^(NSArray *list) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [strongSelf.viewModel shareVideoToUsers:strongSelf.contactView.selectedItems];
    }];
    
    [self.view addSubview:_contactView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _contactView.frame = CGRectMake(0,
                                    0,
                                    self.view.frame.size.width,
                                    self.view.frame.size.height - _naviView.frame.size.height );
}
-(UIView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 150)];
        _defaultView.backgroundColor = [UIColor clearColor];
        
        UIImageView *zwddImg = [[UIImageView alloc]initWithFrame:CGRectMake(55, 0, 90, 90)];
        zwddImg.image = [UIImage imageNamed:@"img_none_friend"];
        [_defaultView addSubview:zwddImg];
        
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, 200, 30)];
        lab.backgroundColor = [UIColor clearColor];
        lab.text = @"您还没有好友先去添加几个吧～";
        lab.textColor = [UIColor lightGrayColor];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentCenter;
        [_defaultView addSubview:lab];
        
        _defaultView.center = CGPointMake(W/2, H/2-100);
        
        [self.view addSubview:_defaultView];
    }
    
    return _defaultView;
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

        NSString* str = [NSUserDefaultsManager getObjectForKey:LOG_SHARE_CONTENT];
        if (str) {
            [Utils BDLog:1 module:@"605" action:@"Share" content:[NSString stringWithFormat:str,-1]];
            [NSUserDefaultsManager saveObject:nil forKey:LOG_SHARE_CONTENT];
        }
        [MBProgressHUD showError:@"分享取消" toView:nil];
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
    [_naviView setLeftView:backBt];
    
    // title
    UILabel* lbl = [UIHelper createTitleLabel:@"分享"];
    lbl.textColor = [UIColor whiteColor];
    [_naviView setTitleView:lbl];
   
}


@end
