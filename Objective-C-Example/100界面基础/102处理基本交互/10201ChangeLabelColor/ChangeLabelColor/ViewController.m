//
//  ViewController.m
//  HelloWorld
//
//  Created by niit on 16/1/28.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 按钮的默认事件 Touch Up Inside

// void -> IBAction
//- (IBAction)blueBtnPressed
//{
//    NSLog(@"蓝色按钮被按了,修改文字颜色为蓝色");
//    self.label.textColor = [UIColor blueColor];
//    
//    self.label.text = @"蓝色";
//}
//
//- (IBAction)redBtnPressed
//{
//    NSLog(@"红色按钮被按了,修改文字颜色为红色");
////    self.label.textColor = [UIColor redColor];
//}
//
//- (IBAction)greenBtnPressed
//{
//    NSLog(@"绿色按钮被按了,修改文字颜色为绿色");
////    self.label.textColor = [UIColor greenColor];
//}
//
//- (IBAction)grownBtnPressed
//{
//    NSLog(@"棕色");
//}


- (IBAction)btnPressed:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 1:
            NSLog(@"蓝色");
            self.label.textColor = [UIColor blueColor];
            break;
        case 2:
            NSLog(@"红色");
            self.label.textColor = [UIColor redColor];
            break;
        case 3:
            NSLog(@"绿色");
            self.label.textColor = [UIColor greenColor];
            break;
        case 4:
            NSLog(@"棕色");
            self.label.textColor = [UIColor brownColor];
            break;
        default:
            break;
    }
    
}



@end
