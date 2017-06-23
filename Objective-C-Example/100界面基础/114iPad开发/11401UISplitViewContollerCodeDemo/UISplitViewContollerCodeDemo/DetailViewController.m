//
//  DetailViewController.m
//  UISplitViewControllerDemo
//
//  Created by niit on 16/3/10.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "DetailViewController.h"

// 定义之后可以不用带mas_前缀
#define MAS_SHORTHAND
// 定义之后equalTo等于mas_equalTo
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"

@interface DetailViewController ()

// 弹出控制器
@property (nonatomic,strong) UIPopoverController *popVC;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.、
    
    
    // 导航栏左侧按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"pop" style:UIBarButtonItemStylePlain target:self action:@selector(popBtnPressed:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"模态窗口" style:UIBarButtonItemStylePlain target:self action:@selector(modelBtnPressed:)];
    self.navigationItem.rightBarButtonItem = rightItem;

    self.title = @"Detail";
    self.view.backgroundColor = [UIColor redColor];
    
    // pop内容视图控制器
    UIViewController *popContentVC = [[UIViewController alloc] init];
    popContentVC.view.backgroundColor = [UIColor blueColor];
    
    // 创建弹出控制器
    self.popVC = [[UIPopoverController alloc] initWithContentViewController:popContentVC];
    
    // 弹出的尺寸
    self.popVC.popoverContentSize = CGSizeMake(320, 500);
    
    // 创建label
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:100];
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = 101;
    [self.view addSubview:label];
    
    // 为label创建约束
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)popBtnPressed:(id)sender
{
    // 弹出pop窗口
    if(self.popVC.popoverVisible)
    {
        [self.popVC dismissPopoverAnimated:YES];
    }
    else
    {
        // 从按钮旁弹出
        [self.popVC presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
}
- (IBAction)modelBtnPressed:(id)sender
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor yellowColor];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeModal)];
    vc.navigationItem.rightBarButtonItem = rightBtn;
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    
    
    navi.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    navi.modalPresentationStyle = UIModalPresentationFormSheet;
    
    
    [self presentViewController:navi animated:YES completion:nil];
    
}

- (void)closeModal
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setStuName:(NSString *)stuName
{
    _stuName = stuName;
    
    // 根据情况，将数据显示到界面
    UILabel *label = [self.view viewWithTag:101];
    label.text = stuName;
    
}


@end
