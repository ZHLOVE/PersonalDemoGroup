//
//  Person.m
//  KVODemo
//
//  Created by niit on 16/1/19.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)initWithName:(NSString *)n
{
    self = [super init];
    if (self) {
        self.name = n;
    }
    return self;
}

// 2 编写监看的处理程序
- (void)observeValueForKeyPath:(NSString *)keyPath                     // 键值
                      ofObject:(id)object                              // 哪个对象
                        change:(NSDictionary<NSString *,id> *)change   // 发生了什么改变
                       context:(void *)context                         // 附带的参数
{
    if([keyPath isEqualToString:@"price"])
    {
        // 改变信息
//        NSLog(@"change = %@",change);
        
        float newValue = [change[@"new"] floatValue];
        float oldValue = [change[@"old"] floatValue];
        
        if(newValue > oldValue)
        {
            NSLog(@"%@:涨了,赚钱了",self.name);
        }
        else if(newValue < oldValue)
        {
            NSLog(@"%@:跌了,亏钱了",self.name);
        }
        else
        {
            NSLog(@"%@:价格没动!",self.name);
        }
    }
    else if([keyPath isEqualToString:@"ledColor"])
    {
        LedColor newValue = [change[@"new"] intValue];
        LedColor oldValue = [change[@"old"] intValue];
        
        //红灯->黄灯 打印@"可以准备走了"
        //黄灯->绿灯 打印@"绿灯了，快走！"
        //绿灯->黄灯 打印@"准备停下！"
        //黄灯->红灯 打印@"停下！"
        if(newValue == kLedColorYellow && oldValue == kLedColorRed)
        {
            NSLog(@"%@可以准备走了",self.name);
        }
        else if(newValue == kLedColorGreen && oldValue == kLedColorYellow)
        {
            NSLog(@"%@绿灯了，快走",self.name);
        }
        else if(newValue == kLedColorYellow && oldValue == kLedColorGreen)
        {
            NSLog(@"%@准备停下！",self.name);
        }
        else if(newValue == kLedColorRed && oldValue == kLedColorYellow)
        {
            NSLog(@"%@停下！",self.name);
        }
        
    }
}

// 3 移除监看
- (void)dealloc
{
    // 移除掉监看
    [self.myStock removeObserver:self forKeyPath:@"price"];
}

//
- (void)setLed:(StreetCorssLed *)led
{
    _led = led;
    
    // 添加监看 人监看灯
    [led addObserver:self forKeyPath:@"ledColor" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

@end
