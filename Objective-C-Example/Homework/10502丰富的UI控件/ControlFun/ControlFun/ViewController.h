//
//  ViewController.h
//  ControlFun
//
//  Created by student on 16/2/18.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *sliderValueLabel;
@property (weak, nonatomic) IBOutlet UISwitch *leftSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *rightSwitch;
@property (weak, nonatomic) IBOutlet UIButton *doSomethingBtn;

- (IBAction)sliderChanged:(id)sender;
- (IBAction)switchChaged:(id)sender;
- (IBAction)doSomethingBtnPressed:(id)sender;
- (IBAction)segementChanged:(id)sender;


@end

