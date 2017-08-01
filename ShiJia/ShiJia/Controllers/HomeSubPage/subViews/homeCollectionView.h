//
//  homeCollectionView.h
//  ShiJia
//
//  Created by 峰 on 2017/2/16.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//
/**
 *  2 *n 显示View
 */
#import <UIKit/UIKit.h>
#import "homeModel.h"
#import "HomeCallBackDelegate.h"

@interface homeCollectionView : UIView

@property (nonatomic, strong) homeModel *listModel;
@property (nonatomic, weak) id<CallBackDelegate>delegate;
@end
