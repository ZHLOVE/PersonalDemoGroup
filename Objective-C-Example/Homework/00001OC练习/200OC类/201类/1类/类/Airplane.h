//
//  Car.h
//  类
//
//  Created by niit on 15/12/23.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>


// 类的声明部分
@interface Airplane : NSObject
{
    // 1 声明实例变量
    //用来描述和保存类的信息
    //(作用域:整个类的内部都可以使用)
    
@private    // 私有 只有本类的方法可以访问,子类也不能访问
@protected  // 保护 本类和子类的方法可以访问  (默认)
@public     // 共有 其他外部的也可以通过->访问
    
    NSString *color;//颜色
    int price;//价格
    NSString *brand;//品牌
}

// 2 声明方法

// setter getter方法
// 提供给外部改变或者得到内部实例变量的值
- (void)setColor:(NSString *)c;// 设置值
- (NSString *)color;// 获取值

- (void)setPrice:(int)p;
- (int)price;

- (void)setBrand:(NSString *)b;
- (NSString *)brand;

- (void)printCarInfo;
// 提供的其他功能方法
- (void)drive;
- (void)addOil;


// 练习
// 1 参照color的setter getter方法写price brand的setter getter方法


@end