//
//  ViewControllerB.m
//  PresentViewController
//
//  Created by niit on 16/2/24.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewControllerB.h"

#import "AppDelegate.h"

@interface ViewControllerB ()

@end

@implementation ViewControllerB

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%s",__func__);
}

// ViewController关于模态窗口的2个相关属性
// presentedViewController
// presentingViewController

// A -> B
// B是A的 presentedViewController
// A是B的 presentingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.resultLabel.text = [NSString stringWithFormat:@"%i",self.num];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSLog(@"%s",__func__);
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    NSLog(@"%@",appDelegate.window.rootViewController);
//    appDelegate.window.rootViewController 就是 ViewControllerA 对象
    
//    NSLog(@"A presentingViewController%@",appDelegate.window.rootViewController.presentingViewController);
//    NSLog(@"A presentedViewController:%@",appDelegate.window.rootViewController.presentedViewController);
//    
//    NSLog(@"B presentingViewController:%@",self.presentingViewController);
//    NSLog(@"B presentedViewController:%@",self.presentedViewController);
    

}

- (IBAction)cancelBtnPressed:(id)sender
{
    // 取消当前模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
