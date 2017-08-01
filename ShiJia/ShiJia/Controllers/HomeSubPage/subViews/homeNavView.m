//
//  homeNavView.m
//  ShiJia
//
//  Created by 峰 on 2017/2/16.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "homeNavView.h"
#import "UIImage+GIF.h"
#define kButtonWidth 80
#define kButtonHeight 40

#define fontSizeA 17
#define fontSizeB 14
#define fontSizeC 12

#define textColorA [UIColor colorWithHexString:@"444444"]
#define textColorB [UIColor colorWithHexString:@"9a9a9a"]
#define textColorC [UIColor colorWithHexString:@"0085cf"]

#define LeftRightSpace 6


@interface homeNavView ()

@property (nonatomic, strong) UILabel *categoryNameLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIImageView *navImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;


@end

@implementation homeNavView

- (instancetype)init{
    self = [super init];
    if (self) {

        [self addSubview:self.moreButton];
        [self addSubview:self.categoryNameLabel];
        [self addSubview:self.navImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.detailLabel];
         self.backgroundColor = [UIColor whiteColor];
        [self addHomeNavsubViewConstraints];
    }
    return self;
}

-(void)setNavModel:(homeModel *)navModel{
    _navModel = navModel;
    if (navModel.contents.count>0) {

        contents *contentmodel = navModel.contents[0];
        _categoryNameLabel.text = contentmodel.categoryName;
        _nameLabel.text = contentmodel.title;
        _detailLabel.text = contentmodel.subTitle;
        if ([contentmodel.resourceType isEqualToString:@"gif"]) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:contentmodel.resourceUrl]];
//            _navImageView.gifData = data;

             _navImageView.image = [UIImage sd_animatedGIFWithData:data];
        }else{
            [_navImageView setImageWithURL:[NSURL URLWithString:contentmodel.resourceUrl] placeholderImage:[UIImage imageNamed:@"addefault"]];
        }
    }
}

-(void)goMore{

    if ([self.delegate respondsToSelector:@selector(clickHomeBricksCallBackWith:andContents:andType:)]) {
        [self.delegate clickHomeBricksCallBackWith:_navModel
                                       andContents:_navModel.contents[0]
                                           andType:1];
    }
}
-(void)clickImageAction{

    if ([self.delegate respondsToSelector:@selector(clickHomeBricksCallBackWith:andContents:andType:)]) {
        [self.delegate clickHomeBricksCallBackWith:_navModel
                                       andContents:_navModel.contents[0]
                                           andType:0];
    }
}

-(UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [UIButton new];
        [_moreButton setImage:[UIImage imageNamed:@"gomorebutton"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(goMore) forControlEvents:UIControlEventTouchUpInside];

    }
    return _moreButton;
}

-(UILabel *)categoryNameLabel{
    if (!_categoryNameLabel) {
        _categoryNameLabel = [UILabel new];
        _categoryNameLabel.textColor = textColorA;
        _categoryNameLabel.font = [UIFont systemFontOfSize:fontSizeA];
    }
    return _categoryNameLabel;
}

-(UIImageView *)navImageView{
    if (!_navImageView) {
        _navImageView = [UIImageView new];
        _navImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(clickImageAction)];
        [_navImageView addGestureRecognizer:tap];
    }
    return _navImageView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = textColorA;
        _nameLabel.font = [UIFont systemFontOfSize:fontSizeB];

    }
    return _nameLabel;
}

-(UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.textColor = textColorB;
        _detailLabel.font = [UIFont systemFontOfSize:fontSizeC];

    }
    return _detailLabel;
}

-(void)addHomeNavsubViewConstraints{

    [_categoryNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(20.);
        make.left.mas_equalTo(self).offset(LeftRightSpace);
        make.right.mas_equalTo(self).offset(-LeftRightSpace-kButtonWidth);
        make.height.mas_equalTo(15);
    }];

    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_categoryNameLabel);
        make.right.mas_equalTo(self).offset(-LeftRightSpace);
    }];

    [_navImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(LeftRightSpace);
        make.right.mas_equalTo(self).offset(-LeftRightSpace);
        make.top.mas_equalTo(_categoryNameLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(AutoSize_H_IP6(195.));
    }];

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_navImageView);
        make.top.mas_equalTo(_navImageView.mas_bottom).offset(10);
        make.height.mas_equalTo(15);
    }];

    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_navImageView);
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(12);
    }];
}

@end
