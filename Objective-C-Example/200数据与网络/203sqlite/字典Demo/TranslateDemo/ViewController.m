//
//  ViewController.m
//  TranslateDemo
//
//  Created by Qiang on 15/4/13.
//  Copyright (c) 2015年 QiangTech. All rights reserved.
//

#import "ViewController.h"

#import "TranslateMachine.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)btnPressed:(id)sender
{
    self.resultTextView.text =  [TranslateMachine translate:self.sourceTextField.text];
}
@end
