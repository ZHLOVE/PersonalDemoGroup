//
//  CollectionLandCell.m
//  ShiJia
//
//  Created by 峰 on 16/7/26.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "CollectionLandCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>

@interface CollectionLandCell ()

@property (nonatomic, strong) UIView      *LandView;

@property (nonatomic, strong) UIImageView *backimageView;
@property (nonatomic, strong) UIButton    *stateButton;
@property (nonatomic, strong) UILabel     *programmNameLabel;
@property (nonatomic, strong) UILabel     *lookHistoryLabel;
@property (nonatomic, strong) UIImageView *tvLogo;
@property (nonatomic, strong) UILabel     *tvName;
@property (nonatomic, strong) UILabel     *tvDescrition;
@property (nonatomic, strong) UILabel     *nowState;

@end

@implementation CollectionLandCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        _LandView = [UIView new];
        _LandView.backgroundColor = [UIColor whiteColor];
        //背景图片
        _backimageView = [UIImageView new];
//        _backimageView.layer.cornerRadius = 3.0f;
//        [_backimageView.layer masksToBounds];
        [_LandView addSubview:_backimageView];
        
        //直播标记
        _stateButton = [UIButton new];
        if ([OPENFLAG isEqualToString:@"0"]) {
            [_stateButton setTitle:@"最新" forState:UIControlStateNormal];
        }
        else{
            [_stateButton setTitle:@"直播中" forState:UIControlStateNormal];
        }
        _stateButton.backgroundColor =RGB(241, 100, 74, 1);
        _stateButton.titleLabel.font = [UIFont systemFontOfSize:10.];
        [_stateButton setTitleColor:RGB(255, 255, 255, 1) forState:UIControlStateNormal];
        [_LandView addSubview:_stateButton];
        
        //tvlogo
        _tvLogo = [UIImageView new];
        [_tvLogo sizeToFit];
        [_LandView addSubview:_tvLogo];
        
        //tvName
        _tvName = [UILabel new];
        _tvName.textColor = RGB(102, 102, 102, 1);
        _tvName.font = [UIFont systemFontOfSize:12.f];
        [_LandView addSubview:_tvName];
        
        
        //节目名字
        _programmNameLabel = [UILabel new];
        _programmNameLabel.textColor = RGB(0,0,0,1);
        _programmNameLabel.font = [UIFont systemFontOfSize:17];
        [_programmNameLabel setAdjustsFontSizeToFitWidth:YES];
        [_LandView addSubview:_programmNameLabel];
        
        //描述
        _tvDescrition = [UILabel new];
        _tvDescrition.textColor = RGB(162, 162, 162, 1);
        _tvDescrition.font = [UIFont systemFontOfSize:12.];
        [_LandView addSubview:_tvDescrition];
        
        //观看历史
        _lookHistoryLabel = [UILabel new];
        _lookHistoryLabel.textColor = RGB(42, 194, 239, 1);
        _lookHistoryLabel.font = [UIFont systemFontOfSize:12];
        [_LandView addSubview:_lookHistoryLabel];
        
        //当前状态
        _nowState = [UILabel new];
        _nowState.textColor = RGB(154, 154, 154, 1);
        _nowState.font = [UIFont systemFontOfSize:12.];
        [_LandView addSubview:_nowState];
        
        
        [_LandView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        //约束条件
        [_backimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(_LandView);
            make.height.mas_equalTo(110);
        }];
        
        [_stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_LandView);
            make.top.mas_equalTo(_LandView).offset(15);
            make.size.mas_equalTo(CGSizeMake(45, 16));
        }];
        
        [_tvLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_LandView).offset(10);
            make.top.mas_equalTo(_backimageView.mas_bottom).offset(10);
        }];
        
        [_tvName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_tvLogo.right);
            make.top.mas_equalTo(_tvLogo);
            make.right.mas_equalTo(_LandView);
        }];
        
        [_programmNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_LandView).offset(10);
            make.top.mas_equalTo(_tvName.mas_bottom).offset(10);
            make.right.mas_equalTo(_LandView).offset(-10);
        }];
        
        [_tvDescrition mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_programmNameLabel);
            make.top.mas_equalTo(_programmNameLabel.mas_bottom).offset(10);
        }];
        
        [_lookHistoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_LandView).offset(10);
            make.top.mas_equalTo(_tvDescrition.mas_bottom).offset(15);
            make.right.mas_equalTo(_LandView).offset(-10);
        }];
        
        [_nowState mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_programmNameLabel);
            make.bottom.mas_equalTo(_LandView).offset(-10);
        }];
    
    }

    return self;
}

-(void)layoutSubviews{




}

-(void)setcontentWith:(WatchListEntity *)model{
    
    NSURL *urlImage = [NSURL URLWithString:model.posterAddr];
    [self.backimageView sd_setImageWithURL:urlImage placeholderImage:[UIImage imageNamed:@"default_image"]];
    self.stateButton.hidden = [model.islive boolValue];
    self.programmNameLabel.text = model.programSeriesName;
    self.lookHistoryLabel.text = model.reason;
    
    //    if (self.isFullScreen) {
            NSURL *logoUrl = [NSURL URLWithString:model.channelLogo];
            [self.tvLogo sd_setImageWithURL:logoUrl];
            self.tvName.text = model.channelName;
            self.tvDescrition.text = model.programSeriesDesc;
    //    }
    
    //    self.nowState.text= model.
    
}
@end
