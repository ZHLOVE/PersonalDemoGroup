//
//  SJNormalMessageModel.m
//  ShiJia
//
//  Created by yy on 16/4/19.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJNormalMessageModel.h"
#import "UserEntity.h"

@implementation SJNormalMessageModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"from" : @"from",
             @"msgId" : @"msgId",
             @"read" : @"read",
             @"time" : @"time",
             @"title" : @"title",
             @"to" : @"to",
             @"type" : @"type"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"to" : [UserEntity class]};
}

@end
