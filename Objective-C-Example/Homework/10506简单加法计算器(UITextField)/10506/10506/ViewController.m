//
//  ViewController.m
//  10506
//
//  Created by 马千里 on 16/2/20.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//加法计算
- (IBAction)btnCalculate:(UIButton *)sender {
    int valueA = [self.numATextField.text intValue];
    int valueB = [self.numBTextField.text intValue];
    NSString *result = [NSString stringWithFormat:@"%d",(valueA + valueB)];
    self.resultLabel.text = [result copy];
}

- (IBAction)backTap:(id)sender {
    [self.view endEditing:YES];
}
@end
