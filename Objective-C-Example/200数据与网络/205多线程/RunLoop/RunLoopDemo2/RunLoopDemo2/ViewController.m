//
//  ViewController.m
//  RunLoopDemo2
//
//  Created by qiang on 5/3/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // 1 即将进入RunLoop
    // 2 即将处理Timer
    // 4 即将处理Source
    // 32 休眠
    // 64 即将退出
    //
    
    // 创建RunLoop监看
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"%lu",activity);
    });
    // 添加
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopCommonModes);
    // 释放
    CFRelease(observer);
    
    // 在CoreFoundation下的内存 需要自己释放
    // 凡是带有Create Copy Retain的函数，创建出来的或者拷贝的对象，都需要release
    
    // 定时器
//    NSTimer *t = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(timerDo) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:t forMode:NSRunLoopCommonModes];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPressed:(id)sender
{
    NSLog(@"%s",__func__);
}


- (void)timerDo
{
    NSLog(@"%s",__func__);
}
@end
