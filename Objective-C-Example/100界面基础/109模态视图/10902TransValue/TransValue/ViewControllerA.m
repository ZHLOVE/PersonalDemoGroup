//
//  ViewController.m
//  TransValue
//
//  Created by niit on 16/2/25.
//  Copyright © 2016年 NIIT. All rights reserved.
//

// A -> B (A弹出了B,A传递数据到B)
// A里面，想办法得到B对象，直接设置它的属性就可以了，把信息传递过去

// A <- C (A弹出了C,C将数据回传到A)
// C里
// 1. B里定义一个协议,协议里定义回传数据的方法
// 2. 定义一个支持协议的delegate的属性
// 3. 回传数据的时候self.delegate执行协议里回传数据的方法
// A里
// 1. 实现C定义的协议,比如就是将返回回来的数据显示到界面上
// 2. 在跳转到C的时候，告诉C，我是你的代理人。

// 练习:
// 1. 不用Storyboard,使用xib实现本程序

#import "ViewControllerA.h"

#import "ViewControllerB.h"
#import "ViewControllerC.h"
// 类的扩展
@interface ViewControllerA ()<ViewControllerCDellegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UILabel *registerResultLabel;

@end

@implementation ViewControllerA

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

// 将要沿着某根连线跳转时触发的方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // (UIStoryboardSegue *)segue 连线对象
    // 两个重要属性:
//    segue.identifier 连线的名字 (用于判断是哪根线)
//    segue.destinationViewController  连线的目标控制器(得到目标控制器，以便传递数据给它)
    
    if([segue.identifier isEqualToString:@"gotoB"])
    {
        ViewControllerB *vcB = segue.destinationViewController;
        vcB.username = self.usernameTextField.text;
        vcB.password = self.passwordTextField.text;
    }
    else if([segue.identifier isEqualToString:@"gotoC"])
    {
        NSLog(@"A:将要跳转到C");
        ViewControllerC *vcC = segue.destinationViewController;
        // 告诉C页面,我是你的代理人，注册好了回调我
        NSLog(@"A:我是C的代理人,你调用我回传数据");
        vcC.delegate = self;
    }
}
#pragma mark -ViewControllerC Delegate Method 实现ViewControllerC的协议里的方法
- (void)transUserName:(NSString *)u andPassword:(NSString *)p andEmail:(NSString *)e
{
    NSLog(@"A:得到C传来的数据:%@,%@,%@",u,p,e);
    self.registerResultLabel.text = [NSString stringWithFormat:@"注册成功!%@，%@,%@",u,p,e];
}
@end
