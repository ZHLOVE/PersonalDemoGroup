//
//  VolumeViewController.h
//  10703TabBar
//
//  Created by student on 16/2/22.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VolumeViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *lengthTextField;
@property (weak, nonatomic) IBOutlet UITextField *widthTextField;
@property (weak, nonatomic) IBOutlet UITextField *heightTextField;

@property (weak, nonatomic) IBOutlet UITextField *BoxVolumeTextField;//方体体积

@property (weak, nonatomic) IBOutlet UITextField *radiusTextField;//半径

@property (weak, nonatomic) IBOutlet UITextField *sphereVolumeTextField;//球体积

@property (weak, nonatomic) IBOutlet UIButton *resultBtn;

- (IBAction)resultBtnPressed:(UIButton *)sender;


@end
