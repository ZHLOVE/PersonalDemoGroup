//
//  SJVIPCell.m
//  ShiJia
//
//  Created by 峰 on 16/9/2.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJVIPCell.h"

@interface SJVIPCell ()
@property (weak, nonatomic) IBOutlet UIButton *ktButton;
@property (weak, nonatomic) IBOutlet UILabel *vipName;
@property (weak, nonatomic) IBOutlet UILabel *vipPrice;

@end


@implementation SJVIPCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
#ifdef BeiJing
    self.ktButton.backgroundColor = kColorBlueTheme;
#else
#endif
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buyVIPAction:(id)sender {
    if (self.vipBlock) {
        _vipBlock(sender);
    }
}

-(void)setCellInfoWithModel:(SJVIPPackageModel *)model {
//    self.vipName.text = model.expireDateDesc;
    self.vipName.text =[NSString stringWithFormat:@"%@",model.productName];
//    self.vipPrice.text = model.price;
    double price = model.price.doubleValue/100;
    NSString *payPrice = [NSString stringWithFormat:@"%.2f",price];
    self.vipPrice.text = [NSString stringWithFormat:@"¥%@",payPrice];

}


@end
