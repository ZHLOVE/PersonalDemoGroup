 //
//  ViewController.m
//  NSOperation
//
//  Created by student on 16/3/24.
//  Copyright © 2016年 马千里. All rights reserved.
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

#pragma mark 1.NSOperation基本使用
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //1创建一个队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//    queue.maxConcurrentOperationCount = 1;//相当于串行
    //2 创建操作任务NSOperation的子类
    //任务类型1
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download1) object:nil];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download2) object:nil];
//    [op1 start];
//    [op2 start];
    //任务类型2:block任务
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@:%s start!",[NSThread currentThread],__func__);
        [NSThread sleepForTimeInterval:0.1];
        NSLog(@"%@:%s ended!",[NSThread currentThread],__func__);
    }];
    [op3 addExecutionBlock:^{
        NSLog(@"%@:%s start!",[NSThread currentThread],__func__);
        [NSThread sleepForTimeInterval:0.1];
        NSLog(@"%@:%s end!",[NSThread currentThread],__func__);
    }];//op3内任务始终并发的
    //任务类型3:自定义NSOperation任务
    MyOperation *op4 = [[MyOperation alloc]init];
    
    //3将任务添加到队列
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
    
}

- (void)download1{
    NSLog(@"%@:%s start!",[NSThread currentThread],__func__);
    [NSThread sleepForTimeInterval:0.1];
    NSLog(@"%@:%s end!",[NSThread currentThread],__func__);
}

- (void)download2{
    NSLog(@"%@:%s start!",[NSThread currentThread],__func__);
    [NSThread sleepForTimeInterval:0.1];
    NSLog(@"%@:%s end!",[NSThread currentThread],__func__);
}

#pragma mark 2依赖

- (IBAction)YLBtnPressed:(UIButton *)sender {
    //依赖
    //1创建一个队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download 1 %@:%s start!",[NSThread currentThread],__func__);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download 2 %@:%s start!",[NSThread currentThread],__func__);
    }];

    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download 3 %@:%s start!",[NSThread currentThread],__func__);
    }];

    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download 4 %@:%s start!",[NSThread currentThread],__func__);
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

#pragma mark 3暂停
- (IBAction)btn4Pressed:(UIButton *)sender {
    // 暂停和继续
    self.queue = [[NSOperationQueue alloc] init];
    self.queue.maxConcurrentOperationCount = 1;
    [self.queue addOperationWithBlock:^{
        for (int i =0; i<50; i++) {
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

}

- (IBAction)btnZTPressed:(UIButton *)sender {
    // 暂停和继续
    self.queue.suspended = !self.queue.suspended;
    [sender setTitle:self.queue.suspended?@"继续":@"暂停" forState:UIControlStateNormal];
}


- (IBAction)btn3Pressed:(UIButton *)sender {
    // 取消队列中所有任务,下面的任务将不再执行
    [self.queue cancelAllOperations];
}

#pragma mark 4更新界面
- (IBAction)btn5Pressed:(UIButton *)sender {
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount = 1;
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
         NSLog(@"download 1 %@:%s start!",[NSThread currentThread],__func__);
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            sender.backgroundColor = [UIColor redColor];
        }];
        
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"download 1 %@:%s start!",[NSThread currentThread],__func__);
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            sender.backgroundColor = [UIColor blueColor];
        }];
        
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"download 1 %@:%s start!",[NSThread currentThread],__func__);
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            sender.backgroundColor = [UIColor greenColor];
        }];
        
    }];
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"download 1 %@:%s start!",[NSThread currentThread],__func__);
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            sender.backgroundColor = [UIColor whiteColor];
        }];
        
    }];
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
}








@end
