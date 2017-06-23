//
//  ViewControllerB.m
//  TransValue
//
//  Created by niit on 16/3/9.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewControllerB.h"

@interface ViewControllerB ()

@end

@implementation ViewControllerB

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    // 纯代码方式下的代码，不用xib,不用storyboard
//    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(70, 70, 180, 180)];
//    label.text = @"B";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:80];
//    [self.view addSubview:label];
//    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(140, 250, 100, 50)];
//    [btn setTitle:@"返回" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//    
//    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // 将前一页面传递来的的数据显示
    self.infoLabel.text = [NSString stringWithFormat:@"用户名:%@\n密码:%@\n登陆成功",self.username,self.password];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnPressed:(id)sender
{
    // 3. 将数据返回给前一页面
    [self.delegate transBack:@"ok！登陆成功"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
