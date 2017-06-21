//
//  ContractM.m
//  WingsBurning
//
//  Created by MBP on 16/8/22.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "ContractM.h"
#import "MJExtension.h"


@implementation ContractM
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
MJExtensionLogAllProperties
//    "none"          goToCompanyList
//    "created",      goToContractInfo
//    "established",  JieYue
//    "termination_requested", goToContractInfo
//    "terminated",   goToCompanyList
//    "rejected"      goToContractInfo
- (NSString *)state{
    if ([_state isEqualToString:@"created"]) {
        return @"等待合约审核";
    }else if ([_state isEqualToString:@"termination_requested"]){
        return @"等待解约审核";
    }else if ([_state isEqualToString:@"established"]){
        return @"已经签约";
    }
    return _state;
}
@end
