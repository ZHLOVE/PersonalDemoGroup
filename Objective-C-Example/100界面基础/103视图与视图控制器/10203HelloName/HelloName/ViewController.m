//
//  ViewController.m
//  HelloName
//
//  Created by niit on 16/1/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)btnPressed:(id)sender
{
    self.nameLabel.text = self.inputTextField.text;
    self.inputTextField.text = @"";
}

@end
