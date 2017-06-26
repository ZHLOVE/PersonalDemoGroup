//
//  Man.m
//  KVODemo
//
//  Created by niit on 16/1/20.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Man.h"

@implementation Man

- (instancetype)initWithName:(NSString *)n
{
    self = [super init];
    if (self) {
        self.name = n;
        
        [self.card addObserver:self forKeyPath:@"money" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

// 懒加载 //lazy
// 用到的时候去创建，不用的时候不创建
// 重写getter方法
- (SalaryCard *)card
{
    if(_card == nil)// 第一次调用的时候_card是空，则创建
    {
        _card = [[SalaryCard alloc] init];
    }
    return _card;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    float oldValue = [change[@"old"] floatValue];
    float newValue = [change[@"new"] floatValue];
    
    if(oldValue < newValue)
    {
        NSLog(@"%@:这个月工资到了!",self.name);
    }
    else
    {
        NSLog(@"%@:老婆又消费了,好心疼!!",self.name);
    }
}




@end
