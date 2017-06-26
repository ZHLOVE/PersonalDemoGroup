//
//  ViewController.h
//  10505
//
//  Created by student on 16/2/19.
//  Copyright © 2016年 niit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *redValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueValueLabel;
@property (weak, nonatomic) IBOutlet UIView *viewColor;


- (IBAction)redSlider:(UISlider *)sender;
- (IBAction)greenSlider:(UISlider *)sender;
- (IBAction)blueSlider:(UISlider *)sender;





@end

