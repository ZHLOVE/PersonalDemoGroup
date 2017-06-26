//
//  main.m
//  NSRunLoop和NSTimer
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Child.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        NSLog(@"程序开始");
        
        Child *aChild = [[Child alloc] init];
        
        // NSTimer 定时器
#pragma mark - NSTimer 定时器
        // NSTimer 属性
        //        @property (copy) NSDate *fireDate;                              //启动时间(通过设置启动时间为后面的时间可以让定时器暂停)
        //        @property (readonly) NSTimeInterval timeInterval;               //间隔
        //        @property NSTimeInterval tolerance NS_AVAILABLE(10_9, 7_0);     //
        //        @property (readonly, getter=isValid) BOOL valid;                //是否在运行
        //        @property (nullable, readonly, retain) id userInfo;             //附带信息
        // * 可以精确到50-100毫秒

#pragma mark - 创建方式1
        // 创建定时器并自动加入到NSRunLoop
//        + (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti     // 时间间隔 秒为单位
//                                             target:(id)aTarget            // 发送到哪个对象
//                                           selector:(SEL)aSelector         // 让对象执行什么消息
//                                           userInfo:(nullable id)userInfo  // 附带的信息
//                                            repeats:(BOOL)yesOrNo;         // 是否重复


//       NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:0.5                  // 时间间隔
//                                         target:aChild             //
//                                       selector:@selector(cry:)
//                                       userInfo:nil
//                                        repeats:YES];
        
#pragma mark - 创建方式2
        // 创建定时器,但不会自动加入NSRunLoop
        //+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti
//                                    target:(id)aTarget
//                                    selector:(SEL)aSelector
//                                    userInfo:(nullable id)userInfo
//                                    repeats:(BOOL)yesOrNo;
        // 创建定时器
        NSTimer *t = [NSTimer timerWithTimeInterval:0.5 target:aChild selector:@selector(cry:) userInfo:nil repeats:YES];
//        [t setFireDate:[NSDate dateWithTimeIntervalSinceNow:10]];// 设定fire时间 ,如让定时器10秒后才开始计时，和触发频率有区别的
//        [t fire];// 立即触发一次
//        // 加入到NSRunLoop,加入后会在fireDate之后自动触发
//        [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
        
        
        // 程序在此位置进入事件循环
        // 程序不会继续往下运行,如果没有事件或者消息的话，就处于休眠状态。如果对象接收到消息能处理。
        [[NSRunLoop currentRunLoop] run];
        
#pragma mark - 练习
        // 1 使用以前的猪、狗、猫类
        //让猪每隔3秒唱歌
        //让狗每隔5秒唱歌
        //让猫每隔8秒唱歌
        
        // 2 使用以前缩写的RGP游戏类,改进后实现以下游戏:
        // 游戏中有三个怪物,每隔一秒自动往随机方向移动一步,怪物不可重叠。
        // 每隔3秒,向游戏中添加一个新怪物。
        // 如果地图填满了，显示游戏结束.关闭定时器。
        // 每隔一秒打印一次地图
    }
    return 0;
}
