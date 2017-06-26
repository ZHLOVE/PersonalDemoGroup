//
//  VolumeViewController.m
//  10703TabBar
//
//  Created by student on 16/2/22.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "VolumeViewController.h"

@interface VolumeViewController ()

@end

@implementation VolumeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.BoxVolumeTextField.userInteractionEnabled = NO;
    self.sphereVolumeTextField.userInteractionEnabled = NO;
    self.resultBtn.backgroundColor = [UIColor grayColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)resultBtnPressed:(UIButton *)sender {
    float lengthValue = [self.lengthTextField.text floatValue];
    float widthValue = [self.widthTextField.text floatValue];
    float radiusValue = [self.radiusTextField.text floatValue];
    float heightValue = [self.heightTextField.text floatValue];
    self.BoxVolumeTextField.text = [NSString stringWithFormat:@"%.2f",lengthValue * widthValue*heightValue];
    self.sphereVolumeTextField.text = [NSString stringWithFormat:@"%.2f",3.1415*radiusValue*radiusValue*radiusValue*4/3];
    //    NSLog(@"%f",lengthValue * widthValue);
}




@end
