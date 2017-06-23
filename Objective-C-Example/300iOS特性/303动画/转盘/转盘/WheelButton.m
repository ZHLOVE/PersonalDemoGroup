//
//  WheelButton.m
//  转盘
//
//  Created by qiang on 16/3/21.
//  Copyright © 2016年 Qiangtech. All rights reserved.
//

#import "WheelButton.h"

#import "ComFunc.h"

@implementation WheelButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// 测试是否点击到png的不透明部分
- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!CGRectContainsPoint(self.bounds, point)) return NO;
    UIImage *img = [UIImage imageNamed:@"LuckyRototeSelected"];
    NSLog(@"%@",NSStringFromCGSize(img.size));
    unsigned char *bytes = getBitmapFromImage(img);
    return bytes[alphaOffset(point.x, point.y, img.size.width)] > 85;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 40;
    CGFloat imageH = 46;
    CGFloat imageX = (contentRect.size.width - imageW) * 0.5;
    CGFloat imageY = 20;
    return CGRectMake(imageX, imageY , imageW, imageH);
}

@end
