//
//  Person.m
//  练习2
//
//  Created by 马千里 on 16/3/12.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "Person.h"

@implementation Person





- (void)machineFeedTheDog{
    [NSTimer scheduledTimerWithTimeInterval:4.5
                                     target:self
                                   selector:@selector(feed)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)feed{
    self.dog.hungry = 100;
    NSLog(@"定时器喂狗");
}

- (void)feedTheDog{
    NSLog(@"代理人老王喂狗");
    self.dog.hungry = 100;
}


@end
