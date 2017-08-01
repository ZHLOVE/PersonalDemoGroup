//
//  homeTableViewCell.m
//  ShiJia
//
//  Created by 峰 on 2017/2/16.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "homeTableViewCell.h"
#import "homeAdView.h"
#import "homeItemView.h"
#import "homeCollectionView.h"
#import "homeNavView.h"
#import "VideoCategory.h"
#import "VideoCategoryDetailViewController.h"
#import "HomeJumpWebViewController.h"
#import "SJMultiVideoDetailViewController.h"
#import "WatchListEntity.h"
#import "HomeBannerView.h"

#define kGrarViewHeght 10



@implementation homeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}


-(void)setCellModel:(homeModel *)cellModel{
    _cellModel = cellModel;
    [self configureDifferentCategoryViewWithModel:_cellModel];
}

-(void)configureDifferentCategoryViewWithModel:(homeModel *)model{
    NSInteger a = 0,b = 0;

    if ([model.separate isEqualToString:@"both"]) {
        a=1;
        b=1;
    }
    if ([model.separate isEqualToString:@"bottom"]) {
        b=1;
    }
    if ([model.separate isEqualToString:@"top"]) {
        a=1;
    }

    if ([model.type isEqualToString:@"banner"]) {
        HomeBannerView *banner = [HomeBannerView new];
        [banner setBannerModel:model];
        banner.delegate = self;
        [self.contentView addSubview:banner];
        [banner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(a*kGrarViewHeght, 0, b*kGrarViewHeght, 0));
        }];
    }
    if ([model.type isEqualToString:@"third"]) {
        homeItemView *item = [[homeItemView alloc]init];
        [item setItemModel:model];
        item.delegate = self;
        [self.contentView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(a*kGrarViewHeght, 0, b*kGrarViewHeght, 0));
        }];
    }
    if ([model.type isEqualToString:@"category"]) {
        homeNavView *nav = [[homeNavView alloc]init];
        [self.contentView addSubview:nav];
        [nav setNavModel:model];
        nav.delegate = self;
        [nav mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(a*kGrarViewHeght, 0, b*kGrarViewHeght, 0));
        }];
    }
    if ([model.type isEqualToString:@"ad"]) {
        homeAdView *ad = [homeAdView new];
        [ad setAdModel:model];
        ad.delegate = self;
        [self.contentView addSubview:ad];
        [ad mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(a*kGrarViewHeght, 0, b*kGrarViewHeght, 0));
        }];
    }
    if ([model.type isEqualToString:@"list"]||[model.type isEqualToString:@"smart"]) {
        homeCollectionView *collection = [homeCollectionView new];
        [collection setListModel:model];
        collection.delegate = self;
        [self.contentView addSubview:collection];
        [collection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(a*kGrarViewHeght, 0, b*kGrarViewHeght, 0));
        }];
    }

}

+(CGFloat )figureUpCellHighWithData:(homeModel *)model{
    //top，bottom，both，none
    NSInteger a=1;
    if ([model.separate isEqualToString:@"none"]) {
        a=0;
    }
    if ([model.separate isEqualToString:@"both"]) {
        a=2;
    }
    if ([model.type isEqualToString:@"banner"]) {

        if (model.contents.count>0) {
            return AutoSize_H_IP6(195.)+kGrarViewHeght*a;
        }else{
            return 0;
        }
    }
    if ([model.type isEqualToString:@"third"]) {

        if (model.contents.count>0) {
            return ceil(model.contents.count/5.0)*SJRealValue_W(95.0)+kGrarViewHeght*a;
        }else{
            return 0;
        }
    }
    if ([model.type isEqualToString:@"category"]) {

        if (model.contents.count>0) {
            return AutoSize_H_IP6(195.)+112+kGrarViewHeght*a;
        }else{
            return 0;
        }
    }
    if ([model.type isEqualToString:@"ad"]) {

        if (model.contents.count>0) {
            return AutoSize_H_IP6(100.)+kGrarViewHeght*a;
        }else{
            return 0;
        }
    }
    if ([model.type isEqualToString:@"list"]||[model.type isEqualToString:@"smart"]) {

        if (model.contents.count>0) {
            if ([model.showFresh isEqualToString:@"0"]) {
                return (AutoSize_H_IP6(95.)+62)*[model.layout integerValue]/2+kGrarViewHeght*a;
            }else{
                return 51.+(AutoSize_H_IP6(95.)+62)*[model.layout integerValue]/2+kGrarViewHeght*a;
            }
        }else{
            return 0;
        }
    }
    return 0;
}


-(void)clickHomeBricksCallBackWith:(homeModel *)model andContents:(contents *)contents andType:(NSInteger)type{

    if ([self.delegate respondsToSelector:@selector(HomeBricksCallBackWith:andContents:andType:)]) {
        [self.delegate HomeBricksCallBackWith:model andContents:contents andType:type];
    }
}

@end
