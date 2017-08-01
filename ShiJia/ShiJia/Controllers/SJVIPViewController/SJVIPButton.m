//
//  SJVIPButton.m
//  ShiJia
//
//  Created by 峰 on 16/10/17.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJVIPButton.h"

@implementation SJVIPButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat imgWidth = self.imageView.image.size.width;
    CGFloat imgHeight = self.imageView.image.size.height;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGFloat textWitdh = textSize.width;

    CGFloat interval;      // distance between the whole image title part and button

    CGFloat titleOffsetX;  // horizontal offset of title
    CGFloat titleOffsetY;  // vertical offset of title
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.centerX.equalTo(self.mas_centerX).offset((textWitdh+5)/2);
        make.width.equalTo(@(imgWidth));
        make.height.equalTo(@(imgHeight));
    }];

    interval = self.imageView.frame.origin.x-5-textWitdh-imgWidth*2;

    titleOffsetX = interval;
    titleOffsetY = 0;
    [self setTitleEdgeInsets:UIEdgeInsetsMake(titleOffsetY, titleOffsetX, 0, 0)];
}

@end
