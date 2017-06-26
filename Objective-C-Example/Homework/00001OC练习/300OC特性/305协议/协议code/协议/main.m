//
//  main.m
//  协议
//
//  Created by niit on 16/1/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {

        Person *p = [[Person alloc] init];
        [p playBaseBall];
        [p playFootBall];
        [p playBasketBall];
        
        
    }
    return 0;
}
