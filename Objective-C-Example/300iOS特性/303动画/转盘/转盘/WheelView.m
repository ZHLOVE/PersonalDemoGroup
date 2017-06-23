//
//  WheelView.m
//  转盘
//
//  Created by qiang on 16/3/21.
//  Copyright © 2016年 Qiangtech. All rights reserved.
//

#import "WheelView.h"

#import "WheelButton.h"

@interface WheelView()

@property (weak, nonatomic) IBOutlet UIImageView *centerView;

@property (weak, nonatomic) IBOutlet UIButton *selBtn;// 当前选中的星座按钮

@property (nonatomic,strong) CADisplayLink *link;

@end

@implementation WheelView

+ (instancetype)wheelView
{
    return [[NSBundle mainBundle] loadNibNamed:@"WheelView" owner:nil options:nil][0];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSLog(@"%s",__func__);
        NSLog(@"%@",self.centerView);
    }
    return self;
}

- (void)awakeFromNib
{
    NSLog(@"%s",__func__);
    NSLog(@"%@",self.centerView);
    
    
    // 按钮宽高
    CGFloat btnW = 68;
    CGFloat btnH = 143;
    // view宽高
    CGFloat wh = self.bounds.size.width;
    
    UIImage *bigImage = [UIImage imageNamed:@"LuckyAstrology"];
    UIImage *selBigImage = [UIImage imageNamed:@"LuckyAstrologyPressed"];
    CGFloat scale = [UIScreen mainScreen].scale;// 图片像素和点的比例
    CGFloat imageW = bigImage.size.width / 12 * scale;
    CGFloat imageH = bigImage.size.height * scale;
    
    // 添加按钮
    for(int i=0;i<12;i++)
    {
        WheelButton *btn = [WheelButton buttonWithType:UIButtonTypeCustom];
        btn.bounds = CGRectMake(0, 0, btnW, btnH);
        btn.layer.anchorPoint = CGPointMake(0.5, 1);
        btn.layer.position = CGPointMake(wh/2, wh/2);
        
        // 旋转角度
        CGFloat radion = M_PI * 2 / 12 * i;
        btn.transform = CGAffineTransformMakeRotation(radion);
        [self.centerView addSubview:btn];
        
        // 按钮背景
        CGRect clipR = CGRectMake(i*imageW, 0, imageW, imageH);
        
        CGImageRef imgR;
        UIImage *image;
        
        imgR = CGImageCreateWithImageInRect(bigImage.CGImage, clipR);
        image = [UIImage imageWithCGImage:imgR];
        [btn setImage:image forState:UIControlStateNormal];
        
        imgR = CGImageCreateWithImageInRect(selBigImage.CGImage, clipR);
        image = [UIImage imageWithCGImage:imgR];
        [btn setImage:image forState:UIControlStateHighlighted];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"LuckyRototeSelected"] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        // 默认选中第一个
        if(i==0)
        {
            [self btnPressed:btn];
        }
        
    }
}

- (CADisplayLink *)link
{
    if(_link == nil)
    {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(angleChange)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _link;
}


- (void)angleChange
{
    // 每秒
    CGFloat angle = M_PI * 2 / 12 / 60;// 美秒转的角度
    self.centerView.transform = CGAffineTransformRotate(self.centerView.transform, angle);
}

- (void)btnPressed:(UIButton *)btn
{
    self.selBtn.selected = NO;
    self.selBtn = btn;
    self.selBtn.selected = YES;
}

- (void)start
{
//    CABasicAnimation *anim = [CABasicAnimation animation];
//    anim.keyPath = @"transform.rotation";
//    anim.toValue = @(M_PI * 2);
//    anim.duration = 2;
//    anim.repeatCount = MAXFLOAT;
//    [self.centerView.layer addAnimation:anim forKey:nil];
    
    self.link.paused = NO;
}

- (void)stop
{
    self.link.paused = YES;
}


- (IBAction)selBtnPressed:(id)sender
{
   self.link.paused = YES;
    
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.toValue = @(M_PI * 2 * 3);
    anim.duration = 0.5;
    anim.delegate = self;
    [self.centerView.layer addAnimation:anim forKey:nil];
    
    // 旋转转盘
    CGFloat angle = atan2(_selBtn.transform.b, _selBtn.transform.a);
    _centerView.transform = CGAffineTransformMakeRotation(-angle);
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.link.paused = NO;
    });
}

@end
