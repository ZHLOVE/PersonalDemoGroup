//
//  OrderListTableViewCell.m
//  ShiJia
//
//  Created by 蒋海量 on 16/9/2.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "OrderListTableViewCell.h"
@interface OrderListTableViewCell ()
@property(nonatomic,weak) IBOutlet UIImageView *line;
@property(nonatomic,weak) IBOutlet UIImageView *line2;

@end
@implementation OrderListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.line.backgroundColor = kTabLineColor;
    self.line2.backgroundColor = kTabLineColor;

    //[self addConstraint:self.imageLeftLayout];
}
-(void)setEntity:(OrderEntity *)entity{
    _entity = entity;
    [self.leftBtn removeAllTargets];
    [self.rightBtn removeAllTargets];
    if ([entity.isCmsProduct isEqualToString:@"NO"]) {
        [self.rightBtn addTarget:self action:@selector(queryCPClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([entity.businessType isEqualToString:@"VIDEO"]) {//影片单点
        if ([entity.state isEqualToString:@"PEND"]) {
            [self.leftBtn addTarget:self action:@selector(watchVideo:) forControlEvents:UIControlEventTouchUpInside];
            [self.rightBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];

        }
        else if ([entity.state isEqualToString:@"PAID"]||[entity.state isEqualToString:@"REFUND"]){
            if ([entity.isExpire isEqualToString:@"YES"]) {
                [self.rightBtn addTarget:self action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                [self.rightBtn addTarget:self action:@selector(watchVideo:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else{
            [self.rightBtn addTarget:self action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else if([entity.businessType isEqualToString:@"GAME"]){
        
    }
    else{
        if ([entity.state isEqualToString:@"PEND"]) {
            [self.rightBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];

        }
        else if ([entity.state isEqualToString:@"PAID"]||[entity.state isEqualToString:@"REFUND"]){
            [self.rightBtn addTarget:self action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];

        }
        else{
            [self.rightBtn addTarget:self action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];

        }
    }
}
-(void)watchVideo:(id)sender{
    [self.m_delegate watchVideo:self.entity];
}
-(void)payClick:(id)sender{
    [self.m_delegate payProduct:self.entity];
}
-(void)orderClick:(id)sender{
    [self.m_delegate orderProduct:self.entity];
}
-(void)refundOrderClick:(id)sender{
    [self.m_delegate refundOrderProduct:self.entity];
}
-(void)queryCPClick:(id)sender{
    [self.m_delegate queryCPProduct:self.entity];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
