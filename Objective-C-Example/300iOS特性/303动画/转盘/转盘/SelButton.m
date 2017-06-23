//
//  SelButton.m
//  转盘
//
//  Created by qiang on 16/3/21.
//  Copyright © 2016年 Qiangtech. All rights reserved.
//

#import "SelButton.h"

#import "ComFunc.h"

@implementation SelButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!CGRectContainsPoint(self.bounds, point)) return NO;
    UIImage *img = [UIImage imageNamed:@"LuckyCenterButton"];
    unsigned char *bytes = getBitmapFromImage(img);
    return bytes[alphaOffset(point.x, point.y, img.size.width)] > 85;
}
@end
