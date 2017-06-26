//
//  DependenceViewController.h
//  UIPickerView
//
//  Created by student on 16/2/24.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DependenceViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


- (IBAction)btnPressed:(UIButton *)sender;

@end
