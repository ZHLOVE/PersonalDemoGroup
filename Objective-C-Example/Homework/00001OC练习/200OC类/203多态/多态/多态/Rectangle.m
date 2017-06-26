//
//  Rectangle.m
//  多态
//
//  Created by niit on 15/12/30.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Rectangle.h"

@implementation Rectangle

- (instancetype)initWithWidth:(float)w andHeight:(float)h
{
    self = [super init];
    if (self) {
        self.width = w;
        self.height = h;
    }
    return self;
}

- (float)area
{
    return self.width*self.height;
}

- (float)perimeter
{
    return 2*(self.width+self.height);
}

@end
