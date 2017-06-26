//
//  TableViewCell.m
//  11402PresidentList
//
//  Created by student on 16/3/10.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "TableViewCell.h"


@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPresident:(President *)president{
    self.label.text = president.name;
}

@end
