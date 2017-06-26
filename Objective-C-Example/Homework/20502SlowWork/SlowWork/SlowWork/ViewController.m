//
//  ViewController.m
//  SlowWork
//
//  Created by student on 16/3/22.
//  Copyright © 2016年 马千里. All rights reserved.
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
//GCD的常用方法:
//1. 定义队列
//dispatch_queue_t queue = dispatch_queue_create(NULL, NULL);// 定义一个队列(自定义队列，全局队列)
//2. 将费时操作作为block放入队列
//dispatch_async(queue, ^{
//    //耗费时间操作代码写在这里
//    ...
//
//    // 3。得到计算结果后,将更新界面的代码放入到主队列中执行
//    dispatch_async(dispatch_get_main_queue(), ^{
//        // 2. 回到主线程更新界面
//    });
//
//});
- (IBAction)btnPressed:(UIButton *)sender {
    //小菊花转动
    [self.activityView startAnimating];
    //GCD方式
    //1 定义一个列队(自定义列队或全局列队)
    dispatch_queue_t queue = dispatch_queue_create(NULL, NULL);
    //2 将要做的任务使用dispath_async丢到列队中
    dispatch_async(queue, ^{
        NSLog(@"当前在%@",[NSThread currentThread].isMainThread?@"主线程中":@"子线程中");
        //串行
        NSString *str1 = [self doSomething1];
        NSString *str2 = [self doSomething2:str1];
        NSString *str3 = [self doSomething3:str1];
        NSString *str4 = [self doSomething4:str1];
        // 3. 得到计算结果后，将更新界面的代码放入到主队列中执行
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"当前在%@",[NSThread currentThread].isMainThread?@"主线程中":@"子线程中");
            //显示结果
            self.textView.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",str1,str2,str3,str4];
            // 停止转动
            [self.activityView stopAnimating];
        });
    });
}

- (NSString *)doSomething1{
    [NSThread sleepForTimeInterval:1];//当前线程休眠1s
    return @"网上获取一段信息:abc123";
}
- (NSString *)doSomething2:(NSString *)str{
    [NSThread sleepForTimeInterval:2];
    return [str uppercaseString];//变大写
}
- (NSString *)doSomething3:(NSString *)str{
    [NSThread sleepForTimeInterval:1];
    return [NSString stringWithFormat:@"%lu",str.length];
}
- (NSString *)doSomething4:(NSString *)str{
    [NSThread sleepForTimeInterval:1];
    return [str stringByReplacingOccurrencesOfString:@"a" withString:@"AAA"];
}

- (IBAction)btn2Pressed:(UIButton *)sender {
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

}

- (IBAction)btn3Pressed:(UIButton *)sender {
    //开始的时间
    NSData *d1 = [NSDate date];
    //开始转动
    [self.activityView startAnimating];
    __weak ViewController *weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);//并发
    dispatch_async(queue, ^{
        NSString *str1 = [self doSomething1];// 1
        //定义一个组
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
        //等待组内的任务都完成后，继续运行
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

- (IBAction)btn4Pressed:(UIButton *)sender {
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

- (IBAction)btn5Pressed:(UIButton *)sender {
    //把某个任务放到后台线程执行
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
    //更新界面又得回到主线程
    //方式1
    //    [self performSelectorOnMainThread:@selector(showResult:) withObject:result waitUntilDone:NO];
    // 方式2:
    // 让self.textView 在主线程更新内容
    [self.textView performSelectorOnMainThread:@selector(setText:) withObject:result waitUntilDone:NO];
    // 让self.activityView 执行停止动画的方法
    [self.activityView performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
}














@end
