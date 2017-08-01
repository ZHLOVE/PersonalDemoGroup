//
//  SJPayFinishViewController.h
//  ShiJia
//
//  Created by 峰 on 16/9/3.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductEntity.h"



@interface SJPayFinishViewController : BaseViewController

@property(nonatomic,strong) ProductEntity  *productEntity;
@property (nonatomic, strong) NSString *productServiceID;
@property (nonatomic, strong) NSMutableArray *recommArray;
@property (nonatomic, assign) BOOL isFromOrderPay;

@end
