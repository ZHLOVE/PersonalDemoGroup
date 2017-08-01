//
//  homeAdView.m
//  ShiJia
//
//  Created by 峰 on 2017/2/16.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "homeAdView.h"
@interface homeAdView ()

@property (nonatomic, strong) UIImageView *adImage;
@property (nonatomic, strong) NSMutableArray <contents *>*dataArray;
@property (nonatomic, strong) contents *contentsmodel;

@end

@implementation homeAdView

- (instancetype)init
{
    self = [super init];
    if (self) {

        [self addSubview:self.adImage];
        self.backgroundColor = [UIColor whiteColor];
        [self AdSubViewsConstraints];
    }
    return self;
}


-(NSMutableArray<contents *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}


-(void)setAdModel:(homeModel *)adModel{
    _adModel = adModel;
    if (_dataArray) {
        [_dataArray removeAllObjects];
    }
    self.dataArray = [adModel.contents mutableCopy];
    if (self.dataArray.count>0) {
       self.contentsmodel = self.dataArray[0];
        [_adImage setImageWithURL:[NSURL URLWithString:_contentsmodel.resourceUrl] placeholder:nil];
    }
}

-(UIImageView *)adImage{
    if (!_adImage) {

        _adImage = [UIImageView new];
        _adImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(clickADAction)];
        [_adImage addGestureRecognizer:tap];

    }
    return _adImage;
}
-(void)AdSubViewsConstraints{


    [_adImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
}
-(void)clickADAction{
//    if ([self.delegate respondsToSelector:@selector(clickHomeBricksCallBackWith: andIndexPath:andType:)]) {
//        [self.delegate clickHomeBricksCallBackWith:_adModel andIndexPath:0 andType:0];
//    }

    if ([self.delegate respondsToSelector:@selector(clickHomeBricksCallBackWith:andContents:andType:)]) {
        [self.delegate clickHomeBricksCallBackWith:_adModel
                                       andContents:_adModel.contents[0]
                                           andType:0];
        
        contents *currentContent = _adModel.contents[0];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:currentContent.title forKey:@"addpo_name"];
        
        [UMengManager event:@"U_ClickAddPo" attributes:dic];
    }

}

@end
