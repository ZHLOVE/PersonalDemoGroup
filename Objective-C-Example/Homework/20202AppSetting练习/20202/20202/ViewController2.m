//
//  ViewController2.m
//  20202
//
//  Created by student on 16/3/16.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greedSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSUserDefaults *color = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [color objectForKey:@"color"];
    self.redSlider.value = [dict[@"r"] intValue];
    self.greedSlider.value = [dict[@"g"] intValue];
    self.blueSlider.value = [dict[@"b"] intValue];
    self.redValueLabel.text = dict[@"r"];
    self.greenValueLabel.text = dict[@"g"];
    self.blueValueLabel.text = dict[@"b"];
}

- (IBAction)backBtnPressed:(id)sender {
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[self.redValueLabel.text,self.greenValueLabel.text,self.blueValueLabel.text] forKeys:@[@"r",@"g",@"b"]];
    NSUserDefaults *color  = [NSUserDefaults standardUserDefaults];
    [color setObject:dict forKey:@"color"];
    [color synchronize];
    NSUserDefaults *redSlider = [NSUserDefaults standardUserDefaults];
    [redSlider setObject:self.redValueLabel.text forKey:@"redSlider"];
    [redSlider synchronize];
    NSUserDefaults *greedSlider = [NSUserDefaults standardUserDefaults];
    [greedSlider setObject:self.greenValueLabel.text forKey:@"greenSlider"];
    [greedSlider synchronize];
    NSUserDefaults *blueSlider = [NSUserDefaults standardUserDefaults];
    [blueSlider setObject:self.blueValueLabel.text forKey:@"blueSlider"];
    [blueSlider synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)redSlider:(UISlider *)sender {
//    //把滑动条的值显示到label上
    self.redValueLabel.text = [NSString stringWithFormat:@"%3.0f",sender.value];
//    [self changeColor];
    
}

- (IBAction)greenSlider:(UISlider *)sender {
    self.greenValueLabel.text = [NSString stringWithFormat:@"%3.0f",sender.value];
}

- (IBAction)blueSlider:(UISlider *)sender {
    self.blueValueLabel.text = [NSString stringWithFormat:@"%3.0f",sender.value];
}

@end
