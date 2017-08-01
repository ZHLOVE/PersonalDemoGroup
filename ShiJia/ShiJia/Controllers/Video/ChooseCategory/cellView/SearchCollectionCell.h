//
//  SearchCollectionCell.h
//  ShiJia
//
//  Created by 峰 on 2017/1/5.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseCategoryModel.h"


@interface SearchCollectionCell : UICollectionViewCell

@property (nonatomic, strong) programSeries *cellmodel;

-(void)setCellmodel:(programSeries *)cellmodel;

@end
