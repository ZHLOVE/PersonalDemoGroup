//
//  ViewController.m
//  Attention
//
//  Created by student on 16/2/18.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "ViewController.h"

// 练习:
// 1. 分析整个应用中当前有多少对象?罗列出来
/* 
    UIApplication(1)
    AppDelegate(1)
    ViewController(1)
    UIWindow(1)
    UIView(1)
    UIButton(4)
    UILabel(1)
    UIAlertView(3)
    UIActionSheet(1)
 */
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
- (IBAction)btn1Pressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"标题"
                                                       message:@"信息……"
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
    [alertView show];
}
- (IBAction)btn2Pressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"弹出窗口2"
                                                       message:@"中午吃饭？"
                                                      delegate:self
                                             cancelButtonTitle:@"吃了"
                                             otherButtonTitles:@"正在吃",@"还没吃",nil];
     [alertView show];
}
- (IBAction)btn3Pressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"登入"
                                                       message:@"请输入用户名密码"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alertView show];
}
#pragma mark操作表
- (IBAction)btn4Pressed:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"一起吃饭吧？"
                                                      delegate:self
                                             cancelButtonTitle:@"我吃过了,你去吧"
                                        destructiveButtonTitle:@"好的，一起去"
                                             otherButtonTitles:@"一起吃KFC", nil];
    [sheet showInView:self.view];
}

#pragma mark UIAlertViewDelegate Method
// 当用户点了哪个按钮触发的事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"用户点了第几个按钮 = %i,按钮的文字信息:%@",buttonIndex+1,[alertView buttonTitleAtIndex:buttonIndex]);
    NSLog(@"弹窗信息:%@",alertView.title);
    if ([alertView.title isEqualToString:@"登入"]) {
        NSString *info = [NSString stringWithFormat:@"用户名:%@ 密码:%@",[alertView textFieldAtIndex:0].text,[alertView textFieldAtIndex:1].text];
        self.infoLabel.text = info;
    }
}

#pragma mark UIActionSheetDelegate Method
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"操作表的标题:%@",actionSheet.title);
    NSLog(@"用户选择了哪个按钮:%i,%@",buttonIndex,[actionSheet buttonTitleAtIndex:buttonIndex]);
    
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
       NSLog(@"用户点了destructiveBtn");
    }
    else if(buttonIndex == actionSheet.cancelButtonIndex)
    {
        NSLog(@"用户点了cancelBtn");
    }
}




@end
