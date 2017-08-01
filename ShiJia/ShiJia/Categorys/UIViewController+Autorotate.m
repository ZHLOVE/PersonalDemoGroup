//
//  UIViewController+Autorotate.m
//  ShiJia
//
//  Created by yy on 16/3/25.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "UIViewController+Autorotate.h"

#import "SJMultiVideoDetailViewController.h"
#import "WatchListViewController.h"
#import "SJVideoDetailViewController.h"
#import "SJShareVideoViewController.h"
#import "SJWatchTVDetailController.h"

@implementation UIViewController (Autorotate)

- (BOOL)shouldAutorotate
{
    if ([self isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabController = (UITabBarController *)self;
        UINavigationController *navController = tabController.selectedViewController;
        
        if ([self checkTopControllerIsSpecified:navController]) {
            return YES;
            
        }
    }
    else if ([self isKindOfClass:[UINavigationController class]]){
        
        UINavigationController *navController = (UINavigationController *)self;
        if ([navController.topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabController = (UITabBarController *)navController.topViewController;
            UINavigationController *secondNavController = tabController.selectedViewController;
            
            if ([self checkTopControllerIsSpecified:secondNavController]) {
                
                return YES;
            }
        }
        else{
            if ([self checkTopControllerIsSpecified:navController]) {
                return YES;
            }
        }
        
    }
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([self isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabController = (UITabBarController *)self;
        UINavigationController *navController = tabController.selectedViewController;
        
        if ([self checkTopControllerIsSpecified:navController]) {
            return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;

        }
    }
    else if ([self isKindOfClass:[UINavigationController class]]){
        
        UINavigationController *navController = (UINavigationController *)self;
        if ([navController.topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabController = (UITabBarController *)navController.topViewController;
            UINavigationController *secondNavController = tabController.selectedViewController;
           
            if ([self checkTopControllerIsSpecified:secondNavController]) {
              
                return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
            }
        }
        else{
            if ([self checkTopControllerIsSpecified:navController]) {
                return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
            }
        }
        
    }

    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    
    if ([self isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabController = (UITabBarController *)self;
        UINavigationController *navController = tabController.selectedViewController;
        
        if ([self checkTopControllerIsSpecified:navController]) {
            return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
            
        }
    }
    else if ([self isKindOfClass:[UINavigationController class]]){
        
        UINavigationController *navController = (UINavigationController *)self;
        if ([navController.topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabController = (UITabBarController *)navController.topViewController;
            UINavigationController *secondNavController = tabController.selectedViewController;
            
            if ([self checkTopControllerIsSpecified:secondNavController]) {
                
                return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
            }
        }
        else{
            if ([self checkTopControllerIsSpecified:navController]) {
                return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
            }
        }
        
    }
    
    return UIInterfaceOrientationPortrait;
    
}

- (BOOL)checkTopControllerIsSpecified:(UINavigationController *)navController
{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([navController.topViewController isKindOfClass:[SJMultiVideoDetailViewController class]] ||
        [navController.topViewController isKindOfClass:[SJShareVideoViewController class]]) {
        return !delegate.isLockDevice;
    }
//    if ([navController.topViewController isKindOfClass:[SJVideoDetailViewController class]] ||
//        [navController.topViewController isKindOfClass:[SJLiveTVDetailViewController class]] ||
//        [navController.topViewController isKindOfClass:[SJEntertainmentDetailViewController class]]||
//        [navController.topViewController isKindOfClass:[SJWatchTVDetailController class]] ||
//        [navController.topViewController isKindOfClass:[SJShareVideoViewController class]]) {
//        return !delegate.isLockDevice;
//    }
    return NO;
}

#pragma mark -
- (void)dispatchDelayed:(void (^)())block
{
    double delayInSeconds = 0.2;//1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

#pragma mark - UIAlertView
- (void)showAlert:(NSString *)message withDelegate:(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:message
                                                  delegate:delegate
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil, nil];
    [alert show];
}
-(void)showAlert:(NSString *)message sureText:(NSString *)text{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:text otherButtonTitles:nil, nil];
    [alert show];
}
//输入框非空校验
- (NSString *)regularcheck:(UITextField *)_field
{
    if (_field.text == nil) {
        return @"";
    }
    return _field.text;
}

- (void)p_handleError:(NSString*)error
{
    [self p_handleNetworkError];
}

- (void)p_handleNetworkError
{
    MBProgressHUD* HUD = [MBProgressHUD HUDForView:self.view];
    if (HUD == nil) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = @"网络不给力， 稍后再试";
        HUD.removeFromSuperViewOnHide = YES;
        [HUD hide:NO afterDelay:2];
    }
}

#pragma mark - 
- (void)backToWatchListViewController
{
    DDLogInfo(@"%@",self.navigationController.viewControllers);
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[self class]]) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[WatchListViewController class]]) {
                WatchListViewController *main = (WatchListViewController *)controller;
                
                [self.navigationController popToViewController:main animated:YES];
            }
        }
    }
    
}

- (NSString *)currentNetWorkStates {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                    state = @"WiFi";
                    break;
                default:
                    break;
            }
        }
        
    }
    //根据状态选择
    return state;
}

- (void)setDevicePortrait {
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)setDeviceLanLandscape {
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
-(void)setShowRemote:(BOOL)showRemote{
    if (showRemote) {
        [AppDelegate appDelegate].appdelegateService.coinView.hidden = NO;
    }
    else{
        [AppDelegate appDelegate].appdelegateService.coinView.hidden = YES;
    }
}
@end
