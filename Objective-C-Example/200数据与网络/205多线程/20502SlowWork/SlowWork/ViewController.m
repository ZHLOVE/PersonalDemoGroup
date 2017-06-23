//
//  ViewController.m
//  SlowWork
//
//  Created by niit on 16/3/22.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

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

- (IBAction)btnPressed:(id)sender
{
    // 开始的时间
    NSDate *d1 = [NSDate date];
    // 菊花开始转动
    [self.activityView startAnimating];
    // 费时的操作
    NSString *str1 = [self doSomething1];
    NSString *str2 = [self doSomething2:str1];
    NSString *str3 = [self doSomething3:str1];
    NSString *str4 = [self doSomething4:str1];
    // 操作完结果显示在界面上
    self.textView.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",str1,str2,str3,str4];
    // 停止转动
    [self.activityView stopAnimating];
    // 运行完时间
    NSDate *d2 = [NSDate date];
    // 计算总共运行了多少时间
    NSTimeInterval interval = [d2 timeIntervalSinceDate:d1];
    NSLog(@"运行了%.3f秒",interval);
    
}


#pragma mark - GCD方式
- (IBAction)btn2Pressed:(id)sender
{
    NSDate *d1 = [NSDate date];
    
    // 开始转动
    [self.activityView startAnimating];
    
    // GCD方式
    // 1. 定义一个队列(自定义队列或全局队列)
    dispatch_queue_t queue = dispatch_queue_create(NULL, NULL);
    // 2. 将要做的任务使用dispatch_async放到队列中
    dispatch_async(queue, ^{
        NSLog(@"当前在%@",[NSThread currentThread].isMainThread?@"主线程中":@"子线程中");
        NSString *str1 = [self doSomething1];// 1
        NSString *str2 = [self doSomething2:str1];// 2
        NSString *str3 = [self doSomething3:str1];// 3
        NSString *str4 = [self doSomething4:str1];// 4
        
        // 3. 得到计算结果后，将更新界面的代码放入到主队列中执行
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"当前在%@",[NSThread currentThread].isMainThread?@"主线程中":@"子线程中");
            // 显示结果
            self.textView.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",str1,str2,str3,str4];
            // 停止转动
            [self.activityView stopAnimating];
        });
        
    });
    
    NSLog(@"btn2Pressed!");
    NSDate *d2 = [NSDate date];
    
    NSTimeInterval t = [d2 timeIntervalSinceDate:d1];
    NSLog(@"btn2Pressed 耗费时间:%.3f",t);
}
// btn2Pressed 耗费时间:0.001

//GCD的常用方法:
//1. 定义队列(自定义队列或全局并发队列,根据需求情况而定)
//dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);// 全局并发队列
//dispatch_queue_t queue = dispatch_queue_create("com.niit.multiThread5", NULL);// 自定义队列(默认串行)
//2. 将费时操作(block)放入队列
//dispatch_async(queue, ^{
//    //耗费时间操作代码写在这里
//    ...
//
//    // 3.得到计算结果后,将更新界面的代码放入到主队列中执行
//    dispatch_async(dispatch_get_main_queue(), ^{
//        // 更新界面代码写在这里
//        ...
//    });
//
//});

#pragma mark - GCD方式 并发方式1 wait
- (IBAction)btn3Pressed:(id)sender
{
    // 开始的时间
    NSDate *d1 = [NSDate date];
    // 开始转动
    [self.activityView startAnimating];
    
    
    __weak ViewController *weakSelf = self;
    // GCD方式
    // 1. 定义一个队列(自定义队列或全局队列)
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);// 并发
        //dispatch_queue_create(NULL, NULL);
    // 2. 将要做的任务使用dispatch_async放到队列中
    dispatch_async(queue, ^{
        NSLog(@"当前在%@",[NSThread currentThread].isMainThread?@"主线程中":@"子线程中");
        NSString *str1 = [self doSomething1];// 1
        
        
        // 定义一个组
        dispatch_group_t group = dispatch_group_create();
        
        __block NSString *str2;
        __block NSString *str3;
        __block NSString *str4;
        
        dispatch_group_async(group, queue, ^{
            str2 = [weakSelf doSomething2:str1];
        });
        dispatch_group_async(group, queue, ^{
            str3 = [weakSelf doSomething3:str1];
        });
        dispatch_group_async(group, queue, ^{
            str4 = [weakSelf doSomething4:str1];
        });
        
        // 等待组内的任务都完成后，继续运行
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        
        // 3. 得到计算结果后，将更新界面的代码放入到主队列中执行
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"当前在%@",[NSThread currentThread].isMainThread?@"主线程中":@"子线程中");
            // 显示结果
            self.textView.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",str1,str2,str3,str4];
            // 停止转动
            [self.activityView stopAnimating];
            
            // 运行完时间
            NSDate *d2 = [NSDate date];
            // 计算总共运行了多少时间
            NSTimeInterval interval = [d2 timeIntervalSinceDate:d1];
            NSLog(@"运行了%.3f秒",interval);
        });
        
    });
    
}

