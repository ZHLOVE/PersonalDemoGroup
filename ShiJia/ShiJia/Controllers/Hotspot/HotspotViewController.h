//
//  HotspotViewController.h
//  ShiJia
//
//  Created by 蒋海量 on 2017/2/22.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "BaseViewController.h"

@interface HotspotViewController : BaseViewController

@property (nonatomic, strong) UIViewController *parentController;

- (void)refreshData;

@end
