//
//  Wife.m
//  KVODemo
//
//  Created by niit on 16/1/20.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Wife.h"

@implementation Wife

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 每天
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(buybuybuy) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)setMyHusbandCard:(SalaryCard *)myHusbandCard
{
    _myHusbandCard = myHusbandCard;
    [_myHusbandCard addObserver:self forKeyPath:@"money" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)buybuybuy
{
    
//    (每天随机1/10概率进行消费，消费金额是当前余额的5%~100%,不能超支)
    if(arc4random()%10 == 0 && self.myHusbandCard.money>0)
    {

        float buyMoney = self.myHusbandCard.money * (arc4random()%96+5)/100.0;
        NSLog(@"小明老婆:买东西花%g",buyMoney);
        self.myHusbandCard.money -= buyMoney;
    }
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
        NSLog(@"小明老婆:老公的工资到了，又可以买买了!");
    }

}

@end
