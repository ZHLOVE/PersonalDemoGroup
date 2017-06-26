//
//  Person.m
//  谓词Demo
//
//  Created by niit on 16/1/20.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)initWithName:(NSString *)n andAge:(int)a andReward:(int)r
{
    self = [super init];
    if (self) {
        self.name = n;
        self.age = a;
        self.reward = r;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@:%i岁 成绩:%i",self.name,self.age,self.reward];
}
@end
