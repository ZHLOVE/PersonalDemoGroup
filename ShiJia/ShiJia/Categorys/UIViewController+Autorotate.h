//
//  UIViewController+Autorotate.h
//  ShiJia
//
//  Created by yy on 16/3/25.
//  Copyright © 2016年 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Autorotate)

@property(nonatomic)  BOOL showRemote;

/**
 *  常用方法
 */
-(void)showAlert:(NSString *)message withDelegate:(id)delegate;
-(void)showAlert:(NSString *)message sureText:(NSString *)text;

-(NSString *)regularcheck:(UITextField *)_field;
- (void)dispatchDelayed:(void (^)())block;
- (void)p_handleNetworkError;
- (void)p_handleError:(NSString*)error;

- (void)backToWatchListViewController;

/**
 *  获取当前的网络制式
 *
 *  @return wifi、4g、3g、2g
 */
- (NSString *)currentNetWorkStates;
/**
 *  强制横屏
 */
- (void)setDeviceLanLandscape;
/**
 *  强制竖屏
 */
- (void)setDevicePortrait;
@end
