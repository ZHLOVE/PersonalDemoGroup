//
//  Father.m
//  NotificationDemo
//
//  Created by niit on 16/1/20.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Father.h"

#import "def.h"
#import "Child.h"

@implementation Father

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedChild:) name:kNotificationCry object:nil];
    }
    return self;
}

//- (void)feedChild
//{
//    NSLog(@"父亲:给孩子喂奶");
//    self.myChild.hungry += 100;
//}

- (void)feedChild:(NSNotification *)n
{
    Child *child = n.object;
    
    NSLog(@"父亲:给孩子喂奶");
    child.hungry += 100;
}

@end
