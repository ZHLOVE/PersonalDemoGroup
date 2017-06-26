//
//  DrawView.m
//  CADisplayLinkDemo
//
//  Created by student on 16/4/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "DrawView.h"

@interface DrawView()
{
    CGFloat spiderY[50];
    CADisplayLink *link;
}
@property (nonatomic,strong) UIImage *spider;

@end
@implementation DrawView

- (void)setPlaying:(BOOL)playing{
    _playing = playing;
        // 暂停或者继续CADisplay定时器
    link.paused = !playing;
}


- (UIImage *)spider{
    if (_spider == nil) {
        _spider = [UIImage imageNamed:@"spider"];
    }
    return _spider;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    //总宽度/图片宽度
    int count = rect.size.width/self.spider.size.width;
    for (int i=0;i<count; i++) {
        spiderY[i] += arc4random_uniform(5);
        CGFloat x = i*self.spider.size.width;
        CGFloat y = spiderY[i];
        [self.spider drawAtPoint:CGPointMake(x, y)];
        if (spiderY[i] >= rect.size.height ) {
            spiderY[i] = 0;
        }
    }
    
    
}

// storyborad xib在初始化界面的时候调用
- (void)awakeFromNib{
    // 1. NSTimer
    // 创建定时器NSTimer 精度比较低 触发的时候如果NSRunLoop阻塞,它就不会执行
    //    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
    
    // 2. CADisplayLink 定时器
    //每帧刷新结束就必会调用(适合做自定义动画、和视频播放的渲染)
    //注:屏幕的刷新率60帧,每秒刷新60次,所以1秒钟,CADisplayLink会执行60次
    if(link == nil)
    {
        link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        link.paused = YES;
    }
    // 暂停定时器
    //    link.paused=YES;
    // 结束并删除定时器
    //    [link invalidate];// 自动从runLoop中删除绑定的target和selector
    //    link = nil;
}































@end
