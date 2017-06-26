//
//  SmallBoat.m
//  继承
//
//  Created by niit on 15/12/29.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "SmallBoat.h"

@implementation SmallBoat

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"小木船";
        self.speed = 10;
    }
    return self;
}

@end
