//
//  Punch.m
//  WingsBurning
//
//  Created by MBP on 16/8/22.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "Punch.h"
#import "MJExtension.h"

@implementation Punch
/**
 *  服务器时间转本机时间
 */
- (void)setCreated_at:(NSString *)created_at{
//2016-09-19T14:11:22+8000>>>2016-09-19 14:11:22
    NSMutableString *str = [[created_at substringToIndex:19] mutableCopy];
    [str replaceCharactersInRange:NSMakeRange(10, 1) withString:@" "];
    _created_at = str;
}





- (NSString *)punchDate{
    NSString *str = [_created_at substringToIndex:10];
    return str;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
MJExtensionLogAllProperties

@end
