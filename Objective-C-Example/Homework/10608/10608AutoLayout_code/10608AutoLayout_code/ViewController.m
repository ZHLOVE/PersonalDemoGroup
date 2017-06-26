//
//  ViewController.m
//  10608AutoLayout_code
//
//  Created by student on 16/3/2.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,assign) int leftConst;//距离左侧父视图的距离
@property (nonatomic,strong) UIView *tempView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self blueView];
    [self redView];
//    [self blueView2];
//    [self redView2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)blueView{
    UIView *blueView = [[UIView alloc]init];
    blueView.backgroundColor = [UIColor blueColor];
    blueView.translatesAutoresizingMaskIntoConstraints = NO;//不用autoresing
    [self.view addSubview:blueView];
    
 
    
    // 添加约束对象
    // blueView的宽度 = 父视图的0.2
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:blueView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:0.4
                                                                        constant:0];
    [self.view addConstraint:widthConstraint];
    
    // 高度
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:blueView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:0.1
                                                                         constant:0];
    [self.view addConstraint:heightConstraint];
    
    int leftConst = ([UIScreen mainScreen].bounds.size.width-[UIScreen mainScreen].bounds.size.width*0.4*2)/3;
    self.leftConst = leftConst;
    NSLog(@"%d",self.leftConst);
    // 距离底部约束
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:blueView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0
                                                                          constant:-leftConst];
    [self.view addConstraint:bottomConstraint];
    // 距离左边约束
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:blueView
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0
                                                                          constant:leftConst];
    [self.view addConstraint:leftConstraint];

    
}

- (void)redView{
    UIView *redView = [[UIView alloc]init];
    redView.backgroundColor = [UIColor redColor];
    redView.translatesAutoresizingMaskIntoConstraints = NO;//不用autoresing
    [self.view addSubview:redView];
    
    
    
    // 添加约束对象
    // blueView的宽度 = 父视图的0.2
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:redView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:0.4
                                                                        constant:0];
    [self.view addConstraint:widthConstraint];
    
    // 高度
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:redView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:0.1
                                                                         constant:0];
    [self.view addConstraint:heightConstraint];
    
    
    // 距离底部约束
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:redView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:-self.leftConst];
    [self.view addConstraint:bottomConstraint];
    // 距离右边约束
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:redView
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0
                                                                       constant:-self.leftConst];
    [self.view addConstraint:rightConstraint];
    
    
}

- (void)blueView2{
    UIView *blueView2 = [[UIView alloc]init];
    blueView2.backgroundColor = [UIColor blueColor];
    blueView2.translatesAutoresizingMaskIntoConstraints = NO;//不用autoresing
    [self.view addSubview:blueView2];
    
    
    
    // 添加约束对象
    // blueView的宽度 = 父视图的0.2
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:blueView2
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:0.0
                                                                        constant:150];
    [self.view addConstraint:widthConstraint];
    
    // 高度
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:blueView2
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:0.0
                                                                         constant:50];
    [self.view addConstraint:heightConstraint];
    
    int leftConst = ([UIScreen mainScreen].bounds.size.width-150*2)/3;
    self.leftConst = leftConst;
    // 距离底部约束
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:blueView2
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:-leftConst];
    [self.view addConstraint:bottomConstraint];
    // 距离左边约束
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:blueView2
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:leftConst];
    [self.view addConstraint:leftConstraint];
    
    
}

- (void)redView2{
    UIView *redView2 = [[UIView alloc]init];
    redView2.backgroundColor = [UIColor redColor];
    redView2.translatesAutoresizingMaskIntoConstraints = NO;//不用autoresing
    [self.view addSubview:redView2];
    
    
    
    // 添加约束对象
    // blueView的宽度 = 父视图的0.2
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:redView2
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:0.0
                                                                        constant:150];
    [self.view addConstraint:widthConstraint];
    
    // 高度
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:redView2
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:0.0
                                                                         constant:50];
    [self.view addConstraint:heightConstraint];
    
    
    // 距离底部约束
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:redView2
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:-self.leftConst];
    [self.view addConstraint:bottomConstraint];
    // 距离右边约束
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:redView2
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:-self.leftConst];
    [self.view addConstraint:rightConstraint];
    
    
}







@end
























