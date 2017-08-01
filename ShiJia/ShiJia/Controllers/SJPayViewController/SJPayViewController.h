//
//  SJPayViewController.h
//  ShiJia
//
//  Created by 峰 on 16/8/29.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductEntity.h"

@interface SJPayViewController : UIViewController
//+ (UINavigationController *)navigationControllerContainSelf;
@property(nonatomic,strong) NSMutableArray *productList;

@property (nonatomic, strong) NSMutableArray  *recommArray;
@end
