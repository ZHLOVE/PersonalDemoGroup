//
//  SJVertifyCodeViewController.h
//  ShiJia
//
//  Created by 峰 on 2016/12/14.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductEntity.h"

@interface SJVertifyCodeViewController : UIViewController
@property (nonatomic, strong) NSString *stringID;
@property (nonatomic, strong) ProductEntity *dictParams;
@property (nonatomic, strong) NSMutableArray  *recommArray;
@property (nonatomic, strong) NSString *merchantCodeString;
@end
