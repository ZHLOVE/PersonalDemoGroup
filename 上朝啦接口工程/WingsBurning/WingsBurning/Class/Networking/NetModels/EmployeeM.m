//
//  EmployeeM.m
//  WingsBurning
//
//  Created by MBP on 16/8/19.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "EmployeeM.h"
#import "MJExtension.h"


@implementation EmployeeM

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
MJExtensionLogAllProperties
@end
