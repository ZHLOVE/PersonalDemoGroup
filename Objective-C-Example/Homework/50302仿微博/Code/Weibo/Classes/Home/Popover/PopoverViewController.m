//
//  PopoverViewController.m
//  Weibo
//
//  Created by qiang on 4/26/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "PopoverViewController.h"

@interface PopoverViewController ()

@end

@implementation PopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)dealloc
{
    NSLog(@"控制器被销毁了");
}

@end
