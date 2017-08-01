//
//  SJAdView.h
//  ShiJia
//
//  Created by yy on 2017/5/18.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJAdView : UIView

@property (nonatomic, copy) void(^clickAdBlock)();
@property (nonatomic, strong) UIViewController *activeController;

- (instancetype)initWithTitle:(NSString *)text imageUrl:(NSString *)imgString actionUrl:(NSString *)actionString;

@end
