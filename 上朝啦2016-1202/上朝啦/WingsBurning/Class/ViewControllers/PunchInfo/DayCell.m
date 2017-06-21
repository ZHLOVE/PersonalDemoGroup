//
//  DayCell.m
//  WingsBurning
//
//  Created by MBP on 2016/11/24.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "DayCell.h"
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import <Masonry/Masonry.h>
#define ratio  [UIScreen mainScreen].bounds.size.height / 667

@implementation DayCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //outline_yellow//outline_red
        UIImageView *circleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"outline_yellow"]];
        [self.contentView insertSubview:circleImageView atIndex:0];
        self.circleImageView = circleImageView;
        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    __weak typeof (self) weakSelf = self;
    [self.circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.backgroundView).offset(-1.5);
        make.height.mas_equalTo(34 * ratio);
        make.width.mas_equalTo(34 * ratio);
        make.centerX.mas_equalTo(weakSelf.backgroundView.mas_centerX);
    }];
}

@end
