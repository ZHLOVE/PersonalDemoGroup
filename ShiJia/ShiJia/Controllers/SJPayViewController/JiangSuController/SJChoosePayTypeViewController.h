//
//  SJChoosePayTypeViewController.h
//  ShiJia
//
//  Created by 峰 on 2016/12/14.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//
//!!!:只针对江苏版本
//!!!:只针对江苏版本
#import <UIKit/UIKit.h>
#import "ProductEntity.h"

@interface SJChoosePayTypeViewController : UIViewController
@property (nonatomic, strong) NSString *sequenceId;
@property (nonatomic, strong) ProductEntity *dictParams;
@property (nonatomic, strong) NSMutableArray  *recommArray;
@property (nonatomic, strong) NSString *merchantCodeString;
@property (nonatomic, assign) BOOL fromOrderVC;
@end
