//
//  TableViewCell.m
//  MusicPlayer
//
//  Created by student on 16/4/5.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMusic:(Music *)music{
    NSString *imgName = music.singerIcon;
    _imgView.image = [UIImage imageNamed:imgName];
    //圆角
    _imgView.layer.cornerRadius = _imgView.bounds.size.width*0.5;
    //边框
    _imgView.layer.borderColor = [UIColor colorWithRed:0.1 green:0.61 blue:1.0 alpha:1.0].CGColor;
    _imgView.layer.borderWidth = 3;
    _imgView.layer.masksToBounds = YES;
    _nameLabel.text = music.name;
}
@end
