//
//  ViewController.m
//  LockDemo
//
//  Created by niit on 16/3/23.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

// 卖票
// 100张票
// 3个售票员

@interface ViewController ()

@property (nonatomic,assign) int tickets;
@property (nonatomic,strong) NSLock *lock;// 同步锁

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.lock = [[NSLock  alloc] init];
    
    self.tickets = 100;
    
    NSThread *sellerThread1 = [[NSThread alloc] initWithTarget:self selector:@selector(sellTicket2) object:nil];
    sellerThread1.name = @"售票员(张三)";
    NSThread *sellerThread2 = [[NSThread alloc] initWithTarget:self selector:@selector(sellTicket2) object:nil];
    sellerThread2.name = @"售票员(李四)";
    NSThread *sellerThread3 = [[NSThread alloc] initWithTarget:self selector:@selector(sellTicket2) object:nil];
    sellerThread3.name = @"售票员(王五)";
    
    [sellerThread1 start];
    [sellerThread2 start];
    [sellerThread3 start];
    
}

#pragma mark 方法1 synchronized
//@synchronized(self)
//{
//    这里面的代码互斥，只有一个线程在运行里面的代码，其他线程运行到这里发现锁住的，会在这里等待
//}

- (void)sellTicket
{
    while (1)
    {
        NSLog(@"%@ 准备卖票",[NSThread currentThread].name);
        NSDate *d1 = [NSDate date];
        @synchronized(self) // 这里面的代码互斥，只有一个线程在运行里面的代码，其他线程运行到这里发现锁住的，会在这里等待
        {
            NSDate *d2 = [NSDate date];
            NSTimeInterval t = [d2 timeIntervalSinceDate:d1];
            NSLog(@"%@等待了:%.3f秒",[NSThread currentThread].name,t);
            // 得到当前的余票
            int count = self.tickets;
            
            if(count>0)
            {
                [NSThread sleepForTimeInterval:0.01];
                self.tickets = self.tickets - 1;
                NSLog(@"%@:卖出一张票,剩余%i",[NSThread currentThread].name , self.tickets);
            }
            else
            {
                NSLog(@"票卖光了");
                [NSThread exit];// 线程退出
            }
        }

    }
}

#pragma mark - 方式2 NSLock
// 1 卖票 锁住
// 2 喝口水 不要锁住
// 3 上个厕所 不要锁住
// 4 查询别人是不是正在卖票，如果别人不在买票，你就锁住然后卖票然后解锁，如果别人正在卖票，那你也不要闲着，看看报纸，待会再来查询一下

// 优点:
// 1. 将必须锁住的部分代码锁住,不必须的不锁
// 2. 如果发现已被锁住,可以执行其他的代码，而不是等待。

- (void)sellTicket2
{
    while (1)
    {
        
        if([self.lock tryLock])// 尝试去锁住
        {
            // 说明没有人加锁，那我就锁住了
            
            // 开始卖票
            int count = self.tickets;
            if(count>0)
            {
                [NSThread sleepForTimeInterval:0.03];
                self.tickets = self.tickets - 1;
                [self.lock unlock];// 已经卖出了，可以解锁
                NSLog(@"%@:卖出一张票,剩余%i",[NSThread currentThread].name , self.tickets);
                
                NSLog(@"%@:喝口水休息下!",[NSThread currentThread].name);
                [NSThread sleepForTimeInterval:0.01];
            }
            else
            {
                NSLog(@"%@:票卖光了",[NSThread currentThread].name);
                [self.lock unlock];
                [NSThread exit];// 线程退出
            }
        }
        else
        {
            // 没能锁住,别人已锁住,那我先干点别的事。
            NSLog(@"%@:有人正在卖票，我先看会儿报纸，等一会儿",[NSThread currentThread].name);
            [NSThread sleepForTimeInterval:0.01];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 练习:
// 一个盒子里有100块奶酪,有个鼠洞通到盒子
// 3只老鼠,老鼠需要把奶酪叼回自己的窝里，每只老鼠搬得速度不同。(起始的时候，每只老鼠窝里有10块奶酪)
// 鼠洞很小，每一刻只能有一只老鼠在里面通行。（搬奶酪过程，线程互斥）
// 每只老鼠跑动速度不同(来回搬一次时间为0.3s 0.4s 0.5s   )
// 每只老鼠搬完了要休息(0.2s)
// 老鼠发现如果不能叼奶酪，就是在窝里吃0.1块奶酪(耗费每0.1秒),然后继续尝试能不能叼
// 显示最后3只老鼠窝里的奶酪数量，如果没得吃，那只老鼠饿死。
// 线程结束条件:盒子里奶酪没了,或者饿死了。

@end
