//
//  NSNumber+China.m
//  分类
//
//  Created by niit on 16/1/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "NSNumber+China.h"

@implementation NSNumber (China)


- (NSString *)toBigChinaString
{
    NSMutableString *resultStr = [NSMutableString string];
 
    //101
    //10
    //1
    int tmp = [self doubleValue]*100;
    
    int curr = 0;// 位
    while(tmp>0)
    {
        // 求每一位上的数字
        int tmpNum = tmp%10;

        // 添加元
        if(curr == 2)
        {
            if(resultStr.length == 0)
            {
                [resultStr appendString:@"整"];
            }
            [resultStr insertString:@"元" atIndex:0];
        }
        
        // 不为0的情况才需要添加面值和数字
        if(tmpNum!=0)
        {
            // 添加面值
            NSArray *strArr = @[@"分",@"角",[NSNull null],@"拾",@"佰",@"仟",@"万",@"拾",@"佰",@"仟",@"亿"];
            if(curr!=2)
            {
                [resultStr insertString:strArr[curr] atIndex:0];
            }
        
            // 添加数字
            NSArray *bigNum = @[@"零",@"壹",@"贰",@"叁",@"肆",@"伍",@"陆",@"柒",@"捌",@"玖"];
            [resultStr insertString:bigNum[tmpNum] atIndex:0];
        }
        tmp/= 10;
        
        curr++;
    }
    
//    - (BOOL)hasPrefix:(NSString *)str;// 有没有前缀
//    - (BOOL)hasSuffix:(NSString *)str;// 后缀
    
    if([resultStr hasPrefix:@"壹拾"])
    {
        [resultStr deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    
    return resultStr;
}
@end
