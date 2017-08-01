//
//  SJConnectTVViewController.m
//  ShiJia
//
//  Created by yy on 16/4/25.
//  Copyright © 2016年 Ysten. All rights reserved.
//

#import "SJConnectTVViewController.h"
#import "SJConnectTVItemView.h"

#import "SJSetFavoriteViewController.h"
#import "SJLoginViewController.h"
#import "SJUserHelpViewController.h"
#import "SJLightViewController.h"

@interface SJConnectTVViewController ()<UIScrollViewDelegate>
{
    
    IBOutlet UIScrollView  *_scrollView;
    IBOutlet UIPageControl *_pageControl;
    IBOutlet UIButton      *_connectButton;
    UIView        *_contentView;
    
    NSArray *_texts;
    NSMutableArray *_subviewArray;
    
    MBProgressHUD *HUD;
}
@property (nonatomic, weak) IBOutlet UIButton *leftBtn;
@property (nonatomic, weak) IBOutlet UIButton *rightBtn;

@end

@implementation SJConnectTVViewController

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _texts = @[@"可以在手机上收看\n与电视相同的影视剧",
                   @"电视与手机的收视\n喜好可以漫游啦",
                   @"送个大片给好友\n约上好友聊天看电视"];
        _subviewArray = [[NSMutableArray alloc] init];
        
        _contentView = [[UIView alloc] init];
        
        for (int i = 0; i < _texts.count; i++) {
            
            SJConnectTVItemView *itemview = [[SJConnectTVItemView alloc] initWithText:_texts[i]
                                                                                image:[UIImage imageNamed:[NSString stringWithFormat:@"connect_tv_image_%zd",i]]];
            itemview.tag = i;
            [_contentView addSubview:itemview];
            
            [_subviewArray addObject:itemview];
            
        }
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_scrollView addSubview:_contentView];
    
    self.leftBtn.backgroundColor = self.rightBtn.backgroundColor= kColorBlueTheme;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat originx = 0;
    
    for (int i = 0; i < _subviewArray.count; i++) {
        
        SJConnectTVItemView *itemview = _subviewArray[i];
        
        itemview.frame = CGRectMake(originx,
                                    0,
                                    _scrollView.frame.size.width,
                                    _scrollView.frame.size.height);
        
        
        
        originx = itemview.frame.size.width + itemview.frame.origin.x;
        
    }
    
    _contentView.frame = CGRectMake(0,
                                    0,
                                    originx,
                                    _scrollView.frame.size.height);
    
    _scrollView.contentSize = _contentView.size;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(_scrollView.frame);
    NSInteger page = floor((_scrollView.contentOffset.x - pageWidth / 2 ) / pageWidth ) +1;
    _pageControl.currentPage = page;
    
}

#pragma mark - Event
- (IBAction)connectButtonClicked:(id)sender{
    if ([HiTVGlobals sharedInstance].isLogin) {
        
        SJUserHelpViewController *userHelpVC = [[SJUserHelpViewController alloc]init];
        [self.navigationController pushViewController:userHelpVC animated:YES];
        //        [self showMainViewController];
        
    }else{
        SJLoginViewController *sjVC = [[SJLoginViewController alloc]init];
        [self presentViewController:sjVC animated:YES completion:nil];
        return;
    }
}

- (IBAction)continueButtonClicked:(id)sender
{
    if ([HiTVGlobals sharedInstance].interested) {
        [self showMainViewController];
    }
    else{
        [self isHavePersonalResultRequest];
    }
/*#ifdef BeiJing
    [self showMainViewController];
#else
    [self isHavePersonalResultRequest];

#endif*/
}
#pragma mark -  Request
- (void)isHavePersonalResultRequest
{
    
    __weak __typeof(self)weakSelf = self;
    NSDictionary *param = @{
                            @"userId" : [self p_currentUID],
                            //@"tvTemplateId" : WATCHTVGROUPID,
                            //@"vodTemplateId" : [[HiTVGlobals sharedInstance]getEpg_groupId],
                            @"abilityString" :  T_STBext,
                            };
    NSString* url = [NSString stringWithFormat:@"%@/personal/isHavePersonalResult",
                     MYEPG];
    
    DDLogInfo(@"url: %@", url);
    //    [HUD showAnimated:YES];
    [MBProgressHUD showMessag:nil toView:self.view];
    [BaseAFHTTPManager getRequestOperationForHost:url forParam:@"" forParameters:param completion:^(id responseObject) {
        //        [HUD hideAnimated:YES];
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        if (!strongSelf) {
            return;
        }
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if ([[resultDic objectForKey:@"code"] intValue] == 0) {
            if ([[resultDic objectForKey:@"isHave"] intValue] == 1) {
                [strongSelf showMainViewController];
            }
            else{
                [strongSelf goSJSetFavoriteViewController];
            }
        }
        else{
            [strongSelf goSJSetFavoriteViewController];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        
        if (!strongSelf) {
            return;
        }
        [strongSelf goSJSetFavoriteViewController];
    }];
}
-(void)goSJSetFavoriteViewController{
    /*SJSetFavoriteViewController * favoriteVC = [[SJSetFavoriteViewController alloc] init];
    [self.navigationController pushViewController:favoriteVC animated:YES];*/
    SJLightViewController * favoriteVC = [[SJLightViewController alloc] init];
    [self.navigationController pushViewController:favoriteVC animated:YES];
}
-(void)showMainViewController{
    [AppDelegate appDelegate].appdelegateService.SetF = YES;
    [[AppDelegate appDelegate].appdelegateService showMainViewController];
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
@end
