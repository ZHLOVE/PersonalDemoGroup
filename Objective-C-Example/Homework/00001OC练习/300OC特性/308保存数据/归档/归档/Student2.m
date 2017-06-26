//
//  Student2.m
//  归档
//
//  Created by niit on 16/1/13.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Student2.h"

@implementation Student2

- (instancetype)initWithDictionary:(NSDictionary *)d
{
    self = [super init];
    if (self) {
        self.stuId = d[@"stuId"];
        self.name = d[@"name"];
        self.age = [d[@"age"] intValue];
        self.reward = [d[@"reward"] intValue];
    }
    return self;
}

@end
