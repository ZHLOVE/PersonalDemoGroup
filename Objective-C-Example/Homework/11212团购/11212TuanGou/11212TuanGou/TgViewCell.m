//
//  TgViewCell.m
//  11212TuanGou
//
//  Created by 马千里 on 16/3/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "TgViewCell.h"

@implementation TgViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTg:(TgModell *)m{
    _tg = m;
    self.iconImageView.image = [UIImage imageNamed:m.icon];
    self.titleLabel.text = m.title;
    self.priceLabel.text = [NSString stringWithFormat:@"%@元", m.price];
    self.buyCountLabel.text = [NSString stringWithFormat:@"已经有%@人购买", m.buyCount];
}
@end
