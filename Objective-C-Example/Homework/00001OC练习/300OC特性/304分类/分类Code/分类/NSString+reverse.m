//
//  NSString+reverse.m
//  分类
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "NSString+reverse.h"

@implementation NSString(reverse)

- (NSString *)reverseString
{
    NSMutableString *resultStr = [NSMutableString string];
    for (int i=self.length-1; i>=0; i--)
    {
        [resultStr appendString:[[self substringFromIndex:i] substringToIndex:1]];
    }
    return resultStr;
}

@end
