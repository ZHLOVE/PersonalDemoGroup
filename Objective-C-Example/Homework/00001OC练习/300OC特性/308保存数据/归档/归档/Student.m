//
//  Student.m
//  归档
//
//  Created by niit on 16/1/12.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Student.h"

@implementation Student

// 定义宏定义,防止归档和解档时的key因为敲错而不一致造成错误
#define kName @"Name"
#define kAge @"Age"

// 归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:kName];
    [aCoder encodeInt:self.age forKey:kAge];
}

// 解档
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    // 如果父类支持NSCoding 则这里写 self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.name = [aDecoder decodeObjectForKey:kName];
        self.age = [aDecoder decodeIntForKey:kAge];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"姓名:%@ 年龄:%i",self.name,self.age];
}

@end
