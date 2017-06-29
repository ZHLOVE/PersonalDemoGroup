//
//  ChangeRule.m
//  WingsBurning
//
//  Created by MBP on 2017/3/2.
//  Copyright © 2017年 leqi. All rights reserved.
//

#import "ChangeRule.h"
#import "MJExtension.h"


@implementation ChangeRule
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

MJExtensionLogAllProperties

@end
