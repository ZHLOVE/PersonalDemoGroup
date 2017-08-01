//
//  SJVIPViewModel.m
//  ShiJia
//
//  Created by 峰 on 16/9/7.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJVIPViewModel.h"
#import "SJVIPNetWork.h"


@implementation SJVIPViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(RACSignal *)requestVIPPackage:(SJGetVIPModel *)requestModel {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        [SJVIPNetWork SJ_VIPPackagesRequest:requestModel Block:^(id result, NSString *error) {
        
            if (error) {
                
                [subscriber sendError:SJERROR(error)];
            
            }else{
                if ([[result objectForKey:@"result"]isEqualToString:@"ORD-000"]) {
                   
                    NSArray *array = [SJVIPPackageModel mj_objectArrayWithKeyValuesArray:[result objectForKey:@"productList"]];
                    
                    [subscriber sendNext:array];
                    
                }else{

                    [subscriber sendError:SJERROR([result objectForKey:@"message"])];
                }
            
            
            }
        }];
        
        return [RACDisposable disposableWithBlock:^{
            //销毁信号-----
        }];
    }];
}


@end
