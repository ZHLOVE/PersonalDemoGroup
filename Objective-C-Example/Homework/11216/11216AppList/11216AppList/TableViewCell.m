//
//  TableViewCell.m
//  11215
//
//  Created by 马千里 on 16/3/9.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}


- (void)setNews:(AppsModel *)App{
    self.uiImageView.image = [UIImage imageNamed:App.image];
    self.softName.text = App.softName;
    self.fortune.text = App.fortune;
    self.edition.text = App.edition;
}

@end
