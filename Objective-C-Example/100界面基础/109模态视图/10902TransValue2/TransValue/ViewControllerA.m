//
//  ViewController.m
//  TransValue
//
//  Created by niit on 16/3/9.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewControllerA.h"
#import "ViewControllerB.h"

// 1. 声明支持协议
@interface ViewControllerA ()<ViewControllerBDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UILabel *backMessageLabel;

@end

@implementation ViewControllerA

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

// A -> B

- (IBAction)loginBtnPressed:(id)sender
{
    // 方式1.(连线) 按钮直接连线过去
    
    // 方式2.(连线) 通过指定连线的名字跳转
//    [self performSegueWithIdentifier:@"gotoB" sender:nil];
    
    // 方式3.(代码弹出) 通过Storyboard里的场景创建一个对象弹出
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewControllerB *vcB = [sb instantiateViewControllerWithIdentifier:@"vcB"];
    vcB.username = self.usernameTextField.text;
    vcB.password = self.passwordTextField.text;
    // 告诉vcB我是你的代理，你返回的时候把消息传递回来
    vcB.delegate = self;
    [self presentViewController:vcB animated:YES completion:nil];
    
    // 方式4.(代码弹出) 使用xib
//    ViewControllerB *vcB = [[ViewControllerB alloc] initWithNibName:@"ViewControllerB2" bundle:nil];// 自动查找同名xib进行初始化
//    [self presentViewController:vcB animated:YES completion:nil];
    
    // 方式5.(代码弹出) 纯代码
//    ViewControllerB *vcB = [[ViewControllerB alloc] init];// 自动查找同名xib进行初始化
//    [self presentViewController:vcB animated:YES completion:nil];
    
}

// 如果是沿着连线方向跳转的，在此方法里传递数据
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    ViewControllerB *destVC = segue.destinationViewController;
////    destVC.infoLabel.text = 错误的!
    // 当前ViewControllerB对象中的view还没有创建，view上的元素还是空!
    // 不要去改变其他控制器控制的视图，而是将数据传递过去，他们自己显示到界面

//    destVC.username = self.usernameTextField.text;
//    destVC.password = self.passwordTextField.text;
//    destVC.delegate = self;
//}

// 2. 实现协议里的方法
- (void)transBack:(NSString *)str
{
    self.backMessageLabel.text = str;
}

@end
