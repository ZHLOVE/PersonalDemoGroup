//
//  HomeTableViewController.m
//  WeiBo
//
//  Created by student on 16/4/21.
//  Copyright © 2016年 BNG. All rights reserved.
//


#import "HomeTableViewController.h"

#import "VisitorView.h"
#import "UIBarButtonItem+Create.h"
#import "TitleButton.h"
#import "PopoverViewController.h"
#import "PopoverAnimator.h"
#import "def.h"
//转场控制器
#import "PopoverPresentationController.h"
#import "UserAccount.h"
//转场动画协议
@interface HomeTableViewController ()<UIViewControllerTransitioningDelegate>
{
    BOOL isPresent;//判断是否弹出
}
@property(nonatomic,strong) PopoverAnimator *popoverAnimatior;
@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![[UserAccount sharedUserAccount] isLogined]) {
        [self.vistorView setupVisitorInfo:YES imageName:@"visitordiscover_feed_image_house" message:@"关注一些人，回这里看看有什么惊喜"];
    }
    //设置导航栏上的按钮
    [self setupNavi];
    
    //监听通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change) name:kNontificationPopoverWillShow object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change) name:kNontificationPopoverWillDismiss object:nil];
   
}

- (void)change{
    TitleButton *titleBtn = self.navigationItem.titleView;
    titleBtn.selected = !titleBtn.selected;
}

- (void)setupNavi{
    //添加左右按钮

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem createBarButtonItem:@"navigationbar_friendattention" target:self action:@selector(leftItenPressed:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem createBarButtonItem:@"navigationbar_pop" target:self action:@selector(rightItemPressed:)];
    //2 创建标题按钮
    TitleButton *titleBtn = [[TitleButton alloc]init];
    [titleBtn setTitle:@"WeiBo" forState:UIControlStateNormal];
    
    [titleBtn sizeToFit];
    [titleBtn addTarget:self action:@selector(titleBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    
}

- (void)leftItenPressed:(id)sender{
    
}

- (void)rightItemPressed:(id)sender
{
    NSLog(@"%s",__func__);
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"QRCodeViewController" bundle:nil];
    UINavigationController *navi = sb.instantiateInitialViewController;
    
    [self presentViewController:navi animated:YES completion:nil];
}

// 自定义转场动画见:
//http://www.cnblogs.com/zanglitao/p/4167909.html
- (void)titleBtnPressed:(UIButton *)sender{
//    sender.selected = !sender.selected;
    //弹出菜单
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PopoverStoryBoard" bundle:nil];
    PopoverViewController *popVC = sb.instantiateInitialViewController;
    
    // 采用自定义转场动画
    // 自定义转场动画
    popVC.modalPresentationStyle = UIModalPresentationCustom;
    popVC.transitioningDelegate = self.popoverAnimatior;
    
    [self presentViewController:popVC animated:YES completion:nil];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}



- (PopoverAnimator *)popoverAnimatior{
    if (_popoverAnimatior == nil) {
        _popoverAnimatior = [[PopoverAnimator alloc]init];
        _popoverAnimatior.presentFrame = CGRectMake(55, 56, 200, 350);

    }
    return _popoverAnimatior;
}



@end
