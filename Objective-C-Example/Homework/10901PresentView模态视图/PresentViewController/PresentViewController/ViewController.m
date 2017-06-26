//
//  ViewController.m
//  PresentViewController
//
//  Created by student on 16/2/24.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController.h"
#import "ViewControllerB.h"
#import "ViewControllerD.h"
#import "ViewControllerE.h"

@interface ViewController ()

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

// 1. 直接按钮触发跳转
//当沿着连线跳转的时候触发的方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"popB"]) {
        ViewControllerB *vcB = segue.destinationViewController;
        vcB.num = [self.infoTextFielld.text intValue] * 10;
    }
}

// 2. 沿着某根连线跳转
- (IBAction)btnCPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"popC" sender:nil];
    
}
// 方式3. 通过Storyboard创建,代码弹出
- (IBAction)btnDPressed:(UIButton *)sender {
    //得到storyBoard对象
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // 在Storyboard中找到StoryboardId为@"vcD"的场景为模板创建一个对象对象
    ViewControllerD *vcD = [sb instantiateViewControllerWithIdentifier:@"vcD"];
    [self presentViewController:vcD animated:YES completion:nil];
}

// 方式4. 通过xib创建对象,代码弹出
- (IBAction)btnEPressed:(UIButton *)sender {
    ViewControllerE *vcE = [[ViewControllerE alloc]init];
    //窗口样式
    vcE.modalPresentationStyle = UIModalPresentationFullScreen;
    vcE.modalTransitionStyle = UIModalTransitionStylePartialCurl;
        // 代码弹出视图控制器对象
    [self presentViewController:vcE animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.infoTextFielld resignFirstResponder];
}


@end
