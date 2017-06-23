//
//  ViewController.m
//  Test
//
//  Created by qiang on 4/25/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "ViewController.h"

#import "MyView.h"
#import "MyView2.h"
#import "MyView3.h"

#import "ChildViewController.h"

@interface ViewController ()

// 指向的对象没有强指针引用，则自动设置为空
@property (nonatomic,weak) UIView *tmpView;

@property (nonatomic,strong) ChildViewController *childVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    MyView *v = [[MyView alloc] init];
//    v.frame = CGRectMake(100, 100, 100, 100);
//    v.backgroundColor = [UIColor redColor];
//    v.tag = 101;
//    [self.view addSubview:v];
//    self.tmpView = v;
    
//    MyView2 *myView2 = [[MyView2 alloc] init];
//    myView2.frame = CGRectMake(50, 50, 100, 100);
//    [self.view addSubview:myView2];
    
    // xib storyboard里的东西都是在创建好了类的对象后，网界面上添加或者设置 ，用来初始化的。
    
//    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MyView2" owner:nil options:nil];
//    NSLog(@"%@",arr);
//    
//    MyView2 *view2 = arr[0];
//    MyView3 *view3 = arr[1];
//    
//    [self.view addSubview:view2];
//    [self.view addSubview:view3];
    
    ChildViewController *childVC = [[ChildViewController alloc] init];
    childVC.view.frame = CGRectMake(0, 100, 320, 200);
    [self.view addSubview:childVC.view];
    
    self.childVC = childVC;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    UIView *v = [self.view viewWithTag:101];
//    [v removeFromSuperview];
//    
////    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [self showInfo];
////    });
//    [self performSelector:@selector(showInfo) withObject:nil afterDelay:1];
}

//- (void)showInfo
//{
//    NSLog(@"%@",self.tmpView);
//}

@end
