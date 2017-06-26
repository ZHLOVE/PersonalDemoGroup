//
//  Child.h
//  NSRunLoop和NSTimer
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Child;

// 定义协议
// 一般命名方式: 类名+Delegate
@protocol ChildDelegate <NSObject>

// 喂养小孩的方法
@required // 必须要实现的方法
- (void)feedChild:(Child *)c;

@optional // 可选实现的方法,代理人可以不实现
- (void)playWithChild:(Child *)c;

@end


@interface Child : NSObject

// 饥饿度
@property (nonatomic,assign) int hungry;
// 快乐值
@property (nonatomic,assign) int happyniess;

- (void)cry:(NSTimer *)t;

// id 是泛类型,可以指向任何类型对象
// id<某协议> 是指实现了某协议的任何类的对象
@property (nonatomic,weak) id<ChildDelegate> delegate;// 一般会命名为delegate

//@property (nonatomic,weak) id<ChildDelegate> delegate2; // 可能是有多个代理人。

@end
