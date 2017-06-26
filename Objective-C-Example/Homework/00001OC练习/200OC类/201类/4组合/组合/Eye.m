//
//  Eye.m
//  组合
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Eye.h"

#import "CommFunc.h"

@implementation Eye

- (NSString *)info
{
    NSString *str = [NSString stringWithFormat:@"一双%@%@的眼睛",[CommFunc colorStr:self.color],self.bShuang?@"双眼皮":@"单眼皮"];
    
    return str;
}

@end
