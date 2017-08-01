//
//  SJVideoPlayerSeriesViewTableCell.m
//  ShiJia
//
//  Created by yy on 16/7/23.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJVideoPlayerSeriesViewTableCell.h"

NSString * const kSJVideoPlayerSeriesViewTableCellIdentifier = @"SJVideoPlayerSeriesViewTableCell";

@interface SJVideoPlayerSeriesViewTableCell ()

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UIImageView *lineImgView;

@end

@implementation SJVideoPlayerSeriesViewTableCell

#pragma mark - Lifecycle
- (void)awakeFromNib
{
    [super awakeFromNib];
    _lineImgView.backgroundColor = kColorLightGrayBackground;
    [_lineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(0.5);
    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Data
- (void)showText:(NSString *)text
{
    _label.text = text;
}

#pragma mark - Setter
- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    if (checked) {
        _label.textColor = kColorBlueTheme;
    }
    else{
        _label.textColor = [UIColor whiteColor];
    }
}

@end
