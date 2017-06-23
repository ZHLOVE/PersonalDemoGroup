//
//  ViewController.m
//  PresentViewController
//
//  Created by niit on 16/2/24.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewControllerA.h"

#import "ViewControllerB.h"
#import "ViewControllerD.h"
#import "ViewControllerE.h"


@interface ViewControllerA ()

@end

@implementation ViewControllerA

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

// 当沿着Storyboard中的连线跳转的时候触发的方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s",__func__);
    
    NSLog(@"%@",segue.identifier);// 连线的名字
    NSLog(@"%@",segue.destinationViewController);// 连线的目标是哪个控制器
 
    if([segue.identifier isEqualToString:@"popB"])
    {
        ViewControllerB *vcB = segue.destinationViewController;
        
        // 错误!当前处于正要弹出的状态，vcB对象创建了，但是视图还没有创建初始化
        // vcB.resultLabel 界面对象还没有显示出来，还是空对象
        // vcB.resultLabel.text = [NSString stringWithFormat:@"%i",[self.numTextField.text intValue] * 10];
        
        vcB.num = [self.numTextField.text intValue] * 10;
    }
}



// 方式1. 直接按钮触发跳转

// 方式2. 沿着某根连线跳转
- (IBAction)popCBtnPressed:(id)sender
{
    // 沿着identifier是@"popC"的连线
    [self performSegueWithIdentifier:@"popC" sender:nil];
}

// 方式3. 通过Storyboard中的场景创建新视图控制器对象,代码弹出
- (IBAction)popDBtnPressed:(id)sender
{
    // Stroyboard对象
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // 在Storyboard中找到StoryboardId为@"vcD"的场景为模板创建一个对象
    ViewControllerD *vcD = [sb instantiateViewControllerWithIdentifier:@"vcD"];
    
    // 代码弹出视图控制器对象
    [self presentViewController:vcD animated:YES completion:nil];
}

// 方式4. 通过xib创建新视图控制器对象,代码弹出
- (IBAction)popEBtnPressed:(id)sender
{
    ViewControllerE *vcE = [[ViewControllerE alloc] init];
    // 窗口样式
    vcE.modalPresentationStyle = UIModalPresentationFullScreen;// iPhone只有全屏方式
    vcE.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    // 切换动画方式
//    UIModalTransitionStyleCoverVertical = 0,
//    UIModalTransitionStyleFlipHorizontal __TVOS_PROHIBITED,
//    UIModalTransitionStyleCrossDissolve,
//    UIModalTransitionStylePartialCurl NS_ENUM_AVAILABLE_IOS(3_2) __TVOS_PROHIBITED,
    
    // 直接赋值，把数据传递过去
    vcE.num = [self.numTextField.text intValue] * 10;
    
    // 代码弹出视图控制器对象
    [self presentViewController:vcE animated:YES completion:nil];
}


// 触摸开始的时候触发的方法，当前视图属于UIView类,UIView从UIResponder继承了这个方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 关闭键盘
//    [self.view endEditing:YES];
    
    [self.numTextField resignFirstResponder];
}
@end
