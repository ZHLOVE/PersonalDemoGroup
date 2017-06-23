//
//  ViewController2.m
//  CopyAndPaste
//
//  Created by niit on 16/4/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()
{
    CGPoint curPoint;
    CGPoint posXY;
}
@property (nonatomic,strong) UIImageView *curMoveImageView;
@property (nonatomic,strong) UIImageView *curOpImageView;


@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

// 遍历self.view中的子视图,判断传入的点是不是在这个子视图的范围内
- (UIImageView *)imageViewAtPoint:(CGPoint)point
{
    for(int i=self.view.subviews.count-1;i>=0;i--)
    {
        UIImageView *imgView = self.view.subviews[i];
        if(CGRectContainsPoint(imgView.frame, point))
        {
            return imgView;
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    // 得到触摸点下面的虫子的视图
    self.curMoveImageView = [self imageViewAtPoint:point];
    if(self.curOpImageView!= nil)
    {
        CGPoint p = [touch locationInView:self.curOpImageView];
        posXY = CGPointMake(p.x-self.curOpImageView.frame.size.width/2, p.y-self.curOpImageView.frame.size.height/2);
    }

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    if(self.curOpImageView != nil)
    {
        self.curMoveImageView.center = CGPointMake(point.x-posXY.x, point.y-posXY.y);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.curMoveImageView = nil;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    self.curOpImageView = [self imageViewAtPoint:point];
    
    curPoint = point;
    
    if(touch.tapCount > 1)
    {
        // 菜单
        UIMenuController *menu = [UIMenuController sharedMenuController];
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
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIPasteboard generalPasteboard].image];
        [self.view addSubview:imageView];
        imageView.center = curPoint;
    }
}

- (void)up:(id)sender
{
//    [self.view addSubview:self.curOpImageView];
    [self.view bringSubviewToFront:self.curOpImageView];
}

- (void)down:(id)sender
{
    [self.view sendSubviewToBack:self.curOpImageView];
}

// 判断方法是否能狗执行,隐藏菜单中不能执行的菜单项
// (弹出菜单时候，会被调用)
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    NSLog(@"%s",action);
    if(@selector(paste:) == action)
    {
       if([UIPasteboard generalPasteboard].image != nil)
       {
           return YES;
       }
       else
       {
           return NO;
       }
    }
    if(@selector(copy:) == action || @selector(cut:) == action
       ||@selector(up:) == action || @selector(down:) == action)
    {
        if(self.curOpImageView != nil)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    return [super canPerformAction:action withSender:sender];
}


@end
