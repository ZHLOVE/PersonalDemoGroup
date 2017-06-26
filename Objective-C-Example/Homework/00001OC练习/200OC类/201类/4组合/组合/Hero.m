//
//  Player.m
//  组合
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Hero.h"

@implementation Hero

- (void)move:(Direction)d
{
    switch (d) {
        case kDirectionUp:
            self.y--;// => self.y = self.y - 1; => [self setY:([self y] - 1)];
            break;
        case kDirectionDown:
            self.y++;
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
@end
