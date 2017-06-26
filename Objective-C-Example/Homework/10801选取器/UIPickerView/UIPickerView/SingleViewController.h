//
//  SingleViewController.h
//  UIPickerView
//
//  Created by student on 16/2/23.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


- (IBAction)btnPressed:(UIButton *)sender;

@end
