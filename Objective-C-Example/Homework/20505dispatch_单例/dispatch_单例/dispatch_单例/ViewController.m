//
//  ViewController.m
//  dispatch_单例
//
//  Created by student on 16/3/23.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

#import "Person.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Person *p1 = [[Person alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
