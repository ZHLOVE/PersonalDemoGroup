//
//  SplashViewController.h
//  ShiJia
//
//  Created by 蒋海量 on 2017/2/19.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import "BaseViewController.h"

@interface SplashViewController : BaseViewController
@property (nonatomic, assign) BOOL isSecondTime;
@property (nonatomic,weak)  IBOutlet UIImageView*defaultImg;
@end
