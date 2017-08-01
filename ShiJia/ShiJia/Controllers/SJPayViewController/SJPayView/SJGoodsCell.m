//
//  SJGoodsCell.m
//  ShiJia
//
//  Created by 峰 on 16/9/2.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJGoodsCell.h"
@interface SJGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodExpiryDate;
@property (weak, nonatomic) IBOutlet UILabel *goodExpiryDate2;

@end


@implementation SJGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code


}
-(void)setProductEntity:(ProductEntity *)productEntity{
    _productEntity = productEntity;
    if ([productEntity.businessType isEqualToString:@"VIDEO"]) {//影片单点
        [self.goodsImage setImageWithURL:[NSURL URLWithString:productEntity.imgAddr] placeholderImage:[UIImage imageNamed:@"dpgmdefault"]];
    }
    else{
        [self.goodsImage setImageWithURL:[NSURL URLWithString:productEntity.imgAddr] placeholderImage:[UIImage imageNamed:@"hygmdefault"]];
    }
    self.goodsName.text = productEntity.name;
    self.goodsPrice.text = [NSString stringWithFormat:@"¥ %@",productEntity.payPrice];
    self.goodExpiryDate.text = [NSString stringWithFormat:@"购买有效期:%@",productEntity.expireDateDesc];
    if (![productEntity.ppCycleNu isEqualToString:@"0"]/*[productEntity.name isEqualToString:@"省心连续包"]*/) {
   self.goodExpiryDate2.text = [NSString stringWithFormat:@"有效期至:%@",productEntity.endTime];
    }

}
-(IBAction)checkClick:(id)sender{
    if (_goodsCellCheckBlock) {
        self.goodsCellCheckBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
