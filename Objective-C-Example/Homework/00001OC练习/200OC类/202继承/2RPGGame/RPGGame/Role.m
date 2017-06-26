//
//  Role.m
//  RPGGame
//
//  Created by niit on 15/12/29.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Role.h"

@implementation Role

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.x = arc4random()%kMapSize;
        self.y = arc4random()%kMapSize;
    }
    return self;
}

- (void)move:(Direction)d
{
    switch (d) {
        case kDirectionUp:
            //self.y--;
            // 1 => self.y = self.y - 1;
            // 2 => [self setY:([self y] - 1)];
            _y--; // 实例变量操作
            break;
        case kDirectionDown:
            //self.y++;
            _y++;
            break;
        case kDirectionLeft:
            self.x--;
            break;
        case kDirectionRight:
            self.x++;
            break;
            
        default:
            break;
    }
}

// 属性会帮你创建setter和getter方法，但如果写了setter getter方法，则会使用你写的setter getter方法
- (void)setX:(int)x
{
    if(x>=0 && x<kMapSize)
    {
        _x = x;
    }
}

- (void)setY:(int)y
{
    // 如果在地图范围内的
    if(y>=0 && y<kMapSize)
    {
        _y = y;
    }
}

- (void)walkOneStep
{
    
}
@end
