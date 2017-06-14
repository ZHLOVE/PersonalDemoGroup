//
//  ViewController.m
//  scoreViewDemo
//
//  Created by wukeng-mac on 16/6/29.
//  Copyright © 2016年 wukeng-mac. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet DrawView *drawView;
@property (weak, nonatomic) IBOutlet DrawView *drawLine;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    CGFloat randomPrecent = (arc4random_uniform(100) + 1)/ 100.0;
    NSLog(@"%f",randomPrecent);
    self.drawView.precent = (arc4random_uniform(100) + 1)/ 100.0;
    self.drawLine.precent = randomPrecent;
}

@end
