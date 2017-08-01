//
//  SJSaleCouponCell.m
//  ShiJia
//
//  Created by 峰 on 16/9/2.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "SJSaleCouponCell.h"

@interface SJSaleCouponCell ()
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *sourceFrom;
@property (strong, nonatomic) IBOutlet UIImageView *tattooImage;
@property (strong, nonatomic) IBOutlet UILabel *expiryDay;


@end

@implementation SJSaleCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
//未使用
-(void)setUnUseCellWithModel:(SJTicketsModel *)Model {
    self.backImage.image =[UIImage imageNamed:@"sale_1"];
    self.price.text = [NSString stringWithFormat:@"%d",(int)[Model.price integerValue]/100];
    self.name.text = Model.ticketName;
    self.expiryDay.text = Model.expireDate;
    
    if ([Model.source isEqualToString:@"SYSTEM"]) {
        self.sourceFrom.text = @"系统奖励";
    }
    self.tattooImage.image = nil;
}
//使用
-(void)setUsedCellWithModel:(SJTicketsModel *)Model {
    self.backImage.image =[UIImage imageNamed:@"sale_2"];
    self.price.text = [NSString stringWithFormat:@"%d",(int)[Model.price integerValue]/100];
    self.name.text = Model.ticketName;
    self.expiryDay.text = Model.expireDate;
    if ([Model.source isEqualToString:@"SYSTEM"]) {
        self.sourceFrom.text = @"系统奖励";
    }
    self.tattooImage.image = [UIImage imageNamed:@"shuiying_2"];
    
}
//过期了
-(void)setInvailCellWithModel:(SJTicketsModel *)Model {
    self.backImage.image =[UIImage imageNamed:@"sale_2"];
    self.price.text = [NSString stringWithFormat:@"%d",(int)[Model.price integerValue]/100];
    self.name.text = Model.ticketName;
    self.expiryDay.text = Model.expireDate;
    if ([Model.source isEqualToString:@"SYSTEM"]) {
        self.sourceFrom.text = @"系统奖励";
    }
    self.tattooImage.image = [UIImage imageNamed:@"shuiying_1"];
}

@end
