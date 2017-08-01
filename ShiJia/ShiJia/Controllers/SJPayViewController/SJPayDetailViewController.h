//
//  SJPayDetailViewController.h
//  ShiJia
//
//  Created by 蒋海量 on 2017/5/27.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductEntity.h"

@interface SJPayDetailViewController : BaseViewController
@property(nonatomic,strong) ProductEntity*productEntity;
@property (nonatomic, strong) NSMutableArray  *recommArray;

@end
