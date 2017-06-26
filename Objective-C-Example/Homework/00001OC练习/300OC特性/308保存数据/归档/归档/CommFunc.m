//
//  CommFunc.m
//  综合应用
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "CommFunc.h"

//NSString *contatctTypeToString(ContactType type)
//{
//    NSArray *info = @[@"同事",@"亲戚",@"同学",@"朋友"];
//    return info[type-1];
//}

@implementation CommFunc

+ (NSString *)contatctTypeToString:(ContactType)type
{
    NSArray *info = @[@"同事",@"亲戚",@"同学",@"朋友"];
    return info[type-1];
}

@end
