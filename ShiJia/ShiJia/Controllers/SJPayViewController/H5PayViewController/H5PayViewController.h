//
//  H5PayViewController.h
//  ShiJia
//
//  Created by 峰 on 2017/3/29.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "BaseViewController.h"
#import "SJPhoneFareModel.h"
#import "ProductEntity.h"
@interface H5PayViewController : UIViewController
@property (nonatomic, strong) H5PayParams     *payParams;
@property (nonatomic, strong) ProductEntity   *dictParams;
@property (nonatomic, strong) NSString        *orderNoString;
@property (nonatomic, strong) NSMutableArray  *recommArray;
@property (nonatomic, strong) NSString        *merchantCodeString;
@property (nonatomic, assign) BOOL fromOrderPay;
@end
