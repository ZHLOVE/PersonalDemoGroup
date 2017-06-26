//
//  UIView+Frame.m
//  Weibo
//
//  Created by qiang on 4/25/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setX_:(CGFloat)x{
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY_:(CGFloat)y{
    
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setWidth_:(CGFloat)width{
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;;
}

- (void)setHeigt_:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)x_
{
    return self.frame.origin.x;
}
- (CGFloat)y_
{
    return self.frame.origin.y;
}
- (CGFloat)width_
{
    return self.frame.size.width;
}
- (CGFloat)heigt_
{
    return self.frame.size.height;
}

@end
