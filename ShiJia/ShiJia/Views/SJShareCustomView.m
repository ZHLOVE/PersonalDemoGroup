//
//  SJShareCustomView.m
//  ShiJia
//
//  Created by 峰 on 2017/2/24.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "SJShareCustomView.h"

@interface SJShareCustomView()

@property (nonatomic, strong) UIView            *topView;
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) UIButton          *cancelButton;

@end

@implementation SJShareCustomView

- (instancetype)init
{
    self = [super init];
    if (self) {

        [self addSubview:self.topView];
        [self addSubview:self.collectionView];

        [self addSubViewsConstraint];

    }
    return self;
}

#pragma  mark Event
-(void)cancelAction{

}

#pragma  mark UI & Constraint
-(void)addSubViewsConstraint{

    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(43.);
    }];

    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(50);
    }];
}

-(UIView *)topView{
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor whiteColor];
        UIView *line = [UIView new];
        line.backgroundColor = kColorBlueTheme;
        [_topView addSubview:line];

        UILabel *label = [UILabel new];
        label.text = @"分享";
        label.textColor = kNavTitleColor;
        label.font = [UIFont systemFontOfSize:16];
        [_topView addSubview:label];

        UIView *line2 = [UIView new];
        line2.backgroundColor = RGB(242, 242, 242, 1);
        [_topView addSubview:line2];

        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_topView).offset(21);
            make.top.mas_equalTo(_topView).offset(13);
            make.height.mas_equalTo(17);
            make.width.mas_equalTo(2);
        }];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(line);
            make.left.mas_equalTo(line.mas_right).offset(7);
        }];

        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_topView);
            make.height.mas_equalTo(1);
        }];

    }
    return _topView;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
    }
    return _collectionView;
}

-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:kNavTitleColor forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}


@end
