//
//  Circle.m
//  多态
//
//  Created by niit on 15/12/30.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Circle.h"

@implementation Circle

- (instancetype)initWithR:(float)r
{
    self = [super init];
    if (self)
    {
        self.r = r;
    }
    return self;
}

- (float)area
{
    return M_PI*self.r*self.r;
}
- (float)perimeter
{
    return 2*M_PI*self.r;
}

@end
