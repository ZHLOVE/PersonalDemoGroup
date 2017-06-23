//
//  PresidentDetailTableViewController.m
//  NaviAndTable
//
//  Created by niit on 16/3/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "PresidentDetailTableViewController.h"

@interface PresidentDetailTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *fromTextField;
@property (weak, nonatomic) IBOutlet UITextField *toTextField;
@property (weak, nonatomic) IBOutlet UITextField *partyTextField;

@end

@implementation PresidentDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 把对象信息显示到界面
    self.nameTextField.text = self.pre.name;
    self.fromTextField.text = self.pre.fromYear;
    self.toTextField.text = self.pre.toYear;
    self.partyTextField.text = self.pre.party;
}

- (IBAction)saveBtnPressed:(id)sender
{
    // 把修改的数据保存到对象
    self.pre.name = self.nameTextField.text ;
    self.pre.fromYear = self.fromTextField.text;
    self.pre.toYear = self.toTextField.text;
    self.pre.party = self.partyTextField.text ;
    
    // 回到前一页面
    [self.navigationController popViewControllerAnimated:YES];
    
    // 让代理人(前一个页面)刷新一下数据
    [self.delegate refresh];
}




@end