#pragma mark - GCD方式 并发方式2  notifiy
- (IBAction)btn4Pressed:(id)sender
{
    // 开始的时间
    NSDate *d1 = [NSDate date];
    // 开始转动
    [self.activityView startAnimating];
    
    
    __weak ViewController *weakSelf = self;
    // GCD方式
    // 1. 定义一个队列(自定义队列或全局队列)
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);// 并发
    //dispatch_queue_create(NULL, NULL);
    // 2. 将要做的任务使用dispatch_async放到队列中
    dispatch_async(queue, ^{
        NSLog(@"当前在%@",[NSThread currentThread].isMainThread?@"主线程中":@"子线程中");
        NSString *str1 = [self doSomething1];// 1
        
        
        // 定义一个组
        dispatch_group_t group = dispatch_group_create();
        
        __block NSString *str2;
        __block NSString *str3;
        __block NSString *str4;
        
        dispatch_group_async(group, queue, ^{
            str2 = [weakSelf doSomething2:str1];
        });
        dispatch_group_async(group, queue, ^{
            str3 = [weakSelf doSomething3:str1];
        });
        dispatch_group_async(group, queue, ^{
            str4 = [weakSelf doSomething4:str1];
        });
        
        NSLog(@"a");
        // 在组内的任务都运行完了之后再运行
        dispatch_group_notify(group, queue, ^{
            // 3. 得到计算结果后，将更新界面的代码放入到主队列中执行
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"当前在%@",[NSThread currentThread].isMainThread?@"主线程中":@"子线程中");
                // 显示结果
                self.textView.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",str1,str2,str3,str4];
                // 停止转动
                [self.activityView stopAnimating];
                
                // 运行完时间
                NSDate *d2 = [NSDate date];
                // 计算总共运行了多少时间
                NSTimeInterval interval = [d2 timeIntervalSinceDate:d1];
                NSLog(@"运行了%.3f秒",interval);
            });
        });
        NSLog(@"b");
        
    });
}

#pragma mark - performSelectorInBackground
- (IBAction)btn5Pressed:(id)sender
{
    // 把某个任务放到后台线程执行
    [self.activityView startAnimating];
    
    [self performSelectorInBackground:@selector(calculate) withObject:nil];
}

- (void)calculate
{
    NSString *str1 = [self doSomething1];// 1
    NSString *str2 = [self doSomething2:str1];// 2
    NSString *str3 = [self doSomething3:str1];// 3
    NSString *str4 = [self doSomething4:str1];// 4
    NSString *result = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",str1,str2,str3,str4];
    
    // 更新界面又得回到主线程
    
    // 方式1:
//    [self performSelectorOnMainThread:@selector(showResult:) withObject:result waitUntilDone:NO];
    
    // 方式2:
    // 让self.textView 在主线程更新内容
    [self.textView performSelectorOnMainThread:@selector(setText:) withObject:result waitUntilDone:NO];
    // 让self.activityView 执行停止动画的方法
    [self.activityView performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    
}

// 方式1调用的方法
//- (void)showResult:(NSString *)result
//{
//    self.textView.text = result;
//    [self.activityView stopAnimating];
//}



#pragma mark - 费时的操作

- (NSString *)doSomething1
{
    [NSThread sleepForTimeInterval:1];// 当前线程休眠1s
    return @"从网络上获取一段信息:abc123";
}

- (NSString *)doSomething2:(NSString *)str
{
    [NSThread sleepForTimeInterval:2];// 当前线程休眠2s
    return [str uppercaseString];
}

- (NSString *)doSomething3:(NSString *)str
{
    [NSThread sleepForTimeInterval:3];// 当前线程休眠3s
    return [NSString stringWithFormat:@"%lu",str.length];
}

- (NSString *)doSomething4:(NSString *)str
{
    [NSThread sleepForTimeInterval:4];// 当前线程休眠2s
    return [str stringByReplacingOccurrencesOfString:@"a" withString:@"A"];
}

@end
