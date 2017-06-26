//
//  Master.m
//  练习2
//
//  Created by 马千里 on 16/3/12.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "Master.h"

@implementation Master

- (instancetype)init
{
    self = [super init];
    if (self) {
        //监听一个通知，当收到通知时，调用notificationAction方法
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedMyDog) name:kFeedTheDog object:nil];
    }
    return self;
}

- (void)feedMyDog{
    
    
    if (self.myDog ) {
        NSLog(@"主人喂狗");
        self.myDog.hungry = 100;
    }
    
}
@end
