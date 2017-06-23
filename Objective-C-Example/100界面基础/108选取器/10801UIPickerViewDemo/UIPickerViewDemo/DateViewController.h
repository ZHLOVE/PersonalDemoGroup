//
//  DateViewController.h
//  UIPickerViewDemo
//
//  Created by niit on 16/2/23.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

- (IBAction)btnPressed:(id)sender;

- (IBAction)dateChanged:(id)sender;

@end
