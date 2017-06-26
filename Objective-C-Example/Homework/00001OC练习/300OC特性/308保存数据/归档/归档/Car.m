//
//  Car.m
//  归档
//
//  Created by niit on 16/1/12.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Car.h"

@implementation Car

- (instancetype)initWithDictionary:(NSDictionary *)d
{
    self = [super init];
    if (self) {
        self.brand = d[@"品牌"];
        self.type = d[@"型号"];
        self.price = [d[@"价格"] intValue];
    }
    return self;
}

@end
