//
//  DrawView.m
//  饼状图和柱状图
//
//  Created by niit on 16/4/6.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView

- (void)setType:(int)type
{
    _type = type;
    
    [self setNeedsDisplay];
}

- (void)setList:(NSArray *)list
{
    _list = list;
    
    [self setNeedsDisplay];
}

- (UIColor *)randomColor
{
    return [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    switch (self.type)
    {
        case 0:
        {
            // 中心点
            CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
            CGFloat radius = rect.size.width/2 * 0.8;
            CGFloat startAngle = - M_PI_2;
            
            for(NSDictionary *dict in self.list)
            {
                // 1. 绘制扇形
                CGFloat percent = [dict[@"percent"] doubleValue];
                CGFloat endAngle = startAngle + M_PI * 2 * percent;
                
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:center];
                [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
                [path closePath];
                [[self randomColor] setFill];
                [path fill];
                
                // 2. 绘制文字
                NSString *text = dict[@"text"];
                // 计算文字绘制的位置
                CGFloat x;
                CGFloat y;
                x = center.x + cos(startAngle + M_PI * percent) * radius * 0.8;
                y = center.y + sin(startAngle + M_PI * percent) * radius * 0.8;
                CGPoint textPoint = CGPointMake(x, y);
                [[UIColor whiteColor] setStroke];
                [text drawAtPoint:textPoint withAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
                
                // 下一个扇形的起始角度为当前结束角度
                startAngle = endAngle;

            }
        }
            
            break;
            
        case 1:
        {
            CGFloat x,y,w,h;// 起始位置x,y 宽高
            w = rect.size.width / (self.list.count * 2 - 1);// 条状的宽度
            for(int i=0;i<self.list.count;i++)
            {
                // 1. 绘制柱状图
                NSDictionary *dict = self.list[i];
                x = i * w * 2;
                CGFloat percent = [dict[@"percent"] doubleValue];
                h = rect.size.height * percent;
                y = rect.size.height - h;
                
                UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, w, h)];
                [[self randomColor] setFill];
                [path fill];
                
                // 2. 绘制文字
                NSString *text = dict[@"text"];
                CGFloat textX;
                CGFloat textY;
                textX = x;
                textY = y - 30;
                CGPoint textPoint = CGPointMake(textX, textY);
                [[UIColor whiteColor] setStroke];
                [text drawAtPoint:textPoint withAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            }
            
        }
            break;
        default:
            break;
    }
    
}


@end
