//
//  SJGoodsCell.h
//  ShiJia
//
//  Created by 峰 on 16/9/2.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductEntity.h"
typedef void(^GoodsCellCheck)();

@interface SJGoodsCell : UITableViewCell
@property(nonatomic,strong) ProductEntity*productEntity;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeftLayout;
@property(nonatomic,weak) IBOutlet UIButton *selectBtn;
@property (nonatomic, copy) GoodsCellCheck goodsCellCheckBlock;



@end
