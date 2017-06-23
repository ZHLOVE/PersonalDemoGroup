//
//  TableViewCell3.m
//  CustomCell
//
//  Created by niit on 16/3/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "TableViewCell3.h"

@implementation TableViewCell3

// 当对象从xib或者Storyboard里创建的时候会调用该方法
- (void)awakeFromNib {
    // Initialization code
    NSLog(@"%s",__func__);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 代码创建界面元素
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(150, 25, 70, 15)];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(150+80, 25, 70, 15)];
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(150, 56, 70, 15)];
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(150+80, 56, 70, 15)];
        
        label1.text = @"型号";
        label3.text = @"颜色";
        
        [self.contentView addSubview:label1];
        [self.contentView addSubview:label2];
        [self.contentView addSubview:label3];
        [self.contentView addSubview:label4];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 130, 130)];
        [self.contentView addSubview:iconImageView];
        
        // 
        self.iconImageView = iconImageView;
        self.nameLabel = label2;
        self.colorLabel = label4;
        
    }
    return self;
}

// 当父视图大小改变时，会自动执行该方法
- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
