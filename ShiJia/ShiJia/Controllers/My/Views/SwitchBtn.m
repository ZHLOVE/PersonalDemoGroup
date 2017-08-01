//
//  SwitchBtn.m
//  HiTV
//
//  Created by 蒋海量 on 15/7/25.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "SwitchBtn.h"
@interface SwitchBtn()
@property (nonatomic, strong) UIImageView *img;

@end

@implementation SwitchBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        //[self setBackgroundImage:[UIImage imageNamed:@"开关底.png"] forState:UIControlStateNormal];
        
        _img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 22)];
        _img.image = [UIImage imageNamed:@"switchOn"];
        _img.backgroundColor = [UIColor clearColor];
        _img.userInteractionEnabled = NO;
        [self addSubview:_img];
        
    }
    return self;
}

- (void)setIsPressed:(BOOL)isPressed {
    _isPressed = isPressed;
    if (isPressed) {
        _img.image = [UIImage imageNamed:@"switchOn"];

    }
    else {
        _img.image = [UIImage imageNamed:@"关.png"];

    }
    //_isPressed = !_isPressed;
}
@end
