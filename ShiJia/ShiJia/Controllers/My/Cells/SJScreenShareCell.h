//
//  SJScreenShareCell.h
//  ShiJia
//
//  Created by 峰 on 16/7/1.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJScreenShareCellModel.h"

@interface SJScreenShareCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setCellValueWithModel:(SJScreenShareCellModel *)model;

@end
