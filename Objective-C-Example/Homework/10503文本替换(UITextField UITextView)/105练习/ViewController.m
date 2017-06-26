//
//  ViewController.m
//  105练习
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnPressed:(UIButton *)sender {
    
    NSString *name = self.nameTextField.text;
    NSString *age = self.ageTextField.text;
    NSString *class = self.classTextField.text;
    NSMutableString *demo = [self.demoTextView.text mutableCopy];
    //查找对应的<name>并替换
    NSRange range = [demo rangeOfString:@"<name>"];
    if(range.location != NSNotFound)
    {
        [demo replaceCharactersInRange:range withString:name];
    }
    
    NSRange range2 = [demo rangeOfString:@"<age>"];
    if(range2.location != NSNotFound)
    {
        [demo replaceCharactersInRange:range2 withString:age];
    }
    
    NSRange range3 = [demo rangeOfString:@"<class>"];
    if(range3.location != NSNotFound)
    {
        [demo replaceCharactersInRange:range3 withString:class];
    }
    self.resultTextView.text = [demo copy];
    
//    NSLog(@"%@",demo);
}



- (IBAction)backTap:(id)sender {
    [self.view endEditing:YES];
}
@end
