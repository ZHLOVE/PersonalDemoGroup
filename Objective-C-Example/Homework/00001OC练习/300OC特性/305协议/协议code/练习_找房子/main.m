//
//  main.m
//  练习:找房子
//
//  Created by niit on 16/1/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Person.h"
#import "Agent.h"
#import "Friend.h"
#import "Girl.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        Person *xiaoming = [[Person alloc] init];
        Agent *agent = [[Agent alloc] init];
//        Friend *friend = [[Friend alloc] init];
        Girl *g = [[Girl alloc] init];
        
        xiaoming.delegate = g;
        xiaoming.girlFriend = g;
        
        [[NSRunLoop currentRunLoop] run];
        
        //练习:
        //小明(Person类)刚到上海工作，住在公司宿舍，由于刚入职，工作繁忙没有空余时间，他就委托中山房产 中介公司(Agent类)和他的朋友 小张(Friend类)找房子。
        //他每天给中介公司或小张打电话，询问有没有合适的房源。他的心理价位是1000元每月.（即等于1000的时候，即找到房子）
        //如果中介公司帮他找房子，每天能找到的一处房源的价格800~3000随机
        //如果小张帮他找，每天能找到一处价格约500~4000的房子
        
        //编写程序，运行直到到找到房子。显示当天星期几，显示每天中介或者小张帮他找到房子的价格。
        
        //再写一个女朋友协议
        //必须实现的方法:
        //做饭
        //可选方法:
        //洗衣服
        //小明每天让女朋友帮他做饭，如果女朋友实现了洗衣服，则让女朋友洗衣服。
    }
    return 0;
}
