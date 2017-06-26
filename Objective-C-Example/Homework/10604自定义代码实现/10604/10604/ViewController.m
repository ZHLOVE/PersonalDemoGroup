//
//  ViewController.m
//  10604
//
//  Created by student on 16/3/2.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define W(x) (x * kScreenWidth / 320.0)
#define H(y) (y * kScreenHeight / 568.0)

#define WR(y) (y * kScreenHeight / 320.0)
#define WR(x) (x * kScreenWidth / 568.0)

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

@end
