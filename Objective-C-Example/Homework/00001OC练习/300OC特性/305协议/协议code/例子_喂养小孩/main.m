//
//  main.m
//  例子1喂养小孩
//
//  Created by niit on 16/1/8.
//  Copyrigh/Users/niit/workspace/协议/协议.xcodeprojt © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Child.h"
#import "Father.h"
#import "Mother.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        Child *aChild = [[Child alloc] init];
        Father *aFather = [[Father alloc] init];
        Mother *aMother = [[Mother alloc] init];

        aChild.delegate = aMother;
        
        // 练习:
        // 写一个保姆类,让她实现喂养协议。并创建一个保姆，让她负责喂养小孩。
        
        [[NSRunLoop currentRunLoop] run];

        
        
    }
    return 0;
}
