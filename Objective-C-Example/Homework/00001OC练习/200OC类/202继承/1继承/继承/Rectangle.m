//
//  Rectangle.m
//  继承
//
//  Created by niit on 15/12/29.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Rectangle.h"

@implementation Rectangle

- (instancetype)initWithWidth:(int)w andHeight:(int)h
{
    self = [super init];
    if (self)
    {
        self.width = w;
        self.height = h;
    }
    return self;
}

+ (instancetype)rectangleWithWidth:(int)w andHeight:(int)h
{
    return [[[self class] alloc] initWithWidth:w andHeight:h];
    
//    Rectangle *rect = [[Rectangle alloc] init];
//    rect.width = w;
//    rect.height = h;
//    return rect;
}

- (int)perimeter
{
    return  2*(self.width+self.height);
}
- (int)area
{
    return self.width*self.height;
}


@end
