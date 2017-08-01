//
//  SJLocalVedioCell.m
//  ShiJia
//
//  Created by 峰 on 16/8/31.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJLocalVedioCell.h"

@implementation SJLocalVedioCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageView.layer.borderColor = [UIColor clearColor].CGColor;
        [self.contentView addSubview:self.imageView];
        self.timeButton = [UIButton new];
        self.timeButton.enabled = NO;
        self.timeButton.backgroundColor = [UIColor blackColor];
        self.timeButton.alpha = 0.4;
        [self.timeButton setImage:[UIImage imageNamed:@"vediologo"] forState:UIControlStateNormal];
        self.timeButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:self.timeButton];
        [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(self.contentView).offset(-5);
            make.size.mas_equalTo(CGSizeMake(60, 20));
        }];
    }
    return self;
}
- (void)setCellValueWithModel:(ALAsset *)model {
    _imageView.image        = [UIImage imageWithCGImage:[model thumbnail]];
    NSInteger timeNumber = [[ model valueForProperty:ALAssetPropertyDuration ] integerValue];
    [_timeButton setTitle:[Utils secondsString:timeNumber] forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];

}
@end
