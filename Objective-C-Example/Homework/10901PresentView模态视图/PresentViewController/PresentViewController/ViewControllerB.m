//
//  ViewControllerB.m
//  PresentViewController
//
//  Created by student on 16/2/24.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewControllerB.h"
#import "AppDelegate.h"

@interface ViewControllerB ()

@end

@implementation ViewControllerB

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.presentedViewController 被弹出
//    self.presentingViewController 正弹出
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.resuleLabel.text = [NSString stringWithFormat:@"%i",self.num];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    //    NSLog(@"%@",appDelegate.window.rootViewController);
    //    appDelegate.window.rootViewController 就是 ViewControllerA 对象
    
    //    NSLog(@"A presentingViewController%@",appDelegate.window.rootViewController.presentingViewController);
    //    NSLog(@"A presentedViewController:%@",appDelegate.window.rootViewController.presentedViewController);
    //
    //    NSLog(@"B presentingViewController:%@",self.presentingViewController);
    //    NSLog(@"B presentedViewController:%@",self.presentedViewController);
    
}



- (IBAction)cancelBtnPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
