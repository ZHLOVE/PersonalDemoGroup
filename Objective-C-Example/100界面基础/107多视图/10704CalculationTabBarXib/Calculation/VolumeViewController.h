//
//  VolumeViewController.h
//  Calculation
//
//  Created by niit on 16/2/22.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SummaryViewController.h"

@interface VolumeViewController : UIViewController

@property (nonatomic,weak) SummaryViewController *summaryVC;

- (IBAction)calBtnPressed:(id)sender;

@end
