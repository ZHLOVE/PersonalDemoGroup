//
//  SJSelectAllButton.m
//  ShiJia
//
//  Created by yy on 16/3/7.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJSelectAllButton.h"

CGFloat const kSJSelectAllButtonWidth = 90.0;

static CGFloat kIconImgWidth = 20.0;

@interface SJSelectAllButton ()

@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel     *label;

@end

@implementation SJSelectAllButton

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        //icon
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"contact_list_uncheck"];
        [self addSubview:_iconImgView];
        
        //label
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:15.0];
        _label.textColor = [UIColor darkGrayColor];
        _label.text = @"全选";
        [self addSubview:_label];
        
    }
    return self;
}

- (void)layoutSubviews
{

    _iconImgView.frame = CGRectMake(10, (self.frame.size.height-kIconImgWidth)/2.0, kIconImgWidth, kIconImgWidth);
    _label.frame = CGRectMake(kIconImgWidth, 0, self.frame.size.width-kIconImgWidth, self.frame.size.height);
}

#pragma mark - Setter
- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    if (checked) {
        _iconImgView.image = [UIImage imageNamed:@"contact_list_checked"];
    }
    else{
        _iconImgView.image = [UIImage imageNamed:@"contact_list_uncheck"];
    }
}


@end
