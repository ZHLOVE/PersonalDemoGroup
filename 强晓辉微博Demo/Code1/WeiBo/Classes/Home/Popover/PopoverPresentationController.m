//
//  PopoverPresentationController.m
//  WeiBo
//
//  Created by student on 16/4/26.
//  Copyright © 2016年 BNG. All rights reserved.
//

#import "PopoverPresentationController.h"

@implementation PopoverPresentationController
//布局转场子视图调用
- (void)containerViewDidLayoutSubviews{
    //1修改弹出视图的消息
//    self.presentedView.frame = CGRectMake(100, 50, 200, 200);
    self.presentedView.frame = self.presentFrame;
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    bgView.frame = [UIScreen mainScreen].bounds;
    //2容器视图,添加蒙版视图插入到最下面
    [self.containerView insertSubview:bgView atIndex:0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDo:)];
    [bgView addGestureRecognizer:tap];
}
- (void)tapDo:(UITapGestureRecognizer *)tap{
   [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
