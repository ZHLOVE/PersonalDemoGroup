//
//  ViewController.m
//  LockDemo
//
//  Created by student on 16/3/23.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,assign) int tickets;
@property (nonatomic,strong) NSLock *lock;//同步锁

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lock = [[NSLock alloc]init];
    self.tickets = 100;
    NSThread *sellerThread1 = [[NSThread alloc]initWithTarget:self selector:@selector(sellTicket) object:nil];
    sellerThread1.name = @"售票员(张三)";
    NSThread *sellerThread2 = [[NSThread alloc]initWithTarget:self selector:@selector(sellTicket) object:nil];
    sellerThread2.name = @"售票员(李四)";
    NSThread *sellerThread3 = [[NSThread alloc] initWithTarget:self selector:@selector(sellTicket) object:nil];
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
- (void)sellTicket{
    while (1) {
        NSLog(@"%@ 准备卖票",[NSThread currentThread].name);
        NSDate *d1 = [NSDate date];
        @synchronized(self) {
            NSDate *d2 = [NSDate date];
            NSTimeInterval t = [d2 timeIntervalSinceDate:d1];
            NSLog(@"%@等待用了:%.3f秒",[NSThread currentThread].name,t);
            //当前余票
            int count = self.tickets;
            if (count>0) {
                [NSThread sleepForTimeInterval:0.01];
                self.tickets = self.tickets - 1;
                NSLog(@"%@:卖出一张票,剩余%i",[NSThread currentThread].name , self.tickets);
            }else{
                NSLog(@"票卖光了");
                [NSThread exit];
            }
        }
    }
}

- (void)sellTicket2{
    while (1) {
        if ([self.lock tryLock])//尝试去锁住
        {
            //说明没有人枷锁，那就锁住
            //开始卖票
            int count = self.tickets;
            if (count>0) {
                [NSThread sleepForTimeInterval:0.03];
                [self.lock unlock];//票卖出，解锁
                NSLog(@"%@:卖出一张票,剩余%i",[NSThread currentThread].name , self.tickets);
                
                NSLog(@"%@:喝口水休息下!",[NSThread currentThread].name);
                [NSThread sleepForTimeInterval:0.01];
            }else{
                NSLog(@"%@:票卖光了",[NSThread currentThread].name);
                [self.lock unlock];
                [NSThread exit];// 线程退出
            }
        }else{
            //没能锁住，别人已经锁住，自己可以做其他事情
            NSLog(@"%@:有人正在卖票，我先看会儿报纸，等一会儿",[NSThread currentThread].name);
            [NSThread sleepForTimeInterval:0.01];
        }
    }
}
























@end
