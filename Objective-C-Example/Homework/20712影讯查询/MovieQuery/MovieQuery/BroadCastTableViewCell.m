//
//  BroadCastTableViewCell.m
//  MovieQuery
//
//  Created by student on 16/4/1.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "BroadCastTableViewCell.h"

@implementation BroadCastTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setMovieHell:(Movie *)movieHell{
    _hallLabel.text = movieHell.hall;
    _priceLabel.text = movieHell.price;
    _timeLabel.text = movieHell.time;
}
@end
