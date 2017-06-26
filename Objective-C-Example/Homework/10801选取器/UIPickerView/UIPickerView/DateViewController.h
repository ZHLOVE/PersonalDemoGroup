//
//  DateViewController.h
//  UIPickerView
//
//  Created by student on 16/2/23.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
- (IBAction)btnPressed:(UIButton *)sender;
- (IBAction)dateChange:(id)sender;

@end
