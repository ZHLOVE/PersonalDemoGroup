//
//  ViewController.m
//  MutiThread
//
//  Created by student on 16/3/22.
//  Copyright © 2016年 马千里. All rights reserved.
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

//函数(参数是void *,返回值是void *)
void *run(void *param){
    for (int i =0 ; i<10000; i++) {
        NSLog(@"MutiThread1:%i",i);
    }
    return NULL;
}

void *run2(void *param){
    for (int i =0 ; i<10000; i++) {
        NSLog(@"MutiThread2:%i",i);
    }
    return NULL;
}
- (IBAction)btnPressed:(UIButton *)sender {
    //1 pthread方式
    pthread_t thread;
    pthread_create(&thread, NULL, run, NULL);//创建子线程
    pthread_t thread2;
    pthread_create(&thread2, NULL, run2, NULL);
    //2 NSThread方式
    //创建实例，然后启动
    NSThread *thread3 = [[NSThread alloc]initWithTarget:self selector:@selector(multiThread:) object:@"子线程3"];
    [thread3 start];
    // 方式2:类方法创建
    [NSThread detachNewThreadSelector:@selector(multiThread:) toTarget:self withObject:@"子线程4"];
    //3 GCD方式
    //1)队列类型
    //*主队列->主线程（UI线程）
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //2)全局并发队列（子线程）并发
    // 优先级(高优先级、普通优先级、低优先级)
    // DISPATCH_QUEUE_PRIORITY_HIGH 2        高优先级
    // DISPATCH_QUEUE_PRIORITY_DEFAULT 0     普通优先级
    // DISPATCH_QUEUE_PRIORITY_LOW (-2)      低优先级
    // DISPATCH_QUEUE_PRIORITY_BACKGROUND
        dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //3）自定义队列
    //    dispatch_queue_t queue2 = dispatch_queue_create("子线程5", NULL);
    //GCD的工作方式就是把要做的操作（block)放入队列
    dispatch_async(queue1, ^{
        for(int i= 0;i< 10000;i++)
        {
            NSLog(@"子线程5: %i",i);
        }
    });
    //4 NSOperationQueue线程池
    NSOperationQueue *threadQueue = [[NSOperationQueue alloc]init];
    [threadQueue addOperationWithBlock:^{
        for(int i= 0;i< 10000;i++)
        {
            NSLog(@"子线程6: %i",i);
        }
    }];
    NSOperationQueue *threadQueue2 = [[NSOperationQueue alloc]init];
    threadQueue2.maxConcurrentOperationCount = 2;//并发数量
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(multiThread:) object:@"子线程7"];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(multiThread:) object:@"子线程8"];
    NSInvocationOperation *op3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(multiThread:) object:@"子线程9"];
    [threadQueue2 addOperation:op1];
    [threadQueue2 addOperation:op2];
    [threadQueue2 addOperation:op3];
    //5 后台线程
    [self performSelectorInBackground:@selector(multiThread:) withObject:@"后台线程"]; 
    
}

- (void)multiThread:(NSString *)threadName
{
    for(int i= 0;i< 10000;i++)
    {
        NSLog(@"%@: %i",threadName,i);
    }
    
}
@end
