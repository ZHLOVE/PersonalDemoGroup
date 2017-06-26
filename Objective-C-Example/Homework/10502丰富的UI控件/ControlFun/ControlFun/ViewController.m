//
//  ViewController.m
//  ControlFun
//
//  Created by student on 16/2/18.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImage *img1 = [UIImage imageNamed:@"apress_logo"];
//    UIImage *img2 = [UIImage imageNamed:@"blueButton"];
//    
//    //创建拉伸的图片
//    UIEdgeInsets insets = UIEdgeInsetsMake(0, 12, 0, 12);//上下左右
//    UIImage *img3 = [img1 resizableImageWithCapInsets:]
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backTap:(id)sender {
    //1结束编辑
    [self.view endEditing:YES];
}

// 滑动条滑动触发的方法
- (IBAction)sliderChanged:(UISlider *)sender {
    //滑动条的值 value
    int value = sender.value;
    //把滑动条的值显示到label上
    self.sliderValueLabel.text = [NSString stringWithFormat:@"%i",value];
}

- (IBAction)switchChaged:(UISwitch *)sender {
    // 开关控件的主要属性:
    // 开关的当前开关状态 on属性
    BOOL open = sender.on;
    // 设置状态，并是否要带上动画
    [self.leftSwitch setOn:open animated:YES];
    [self.rightSwitch setOn:open animated:NO];
}

- (IBAction)doSomethingBtnPressed:(UIButton *)sender {
    UIActionSheet *actionSheet =[[UIActionSheet alloc] initWithTitle:@"提示消息"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"好的"
                                                   otherButtonTitles:@"嗯", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSString *message = @"吃饭吧";
        NSMutableString *muMessage = [message mutableCopy];
        [muMessage insertString:self.nameTextField.text atIndex:0];
        NSString *messageAlert = [muMessage copy];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提醒"
                                                           message:messageAlert
                                                          delegate:self
                                                 cancelButtonTitle:@"马上去"
                                                 otherButtonTitles:@"不去",nil];
        [alertView show];
        //        NSLog(@"%i",buttonIndex);
    }else{
        //        NSLog(@"%i",buttonIndex);
    }
}

- (IBAction)segementChanged:(UISegmentedControl *)sender {
    //分段控件的主要属性:
    //当前选中项 sender.selectedSegmentIndex
    
    // 1 如果是点开关段
    // 显示开关，隐藏按钮
    // 2 如果是点按钮段
    // 相仿
    if (sender.selectedSegmentIndex == 0) {
        self.leftSwitch.hidden = NO;
        self.rightSwitch.hidden = NO;
        self.doSomethingBtn.hidden = YES;
    }
    else{
        self.leftSwitch.hidden = YES;
        self.rightSwitch.hidden = YES;
        self.doSomethingBtn.hidden = NO;
    }
}
@end


















