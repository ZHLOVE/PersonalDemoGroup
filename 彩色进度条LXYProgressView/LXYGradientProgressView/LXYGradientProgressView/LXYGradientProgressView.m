//
//  LXYGradientProgressView.m
//  LXYGradientProgressView
//
//  Created by 宣佚 on 15/8/19.
//  Copyright (c) 2015年 Liuxuanyi. All rights reserved.
//

#import "LXYGradientProgressView.h"

@implementation LXYGradientProgressView

@synthesize animating;
@synthesize progress;

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        CAGradientLayer *layer = (id)[self layer];
        [layer setStartPoint:CGPointMake(0, 0)];
        [layer setEndPoint:CGPointMake(1.0, 0.5)];
        
        NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:1];
        for (NSInteger hue = 0; hue <= 360; hue += 5) {
            UIColor *color;
            color = [UIColor colorWithHue:1.0 * hue / 360
                               saturation:1.0
                               brightness:1.0
                                    alpha:1.0];
            [colors addObject:(id)[color CGColor]];
        }
        [layer setColors:[NSArray arrayWithArray:colors]];
        
        maskLayer = [CALayer layer];
        [maskLayer setFrame:CGRectMake(0, 0, 0, frame.size.height)];
        [maskLayer setBackgroundColor:[UIColor blackColor].CGColor];
        [layer setMask:maskLayer];
    }
    return self;
}

+(Class)layerClass
{
    return [CAGradientLayer class];
}

-(void)setProgress:(CGFloat)value
{
    if (progress != value) {
        progress = MIN(1.0, fabs(value));
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews
{
    CGRect maskRect = [maskLayer frame];
    maskRect.size.width = CGRectGetWidth([self bounds]) * progress;
    [maskLayer setFrame:maskRect];
}

-(NSArray *)shiftColors:(NSArray *)colors
{
    NSMutableArray *mutable = [colors mutableCopy];
    id last = [mutable lastObject];
    [mutable removeLastObject];
    [mutable insertObject:last atIndex:0];
    return [NSArray arrayWithArray:mutable];
}

-(void)performAnimation
{
    // 移动最后一个颜色到第一个
    // 切换其他所有颜色
    CAGradientLayer *layer = (id)[self layer];
    NSMutableArray *mutable = [[layer colors] mutableCopy];
    id lastColor = [mutable lastObject];
    [mutable removeLastObject];
    [mutable insertObject:lastColor atIndex:0];
    NSMutableArray *shiftColors = [NSMutableArray arrayWithArray:mutable];
    
    // 更新颜色
    [layer setColors:shiftColors];
    
    //创建一个【自左向右颜色渐变的】动画
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    [animation setToValue:shiftColors];
    [animation setDuration:0.08f];
    [animation setRemovedOnCompletion:YES];
    [animation setFillMode:kCAFillModeForwards];
    [animation setDelegate:self];
    [layer addAnimation:animation forKey:@"animationGradient"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([self isAnimating]) {
        [self performAnimation];
    }
}

-(void)startAnimating
{
    if (![self isAnimating]) {
        animating = YES;
        [self performAnimation];
    }
}
//
-(void)stopAnimating
{
    if ([self isAnimating]) {
        animating = NO;
    }
}

@end
