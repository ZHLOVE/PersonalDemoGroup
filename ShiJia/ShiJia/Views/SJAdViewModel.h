//
//  SJAdViewModel.h
//  ShiJia
//
//  Created by yy on 2017/5/26.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJAdViewModel : NSObject

@property (nonatomic, copy) void(^loadAdFailedBlock)();

- (instancetype)initWithActiveController:(UIViewController *)controller;

- (void)start;

@end

