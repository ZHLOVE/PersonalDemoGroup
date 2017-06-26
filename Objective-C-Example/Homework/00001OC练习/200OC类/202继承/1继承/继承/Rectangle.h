//
//  Rectangle.h
//  继承
//
//  Created by niit on 15/12/29.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rectangle : NSObject

@property (nonatomic,assign) int width;
@property (nonatomic,assign) int height;

// 实例初始化方法
- (instancetype)initWithWidth:(int)w andHeight:(int)h;
// 类方法，创建并初始化
+ (instancetype)rectangleWithWidth:(int)w andHeight:(int)h;

- (int)perimeter;
- (int)area;

@end
