//
//  ViewController.m
//  NSOperation
//
//  Created by niit on 16/3/24.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "MyOperation.h"

@interface ViewController ()

@property (nonatomic,strong) NSOperationQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - 4. 更新界面(向主队列中添加任务)
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 1. 创建一个队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;

    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"download 1 %@:%s start!",[NSThread currentThread],__func__);
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            self.view.backgroundColor = [UIColor blueColor];
        }];
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"download 2 %@:%s start!",[NSThread currentThread],__func__);
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            self.view.backgroundColor = [UIColor greenColor];
        }];
    }];

    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"download 3 %@:%s start!",[NSThread currentThread],__func__);
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            self.view.backgroundColor = [UIColor yellowColor];
        }];
    }];

    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"download 4 %@:%s start!",[NSThread currentThread],__func__);
        
        // 往主队列中添加任务
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.view.backgroundColor = [UIColor redColor];
        }];
    }];

    NSBlockOperation *op5 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download 5 %@:%s start!",[NSThread currentThread],__func__);
    }];
    [op4 addDependency:op1];
    [op4 addDependency:op2];
    [op4 addDependency:op3];
    [op4 addDependency:op5];

    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
    [queue addOperation:op5];
}


#pragma mark - 3. 暂停
- (IBAction)btn1Pressed:(id)sender
{
    self.queue = [[NSOperationQueue alloc] init];
    self.queue.maxConcurrentOperationCount = 1;
    [self.queue addOperationWithBlock:^{
        for (int i=0; i<50; i++)
        {
            [NSThread sleepForTimeInterval:0.1];
            NSLog(@"%i download1 %@",i,[NSThread currentThread]);
        }
    }];
    
    [self.queue addOperationWithBlock:^{
        for (int i=0; i<50; i++)
        {
            [NSThread sleepForTimeInterval:0.1];
            NSLog(@"%i download2 %@",i,[NSThread currentThread]);
        }
    }];
    
    [self.queue addOperationWithBlock:^{
        for (int i=0; i<50; i++)
        {
            [NSThread sleepForTimeInterval:0.1];
            NSLog(@"%i download3 %@",i,[NSThread currentThread]);
        }
    }];
    
    [self.queue addOperationWithBlock:^{
        for (int i=0; i<50; i++)
        {
            [NSThread sleepForTimeInterval:0.1];
            NSLog(@"%i download4 %@",i,[NSThread currentThread]);
        }
    }];
    
}
- (IBAction)btn2Pressed:(UIButton *)sender
{
    // 暂停和继续
    self.queue.suspended = !self.queue.suspended;
    [sender setTitle:self.queue.suspended?@"继续":@"暂停" forState:UIControlStateNormal];
}


- (IBAction)btn3aPressed:(id)sender
{
    self.queue = [[NSOperationQueue alloc] init];
    
    MyOperation *op = [[MyOperation alloc] init];
    [self.queue addOperation:op];
}

- (IBAction)btn3Pressed:(id)sender
{
    // 取消队列中所有任务
    [self.queue cancelAllOperations];
}

#pragma mark - 2. 依赖

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    // 1. 创建一个队列
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    
//    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"download 1 %@:%s start!",[NSThread currentThread],__func__);
//    }];
//    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"download 2 %@:%s start!",[NSThread currentThread],__func__);
//    }];
//
//    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"download 3 %@:%s start!",[NSThread currentThread],__func__);
//    }];
//
//    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"download 4 %@:%s start!",[NSThread currentThread],__func__);
//    }];
//
//    NSBlockOperation *op5 = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"download 5 %@:%s start!",[NSThread currentThread],__func__);
//    }];
//    [op4 addDependency:op1];
//    [op4 addDependency:op2];
//    [op4 addDependency:op3];
//    [op4 addDependency:op5];
//    [op1 addDependency:op2];// 不能循环依赖
//    
//    [queue addOperation:op1];
//    [queue addOperation:op2];
//    [queue addOperation:op3];
//    [queue addOperation:op4];
//    [queue addOperation:op5];
//}

#pragma mark - 1. NSOperation 和 NSOperationQueue的基本使用
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    
//    // 1. 创建一个队列
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    // 队列并发数
//    queue.maxConcurrentOperationCount = 1;// 相当于串行
//    
//    // 2. 创建操作任务 NSOperation的子类
//    
//    // 任务类型1: NSInvocationOperation任务
//    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download1) object:nil];
//    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download2) object:nil];
////    [op1 start];// 操作执行start,不加入队列,则是在当前线程执行
////    [op2 start];
//    
//    // 任务类型2: block任务
//    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"%@:%s start!",[NSThread currentThread],__func__);
//        [NSThread sleepForTimeInterval:0.1];
//        NSLog(@"%@:%s ended!",[NSThread currentThread],__func__);
//    }];
//    [op3 addExecutionBlock:^{
//        NSLog(@"%@:%s start!",[NSThread currentThread],__func__);
//        [NSThread sleepForTimeInterval:0.1];
//        NSLog(@"%@:%s ended!",[NSThread currentThread],__func__);
//    }];// op3内的block任务始终是并发的。
//    
//    // 任务类型3: 自定义NSOperation任务
//    MyOperation *op4 = [[MyOperation alloc] init];
//    
//    // 3. 将任务添加到队列
//    [queue addOperation:op1];// [op1 start];
//    [queue addOperation:op2];
//    [queue addOperation:op3];
//    [queue addOperation:op4];
//
//}
//
//- (void)download1
//{
//    NSLog(@"%@:%s start!",[NSThread currentThread],__func__);
//    [NSThread sleepForTimeInterval:0.1];
//    NSLog(@"%@:%s ended!",[NSThread currentThread],__func__);
//}
//
//- (void)download2
//{
//    NSLog(@"%@:%s start!",[NSThread currentThread],__func__);
//    [NSThread sleepForTimeInterval:0.1];
//    NSLog(@"%@:%s ended!",[NSThread currentThread],__func__);
//}



@end
