//
//  ViewController.m
//  MouseCheese
//
//  Created by niit on 16/3/24.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    float mouseCount[3];
    float moustTransTime[3];
}
// 奶酪数量
@property (nonatomic,assign) int count;
@property (nonatomic,strong) NSLock *lock;

@end

@implementation ViewController


// 练习:
// 一个盒子里有100块奶酪,有个鼠洞通到盒子
// 3只老鼠,老鼠需要把奶酪叼回自己的窝里，每只老鼠搬得速度不同。(起始的时候，每只老鼠窝里有10块奶酪)
// 鼠洞很小，每一刻只能有一只老鼠在里面通行。（搬奶酪过程，线程互斥）
// 每只老鼠跑动速度不同(来回搬一次时间为0.3s 0.4s 0.5s   )
// 每只老鼠搬完了要休息(0.2s)
// 老鼠发现如果不能叼奶酪，就是在窝里吃0.1块奶酪(耗费每0.1秒),然后继续尝试能不能叼
// 显示最后3只老鼠窝里的奶酪数量，如果没得吃，那只老鼠饿死。
// 线程结束条件:盒子里奶酪没了,或者饿死了。

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.lock = [[NSLock alloc] init];
    
    self.count = 100;
    
    mouseCount[0] = 10;
    mouseCount[1] = 10;
    mouseCount[2] = 10;
    
    moustTransTime[0] = 0.3;
    moustTransTime[1] = 0.4;
    moustTransTime[2] = 0.5;
    
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(trans) object:nil];
    thread1.name = @"1";
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(trans) object:nil];
    thread2.name = @"2";

    NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(trans) object:nil];
    thread3.name = @"3";
    
    [thread1 start];
    [thread2 start];
    [thread3 start];
    
}

- (void)trans
{
    while (1)
    {
        //NSLog(@"老鼠%@:开始搬奶酪",[NSThread currentThread].name);
        
        int i = [[NSThread currentThread].name intValue] - 1;
        if([self.lock tryLock])
        {
            if(self.count <= 0)
            {
                NSLog(@"老鼠%i:没有奶酪了",i);
                [self.lock unlock];
                [NSThread exit];
            }
            
            NSLog(@"老鼠%i:搬一块奶酪,剩余%i,我有%.1f",i,self.count,mouseCount[i]);
            self.count--;
            mouseCount[i]++;
            [NSThread sleepForTimeInterval:moustTransTime[i]];
            [self.lock unlock];
            
            NSLog(@"老鼠%i:休息2s",i);
            [NSThread sleepForTimeInterval:0.2];
        }
        else
        {
            if(mouseCount[i]<=0)
            {
                NSLog(@"老鼠%i:没奶酪,饿死了",i);
                [NSThread exit];
            }
            NSLog(@"老鼠%i:吃奶酪,剩余%.1f",i,mouseCount[i]);
            mouseCount[i] -= 0.1f;
            [NSThread sleepForTimeInterval:0.1];
            
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
