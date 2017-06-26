//
//  MainViewController.h
//  10703toolBar
//
//  Created by student on 16/2/22.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaViewController.h"
#import "VolumeViewController.h"

@interface MainViewController : UIViewController
@property(nonatomic,strong) AreaViewController *areaVC;
@property(nonatomic,strong) VolumeViewController *volumeVC;

@end
