//
//  ViewController.m
//  MultiThread
//
//  Created by niit on 16/3/22.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import <pthread.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 函数 (参数是void *,返回值是 void *)
void * run(void *param)
{
    for(int i= 0;i< 10000;i++)
    {
        NSLog(@"子线程1: %i",i);
    }
    return NULL;
}

void * run2(void *param)
{
    for(int i= 0;i< 10000;i++)
    {
        NSLog(@"子线程2: %i",i);
    }
    return NULL;
}

- (IBAction)btnPressed:(id)sender
{
    // 1. pthread 方式
    pthread_t thread1;
    pthread_create(&thread1, NULL, run, NULL); // 创建子线程
    
    pthread_t thread2;
    pthread_create(&thread2, NULL, run2, NULL);
    
    // 2. NSThread 方式
    // 方式1:创建实例,然后启动
    NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(multiThread:) object:@"子线程3"];
    [thread3 start];
    
    // 方式2:类方法创建
    [NSThread detachNewThreadSelector:@selector(multiThread:) toTarget:self withObject:@"子线程4"];
    
    // 3. GCD方式
    
    // 队列类型:
    // 1) 主队列 -> 主线程(UI线程)
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    // 2) 全局并发队列 (子线程) 并发的
    // 参数1: 优先级
    // 优先级(高优先级、普通优先级、低优先级)
    // DISPATCH_QUEUE_PRIORITY_HIGH 2        高优先级
    // DISPATCH_QUEUE_PRIORITY_DEFAULT 0     普通优先级
    // DISPATCH_QUEUE_PRIORITY_LOW (-2)      低优先级
    // DISPATCH_QUEUE_PRIORITY_BACKGROUND
    // 参数2: 保留未使用 填0
//    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 3) 自定义队列 (子线程) 串行队列或并发队列
    // 参数1: 线程标识
    // 参数2: 类型
    // DISPATCH_QUEUE_SERIAL 串行(或填 NULL)
    // DISPATCH_QUEUE_CONCURRENT 并发
    dispatch_queue_t queue2 = dispatch_queue_create("com.niit.multiThread5", NULL);
    
    // GCD的工作方式就是把要做的操作(block)放入队列
    //dispatch_sync   同步
    //dispatch_async  异步
    dispatch_async(queue2, ^{
        for(int i= 0;i< 10000;i++)
        {
            NSLog(@"子线程5: %i",i);
        }
    });
    
    // 4. NSOperationQueue 线程池
    NSOperationQueue *threadQueue = [[NSOperationQueue alloc] init];
    [threadQueue addOperationWithBlock:^{
        for(int i= 0;i< 10000;i++)
        {
            NSLog(@"子线程6: %i",i);
        }
    }];
    
    NSOperationQueue *threadQueue2 = [[NSOperationQueue alloc] init];
    threadQueue2.maxConcurrentOperationCount = 2;//并发数量
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(multiThread:) object:@"子线程7"];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(multiThread:) object:@"子线程8"];
    NSInvocationOperation *op3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(multiThread:) object:@"子线程9"];
    [threadQueue2 addOperation:op1];
    [threadQueue2 addOperation:op2];
    [threadQueue2 addOperation:op3];
    
    // 5. 后台线程
    [self performSelectorInBackground:@selector(multiThread:) withObject:@"后台线程"];
    
//    [self multiThread:@"主线程"];
}

- (void)multiThread:(NSString *)threadName
{
    for(int i= 0;i< 10000;i++)
    {
        NSLog(@"%@: %i",threadName,i);
    }
    
}

- (IBAction)segChanged:(id)sender
{
    NSLog(@"%s",__func__);
}

@end
