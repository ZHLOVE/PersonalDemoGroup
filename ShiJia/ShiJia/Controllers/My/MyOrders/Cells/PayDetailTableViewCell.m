//
//  PayDetailTableViewCell.m
//  ShiJia
//
//  Created by 蒋海量 on 16/9/2.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "PayDetailTableViewCell.h"
@interface PayDetailTableViewCell ()

@property(nonatomic,weak) IBOutlet UIImageView *line1;
@property(nonatomic,weak) IBOutlet UIImageView *line2;
@property(nonatomic,weak) IBOutlet UIImageView *line3;
@property(nonatomic,weak) IBOutlet UIImageView *line4;

@property(nonatomic,weak) IBOutlet UIButton *leftBtn;
@property(nonatomic,weak) IBOutlet UIButton *rightBtn;

@property(nonatomic,assign) BOOL TD;

@end

@implementation PayDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.line1.backgroundColor = kTabLineColor;
    self.line2.backgroundColor = kTabLineColor;
    self.line3.backgroundColor = kTabLineColor;
    self.line4.backgroundColor = kTabLineColor;
}
-(void)setEntity:(OrderDetailEntity *)entity{
    _entity = entity;
    [self.rightBtn removeAllTargets];
    
    self.contentNameLab.text = entity.productName;
    self.sequenceCodeLab.text = [NSString stringWithFormat:@"订单号:%@",entity.sequenceId];
    self.priceLab.text = [NSString stringWithFormat:@"¥ %.2f",[entity.payPrice floatValue]];
    self.orderTimeLab.text = [NSString stringWithFormat:@"下单时间:%@",entity.startTime];
    self.leftBtn.hidden = YES;

    if ([entity.businessType isEqualToString:@"VIDEO"]) {//影片单点
        [self.logoImg setImageWithURL:[NSURL URLWithString:entity.imgAddr] placeholderImage:[UIImage imageNamed:@"dpgmdefault"]];
        self.titleLab.text = @"单片购买";
        
        if ([entity.state isEqualToString:@"PEND"]) {
            [self.rightBtn setImage:[UIImage imageNamed:@"zhifu"] forState:UIControlStateNormal];
            [self.rightBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
            self.dateLab.text = @"";
            self.endTimeLab.text = @"";
            self.statusLab.text = @"待支付";
            self.payTypeLab.hidden = YES;
        }
        else if ([entity.state isEqualToString:@"PAID"]||[entity.state isEqualToString:@"REFUND"]){
            if ([entity.isExpire isEqualToString:@"YES"]) {
                [self.rightBtn setImage:[UIImage imageNamed:GoumaiImage] forState:UIControlStateNormal];
                [self.rightBtn addTarget:self action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                [self.rightBtn setImage:[UIImage imageNamed:@"guankan"] forState:UIControlStateNormal];
                [self.rightBtn addTarget:self action:@selector(watchVideo:) forControlEvents:UIControlEventTouchUpInside];
            }
            self.dateLab.text = [NSString stringWithFormat:@"剩余有效期:%@",entity.expireNum];
            self.endTimeLab.text = [NSString stringWithFormat:@"有效期至:%@",entity.endTime];
            if ([entity.state isEqualToString:@"PAID"]) {
                self.statusLab.text = @"已订购";
            }
            else{
                self.statusLab.text = @"已退订";
                
            }
            self.payTypeLab.hidden = NO;

            if ([entity.payType isEqualToString:@"WEIXIN"]) {
                self.payTypeLab.text = @"微信支付";
            }
            else if ([entity.payType isEqualToString:@"ALIPAY"]){
                self.payTypeLab.text = @"支付宝支付";
            }
            else if ([entity.payType isEqualToString:@"ETICKET"]){
                self.payTypeLab.text = @"优惠券支付";
            }
            else{
                self.payTypeLab.text = @"苹果支付";
            }

        }
        else{
            [self.rightBtn setImage:[UIImage imageNamed:GoumaiImage] forState:UIControlStateNormal];
            [self.rightBtn addTarget:self action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];
            self.dateLab.text = @"";
            self.endTimeLab.text = @"";
            self.statusLab.text = @"交易关闭";
            self.payTypeLab.hidden = YES;
        }
    }
    else{
        [self.logoImg setImageWithURL:[NSURL URLWithString:entity.imgAddr] placeholderImage:[UIImage imageNamed:@"hygmdefault"]];
        self.titleLab.text = @"会员购买";
        if ([entity.state isEqualToString:@"PEND"]) {
            [self.rightBtn setImage:[UIImage imageNamed:@"zhifu"] forState:UIControlStateNormal];
            [self.rightBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
            self.dateLab.text = @"";
            self.endTimeLab.text = @"";
            self.statusLab.text = @"待支付";
            self.payTypeLab.hidden = YES;


        }
        else if ([entity.state isEqualToString:@"PAID"]||[entity.state isEqualToString:@"REFUND"]){

            self.TD = NO;
            self.dateLab.text = [NSString stringWithFormat:@"剩余有效期:%@",entity.expireNum];
            self.endTimeLab.text = [NSString stringWithFormat:@"有效期至:%@",entity.endTime];
            if ([entity.state isEqualToString:@"PAID"]) {
                self.statusLab.text = @"已订购";
            }
            else{
                self.statusLab.text = @"已退订";

            }
            self.payTypeLab.hidden = NO;
            
            if ([entity.payType isEqualToString:@"WEIXIN"]) {
                self.payTypeLab.text = @"微信支付";
            }
            else if ([entity.payType isEqualToString:@"ALIPAY"]){
                self.payTypeLab.text = @"支付宝支付";
            }
            else if ([entity.payType isEqualToString:@"ETICKET"]){
                self.payTypeLab.text = @"优惠券支付";
            }
            else{
                self.payTypeLab.text = @"苹果支付";
            }
        }
        else{
            [self.rightBtn setImage:[UIImage imageNamed:GoumaiImage] forState:UIControlStateNormal];
            [self.rightBtn addTarget:self action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];
            self.dateLab.text = @"";
            self.endTimeLab.text = @"";
            self.statusLab.text = @"交易关闭";
            self.payTypeLab.hidden = YES;


        }
        
        if ([entity.businessType isEqualToString:@"GAME"]){
            self.titleLab.text = @"游戏购买";
            self.rightBtn.hidden = YES;
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
-(void)setTD:(BOOL)TD{
    _TD = TD;
    if (_TD) {
        [self.rightBtn setImage:[UIImage imageNamed:@"tuiding"] forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(refundOrderClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [self.rightBtn setImage:[UIImage imageNamed:GoumaiImage] forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
