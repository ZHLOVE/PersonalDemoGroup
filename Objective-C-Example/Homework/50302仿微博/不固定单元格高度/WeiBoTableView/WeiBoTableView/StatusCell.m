//
//  StatusCell.m
//  WeiBoTableView
//
//  Created by student on 16/3/8.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "StatusCell.h"

@interface StatusCell()

@property (nonatomic,weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *contentLabel;
@property (nonatomic,weak) IBOutlet UIImageView *pictureImageView;
@property (nonatomic,weak) IBOutlet UIImageView *vipImageView;
@end
@implementation StatusCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStatus:(StatusModel *)status
{
    _status = status;
    
    self.iconImageView.image = [UIImage imageNamed:status.icon];
    self.nameLabel.text = status.name;
    self.contentLabel.text = status.text;
    self.pictureImageView.image = [UIImage imageNamed:status.picture];
    self.vipImageView.hidden = !status.vip;
}

@end
