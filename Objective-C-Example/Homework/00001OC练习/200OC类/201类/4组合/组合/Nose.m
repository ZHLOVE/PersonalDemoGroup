//
//  Nose.m
//  组合
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Nose.h"

@implementation Nose

- (NSString *)info
{
    NSString *str = [NSString stringWithFormat:@"一个%@的鼻子",self.bGao?@"高高的":@"塌"];
    
    return str;
}

@end
