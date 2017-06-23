//
//  ViewController.m
//  CopyAndPaste
//
//  Created by niit on 16/4/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
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

// 要弹出菜单，视图控制器必须要能成为第一响应者
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    // 菜单
    UIMenuController *menu = [UIMenuController sharedMenuController];
    // 弹出的位置
    [menu setTargetRect:CGRectMake(point.x, point.y, 0, 0) inView:self.view];
    // 显示出来
    [menu setMenuVisible:YES animated:YES];
}

- (void)copy:(id)sender
{
    NSLog(@"复制");
    
    //剪贴板
    [UIPasteboard generalPasteboard].string = self.infoLabel.text;
}

- (void)cut:(id)sender
{
    NSLog(@"剪切");
}

- (void)paste:(id)sender
{
    self.infoLabel.text = [UIPasteboard generalPasteboard].string;
}

@end
