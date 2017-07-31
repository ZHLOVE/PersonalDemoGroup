//
//  ViewController.m
//  playFun
//
//  Created by MccRee on 2017/7/26.
//  Copyright © 2017年 MccRee. All rights reserved.
//

#import "ViewController.h"
#import "FP.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FP *fp = [[FP alloc]init];

    NSLog(@"%@",fp.key);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
