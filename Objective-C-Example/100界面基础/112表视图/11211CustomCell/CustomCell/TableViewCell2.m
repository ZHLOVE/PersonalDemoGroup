//
//  TableViewCell2.m
//  CustomCell
//
//  Created by niit on 16/3/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "TableViewCell2.h"

@implementation TableViewCell2

// 当对象从xib或者Storyboard里创建的时候会调用该方法
- (void)awakeFromNib {
    // Initialization code
    NSLog(@"%s",__func__);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
