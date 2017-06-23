//
//  DependenceViewController.h
//  UIPickerViewDemo
//
//  Created by niit on 16/2/24.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DependenceViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
- (IBAction)btnPressed:(id)sender;

@end
