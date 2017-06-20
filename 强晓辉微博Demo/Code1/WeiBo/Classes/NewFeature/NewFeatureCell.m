//
//  NewFeatureCell.m
//  WeiBo
//
//  Created by student on 16/5/3.
//  Copyright © 2016年 BNG. All rights reserved.
//

#import "NewFeatureCell.h"

#import "def.h"
// 定义之后可以不用带mas_前缀
#define MAS_SHORTHAND
// 定义之后equalTo等于mas_equalTo
#define MAS_SHORTHAND_GLOBALS
#import <Masonry.h>
@interface NewFeatureCell()

@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIButton *startBtn;

@end

@implementation NewFeatureCell

// 代码创建的时候初始化对象
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加背景图片及按钮
        [self.contentView addSubview:self.bgImageView];
        [self.contentView addSubview:self.startBtn];
        // 设置布局约束
        [self.bgImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.contentView);
        }];
        [self.startBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.centerX);
            make.centerY.equalTo(self.contentView.centerY).offset(50);
            //            372 × 85
            make.width.equalTo(372/2);
            make.height.equalTo(85/2);
        }];
    }
    return self;
}




- (void)setImageIndex:(int)imageIndex
{
    _imageIndex = imageIndex;
    self.bgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"new_feature_%i",imageIndex+1]];
    
    [self.startBtn setHidden:!(imageIndex == 3)];
}

- (UIImageView *)bgImageView
{
    if(_bgImageView == nil)
    {
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}

- (UIButton *)startBtn
{
    if(_startBtn == nil)
    {
        _startBtn = [[UIButton alloc] init];
        
        [_startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_button"] forState:UIControlStateNormal];
        [_startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_button_highlighted"] forState:UIControlStateHighlighted];
        [_startBtn setHidden:YES];
        [_startBtn addTarget:self action:@selector(startBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (void)startBtnPressed:(id)sender{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRootSwitchViewController object:nil];
}

@end
