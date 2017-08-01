//
//  RecommendCollectionViewCell2.m
//  ShiJia
//
//  Created by 峰 on 2017/5/8.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "RecommendCollectionViewCell2.h"
#import <YYKit/YYLabel.h>
#import "UIImageView+WebCache.h"


#define bottomSpace 55.
#define reasonLabelHeight 35.
#define Space1 12.
#define Space2 7.
#define Space3 10
#define Space4 7.
#define Space5 6.
#define backImageHeight 40.


#define titleSize 12.


@interface RecommendCollectionViewCell2 (){
    
   CAGradientLayer *headerLayer;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet YYLabel     *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel     *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *describeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gradinetView;

@end

@implementation RecommendCollectionViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self addSubviewsConstraints];
    self.describeLabel.textColor = UIColorHex(989898);
    self.describeLabel.font = [UIFont systemFontOfSize:titleSize];
    
    self.reasonLabel.textColor = [UIColor whiteColor];
    self.reasonLabel.font = [UIFont systemFontOfSize:titleSize];
    
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont systemFontOfSize:titleSize];
}

-(void)addSubviewsConstraints{
    [self.cellImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, AutoSize_H_IP6(bottomSpace), 0));
    }];
    
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_cellImage).offset(Space5);
        make.right.mas_equalTo(_cellImage).offset(-Space5);
        make.bottom.mas_equalTo(_cellImage).offset(-Space4);
        //make.height.mas_equalTo(AutoSize_H_IP6(bottomSpace));
    }];
    
    [self.gradinetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(_cellImage);
        make.height.mas_equalTo(AutoSize_H_IP6(backImageHeight+Space4));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_reasonLabel);
        make.top.mas_equalTo(_cellImage.mas_bottom).offset(Space1);
        make.bottom.mas_equalTo(_describeLabel.mas_top).offset(-Space2);
    }];
    
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_reasonLabel);
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(Space2);
        make.bottom.mas_equalTo(self).offset(-Space3);
    }];
    
    
    
}

-(void)setCellModel:(WatchListEntity *)cellModel{
    
//    if (cellModel.verticalPosterAddr.length == 0) {
//        [self.cellImage sd_setImageWithURL:[NSURL URLWithString:cellModel.posterAddr] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
//    }else{
    
    [self.cellImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.cellImage.contentMode =  UIViewContentModeScaleAspectFill;
    self.cellImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.cellImage.clipsToBounds  = YES;
    [self.cellImage sd_setImageWithURL:[NSURL URLWithString:cellModel.posterAddr] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
//    }

    self.reasonLabel.text = cellModel.reason;
    if (cellModel.reason.length == 0) {
        self.reasonLabel.text = cellModel.programSeriesDesc;
        
    }
    
    self.nameLabel.text = cellModel.programSeriesName;
    self.describeLabel.text = cellModel.programSeriesDesc;
    
}

- (void) insertTransparentGradient {
    UIColor *colorOne = RGB(0, 0, 0, 0);;
    UIColor *colorTwo = RGB(0, 0, 0, 1);;
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    //crate gradient layer
    headerLayer = [CAGradientLayer layer];
    
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.frame = self.reasonLabel.bounds;
    
    //[self.layer insertSublayer:headerLayer atIndex:0];
    
    [self.reasonLabel.layer addSublayer:headerLayer];
}

@end
