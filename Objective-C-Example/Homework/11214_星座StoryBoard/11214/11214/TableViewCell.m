//
//  TableViewCell.m
//  11214
//
//  Created by 马千里 on 16/3/9.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)setConstellation:(Constellation *)constellation{
    self.image.image = [UIImage imageNamed:constellation.image];
    self.Fortune.image = [UIImage imageNamed:constellation.Fortune];
    self.name.text = constellation.Name;
    self.Text.text = constellation.Text;
    self.Date.text = constellation.Date;
    
}
@end
