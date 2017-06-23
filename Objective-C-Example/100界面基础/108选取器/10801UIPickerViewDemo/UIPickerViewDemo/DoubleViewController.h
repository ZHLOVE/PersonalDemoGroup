//
//  DoubleViewController.h
//  UIPickerViewDemo
//
//  Created by niit on 16/2/23.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoubleViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
- (IBAction)btnPressed:(id)sender;

@end
