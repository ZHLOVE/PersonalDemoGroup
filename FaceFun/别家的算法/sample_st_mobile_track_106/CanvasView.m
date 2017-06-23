//
//  CanvasView.m
//  Created by sluin on 15/7/1.
//  Copyright (c) 2015年 SunLin. All rights reserved.
//

#import "CanvasView.h"

@implementation CanvasView

- (void)drawRect:(CGRect)rect {
    [self drawPointWithPoints:self.arrPersons];
}

-(void)drawPointWithPoints:(NSArray *)arrPersons
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, false);
    
    [[UIColor greenColor] set];
    CGContextSetLineWidth(context, 2);
    
    for (NSDictionary *dicPerson in self.arrPersons) {
        if ([dicPerson objectForKey:POINTS_KEY]) {
            for (NSValue *pointValue in [dicPerson objectForKey:POINTS_KEY]) {
                CGPoint p = [pointValue CGPointValue] ;
                CGContextFillRect(context, CGRectMake(p.x - 1.0 , p.y - 1.0 , 2.0 , 2.0));
            }
        }
        if ([dicPerson objectForKey:RECT_KEY]) {
            CGContextStrokeRect(context, [[dicPerson objectForKey:RECT_KEY] CGRectValue]);
        }
    }
}

@end
