//
//  SJVIPCell.h
//  ShiJia
//
//  Created by 峰 on 16/9/2.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJPurchaseModel.h"

typedef void(^OpenVIPBlock )(id sender);

@interface SJVIPCell : UITableViewCell


-(void)setCellInfoWithModel:(SJVIPPackageModel *)model;


@property (nonatomic, copy)  OpenVIPBlock vipBlock;

@end
