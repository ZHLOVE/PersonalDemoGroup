//
//  ViewController.m
//  TransValue
//
//  Created by niit on 16/3/9.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewControllerC.h"
#import "ViewControllerB.h"

@interface ViewControllerC ()

@end

@implementation ViewControllerC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)loginBtnPressed:(id)sender
{
    // 方式1. 按钮直接连线过去
    
    // 方式2. 通过指定连线的名字跳转
//    [self performSegueWithIdentifier:@"gotoD" sender:nil];
    
    // 方式3. 通过Storyboard里的场景创建一个对象弹出
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ViewControllerD *vc = [sb instantiateViewControllerWithIdentifier:@"vcD"];
//    [self.navigationController pushViewController:vc animated:YES];
    
    // 方式4. 使用xib
//    ViewControllerD *vcB = [[ViewControllerB alloc] initWithNibName:@"ViewControllerD2" bundle:nil];// 自动查找同名xib进行初始化
//    [self.navigationController pushViewController:vc animated:YES];
    
    // 方式5. 纯代码
//    ViewControllerB *vcB = [[ViewControllerB alloc] init];// 自动查找同名xib进行初始化
//    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
