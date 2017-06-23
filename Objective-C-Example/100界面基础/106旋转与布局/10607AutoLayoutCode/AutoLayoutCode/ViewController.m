//
//  ViewController.m
//  AutoLayoutCode
//
//  Created by niit on 16/3/2.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self test1];
    [self test2];
    
}


- (void)test2
{
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    redView.translatesAutoresizingMaskIntoConstraints = NO;// 不使用autoresing
    [self.view addSubview:redView];
    
    
    // 添加约束对象
    // blueView的宽度 = 父视图的一半
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:redView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:0.5
                                                                        constant:0];
    [self.view addConstraint:widthConstraint];
    
    // 高度
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:redView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:0.5
                                                                         constant:0];
    [self.view addConstraint:heightConstraint];
    
    // 距离顶部约束
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:redView
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1.0
                                                                      constant:0];
    [self.view addConstraint:centerXConstraint];
    // 距离左边约束
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:redView
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeCenterY
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:centerYConstraint];
    
    
}

- (void)test1
{
    UIView *blueView = [[UIView alloc] init];
    blueView.backgroundColor = [UIColor blueColor];
    blueView.translatesAutoresizingMaskIntoConstraints = NO;// 不使用autoresing
    [self.view addSubview:blueView];
    
    
    // 添加约束对象
    // blueView的宽度 = 100
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:blueView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:0.0
                                                              constant:100];
    [blueView addConstraint:widthConstraint];
    
    // 高度
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:blueView
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:0.0
                                                                        constant:80];
    [blueView addConstraint:heightConstraint];
    
    // 距离顶部约束
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:blueView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0
                                                                       constant:20];
    [self.view addConstraint:topConstraint];
    // 距离左边约束
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:blueView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:20];
    [self.view addConstraint:leftConstraint];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
