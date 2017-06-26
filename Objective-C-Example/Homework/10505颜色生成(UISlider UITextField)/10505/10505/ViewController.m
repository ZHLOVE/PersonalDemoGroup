//
//  ViewController.m
//  10505
//
//  Created by student on 16/2/19.
//  Copyright © 2016年 niit. All rights reserved.
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

- (void)changeColor{
    CGFloat red = [self.redValueLabel.text intValue]/255.0;
    CGFloat green = [self.greenValueLabel.text intValue]/255.0;
    CGFloat blue = [self.blueValueLabel.text intValue]/255.0;
    [self.viewColor setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:0.8]];
}

- (IBAction)redSlider:(UISlider *)sender {
//    CGFloat red = (arc4random()%255)/255.0;
//    [aView setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:0.6]];
    //滑动条的值 value
    int value = sender.value;
    //把滑动条的值显示到label上
    self.redValueLabel.text = [NSString stringWithFormat:@"%i",value];
    [self changeColor];
    
}

- (IBAction)greenSlider:(UISlider *)sender {
    int value = sender.value;
    self.greenValueLabel.text = [NSString stringWithFormat:@"%i",value];
     [self changeColor];
}

- (IBAction)blueSlider:(UISlider *)sender {
    int value = sender.value;
    self.blueValueLabel.text = [NSString stringWithFormat:@"%i",value];
     [self changeColor];
}
@end
