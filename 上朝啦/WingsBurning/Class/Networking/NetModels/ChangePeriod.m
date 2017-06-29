//
//  ChangePeriod.m
//  WingsBurning
//
//  Created by MBP on 2017/3/2.
//  Copyright © 2017年 leqi. All rights reserved.
//

#import "ChangePeriod.h"
#import "MJExtension.h"

@implementation ChangePeriod
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

MJExtensionLogAllProperties
@end
