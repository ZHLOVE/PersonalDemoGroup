//
//  VideoHomeCollectionViewCell.m
//  ShiJia
//
//  Created by 蒋海量 on 16/7/22.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "VideoHomeCollectionViewCell.h"
NSString * const cVideoHomeCollectionViewCellID = @"VideoHomeCollectionViewCell";

@implementation VideoHomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imgView.size = CGSizeMake(self.imgView.image.size.width/1.8, self.imgView.image.size.height/1.8);
    self.imgView.center = CGPointMake((W/3-10)/2,(W/3-10)/2-10);
    [self addSubview:_imgView];

}
@end
