//
//  SJCoupViewModel.m
//  ShiJia
//
//  Created by 峰 on 16/9/9.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJCoupViewModel.h"
#import "SJVIPNetWork.h"


@implementation SJCoupViewModel


-(RACSignal *)getUnUseTickets:(SJGetTicketsModel *)requestModel {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [SJVIPNetWork SJ_CouponTicketsRequest:requestModel Block:^(id result, NSString *error) {
            if (error) {
                [subscriber sendError:SJERROR(error)];
            }else{
                
                if ([result[@"result"] isEqualToString:@"ORD-000"]) {
                    NSArray *array =[ SJTicketsModel mj_objectArrayWithKeyValuesArray:result[@"ticketList"]];
                    
                    
                    [subscriber sendNext:array];
                }
            
            }
        
        }];
        
        return [RACDisposable disposableWithBlock:^{
            //销毁信号-----
        }];
    }];

}

-(RACSignal *)getUsedTickets:(SJGetTicketsModel *)requestModel {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [SJVIPNetWork SJ_CouponTicketsRequest:requestModel Block:^(id result, NSString *error) {
            if (error) {
                [subscriber sendError:SJERROR(error)];
            }else{
                
                if ([result[@"result"] isEqualToString:@"ORD-000"]) {
                    NSArray *array =[ SJTicketsModel mj_objectArrayWithKeyValuesArray:result[@"ticketList"]];
                    [subscriber sendNext:array];
                }
                
            }
            
        }];
        
        return [RACDisposable disposableWithBlock:^{
            //销毁信号-----
        }];
    }];
}

-(RACSignal *)getInvailTickets:(SJGetTicketsModel *)requestModel {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [SJVIPNetWork SJ_CouponTicketsRequest:requestModel Block:^(id result, NSString *error) {
            if (error) {
                [subscriber sendError:SJERROR(error)];
            }else{
                
                if ([result[@"result"] isEqualToString:@"ORD-000"]) {
                    NSArray *array =[ SJTicketsModel mj_objectArrayWithKeyValuesArray:result[@"ticketList"]];
                    [subscriber sendNext:array];
                }
                
            }
            
        }];
        
        return [RACDisposable disposableWithBlock:^{
            //销毁信号-----
        }];
    }];
}
@end
