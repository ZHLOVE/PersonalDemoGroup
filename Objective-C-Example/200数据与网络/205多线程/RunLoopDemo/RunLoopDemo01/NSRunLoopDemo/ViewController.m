//
//  ViewController.m
//  NSRunLoopDemo
//
//  Created by qiang on 4/27/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "ViewController.h"

//
//CFRunLoop源码
//http://opensource.apple.com/source/CF/CF-1151.16/

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //1. 显示NSRunLoop信息
//    NSLog(@"%@",[NSRunLoop currentRunLoop]);// 当前线程的RunLoop
//    NSLog(@"%@",[NSRunLoop mainRunLoop]);// 主线程的RunLoop
//    
//    CFRunLoopRef runLoopRef = CFRunLoopGetCurrent();
//    CFRunLoopRef mainRunLoopRef = CFRunLoopGetMain();
//    NSLog(@"%@ %@",runLoopRef,mainRunLoopRef);
    
//    // 2.
//    NSThread *t = [[NSThread alloc] initWithTarget:self selector:@selector(doSomething) object:nil];
//    [t start];
    
    // 3.
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(run) userInfo:nil repeats:YES];// 默认模式下工作
    
    NSTimer *t = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
    // 1. NSDefaultRunLoopMode:默认模式
//    [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
    // 2. UITrackingRunLoopMode:拖动UIScrollView时的模式
    [[NSRunLoop currentRunLoop] addTimer:t forMode:UITrackingRunLoopMode];
    // 3. NSRunLoopCommonModes 综合两种
    [[NSRunLoop currentRunLoop] addTimer:t forMode:NSRunLoopCommonModes];
    
}

//- (void)doSomething
//{
//    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];// sources0 sources1
////    [[NSRunLoop currentRunLoop] addTimer:<#(nonnull NSTimer *)#> forMode:<#(nonnull NSString *)#>
//    
//    NSLog(@"%@",[NSRunLoop currentRunLoop]);
//    [[NSRunLoop currentRunLoop] run];
//    NSLog(@"%@",[NSRunLoop currentRunLoop]);
//    NSLog(@"%@ end.",[NSThread currentThread]);
//}

- (void)run
{
    static int i=0;
    NSLog(@"--------%-----i",i++);
    
}
- (IBAction)btnPressed:(id)sender {
    // 在调试窗口查看函数调用栈
    // CFRunLoopDoSources0中处理
    // Sources1 中接收事件，再分发到Sources0
    NSLog(@"%s",__func__);
}


@end
