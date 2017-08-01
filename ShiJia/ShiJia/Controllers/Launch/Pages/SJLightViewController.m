//
//  SJLightViewController.m
//  ShiJia
//
//  Created by 蒋海量 on 16/9/13.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJLightViewController.h"
#import "SJLightView.h"

static float height = 460;

@interface SJLightViewController ()
@property (nonatomic, strong) TRTopNavgationView *naviView;
@property (nonatomic, strong) NSMutableArray *markArray;
@property (nonatomic, strong) NSMutableArray *IdList;

@property (nonatomic, weak) IBOutlet UIButton *bottomButton;

@property (nonatomic, strong) SJLightView *lightView;
@property (strong, nonatomic)  UIView *defaultView;

@end

@implementation SJLightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = kColorLightGrayBackground;
    self.title = @"点亮你选择的节目";
    [self initNavigationView];

    [self initUI];
    if ([HiTVGlobals sharedInstance].anonymousUid) {
        [self loadMarkRequest];
    }
    else{
        [[HiTVGlobals sharedInstance] addObserver:self forKeyPath:NSStringFromSelector(@selector(anonymousUid)) options:NSKeyValueObservingOptionNew context:nil];
    }
}
-(void)initUI{
    float labTH = 70;
    float viewTH = 110;

    if (W>320) {
        labTH = 100;
        viewTH = 150;
    }

    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake((W-280)/2, labTH, 280, 60)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor lightGrayColor];
    titleLab.text = @"生成你的个人节目单，每天为你推荐专属节目，请至少选择一个。";
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.numberOfLines = 0;
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    
    _lightView=[[SJLightView alloc]initWithFrame:CGRectMake((W-300)/2, viewTH, 300, height)];
    _lightView.array = self.markArray;
    _lightView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_lightView];
    
    __weak __typeof(self)weakSelf = self;
    [_lightView setBlock:^(UIButton *button, NSString *string) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        DDLogInfo(@"---%@",string);
        if ([strongSelf.IdList containsObject:string]) {
            [button setTitleColor:button.backgroundColor forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
            [strongSelf handleSelectEvent:string selected:NO];
        }
        else{
            button.backgroundColor = button.titleLabel.textColor;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [strongSelf handleSelectEvent:string selected:YES];
        }
        
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [AppDelegate appDelegate].appdelegateService.coinView.hidden = YES;
}
-(UIView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 150)];
        _defaultView.backgroundColor = [UIColor clearColor];
        
        UIImageView *zwddImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
        zwddImg.image = [UIImage imageNamed:@"icon_kandan_empty"];
        [_defaultView addSubview:zwddImg];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 90, 30)];
        lab.backgroundColor = [UIColor clearColor];
        lab.text = @"跳  过";
        lab.textColor = [UIColor lightGrayColor];
        lab.font = [UIFont systemFontOfSize:16];
        lab.textAlignment = NSTextAlignmentCenter;
        [_defaultView addSubview:lab];
        
        _defaultView.center = CGPointMake(W/2, H/2);
        
        [self.view addSubview:_defaultView];
        
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        tapGr.cancelsTouchesInView = NO;
        
        [_defaultView addGestureRecognizer:tapGr];
    }
    
    return _defaultView;
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [AppDelegate appDelegate].appdelegateService.SetF = YES;
    if ([AppDelegate appDelegate].appdelegateService.hasMainVC) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_UserInterested object:nil];
    }
    else{
        [[AppDelegate appDelegate].appdelegateService showMainViewController];
    }
}
-(NSMutableArray *)markArray{
    if (!_markArray) {
        _markArray = [NSMutableArray array];
    }
    return _markArray;
}
-(NSMutableArray *)IdList{
    if (!_IdList) {
        _IdList = [NSMutableArray array];
    }
    return _IdList;
}
- (NSString*)p_currentUID {
    if ([HiTVGlobals sharedInstance].isLogin) {
        if (![HiTVGlobals sharedInstance].uid) {
            return @"";
        }
        return [HiTVGlobals sharedInstance].uid;
        
    }else{
        if (![HiTVGlobals sharedInstance].anonymousUid) {
            return @"";
        }
        return [HiTVGlobals sharedInstance].anonymousUid;
    }
}
#pragma mark - Data
- (void)handleSelectEvent:(NSString *)mark selected:(BOOL)selected
{
    if (selected) {
        
        if (![self.IdList containsObject:mark]) {
            [self.IdList addObject:mark];
        }
        
        if (self.IdList.count > 0 && !_bottomButton.enabled) {
            _bottomButton.enabled = YES;
            [_bottomButton setBackgroundColor:kColorBlueTheme];
            [_bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_bottomButton setTitle:@"确 定" forState:UIControlStateNormal];
        }
    }
    else{
        
        if ([self.IdList containsObject:mark]) {
            [self.IdList removeObject:mark];
        }
        
        if (self.IdList.count == 0) {
            _bottomButton.enabled = NO;
            [_bottomButton setBackgroundColor:[UIColor whiteColor]];
            [_bottomButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_bottomButton setTitle:@"请选择" forState:UIControlStateNormal];
        }
        
    }
}
#pragma mark -  Request
-(void)loadMarkRequest{
    __weak __typeof(self)weakSelf = self;
    NSString* url = [NSString stringWithFormat:@"%@/personal/mark.json",
                     MYEPG];
    NSDictionary *param = @{
                            @"userId" : [self p_currentUID],
                            //@"tvTemplateId" : WATCHTVGROUPID,
                           // @"vodTemplateId" : [[HiTVGlobals sharedInstance]getEpg_groupId],
                            @"abilityString" :  T_STBext,
                            };
    
    
    DDLogInfo(@"url: %@", url);
    [MBProgressHUD showMessag:nil toView:self.view];
    [BaseAFHTTPManager getRequestOperationForHost:url forParam:@"" forParameters:param completion:^(id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        if (!strongSelf) {
            return;
        }
        NSMutableArray *resultArray = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"tags"]) {
            [resultArray addObject:dic[@"name"]];
        }
        strongSelf.markArray = resultArray;
        _lightView.array = strongSelf.markArray;
        _bottomButton.hidden = NO;
        _bottomButton.enabled = NO;
        [_bottomButton setBackgroundColor:[UIColor whiteColor]];
        [_bottomButton setTitle:@"请选择" forState:UIControlStateNormal];
        if (_lightView.array.count == 0) {
            strongSelf.defaultView.hidden = NO;
        }
        else{
            strongSelf.defaultView.hidden = YES;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        [strongSelf p_handleNetworkError];
        strongSelf.defaultView.hidden = NO;

    }];
}
#pragma mark - Event
- (IBAction)bottomButtonClicked:(id)sender
{
    
    NSString *programIds = [self.IdList componentsJoinedByString:@"|"];
    
    [MBProgressHUD showMessag:nil toView:self.view];
    NSDictionary *param = @{
                            @"userId" : [self p_currentUID],
                            @"interestedClass" : programIds,
                            };
    __weak __typeof(self)weakSelf = self;
    [BaseAFHTTPManager getRequestOperationForHost:MYEPG forParam:@"/personal/addUserInterestedClass" forParameters:param completion:^(id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        
        
        
        if (responseObject == nil) {
            return;
        }
        
       // NSString *code = responseObject[@"code"];
       // if (code.integerValue == 0) {
            [AppDelegate appDelegate].appdelegateService.SetF = YES;
            if ([AppDelegate appDelegate].appdelegateService.hasMainVC) {
                [strongSelf dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:TPIMNotification_UserInterested object:nil];
            }
            else{
                [[AppDelegate appDelegate].appdelegateService showMainViewController];
            }
        //}
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        
    }];
    
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(anonymousUid))]) {
        [self loadMarkRequest];
    }
}
- (void)initNavigationView
{
    _naviView = [TRTopNavgationView navgationView];
    _naviView.backgroundColor = [UIColor whiteColor];
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
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
    //[_naviView setLeftView:backBt];
    
    // title
    UILabel* lbl = [UIHelper createTitleLabel:self.title];
    lbl.textColor = [UIColor blackColor];
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
