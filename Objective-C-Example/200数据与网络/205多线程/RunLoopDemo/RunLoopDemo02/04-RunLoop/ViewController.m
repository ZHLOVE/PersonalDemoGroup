//
//  ViewController.m
//  04-RunLoop
//
//  Created by xiaomage on 15/7/10.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)btnClick:(id)sender {
    NSLog(@"btnClick----------");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self timer];
    [self observer];
}

- (void)observer
{
    // 创建observer
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"----监听到RunLoop状态发生改变---%zd", activity);
    });

    // 添加观察者：监听RunLoop的状态
//    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer,kCFRunLoopCommonModes);
    
    // 释放Observer
    CFRelease(observer);
}

/*
    CF的内存管理（Core Foundation）
    1.凡是带有Create、Copy、Retain等字眼的函数，创建出来的对象，都需要在最后做一次release
    * 比如CFRunLoopObserverCreate
    2.release函数：CFRelease(对象);
 */

- (void)timer2
{
    // 调用了scheduledTimer返回的定时器，已经自动被添加到当前runLoop中，而且是NSDefaultRunLoopMode
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
    // 修改模式
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)timer
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    // 定时器只运行在NSDefaultRunLoopMode下，一旦RunLoop进入其他模式，这个定时器就不会工作
//        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    // 定时器只运行在UITrackingRunLoopMode下，一旦RunLoop进入其他模式，这个定时器就不会工作
//        [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    
    // 定时器会跑在标记为common modes的模式下
    // 标记为common modes的模式：UITrackingRunLoopMode和NSDefaultRunLoopMode
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)run
{
    NSLog(@"----run");
}

@end
