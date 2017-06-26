//
//  ViewController.h
//  10506
//
//  Created by 马千里 on 16/2/20.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UITextField *numATextField;

@property (weak, nonatomic) IBOutlet UITextField *numBTextField;




- (IBAction)btnCalculate:(UIButton *)sender;
- (IBAction)backTap:(id)sender;

@end

