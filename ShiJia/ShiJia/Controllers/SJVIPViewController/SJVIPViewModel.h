//
//  SJVIPViewModel.h
//  ShiJia
//
//  Created by 峰 on 16/9/7.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJPurchaseModel.h"

@interface SJVIPViewModel : NSObject

-(RACSignal *)requestVIPPackage:(SJGetVIPModel *)requestModel;

@end
