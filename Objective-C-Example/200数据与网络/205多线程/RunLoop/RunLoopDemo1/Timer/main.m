//
//  main.m
//  Timer
//
//  Created by qiang on 5/3/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        NSLog(@"程序开始");
        int result = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        
        // 1. 创建程序对象
        // 2. 进入runloop
        while(1)
        {
            // 1 用户输入,就行处理
            // 2 定时器触发，就进行处理
            // 3 网络数据传入传出,就进行处理
            // 没有任何事件就睡觉
        }
        
        
        NSLog(@"程序结束");
        return result;
    }
}
