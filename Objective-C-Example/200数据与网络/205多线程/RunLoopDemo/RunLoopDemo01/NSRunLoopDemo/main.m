//
//  main.m
//  NSRunLoopDemo
//
//  Created by qiang on 4/27/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        
        NSLog(@"----开始----");
        int result = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        NSLog(@"----结束----");
        return result;
    }
}
