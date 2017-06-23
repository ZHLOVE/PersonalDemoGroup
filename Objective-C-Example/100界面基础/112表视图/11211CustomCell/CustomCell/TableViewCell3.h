//
//  TableViewCell3.h
//  CustomCell
//
//  Created by niit on 16/3/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell3 : UITableViewCell

// 此处无需与xib或者Storyboard连接，IBOutLet可以删除
@property (weak, nonatomic) UIImageView *iconImageView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *colorLabel;

@end
