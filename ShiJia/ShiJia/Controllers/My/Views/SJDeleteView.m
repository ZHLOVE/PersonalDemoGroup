//
//  SJDeleteView.m
//  ShiJia
//
//  Created by yy on 16/4/18.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "SJDeleteView.h"

CGFloat const kSJDeleteViewHeight = 40.0;
static CGFloat kLineWidth = 1;
static CGFloat kTopPadding = 9.0;

@interface SJDeleteView ()

@property (nonatomic, strong, readwrite) UIButton *selectAllButton;
@property (nonatomic, strong, readwrite) UIButton *deleteButton;
@property (nonatomic, strong) UIImageView *topLineImgView;
@property (nonatomic, strong) UIImageView *midLineImgView;

@end

@implementation SJDeleteView

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // 全选按钮
        _selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectAllButton.backgroundColor = [UIColor clearColor];
        [_selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
        _selectAllButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_selectAllButton setTitleColor:kFontColorDarkGray forState:UIControlStateNormal];
        [self addSubview:_selectAllButton];
        
        // 删除按钮
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.backgroundColor = [UIColor clearColor];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_deleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self addSubview:_deleteButton];
        _deleteButton.enabled = NO;
        _isDeleteEnabled = NO;
        
        // 顶部分割线
        _topLineImgView = [[UIImageView alloc] init];
        _topLineImgView.backgroundColor = [UIColor colorWithRed:219/255.0 green:222/255.0 blue:225/255.0 alpha:1.0];;
        [self addSubview:_topLineImgView];
        
        // 按钮中间分割线
        _midLineImgView = [[UIImageView alloc] init];
        _midLineImgView.backgroundColor = [UIColor colorWithRed:219/255.0 green:222/255.0 blue:225/255.0 alpha:1.0];;
        [self addSubview:_midLineImgView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _topLineImgView.frame = CGRectMake(0, 0, self.frame.size.width, kLineWidth);
    _midLineImgView.frame = CGRectMake((self.frame.size.width - kLineWidth) / 2.0, kTopPadding, kLineWidth, self.frame.size.height - 2 * kTopPadding);
   
    _selectAllButton.frame = CGRectMake(0, kLineWidth, (self.frame.size.width - kLineWidth) / 2.0, self.frame.size.height - kLineWidth);
    _deleteButton.frame = CGRectMake(_selectAllButton.frame.size.width + kLineWidth, kLineWidth, _selectAllButton.frame.size.width, _selectAllButton.frame.size.height);
    
}

#pragma Setter & Getter
- (void)setIsDeleteEnabled:(BOOL)isDeleteEnabled
{
    _isDeleteEnabled = isDeleteEnabled;
    _deleteButton.enabled = _isDeleteEnabled;
    
    if (isDeleteEnabled) {
        [_deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else{
        [_deleteButton setTitleColor:kColorLightGrayBackground forState:UIControlStateNormal];
    }
}

- (void)setIsSelectedAll:(BOOL)isSelectedAll
{
    _isSelectedAll = isSelectedAll;
    if (isSelectedAll) {
        [_selectAllButton setTitle:@"取消全选" forState:UIControlStateNormal];
    }
    else{
        [_selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
    }
}

@end
