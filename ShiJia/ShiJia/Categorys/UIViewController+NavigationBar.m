//
//  UIViewController+NavigationBar.m
//  HiTV
//
//  Created by lanbo zhang on 8/11/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import "SJRemoteControlViewController.h"
#import "TogetherManager.h"
#import "WatchListViewController.h"
#import "VideoHomeViewController.h"
#import "ChannelViewController.h"
#import "SJMyViewController.h"


#import "OrderListViewController.h"
#import "SJAboutViewController.h"
#import "SJConnectTVViewController.h"
#import "SJInviteUserViewController.h"
#import "SJLiveTVDetailViewController.h"
#import "SJLoginViewController.h"
#import "SJMessageCenterViewController.h"
#import "SJMessageDetailViewController.h"
#import "SJMessageSettingViewController.h"
#import "SJMultiVideoDetailViewController.h"
#import "SJSetFavoriteViewController.h"
#import "SJSettingViewController.h"
#import "SJShareVideoViewController.h"
#import "SJVideoDetailViewController.h"
#import "SJWatchTVDetailController.h"
#import "SJYueViewController.h"
#import "TPEditVideoViewController.h"
#import "TPRecordShortVideoViewController.h"
#import "SJMUCUserInfoViewController.h"
#import "SJLightViewController.h"
#import "MainViewController.h"
#import "RelationDeviceController.h"

@implementation UIViewController (NavigationBar)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewDidLoad);
        SEL swizzledSelector = @selector(hitv_viewDidLoad);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
        SEL originalWillAppearSelector = @selector(viewWillAppear:);
        SEL swizzledWillAppearSelector = @selector(hitv_viewWillAppear);
        
        Method originalWillAppearMethod = class_getInstanceMethod(class, originalWillAppearSelector);
        Method swizzledWillAppearMethod = class_getInstanceMethod(class, swizzledWillAppearSelector);
        
        BOOL didAddWillAppearMethod = class_addMethod(class, originalWillAppearSelector, method_getImplementation(swizzledWillAppearMethod), method_getTypeEncoding(swizzledWillAppearMethod));
        
        if (didAddWillAppearMethod) {
            class_replaceMethod(class, swizzledWillAppearSelector, method_getImplementation(originalWillAppearMethod), method_getTypeEncoding(originalWillAppearMethod));
        } else {
            method_exchangeImplementations(originalWillAppearMethod, swizzledWillAppearMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void)hitv_viewDidLoad {
   // [self hitv_viewDidLoad];
    self.navigationController.navigationBar.translucent=NO;

    if (self.navigationController == nil) {
        return;
    }
    if ([self.navigationController.viewControllers firstObject] != self) {
        if (self.navigationItem.leftBarButtonItems != nil) {
            return;
        }
        CGFloat KOffset = -15;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
            KOffset = -15;
        }
        int backRegionWidth = 44;
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage* image = [UIImage imageNamed:@"white_back_btn"];
        
        [button setImage:image forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 44, 44);
        [button addTarget:self action:@selector(p_backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        //    title.frame = CGRectMake(44, 0, backRegionWidth - 44, 44);
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backRegionWidth, 44)];
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton addTarget:self action:@selector(p_backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        backButton.frame = CGRectMake(0, 0, backRegionWidth, 44);
        [view addSubview:backButton];
        //    [view addSubview:title];
        [view addSubview:button];
        //    button.frame = CGRectMake(0, 0, 44, 44);
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = KOffset;// it was -6 in iOS 6
        [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:view]/*this will be the button which u actually need*/, nil] animated:NO];

        

    }else{
        self.navigationController.navigationBar.barTintColor = kNavgationBarColor;


    }
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:18.0f],
                                NSFontAttributeName,
                                kNavTitleColor,
                                NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [AppDelegate appDelegate].appdelegateService.coinView.hidden = YES;
    

    if ([self isKindOfClass:[WatchListViewController class]] ||
        [self isKindOfClass:[VideoHomeViewController class]] ||
        [self isKindOfClass:[ChannelViewController class]] ||
        [self isKindOfClass:[SJMyViewController class]]||
        [self isKindOfClass:[MainViewController class]]
        ){
        self.hidesBottomBarWhenPushed = NO;
    }
    else{
        self.hidesBottomBarWhenPushed = YES;
    }

}

- (void)hitv_viewWillAppear{
    
    if ([self isKindOfClass:[UINavigationController class]] || [self isKindOfClass:[UITabBarController class]] || [self isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
        return;
    }
    
    if ([self isKindOfClass:[OrderListViewController class]] ||
        [self isKindOfClass:[SJAboutViewController class]] ||
        [self isKindOfClass:[SJConnectTVViewController class]] ||
        [self isKindOfClass:[SJInviteUserViewController class]] ||
        [self isKindOfClass:[SJLiveTVDetailViewController class]] ||
        [self isKindOfClass:[SJLoginViewController class]] ||
        [self isKindOfClass:[SJMessageCenterViewController class]] ||
        [self isKindOfClass:[SJMessageDetailViewController class]] ||
        [self isKindOfClass:[SJMessageSettingViewController class]] ||
        [self isKindOfClass:[SJMultiVideoDetailViewController class]] ||
        [self isKindOfClass:[SJRemoteControlViewController class]] ||
        [self isKindOfClass:[SJSetFavoriteViewController class]] ||
        [self isKindOfClass:[SJLightViewController class]] ||
        [self isKindOfClass:[SJSettingViewController class]] ||
        [self isKindOfClass:[SJShareVideoViewController class]] ||
        [self isKindOfClass:[SJVideoDetailViewController class]] ||
        [self isKindOfClass:[SJWatchTVDetailController class]] ||
        [self isKindOfClass:[WatchListViewController class]] ||
        [self isKindOfClass:[SJYueViewController class]] ||
        [self isKindOfClass:[TPEditVideoViewController class]] ||
        [self isKindOfClass:[TPRecordShortVideoViewController class]] ||
        [self isKindOfClass:[SJMUCUserInfoViewController class]]||
        [self isKindOfClass:[RelationDeviceController class]] ) {
        self.navigationController.navigationBarHidden = YES;
        
        
    }
    else{
        self.navigationController.navigationBarHidden = NO;
        
    }

}

- (void)p_backButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
