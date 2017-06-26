//
//  AreaViewController.m
//  10703TabBar
//
//  Created by student on 16/2/22.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "AreaViewController.h"

@interface AreaViewController ()

@end

@implementation AreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rectangleAreaTextField.userInteractionEnabled = NO;
    self.circularTextField.userInteractionEnabled = NO;
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
    self.rectangleAreaTextField.text = [NSString stringWithFormat:@"%.2f",lengthValue * widthValue];
    self.circularTextField.text = [NSString stringWithFormat:@"%.2f",3.1415*radiusValue*radiusValue];
    //    NSLog(@"%f",lengthValue * widthValue);
}

@end
