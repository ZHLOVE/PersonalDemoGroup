//
//  Controller.m
//  协议
//
//  Created by niit on 16/1/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Controller.h"

@implementation Controller

// 提供表格标题
- (NSString *)tableTitle
{
    return @"班级成员列表";
}

// 提供表格内容数组(字符串数组)
- (NSArray *)tableContent
{
    return @[@"张三",@"李四",@"王五",@"赵六"];
}

@end
