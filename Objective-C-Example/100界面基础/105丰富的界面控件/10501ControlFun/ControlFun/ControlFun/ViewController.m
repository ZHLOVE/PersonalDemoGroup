//
//  ViewController.m
//  ControlFun
//
//  Created by niit on 16/2/18.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

// 练习:
// 1. 编写doSomething按钮的事件处理方法
//    1.1 点击按钮弹出操作表,见图10501B.png
//    1.2 编写提示框的代理方法,如果点的是"是的,我确定"项,则弹出消息框,见10501C.png
// 2. 纯代码方式实现本程序
      //注:纯代码方式修改view为UIControl类对象 见给出的例子

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 设置doSomething按钮的背景(需要对图片进行拉伸设置）
    // 1. 代码方式
//    // 代码实现设置按钮的背景图片
//    UIImage *img1 = [UIImage imageNamed:@"whiteButton"];
//    UIImage *img2 = [UIImage imageNamed:@"blueButton"];
//
//    // 创建拉伸的图片 (左右各留12像素不拉伸)
//    UIEdgeInsets insets = UIEdgeInsetsMake(0, 12, 0, 12);// 上左下右
//    UIImage *img3 = [img1 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
//    UIImage *img4 = [img2 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
//
//    [self.doSomethingBtn setBackgroundImage:img3 forState:UIControlStateNormal];
//    [self.doSomethingBtn setBackgroundImage:img4 forState:UIControlStateHighlighted];
    
    // 2. 删除原来拖到项目中的图片，重新拉图片放在Assets.scassets中,用Assets.scassets管理图片。
         //设置一下需要拉伸的图片的切片,图片被使用的时候会自动拉伸
}

// * sender 是当前触发这个方法的对象

#pragma mark - 触摸背景,关闭键盘

// Storyboard中需要把self.view改成UIControl类
// TouchDown事件拉出个方法来
- (IBAction)backTap:(id)sender
{
    // 两种方法都可以
    // 1. 当前视图结束编辑状态
//    [self.view endEditing:YES];
    
    // 2. 文本框取消第一响应者
    [self.nameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    
#pragma 关于第一响应者
    // 理解为当前有焦点的对象,正在操作的对象
//    - (nullable UIResponder*)nextResponder; // 下一个响应者，在实现中，一般会返回父级对象
//    - (BOOL)canBecomeFirstResponder;    // 获取指定对象是否可以获取焦点
//    - (BOOL)becomeFirstResponder;       // 把对象设置为第一响应者
//    
//    - (BOOL)canResignFirstResponder;    // 对象是否可以取消第一响应者
//    - (BOOL)resignFirstResponder;       // 取消对象为第一响应者
//    
//    - (BOOL)isFirstResponder;
//    指示对象是否为第一响应者，这里的第一响应者就是当前有焦点的对象，叫法挺奇怪的，第一次看到真还难以理解这个叫法所表达的意思
    
}

// 滑动条滑动触发的方法
- (IBAction)sliderChanged:(UISlider *)sender
{
    // 滑动条的值 value属性
    int value = sender.value;
    // 把滑动条的值显示到Label上
    self.sliderValueLabel.text = [NSString stringWithFormat:@"%i",value];
    
}

// 分段控件改变触发的方法
- (IBAction)segementChanged:(UISegmentedControl *)sender
{
    //分段控件的主要属性和方法:
    //属性 selectedSegmentIndex 当前选中项
    //方法 titleForSegementAtIndex 得到某段的标题
    NSLog(@"选中了%@",[sender titleForSegmentAtIndex:sender.selectedSegmentIndex]);
    
    // 1. 如果是点开关段
    // 显示开关，隐藏按钮
    // 2. 如果是点按钮段
    // 相反
    
    if(sender.selectedSegmentIndex == 0)
    {
        self.leftSwitch.hidden = NO;
        self.rightSwitch.hidden = NO;
        self.doSomethingBtn.hidden = YES;
    }
    else
    {
        self.leftSwitch.hidden = YES;
        self.rightSwitch.hidden = YES;
        self.doSomethingBtn.hidden = NO;
    }
}

// 开关触发的处理方法
- (IBAction)switchChanged:(UISwitch *)sender
{
    // 开关控件的主要属性:
    // 开关的当前开关状态 on属性
    BOOL open = sender.on;
    
    // 设置状态，并是否要带上动画
    [self.leftSwitch setOn:open animated:YES];
    [self.rightSwitch setOn:open animated:NO];
}

// doSomething按钮触发的方法
- (IBAction)doSomethingBtnPressed:(id)sender
{
    
}



@end
