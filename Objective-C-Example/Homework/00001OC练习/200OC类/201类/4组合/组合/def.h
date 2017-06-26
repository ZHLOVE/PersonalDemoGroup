//
//  def.h
//  组合
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#ifndef def_h
#define def_h

// 宏定义 定义地图大小
#define kMapSize 10

// 颜色枚举类型
enum Color
{
    kColorBlack,
    kColorBrown,
    kColorBlue,
    kColorWhite,
    kColorGold,
    kColorMax
};
typedef enum Color Color;

// 方向枚举类型
enum Direction
{
    kDirectionUp,
    kDirectionLeft,
    kDirectionDown,
    kDirectionRight
};
typedef enum Direction Direction;

#endif /* def_h */
