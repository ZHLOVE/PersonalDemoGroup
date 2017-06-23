//
//  SingleViewController.h
//  UIPickerViewDemo
//
//  Created by niit on 16/2/23.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

- (IBAction)btnPressed:(id)sender;

@end
