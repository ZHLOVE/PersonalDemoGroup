//
//  PunchesGather.m
//  WingsBurning
//
//  Created by MBP on 16/9/23.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "PunchesGather.h"
#import "MJExtension.h"

@implementation PunchesGather

MJExtensionLogAllProperties


- (NSString *)normal_days{
    return [_normal_days stringByAppendingString:@"天"];
}

- (NSString *)late_minutes{
    return [_late_minutes stringByAppendingString:@"分钟"];
}

- (NSString *)early_minutes{
    return [_early_minutes stringByAppendingString:@"分钟"];
}

- (NSString *)absent_days{
    return [_absent_days stringByAppendingString:@"天"];
}

@end
