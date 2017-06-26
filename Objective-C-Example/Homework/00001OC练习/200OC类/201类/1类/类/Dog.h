//
//  Dog.h
//  类
//
//  Created by niit on 15/12/28.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

// 属性:
// 颜色
// 名字
// 体重Kg
// 方法:
// 吃(每吃一次，体重增加0.5kg，吃完后显示一下当前体重)
// 叫唤(打印输出@"汪~汪")

enum DogColor
{
    kDogColorBlack,
    kDogColorWhite,
    kDogColorYello,
    kDogColorBlackWhite,
    kDogColorBlackBrown,
    kDogColorMax
};
typedef enum DogColor DogColor;

@interface Dog : NSObject
//{
//    //1 实例变量
//    NSString *color;
//    NSString *name;
//    float weight;
//}

// 1 属性
// 不是变量，它是会帮你生成相关的代码!
//@property (nonatomic,copy) NSString *color;

// 状态少用字符串,应该用枚举类型
@property (nonatomic,assign) DogColor color;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) float weight;

//2 方法
- (void)eat;
- (void)sing;
- (void)printInfo;

//// setter getter方法
//- (void)setColor:(NSString *)c;
//- (NSString *)color;
//
//- (void)setName:(NSString *)n;
//- (NSString *)name;
//
//- (void)setWeight:(float)w;
//- (NSString *)wieght;





@end
