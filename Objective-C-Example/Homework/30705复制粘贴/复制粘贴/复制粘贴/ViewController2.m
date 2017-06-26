//
//  ViewController2.m
//  复制粘贴
//
//  Created by student on 16/4/8.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "ViewController2.h"


@interface ViewController2 ()
{
    CGPoint curPoint;
}
@property (nonatomic,strong) UIImageView *curMoveImageView;
@property (nonatomic,strong) UIImageView *curOpImageView;
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bug1"]];
    imgView.center = self.view.center;
    [self.view addSubview:imgView];
    
    imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bug2"]];
    imgView.center = CGPointMake(200, 300);
    [self.view addSubview:imgView];
    
    imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bug3"]];
    imgView.center = CGPointMake(300, 200);
    [self.view addSubview:imgView];

}

//成为第一响应者
- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (UIImageView *)imageViewAtPoint:(CGPoint)point{
    for(int i=self.view.subviews.count-1;i>=0;i--)
    {
        for (UIImageView *imgView in self.view.subviews) {
            if (CGRectContainsPoint(imgView.frame, point)) {
                return imgView;
            }
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    // 得到触摸点下面的虫子的视图
    self.curMoveImageView = [self imageViewAtPoint:point];
    //    UITouch *touch = [touches anyObject];
    //    CGPoint point = [touch locationInView:self.view];
    //
    //    // 菜单
    //    UIMenuController *menu = [UIMenuController sharedMenuController];
    //    // 弹出的位置
    //    [menu setTargetRect:CGRectMake(point.x, point.y, 0, 0) inView:self.view];
    //    // 显示出来
    //    [menu setMenuVisible:YES animated:YES];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    self.curMoveImageView.center = point;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.curMoveImageView = nil;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    self.curOpImageView = [self imageViewAtPoint:point];
    
    curPoint = point;
    //双击
    if(touch.tapCount > 1)
    {
        // 菜单
        UIMenuController *menu = [UIMenuController sharedMenuController];
        // 弹出的位置
        // 菜单项
        UIMenuItem *menu1 = [[UIMenuItem alloc] initWithTitle:@"置上" action:@selector(up:)];
        UIMenuItem *menu2 = [[UIMenuItem alloc] initWithTitle:@"置下" action:@selector(down:)];
        [menu setMenuItems:@[menu1,menu2]];
        // 弹出的位置
        [menu setTargetRect:CGRectMake(point.x, point.y, 0, 0) inView:self.view];
        // 显示出来
        [menu setMenuVisible:YES animated:YES];
    }

}

//图层置上
- (void)up:(id)sender
{
    
}
//图层置下
- (void)down:(id)sender
{
    
}

- (void)copy:(id)sender
{
    if(self.curOpImageView)
    {
        [UIPasteboard generalPasteboard].image = self.curOpImageView.image;
    }
}

- (void)cut:(id)sender
{
    if(self.curOpImageView)
    {
        [UIPasteboard generalPasteboard].image = self.curOpImageView.image;
        
        // 移除
        [self.curOpImageView removeFromSuperview];
    }
}

- (void)paste:(id)sender
{
    if([UIPasteboard generalPasteboard].image != nil)
    {
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIPasteboard generalPasteboard].image];
        [self.view addSubview:imgView];
        imgView.center = curPoint;
    }
}

// 判断方法是否能狗执行,隐藏菜单中不能执行的菜单项
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if(self.curOpImageView) // 点了bug上
    {
        if([UIPasteboard generalPasteboard].image == nil)
        {
            if(@selector(paste:)== action)
            {
                return NO;
            }
        }
    }
    else // 点了空白处
    {
        if([UIPasteboard generalPasteboard].image != nil)
        {
            if(@selector(paste:)== action)
            {
                return YES;
            }
            return NO;
        }
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

@end
