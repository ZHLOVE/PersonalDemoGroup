//
//  ViewController.m
//  GCD_barrier
//
//  Created by student on 16/3/23.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

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

//C语言函数
void fun1(){
    NSLog(@"%s:%@",__func__,[NSThread currentThread]);
}

- (void)foo{
    NSLog(@"%s:%@",__func__,[NSThread currentThread]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s",__func__);
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    
    //1函数放入队列
    dispatch_async_f(queue, NULL, fun1);
    //2 延迟若干时间执行
    //延迟3s在主线程执行block
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"延迟了3秒%@",[NSThread currentThread]);
    });
    // 基本等同于
    [self performSelector:@selector(foo) withObject:nil afterDelay:3];
    //    // * 延迟4s在queue中执行block
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), queue, ^{
    //        NSLog(@"延迟了4秒 %@",[NSThread currentThread]);
    //    });
    //
    //    // 延迟5s在queue中执行函数fun1
//    dispatch_after_f(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), queue, NULL, fun1);
    // 3. 只运行一次的代码
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    //        NSLog(@"这里面的代码只会运行一次!");
    //    });
    // 4. dispath_barrier与自定义的并发线程配合使用
    // 效果如下:
    // 1 2 并发
    // 3 barrier (等1,2执行完之后执行)
    // 4 5 6 并发 (等3执行完之后执行)
    // 7 barrier (等4 5 6都执行完之后执行)
    // 8 9 10 并发 (等7执行完之后执行)
    
    dispatch_queue_t queue2 = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);// 自定义并发队列
    dispatch_async(queue2, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"------------1----------------%@",[NSThread currentThread]);
    });
    dispatch_async(queue2, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"------------2----------------%@",[NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"------------3 barrier----------------%@",[NSThread currentThread]);
    });
    dispatch_async(queue2, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"------------4----------------%@",[NSThread currentThread]);
    });
    dispatch_async(queue2, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"------------5----------------%@",[NSThread currentThread]);
    });
    dispatch_async(queue2, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"------------6----------------%@",[NSThread currentThread]);
    });
    
    dispatch_barrier_async(queue2, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"------------7 barrier----------------%@",[NSThread currentThread]);
    });
    dispatch_async(queue2, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"------------8----------------%@",[NSThread currentThread]);
    });
    dispatch_async(queue2, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"------------9----------------%@",[NSThread currentThread]);
    });
    dispatch_async(queue2, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"------------10----------------%@",[NSThread currentThread]);
    });


}





@end
