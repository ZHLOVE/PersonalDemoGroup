//
//  GoodsView.m
//  GoodsList
//
//  Created by niit on 16/2/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "GoodsView.h"

#import "GoodsModel.h"

@interface GoodsView()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *alreadyCountLabel;

@end

@implementation GoodsView

+ (GoodsView *)loadGoodsView
{
    return [[NSBundle mainBundle] loadNibNamed:@"GoodsView" owner:nil options:nil][0];
}

- (void)setGoodsModel:(GoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    self.imageView.image = [UIImage imageNamed:goodsModel.picture];
    self.totalCountLabel.text = [NSString stringWithFormat:@"总需人数:%@",goodsModel.totalCount];
    self.alreadyCountLabel.text = [NSString stringWithFormat:@"参与:%@",goodsModel.alreadyCount];
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//}
@end
