//
//  ViewController_A.m
//  TransValue
//
//  Created by student on 16/2/25.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController_A.h"
#import "ViewController_B.h"
#import "ViewController_C.h"



@interface ViewController_A ()<ViewController_CDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;

@property (weak, nonatomic) IBOutlet UILabel *registerResultLabel;

@end

@implementation ViewController_A

// A -> B
// A里面，想办法得到B对象，直接设置它的属性就可以了，把信息传递过去

// A <- C (A弹出了C，C将数据回传到A)
// C里
// 1. B里定义一个协议,协议里协议个回传数据的方法
// 2. 定义一个支持协议的delegate的属性
// 3. 回传数据的时候 self.delegate 执行协议里的方法
// A里
// 1. 实现C定义的协议,比如就是将返回回来的数据显示到界面上
// 2. 在跳转到C的时候，告诉C，我是你的代理人。

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 将要沿着某根连线跳转时触发的方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //    segue.identifier 名字
    //    segue.destinationViewController  目标控制器
    
    if([segue.identifier isEqualToString:@"gotoB"])
    {
        ViewController_B *vcB = segue.destinationViewController;
        vcB.username = self.userNameTextField.text;
        vcB.password = self.passwdTextField.text;
    }
    else if([segue.identifier isEqualToString:@"gotoC"])
    {
        ViewController_C *vcC = segue.destinationViewController;
        // 告诉C页面,我是你的代理人，注册好了回调我
        vcC.delegate = self;
    }
    
}

#pragma mark -ViewControllerC Delegate Method
- (void)transUserName:(NSString *)u andPassword:(NSString *)p andEmail:(NSString *)e{
    
    self.registerResultLabel.text = [NSString stringWithFormat:@"注册成功！%@, %@, %@",u,p,e];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userNameTextField resignFirstResponder];
    [self.passwdTextField resignFirstResponder];
}
















@end
