//
//  Dog.m
//  练习2
//
//  Created by 马千里 on 16/3/12.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "Dog.h"



@implementation Dog

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hungry = 100;
        self.time = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(dogHungry) userInfo:nil repeats:YES];
    }
    return self;
}


- (void)dogHungry{
   
    NSLog(@"%ld",self.hungry);
    self.hungry = self.hungry - 5;
    if (!self.die) {
        if (self.hungry < 60 && self.hungry > 40) {
            //发送通知
            NSLog(@"汪~汪~汪~");
            [[NSNotificationCenter defaultCenter] postNotificationName:kFeedTheDog object:nil];
            
        }else if (self.hungry<40 && self.hungry >0){
            [self.delegate feedTheDog];
        }
        else if (self.hungry == 0){
            self.die = YES;
        }
    }else{
        [self.time invalidate];
        NSLog(@"%@死了",self.fullName);
    }
}

- (void)setFirstName:(NSString *)firstName{
    _firstName = firstName;
    
    NSLog(@"主人你好！我叫%@，请多关照！",_firstName);
}

- (NSString *)lastName{
    if (_lastName == nil) {
        return @"华盛顿";
    }
    return _lastName;
}

- (NSString *)fullName{
    NSString *str = [_firstName stringByAppendingString:@"·"];
    NSString *name = [str stringByAppendingString:self.lastName];
    return name;
}



@end

