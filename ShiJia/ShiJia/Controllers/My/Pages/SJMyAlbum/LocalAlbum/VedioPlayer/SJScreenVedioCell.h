//
//  SJScreenVedioCell.h
//  ShiJia
//
//  Created by 峰 on 16/7/6.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface SJScreenVedioCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setCellValueWithModel:(ALAsset *)model;

@end
