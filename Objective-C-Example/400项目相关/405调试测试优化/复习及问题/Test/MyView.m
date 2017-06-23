//
//  MyView.m
//  Test
//
//  Created by qiang on 4/25/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "MyView.h"

@implementation MyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    NSLog(@"%s",__func__);
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

// 什么时候会被调用? 从xib或者是从storyboard初始化对象时滴啊用
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"%s",__func__);
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        
    }
    return self;
}

// 什么时候会被调用? 直接初始化调用，init也会调用initWithFrame
- (instancetype)initWithFrame:(CGRect)frame
{
    NSLog(@"%s",__func__);
    self = [super initWithFrame:frame];
    if(self)
    {
        
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

// 什么时候会被调用? 被设置尺寸的时候，或者代码调用setNeedsLayout
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"%s",__func__);
}

@end
