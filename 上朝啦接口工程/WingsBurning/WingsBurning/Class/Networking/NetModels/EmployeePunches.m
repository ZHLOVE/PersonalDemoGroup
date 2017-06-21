//
//  EmployeePunches.m
//  WingsBurning
//
//  Created by MBP on 16/8/22.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "EmployeePunches.h"

#import "MJExtension.h"

@implementation EmployeePunches

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageHash = @"无imageHash";
        self.wirelessAp = @"无wifi名称";
        self.operatingSystem = @"无系统版本";
        self.longitude = @1.123;
        self.latitude = @1.123;
        self.phone_model = @"无手机型号";
    }
    return self;
}

MJExtensionLogAllProperties

@end
