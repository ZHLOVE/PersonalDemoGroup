//
//  CookViewController.h
//  10802
//
//  Created by 马千里 on 16/2/23.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CookViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnChoose;

- (IBAction)btnPressed:(UIButton *)sender;

@end
