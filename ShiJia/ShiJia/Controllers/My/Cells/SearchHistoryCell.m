//
//  SearchHistoryCell.m
//  ShiJia
//
//  Created by 蒋海量 on 16/9/1.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SearchHistoryCell.h"

@implementation SearchHistoryCell

//- (void)awakeFromNib {
//    // Initialization code
//}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.deleteBgBtn.hidden = self.deleteBtn.hidden;
    
}
-(IBAction)deleteButtonClick:(id)sender{
    [self.m_delegate deleteHistoryWord:self.titleLabel.text];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
