//
//  TitleButton.m
//  Weibo
//
//  Created by qiang on 4/25/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "TitleButton.h"

#import "UIView+Frame.h"

@implementation TitleButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 文字颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 小图的图片
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateSelected];
    }
    return self;
}

- (void)layoutSubviews // 改变子视图的尺寸位置
{
    [super layoutSubviews];
    
    // label的x位置设置0
//    CGRect labelFrame = self.titleLabel.frame;
//    labelFrame.origin.x = 0;
//    self.titleLabel.frame = labelFrame;
    // =>
    self.titleLabel.x_ = 0;
    
    // 图片的x设置为label的宽度
//    CGRect imgFrame = self.imageView.frame;
//    imgFrame.origin.x = labelFrame.size.width;
//    self.imageView.frame = imgFrame;
    // =>
    self.imageView.x_ = self.titleLabel.width_;
}
@end
