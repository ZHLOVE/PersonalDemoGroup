//
//  SJCoupViewModel.h
//  ShiJia
//
//  Created by 峰 on 16/9/9.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJPurchaseModel.h"

@interface SJCoupViewModel : NSObject

// 获取未使用的优惠券
-(RACSignal *)getUnUseTickets:(SJGetTicketsModel *)requestModel;
//获取已经使用
-(RACSignal *)getUsedTickets:(SJGetTicketsModel *)requestModel;
//获取已经过去的
-(RACSignal *)getInvailTickets:(SJGetTicketsModel *)requestModel;
@end
