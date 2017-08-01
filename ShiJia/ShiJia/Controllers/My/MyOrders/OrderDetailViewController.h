//
//  OrderDetailViewController.h
//  ShiJia
//
//  Created by 蒋海量 on 16/9/2.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderEntity.h"

@interface OrderDetailViewController : BaseViewController
@property (nonatomic, strong) OrderEntity* orderEntity; //订单列表实体
@end
