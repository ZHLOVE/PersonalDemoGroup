//
//  Monster.m
//  组合
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "Monster.h"

@implementation Monster

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

- (void)move:(Direction)d
{
    switch (d) {
        case kDirectionUp:
            self.y--;
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

@end
