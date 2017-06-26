//
//  ViewController.m
//  10509
//
//  Created by 马千里 on 16/2/21.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rectangleAreaTextField.userInteractionEnabled = NO;
    self.circularTextField.userInteractionEnabled = NO;
    
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
    self.rectangleAreaTextField.text = [NSString stringWithFormat:@"%.2f",lengthValue * widthValue];
    self.circularTextField.text = [NSString stringWithFormat:@"%.2f",3.1415*radiusValue*radiusValue];
//    NSLog(@"%f",lengthValue * widthValue);
}
@end
