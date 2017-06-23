//
//  ViewController.m
//  Attention
//
//  Created by niit on 16/2/18.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "AppDelegate.h"

// 练习:
// 1. 分析整个应用中总共有多少哪些对象?罗列出来
// 应用程序对象       UIApplication类
// 应用程序代理对象    AppDelegate类(继承自UIResponder,实现<UIApplicationDelegate>协议)
// 应用程序窗口对象    UIWindow类
// 视图控制器对象      ViewController类(继承自UIViewController)
// 以下为可见对象
// 视图对象(1个)      UIView类
// 按钮对象对象(4个)   UIButton类
// 文本标签对象(1个)   UILabel类
// 提示框对象(3个)     UIAlertView类
// 操作表的对象(1个)   UIActionSheet类

// 2. 使用Reveal查看程序结构

// 3. 使用纯代码实现本程序

@interface ViewController ()<UIAlertViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 弹出提示框(UIAlertView)
- (IBAction)btn1Pressed:(UIButton *)sender
{
    NSLog(@"keyWindow:%@",[UIApplication sharedApplication].keyWindow);
    // 1. 弹出简单提示框
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"弹出框标题"  // 标题
                                                        message:@"弹出框信息"  // 信息
                                                       delegate:self         // 代理人(即哪个对象来处理这个UIAlertView对象的事件)
                                              cancelButtonTitle:@"确定"       // 按钮上的文字
                                              otherButtonTitles:nil];        // 更多按钮
    [alertView show];
    NSLog(@"keyWindow:%@",[UIApplication sharedApplication].keyWindow);
}

- (IBAction)btn2Pressed:(UIButton *)sender
{
    // 2. 多个按钮的提示框
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"弹出窗口2"
                                                        message:@"中饭吃没？"
                                                       delegate:self
                                              cancelButtonTitle:@"吃了"
                                              otherButtonTitles:@"正在吃",@"还没吃",nil];
    [alertView show];
}

- (IBAction)btn3Pressed:(UIButton *)sender
{
    // 3. 带输入框的提示框
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登入"
                                                        message:@"请输入用户名密码"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
    // 设置UIAlertView对象的样式
    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    //    UIAlertViewStyleDefault = 0,            // 默认,即无输入框
    //    UIAlertViewStyleSecureTextInput,        // 密码文本
    //    UIAlertViewStylePlainTextInput,         // 普通文本
    //    UIAlertViewStyleLoginAndPasswordInput   // 用户名密码
    alertView.tag = 101;
    [alertView show];
}

#pragma mark - 弹出操作表(UIActionSheet)
- (IBAction)btn4Pressed:(UIButton *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"小明:一起吃饭吧?"                 // 标题
                                                       delegate:self                              // 代理人
                                              cancelButtonTitle:@"我吃过了,你去吧."                 // cancelButtong标题
                                         destructiveButtonTitle:@"好的,一起去"                     // destructionButton标题
                                              otherButtonTitles:@"一起吃吃KFC",@"一起去吃MC",nil];  // 其他按钮的标题
    [sheet showInView:self.view];
}

#pragma mark - UIAlertViewDelegate Method 弹出框的代理方法
// 作为UIAlertView的代理人，控制器类中编写相应的事件处理方法,都是可选方法，根据需求选择适当的实现

// 当用户点了哪个按钮对应的方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"弹窗的信息:%@",alertView.title);
    NSLog(@"用户点了第几个按钮 = %i,按钮的文字信息:%@",buttonIndex+1,[alertView buttonTitleAtIndex:buttonIndex]);

    //方式一: 通过alertView的标题来区分是哪个alert
    if([alertView.title isEqualToString:@"登入"])
    {
        NSString *info = [NSString stringWithFormat:@"用户名:%@ 密码:%@",[alertView textFieldAtIndex:0].text,[alertView textFieldAtIndex:1].text];
        self.infoLabel.text = info;
    }
    
    //方式二: 通过alertView的tag来区分是哪个alert
//    if(alertView.tag == 101)
//    {
//        NSString *info = [NSString stringWithFormat:@"用户名:%@ 密码:%@",[alertView textFieldAtIndex:0].text,[alertView textFieldAtIndex:1].text];
//        self.infoLabel.text = info;
//    }
    
}

// 用户点击取消的时候
- (void)alertViewCancel:(UIAlertView *)alertView
{
    NSLog(@"%s",__FUNCTION__);
}

// 提示框将要弹出的时候
- (void)willPresentAlertView:(UIAlertView *)alertView
{
    NSLog(@"%s",__FUNCTION__);
}

// 提示框已经弹出
- (void)didPresentAlertView:(UIAlertView *)alertView
{
    NSLog(@"%s",__FUNCTION__);
}

// 提示框将要消失
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%s",__FUNCTION__);
}

// 提示框已经消失
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%s",__FUNCTION__);
}

// Called after edits in any of the default fields added by the style
// - (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView NS_DEPRECATED_IOS(2_0, 9_0);


#pragma mark - UIActionSheetDelegate Method 操作表的代理方法

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"操作表的标题:%@",actionSheet.title);
    NSLog(@"用户选择了哪一个按钮:%i,%@",buttonIndex,[actionSheet buttonTitleAtIndex:buttonIndex]);
    
    // 方式一: 根据buttonIndex判断用户点击了哪个选项
    if(buttonIndex == actionSheet.destructiveButtonIndex)
    {
        NSLog(@"用户点了destructiveBtn");
    }
    else if(buttonIndex == actionSheet.cancelButtonIndex)
    {
        NSLog(@"用户点了cancelBtn");
    }
    
    // 方式二: 根据文字判断
//    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"好的,一起去"])
//    {
//        NSLog(@"他吃过了");
//    }
    
}

@end
