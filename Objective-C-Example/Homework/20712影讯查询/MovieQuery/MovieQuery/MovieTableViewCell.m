//
//  MovieTableViewCell.m
//  MovieQuery
//
//  Created by 马千里 on 16/3/31.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "MovieTableViewCell.h"

@implementation MovieTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMovie:(Movie *)movie{
    _movieName.text = movie.movieName;
}

@end
