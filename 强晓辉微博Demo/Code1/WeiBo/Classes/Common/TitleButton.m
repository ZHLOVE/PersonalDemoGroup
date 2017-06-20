//
//  TitleButton.m
//  WeiBo
//
//  Created by student on 16/4/25.
//  Copyright © 2016年 BNG. All rights reserved.
//

#import "TitleButton.h"

@implementation TitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateSelected];
    }
    return self;
}

- (void)layoutSubviews//改变子视图的尺寸位置
{
    [super layoutSubviews];
    CGRect labelFrame = self.titleLabel.frame;
    labelFrame.origin.x = 0;
    self.titleLabel.frame = labelFrame;
    
    CGRect imgFrame = self.imageView.frame;
    imgFrame.origin.x = labelFrame.size.width;
    self.imageView.frame = imgFrame;
    
    
}

@end
