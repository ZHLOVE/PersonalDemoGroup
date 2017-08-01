//
//  UIView+DefaultEmptyView.m
//  ShiJia
//
//  Created by 峰 on 2017/3/9.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "UIView+DefaultEmptyView.h"

@implementation UIView (DefaultEmptyView)

+(UIView *)Friend_EmptyDefaultView{
   UIView *_defaultEmptyView = [UIView new];
    UIImageView *backimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_friends"]];
    [_defaultEmptyView addSubview:backimage];
    UILabel *label = [UILabel new];
    label.text = @"未找到好友";
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = kColorLightGray;
    [_defaultEmptyView addSubview:label];
    [backimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_defaultEmptyView);
        make.top.mas_equalTo(_defaultEmptyView).offset(100);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_defaultEmptyView);
        make.top.mas_equalTo(backimage.mas_bottom);
    }];
    return _defaultEmptyView;
}


+(UIView *)Main_EmptyDefaultView{
    UIView *_defaultEmptyView = [UIView new];
    UIImageView *backimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_friends"]];
    [_defaultEmptyView addSubview:backimage];
    UILabel *label = [UILabel new];
    label.text = @"没有更多数据";
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = kColorLightGray;
    [_defaultEmptyView addSubview:label];
    [backimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_defaultEmptyView);
        make.top.mas_equalTo(_defaultEmptyView).offset(100);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_defaultEmptyView);
        make.top.mas_equalTo(backimage.mas_bottom);
    }];
    return _defaultEmptyView;
}

@end
