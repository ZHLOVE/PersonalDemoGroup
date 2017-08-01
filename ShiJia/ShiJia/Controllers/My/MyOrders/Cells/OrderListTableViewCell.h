//
//  OrderListTableViewCell.h
//  ShiJia
//
//  Created by 蒋海量 on 16/9/2.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderEntity.h"

@protocol OrderListTableViewCellDelegate <NSObject>
- (void)watchVideo:(OrderEntity *)entity;
- (void)payProduct:(OrderEntity *)entity;
- (void)orderProduct:(OrderEntity *)entity;
- (void)refundOrderProduct:(OrderEntity *)entity;
- (void)queryCPProduct:(OrderEntity *)entity;

@end
@interface OrderListTableViewCell : UITableViewCell
@property (nonatomic,strong) id <OrderListTableViewCellDelegate> m_delegate;

@property(nonatomic,strong) OrderEntity *entity;

@property(nonatomic,weak) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeftLayout;

@property(nonatomic,weak) IBOutlet UILabel *titleLab;
@property(nonatomic,weak) IBOutlet UILabel *statusLab;
@property(nonatomic,weak) IBOutlet UILabel *contentNameLab;
@property(nonatomic,weak) IBOutlet UILabel *priceLab;
@property(nonatomic,weak) IBOutlet UILabel *dateLab;
@property(nonatomic,weak) IBOutlet UILabel *payTypeLab;
@property(nonatomic,weak) IBOutlet UILabel *endTimeLab;

@property(nonatomic,weak) IBOutlet UIImageView *logoImg;
@property(nonatomic,weak) IBOutlet UIButton *leftBtn;
@property(nonatomic,weak) IBOutlet UIButton *rightBtn;

@end
