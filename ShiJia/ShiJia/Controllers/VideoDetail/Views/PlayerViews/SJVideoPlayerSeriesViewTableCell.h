//
//  SJVideoPlayerSeriesViewTableCell.h
//  ShiJia
//
//  Created by yy on 16/7/23.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kSJVideoPlayerSeriesViewTableCellIdentifier;

@interface SJVideoPlayerSeriesViewTableCell : UITableViewCell

@property (nonatomic, assign) BOOL checked;

- (void)showText:(NSString *)text;

@end
