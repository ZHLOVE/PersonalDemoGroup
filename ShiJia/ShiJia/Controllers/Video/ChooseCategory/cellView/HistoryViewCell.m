//
//  HistoryViewCell.m
//  SearchHistory
//
//  Created by 植梧培 on 15/8/25.
//  Copyright (c) 2015年 机智的新手. All rights reserved.
//

#import "HistoryViewCell.h"
CGFloat heightForCell = 35;
@interface HistoryViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation HistoryViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = heightForCell / 2;
    self.layer.borderColor = kColorLightGray.CGColor;
    self.layer.borderWidth = 1.0;
}

- (void)setKeyword:(NSString *)keyword {
    _keyword = keyword;
    _titleLabel.text = _keyword;
    [self layoutIfNeeded];
    [self updateConstraintsIfNeeded];
}

- (CGSize)sizeForCell {
    //宽度加 heightForCell 为了两边圆角。
    return CGSizeMake([_titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + heightForCell, heightForCell);
}
-(void)setHighlighted:(BOOL)highlighted{
    if (highlighted) {
        self.backgroundColor = kColorBlueTheme;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.layer.borderColor = kColorBlueTheme.CGColor;
    }else{
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor lightGrayColor];
        self.layer.borderColor = kColorLightGray.CGColor;
    }
}




@end
