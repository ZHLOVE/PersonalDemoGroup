//
//  SearchCollectionCell.m
//  ShiJia
//
//  Created by 峰 on 2017/1/5.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "SearchCollectionCell.h"
#import "CustomView.h"

@interface SearchCollectionCell ()
@property (weak, nonatomic  ) IBOutlet UIImageView  *programSeriesImage;
@property (weak, nonatomic  ) IBOutlet UILabel      *programSeriesName;
@property (nonatomic, strong) CustomView            *cornerView;

@end

@implementation SearchCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.programSeriesImage.contentMode =  UIViewContentModeScaleAspectFill;
    self.programSeriesImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.programSeriesImage.clipsToBounds  = YES;
    self.programSeriesImage.layer.cornerRadius = 2.0f;
    _cornerView =[[CustomView alloc]initWithFrame:self.programSeriesImage.frame];
    _cornerView.sizeToWidth = 30.f;
    [self addSubview:_cornerView];
}

-(void)setCellmodel:(programSeries *)cellmodel{

    [self.programSeriesImage setImageWithURL:[NSURL URLWithString:cellmodel.verticalPosterAddr] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
    self.programSeriesName.text = cellmodel.name;
    [_cornerView useViewCorners:cellmodel.corner];

}

@end
