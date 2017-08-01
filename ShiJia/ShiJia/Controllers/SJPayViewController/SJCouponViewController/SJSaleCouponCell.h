//
//  SJSaleCouponCell.h
//  ShiJia
//
//  Created by 峰 on 16/9/2.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJPurchaseModel.h"



@interface SJSaleCouponCell : UITableViewCell
/**
 * 设置 未使用Cell
 */
-(void)setUnUseCellWithModel:(SJTicketsModel *)Model;
/**
 * 设置 已使用Cell
 */
-(void)setUsedCellWithModel:(SJTicketsModel *)Model;
/**
 * 设置 无效Cell
 */
-(void)setInvailCellWithModel:(SJTicketsModel *)Model;
@end
