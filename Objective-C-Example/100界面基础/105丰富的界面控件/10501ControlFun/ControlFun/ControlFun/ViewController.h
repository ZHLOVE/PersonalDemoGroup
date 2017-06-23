//
//  ViewController.h
//  ControlFun
//
//  Created by niit on 16/2/18.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic,weak) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *sliderValueLabel;

@property (weak, nonatomic) IBOutlet UISwitch *leftSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *rightSwitch;

@property (weak, nonatomic) IBOutlet UIButton *doSomethingBtn;

- (IBAction)segementChanged:(id)sender;
- (IBAction)switchChanged:(id)sender;
- (IBAction)doSomethingBtnPressed:(id)sender;
- (IBAction)sliderChanged:(id)sender;

@end

