//
//  PayDetailTableViewCell.h
//  ShiJia
//
//  Created by 蒋海量 on 16/9/2.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailEntity.h"
@protocol PayDetailTableViewCellDelegate <NSObject>
- (void)watchVideo:(OrderDetailEntity *)entity;
- (void)payProduct:(OrderDetailEntity *)entity;
- (void)orderProduct:(OrderDetailEntity *)entity;
- (void)refundOrderProduct:(OrderDetailEntity *)entity;

@end
@interface PayDetailTableViewCell : UITableViewCell
@property (nonatomic,strong) id <PayDetailTableViewCellDelegate> m_delegate;

@property(nonatomic,weak) IBOutlet UILabel *titleLab;
@property(nonatomic,weak) IBOutlet UILabel *statusLab;
@property(nonatomic,weak) IBOutlet UILabel *contentNameLab;
@property(nonatomic,weak) IBOutlet UILabel *priceLab;
@property(nonatomic,weak) IBOutlet UILabel *dateLab;
@property(nonatomic,weak) IBOutlet UILabel *payTypeLab;
@property(nonatomic,weak) IBOutlet UILabel *sequenceCodeLab;
@property(nonatomic,weak) IBOutlet UILabel *orderTimeLab;
@property(nonatomic,weak) IBOutlet UIImageView *logoImg;
@property(nonatomic,weak) IBOutlet UILabel *endTimeLab;

@property(nonatomic,strong) OrderDetailEntity *entity;

@end
