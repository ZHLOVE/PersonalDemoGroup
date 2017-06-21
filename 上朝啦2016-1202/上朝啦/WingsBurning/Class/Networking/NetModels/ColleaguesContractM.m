//
//  ColleaguesContractM.m
//  WingsBurning
//
//  Created by MBP on 16/9/13.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "ColleaguesContractM.h"
#import "MJExtension.h"


@implementation ColleaguesContractM

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
MJExtensionLogAllProperties

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
