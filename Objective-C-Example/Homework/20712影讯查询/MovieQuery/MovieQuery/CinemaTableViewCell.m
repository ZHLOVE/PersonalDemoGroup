//
//  CinemaTableViewCell.m
//  MovieQuery
//
//  Created by 马千里 on 16/3/31.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "CinemaTableViewCell.h"

@implementation CinemaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCinema:(Cinema *)cinema{
    _uid = cinema.uid;
    _name.text = cinema.cinemaName;
    _address.text = cinema.address;
    _telephone.text = cinema.telephone;
}

@end
