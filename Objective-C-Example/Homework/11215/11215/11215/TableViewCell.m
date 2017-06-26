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


- (void)setNews:(NewsModel *)news{
    self.image.image = [UIImage imageNamed:news.image];
    self.title.text = news.title;
    self.date.text = news.date;
    self.text.text = news.Text;
}

@end
