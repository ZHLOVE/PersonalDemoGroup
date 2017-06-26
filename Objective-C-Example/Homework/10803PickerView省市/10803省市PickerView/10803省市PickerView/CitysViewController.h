//
//  CitysViewController.h
//  10803省市PickerView
//
//  Created by student on 16/2/24.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChinaArea.h"

@interface CitysViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIPickerView *citysPickView;

@property (weak, nonatomic) IBOutlet UILabel *cityInfoLabel;


@end
