//
//  Round.h
//  类
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

// 7 定义一个界面上的圆形类
// 中心点在屏幕上的坐标、半径
// 提供 计算周长、面积的方法
struct MyPoint
{
    int x;
    int y;
};
typedef struct MyPoint MyPoint;

@interface Round : NSObject

// 1 属性
// 中心点坐标
//@property (nonatomic,assign) int x;
//@property (nonatomic,assign) int y;

@property (nonatomic,assign) MyPoint center;

// 半径
@property (nonatomic,assign) int r;

// 2 方法
// 周长
- (float)perimeter;
- (float)area;


@end
