//
//  SummaryViewController.m
//  Calculation
//
//  Created by niit on 16/2/22.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "SummaryViewController.h"

// 方式1 采用全局变量方式共享数据
// 全局变量,定义在.m文件
// 统计总共计算了多少次
//int calCount = 0;

@interface SummaryViewController ()

@end

@implementation SummaryViewController

// 将要显示
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.infoLabel.text = [NSString stringWithFormat:@"总共计算了%i次",calCount];
    
    self.infoLabel.text = [NSString stringWithFormat:@"总共计算了%i次",self.calCount];
    
    NSLog(@"SummaryVC:%s subviews.count=%i",__func__,self.view.subviews.count);
}

//代码创建视图时，viewDidLoad被调用时self.view已经创建完成。可在在该方法中进一步定制视图。
//XIB创建视图时，viewDidLoad仍会被调用，viewDidLoad被调用时self.view已经创建完成。可在在该方法中进一步定制视图。
//所以，无论那种方式定制视图、都可以覆写该方法。
// 视图完成加载
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"SummaryVC:%s subviews.count=%i",__func__,self.view.subviews.count);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"SummaryVC:%s",__func__);
    }
    return self;
}

//initWithCoder是一个类在XIB中创建但在Xcode中被实例化时被调用的.
//比如,通过XIB创建一个controller的nib文件,然后在xocde中通过initWithNibName来实例化这个controller,那么这个controller的initWithCoder会被调用。
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSLog(@"SummaryVC:%s",__func__);
        //        NSLog(@"SummaryVC:%s subviews.count=%i",__func__,self.view.subviews.count);
    }
    return self;
}

//在使用XIB的时候才会涉及到此方法的使用，当.nib文件被加载的时候，会发送一个awakeFromNib的消息到.nib文件中的每个对象，每个对象都可以定义自己的awakeFromNib函数来响应这个消息，执行一些必要的操作。
- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"SummaryVC:%s subviews.count=%i",__func__,self.view.subviews.count);
}

//无论XIB还是代码创建都会调用loadView方法。self.view为nil时才会被调用。
//代码创建视图时,loadView被调用时,self.view还为nil。一般在该方法中手工定制view。
//XIB创建视图时，loadView仍会被调用、loadView被调用时XIB定制的视图还没创建完成，若是再覆写该方法的话、会将XIB定制的视图覆盖掉。
//所以，纯手工定制视图时，一般在该方法中写；XIB定制视图时、不要覆写该方法。
- (void)loadView
{
    // NSLog(@"SummaryVC:before %s subviews.count=%i",__func__,self.view.subviews.count); 此行代码会造成死循环
    [super loadView];
    NSLog(@"SummaryVC:%s subviews.count=%i",__func__,self.view.subviews.count);
}

// 已经显示
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"SummaryVC:%s subviews.count=%i",__func__,self.view.subviews.count);
    
}

// 将要消失
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"SummaryVC:%s subviews.count=%i",__func__,self.view.subviews.count);
}

// 已经消失
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"SummaryVC:%s subviews.count=%i",__func__,self.view.subviews.count);
}

//- (void)viewDidUnload
//{
//
//}

- (void)dealloc
{
    NSLog(@"SummaryVC:%s subviews.count=%i",__func__,self.view.subviews.count);
}


@end
