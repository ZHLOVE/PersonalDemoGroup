//
//  SJVideoSeriesTableViewCell.m
//  ShiJia
//
//  Created by 蒋海量 on 2017/1/18.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "SJVideoSeriesTableViewCell.h"
#import "CustomView.h"

@interface SJVideoSeriesTableViewCell ()

@property (nonatomic, strong) CustomView *customView;

@end
@implementation SJVideoSeriesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self resetCustomView];
}
-(void)resetCustomView{
    [_customView removeAllSubviews];
    _customView = nil;
    _customView = [[CustomView alloc]initWithFrame:self.frame];
    [self addSubview:_customView];
}
//角标设置
-(void)setModel:(id)model{
    _customView.sizeToWidth = 30;
    [_customView useViewCorners:model];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
