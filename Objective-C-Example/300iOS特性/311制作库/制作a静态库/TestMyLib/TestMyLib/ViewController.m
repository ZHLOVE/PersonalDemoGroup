//
//  ViewController.m
//  TestMyLib
//
//  Created by niit on 16/4/20.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "MyLib.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    MyLib *lib = [[MyLib alloc] init];
    int result = [lib addA:1 andB:2];
    NSLog(@"result = %i",result);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
