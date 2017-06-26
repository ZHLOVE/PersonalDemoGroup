//
//  main.m
//  单例模式
//
//  Created by niit on 15/12/31.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserContext.h"
#import "ClassB.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        // 单例模式 整个程序中只有一个这个类的对象
        
//        UserContext *userInfo = [[UserContext alloc] init];  =>
        UserContext *userInfo = [UserContext sharedUserContext];// 通过单例模式的方法得到对象
        userInfo.username = @"zhangsan";
        userInfo.password = @"123456";
        userInfo.logined = YES;
        
        ClassB *b = [[ClassB alloc] init];
        [b printInfo];

    }
    return 0;
}
