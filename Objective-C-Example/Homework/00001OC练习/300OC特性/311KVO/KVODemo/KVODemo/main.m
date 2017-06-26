//
//  main.m
//  KVODemo
//
//  Created by niit on 16/1/19.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Person.h"
#import "Stock.h"

#import "StreetCorssLed.h"

#import "Man.h"
#import "Wife.h"
#import "Company.h"

#pragma mark - KVO
//KVO （Key-Value Observing)键-值-监看
// * 典型的观察者模式
// * 提供一种机制，每次指定的被观察的对象的属性被修改后，KVO就会自动通知相应的观察者。

// 官方文档搜:
//Introduction to Key-Value Observing Programming Guide

#pragma mark - 流程:
// 1 添加监看(注册监看)
//        - (void)addObserver:(NSObject *)observer
//                 forKeyPath:(NSString *)keyPath
//                    options:(NSKeyValueObservingOptions)options
//                    context:(nullable void *)context;// 添加监看
//[被监看对象 addObserver:监看对象
//           forKeyPath:监看的属性
//              options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
//              context:附带参数对象]];

// 2 监看对象添加监看的处理方法(KVO触发时的处理)
//- (void)observeValueForKeyPath:(NSString *)keyPath                     // 键值
//                      ofObject:(id)object                              // 哪个对象
//                        change:(NSDictionary<NSString *,id> *)change   // 发生了什么改变
//                       context:(void *)context                         // 附带的参数

// 3 不需监看时必须移除监看(取消监看)
//        - (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context NS_AVAILABLE(10_7, 5_0);// 移除监看
//        - (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;// 移除监看
//[被监看对象 removeObserver:监看对象 forKeyPath:监看的属性];

#pragma mark - 注意:
// * 监看对象和被监看对象可以是同一对象
// * 监看对象和被监看对象销毁是应该先移除监看

#pragma mark - 具体应用之处:
// MVC编程模式中,让Controller对象监看Model对象,当Model的数据改变时,Controller对象改变View中的显示。

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
#pragma mark - 例子1 
        // 人监看股票的价格,股票价格改变时,人要做相应处理
        
        // Person对象
//        Person *p= [[Person alloc] initWithName:@"小明"];
        
        // Stock对象
//        Stock *s = [[Stock alloc] initWithName:@"中国石化" andPrice:10.0];
//        
//        // 小明买了中国石化的股票
//        p.myStock = s;
//        
//        // 小明每天查看中国石化股票的涨跌
//        // [被监看对象 addObserver:监看人 forKeyPath:监看的舒心 options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld  context:nil]];
//        [s addObserver:p forKeyPath:@"price" options: NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld  context:nil];
//        
#pragma mark - 练习1
//交通灯类StreetCrossLed类
//定时切换状态
//红灯 5s
//黄灯 1s
//绿灯 3s
//黄灯 1s
//一个人的类Person
//添加一个对交通灯类对象进行监看
//红灯->黄灯 打印@"可以准备走了"
//黄灯->绿灯 打印@"绿灯了，快走！"
//绿灯->黄灯 打印@"准备停下！"
//黄灯->红灯 打印@"停下！"
        
//        StreetCorssLed *led = [[StreetCorssLed alloc] init];
//        p.led = led;
        
#pragma mark - 练习2
// 小明对象
// 小明的工资卡对象
// 小明所在公司对象
// 小明老婆

// 1 公司每月向小明的工资卡里存钱。
// 2 小明老婆每天不定时不定数量刷卡消费若干钱。(每天随机1/10概率进行消费，消费金额是当前余额的5%~100%,不能超支)
// 3 小明监看小明的工资卡。显示不同信息
//   (增加时显示"这个月工资到了!"）
//   (减少时显示“老婆又消费了,好心疼!”)
// 4 小明老婆监看小明工资卡.
//   (当发现增加时,显示"老公的工资到了，又可以买买了!"）
        
        Man *m = [[Man alloc] initWithName:@"小明"];
        Wife *w = [[Wife alloc] init];
        w.myHusbandCard = m.card;
        Company *c = [[Company alloc] init];
        c.xiaominCard = m.card;
        
        [[NSRunLoop currentRunLoop] run];// 进入事件循环,程序不会退出，但程序中的对象可以相应各种事件

    }
    return 0;
}
