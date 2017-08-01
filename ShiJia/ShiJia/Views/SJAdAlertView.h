//
//  SJAdAlertView.h
//  ShiJia
//
//  Created by yy on 2017/5/25.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJAdAlertView : UIView

@property (nonatomic, strong) UIViewController *activeController;

@property (nonatomic, copy) void(^bottomButtonClickedBlock)();

- (instancetype)initWithTitle:(NSString *)text imageUrl:(NSString *)imgString actionUrl:(NSString *)actionString;

- (void)show;
- (void)hide;

@end
