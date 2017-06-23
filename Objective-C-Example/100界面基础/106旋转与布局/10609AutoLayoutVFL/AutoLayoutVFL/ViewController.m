//
//  ViewController.m
//  AutoLayoutVFL
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
    
    [self test3];
}

- (void)test3
{
    UIView *blueView = [[UIView alloc] init];
    blueView.backgroundColor = [UIColor blueColor];
    blueView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:blueView];
    
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    redView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:redView];
    
    // 水平方向的约束
    NSNumber *margin = @20;
    NSString *vfl1 = @"H:|-margin-[blueView]-margin-[redView(==blueView)]-margin-|";
    NSDictionary *viewsDict1 = NSDictionaryOfVariableBindings(blueView,redView);
    NSDictionary *metrics1 = NSDictionaryOfVariableBindings(margin);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:vfl1
                                                                   options:kNilOptions
                                                                   metrics:metrics1
                                                                     views:viewsDict1];
    [self.view addConstraints:constraints];
    
    // 垂直方向的约束
    NSNumber *height = @40;;
    NSString *vfl2 = @"V:|-[blueView(height)]-margin-|";
    NSDictionary *viewsDict2 = NSDictionaryOfVariableBindings(blueView);
    NSDictionary *metrics2 = NSDictionaryOfVariableBindings(margin,height);
    NSArray *constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:vfl2
                                                                    options:kNilOptions
                                                                    metrics:metrics2
                                                                      views:viewsDict2];
    [self.view addConstraints:constraints2];
    
    // 垂直方向
    NSString *vfl3 = @"V:|-[redView(height)]-margin-|";
    NSDictionary *viewsDict3 = NSDictionaryOfVariableBindings(redView);
    NSDictionary *metrics3 = NSDictionaryOfVariableBindings(margin,height);
    NSArray *constraints3 = [NSLayoutConstraint constraintsWithVisualFormat:vfl3
                                                                    options:kNilOptions
                                                                    metrics:metrics3
                                                                      views:viewsDict3];
    [self.view addConstraints:constraints3];
}

- (void)test2
{
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor blueColor];
    view1.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:view1];
    
    // 水平方向的约束
    NSNumber *margin = @50;
    NSString *vfl1 = @"H:|-margin-[view1]-margin-|";
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(view1);
  //@{@"view1":view1};
    NSDictionary *metrics1 = NSDictionaryOfVariableBindings(margin);
  //@{@"margin":margin}
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:vfl1
                                                                   options:kNilOptions
                                                                   metrics:metrics1
                                                                     views:viewsDict];
    [self.view addConstraints:constraints];
    
    // 垂直方向的约束
    
    NSNumber *height = @40;;
    NSString *vfl2 = @"V:|-margin-[view1(height)]|";
    NSDictionary *viewsDict2 = NSDictionaryOfVariableBindings(view1);
    NSDictionary *metrics2 = NSDictionaryOfVariableBindings(margin,height);
    //NSDictionaryOfVariableBindings(margin,height); =>  @{@"margin":margin,@"height":height}
    NSArray *constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:vfl2
                                                                    options:kNilOptions
                                                                    metrics:metrics2
                                                                      views:viewsDict2];
    [self.view addConstraints:constraints2];
}


- (void)test1
{
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor blueColor];
    view1.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:view1];
    
    // 水平方向的约束
    NSString *vfl1 = @"H:|-20-[abc]-20-|";
    NSDictionary *viewsDict = @{@"abc":view1};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:vfl1
                                                                   options:kNilOptions
                                                                   metrics:nil
                                                                     views:viewsDict];
    [self.view addConstraints:constraints];
    
    // 垂直方向的约束
    NSString *vfl2 = @"V:|-20-[abc(40)]|";
    NSDictionary *viewsDict2 = @{@"abc":view1};
    NSArray *constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:vfl2
                                                                   options:kNilOptions
                                                                   metrics:nil
                                                                     views:viewsDict];
    [self.view addConstraints:constraints2];
}


@end
