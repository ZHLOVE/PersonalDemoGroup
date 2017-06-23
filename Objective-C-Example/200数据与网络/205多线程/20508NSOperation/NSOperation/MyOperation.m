//
//  MyOperation.m
//  NSOperation
//
//  Created by niit on 16/3/24.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "MyOperation.h"

@implementation MyOperation

// 任务内容写在- (void)main;中
- (void)main
{
//    NSLog(@"%@:%s start!",[NSThread currentThread],__func__);
//    [NSThread sleepForTimeInterval:0.1];
//    NSLog(@"%@:%s ended!",[NSThread currentThread],__func__);
    
    
    for (int i=0; i<50; i++)
    {
        [NSThread sleepForTimeInterval:0.1];
        NSLog(@"%i download1 %@",i,[NSThread currentThread]);
    }
    if(self.isCancelled) return;// 判断当前任务是否被取消，取消则停止，否则会继续运行下去
    
    for (int i=0; i<50; i++)
    {
        [NSThread sleepForTimeInterval:0.1];
        NSLog(@"%i download2 %@",i,[NSThread currentThread]);
    }
    if(self.isCancelled) return;    
    
    for (int i=0; i<50; i++)
    {
        [NSThread sleepForTimeInterval:0.1];
        NSLog(@"%i download3 %@",i,[NSThread currentThread]);
    }
    
    
}
@end
