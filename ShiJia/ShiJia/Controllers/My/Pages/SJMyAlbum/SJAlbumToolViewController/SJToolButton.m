//
//  SJToolButton.m
//  ShiJia
//
//  Created by 峰 on 16/9/1.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJToolButton.h"

@implementation SJToolButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    // 调整图片的位置和尺寸
    //    self.imageView.y = 0;
    self.imageView.centerX = self.width * 0.5;
    self.imageView.centerY = self.height* 1/3;
    
    // 调整下面文字的图片和尺寸
    //    self.titleLabel.x = 0;
    //    self.titleLabel.y = self.imageView.height;
        self.titleLabel.width = self.width;
    self.titleLabel.centerX = self.width * 0.5;
//    self.titleLabel.centerY = self.height* 5/6;
    self.titleLabel.bottom = self.bottom;
    //    self.titleLabel.height = self.height - self.titleLabel.y;
}

@end
