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
        // add by Allen
        self.timeButton = [UIButton new];
        self.timeButton.enabled = NO;
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
//    _nameLabel.text      = [[model defaultRepresentation] filename];
    
    NSInteger timeNumber = [[ model valueForProperty:ALAssetPropertyDuration ] integerValue];
//    _timeButton.text      = [self TimeformatFromSeconds:timeNumber];
    [_timeButton setTitle:[self TimeformatFromSeconds:timeNumber] forState:UIControlStateNormal];
    
}
- (NSString*)TimeformatFromSeconds:(NSInteger)seconds
{
    
    NSString *str_hour   = [NSString stringWithFormat:@"%02ld",seconds/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    NSString *formattime = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return formattime;
}
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
//    self.selcetImage.image =  selected?[UIImage imageNamed:@"contact_list_checked"]:nil;
    //    self.imageView.layer.borderWidth = selected ? 2 : 0;
}
@end
