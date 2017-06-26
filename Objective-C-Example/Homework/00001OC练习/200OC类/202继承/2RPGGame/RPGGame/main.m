//
//  main.m
//  RPGGame
//
//  Created by niit on 15/12/29.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Game.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        Game *g = [[Game alloc] init];
        [g play];
    }
    return 0;
}
