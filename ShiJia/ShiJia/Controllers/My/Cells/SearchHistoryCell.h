//
//  SearchHistoryCell.h
//  ShiJia
//
//  Created by 蒋海量 on 16/9/1.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchHistoryCellDelegate
- (void)deleteHistoryWord:(NSString *)word;

@end
@interface SearchHistoryCell : UITableViewCell
@property (nonatomic,strong) id <SearchHistoryCellDelegate> m_delegate;

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBgBtn;

@end
