//
//  Face.m
//  组合
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Face.h"

@implementation Face

// 在创建脸的同时，同时创建这个对象的子部件
//- (id)init
//{
//    self = [super init];
//    if(self)
//    {
//        self.eye = [[Eye alloc] init];
//        self.nose = [[Nose alloc] init];
//    }
//    return self;
//}

- (NSString *)info
{
    NSString *str = [NSString stringWithFormat:@"%@,%@",[self.eye info],[self.nose info]];
    return str;
}

@end
