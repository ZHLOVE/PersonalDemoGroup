//
//  ViewController.m
//  Attention_Code
//
//  Created by niit on 16/2/19.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (nonatomic,weak) UILabel *infoLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 1. 得到应用程序对象的方法
    UIApplication *app = [UIApplication sharedApplication];
    NSLog(@"%@",app);
    // 2. 得到应用程序代理类对象的方法
    AppDelegate *appDelegate = app.delegate;
    NSLog(@"%@",appDelegate);
    // 3. 得到UIWindow对象的方法
    UIWindow *window = [app keyWindow];// 主窗体
    NSLog(@"%@",window);
    // 4. 得到window的根控制器对象的方法
    NSLog(@"%@",window.rootViewController);
    NSLog(@"%@",self);
    
#pragma mark - UIApplication的属性和方法

#pragma mark 1.applicationIconBadgeNumber app图标右上角的角标
    float version = [[UIDevice currentDevice].systemVersion floatValue];// 得到系统的版本
    if(version >= 8.0)
    {
        // 注册角标通知(需要用户同意权限)
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        [app registerUserNotificationSettings:settings];
    }
    // 设置角标
    app.applicationIconBadgeNumber = 10;
    
#pragma mark 2. networkActivityIndicatorVisible 联网状态
    app.networkActivityIndicatorVisible = YES;
    
#pragma mark 3. 设置状态栏 (由应用设置也可以有页面来定)
//   在info.plist中添加一项 View controller-based status bar appearance 设置成 NO
    app.statusBarHidden = YES;
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(100, 50, 300, 50);
    label.text = @"提示信息";
    [self.view addSubview:label];
    self.infoLabel = label;
    
#pragma mark 4. 打开其他程序
    [app openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    
    
//    UIButton *btn = [[UIButton alloc] init];
//    btn.frame = CGRectMake(100, 100, 100, 50);
//    [btn setTitle:@"简单提示框" forState:UIControlStateNormal];
//    [self.view addSubview:btn];
//    [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addBtnWithTitle:@"简单提示框" frame:CGRectMake(100, 100, 150, 50) sel:@selector(btn1Pressed:)];
    [self addBtnWithTitle:@"多按钮提示框" frame:CGRectMake(100, 150, 150, 50) sel:@selector(btn2Pressed:)];
    [self addBtnWithTitle:@"带输入框提示框" frame:CGRectMake(100, 200, 150, 50) sel:@selector(btn3Pressed:)];
    
}

- (void)addBtnWithTitle:(NSString *)title frame:(CGRect)rect sel:(SEL)sel
{
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = rect;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnPressed:(UIButton *)sender
{
    [self btnPressed:sender];
}

#pragma mark - 弹出提示框(UIAlertView)
- (IBAction)btn1Pressed:(UIButton *)sender
{
    // 1. 弹出简单提示框
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"弹出框标题"  // 标题
                                                        message:@"弹出框信息"  // 信息
                                                       delegate:self         // 代理人(即哪个对象来处理这个UIAlertView对象的事件)
                                              cancelButtonTitle:@"确定"       // 按钮上的文字
                                              otherButtonTitles:nil];        // 更多按钮
    [alertView show];
}

- (IBAction)btn2Pressed:(UIButton *)sender
{
    // 2. 多个按钮的提示框
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"弹出窗口2" message:@"中饭吃没？" delegate:self cancelButtonTitle:@"吃了" otherButtonTitles:@"正在吃",@"还没吃",nil];
    [alertView show];
}

- (IBAction)btn3Pressed:(UIButton *)sender
{
    // 3. 带输入框的提示框
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登入" message:@"请输入用户名密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    //    UIAlertViewStyleDefault = 0,            // 默认,即无输入框
    //    UIAlertViewStyleSecureTextInput,        // 密码文本
    //    UIAlertViewStylePlainTextInput,         // 普通文本
    //    UIAlertViewStyleLoginAndPasswordInput   // 用户名密码
    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;// UIAlertView对象的样式
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
    NSLog(@"用户点了第几个按钮 = %i,按钮的文字信息:%@",buttonIndex+1,[alertView buttonTitleAtIndex:buttonIndex]);
    NSLog(@"弹窗的信息:%@",alertView.title);
    
    if([alertView.title isEqualToString:@"登入"])
    {
        NSString *info = [NSString stringWithFormat:@"用户名:%@ 密码:%@",[alertView textFieldAtIndex:0].text,[alertView textFieldAtIndex:1].text];
        self.infoLabel.text = info;
    }
}
@end

