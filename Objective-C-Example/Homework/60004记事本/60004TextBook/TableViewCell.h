//
//  TableViewCell.h
//  60004TextBook
//
//  Created by 马千里 on 16/3/13.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Data.h"
@interface TableViewCell : UITableViewCell

@property (nonatomic,weak)Data *data;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
