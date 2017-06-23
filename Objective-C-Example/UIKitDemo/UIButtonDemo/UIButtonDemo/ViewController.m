//
//  ViewController.m
//  UIButtonDemo
//
//  Created by niit on 16/2/26.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 按钮内容偏移
//    self.btn.contentEdgeInsets
    self.btn.titleEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0);
    self.btn.imageEdgeInsets = UIEdgeInsetsMake(0, 150, 0, 0);
//    self.btn.imageEdgeInsets
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
