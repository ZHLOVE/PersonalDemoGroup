//
//  PopoverAnimator.m
//  WeiBo
//
//  Created by student on 16/4/26.
//  Copyright © 2016年 BNG. All rights reserved.
//

#import "PopoverAnimator.h"
#import "def.h"
#import "PopoverPresentationController.h"

@interface PopoverAnimator()
{
    BOOL isPresent;// 是否弹出
}

@end
@implementation PopoverAnimator
#pragma mark - 转场动画
// 告诉系统谁来负责转场动画
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    PopoverPresentationController *pc = [[PopoverPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    pc.presentFrame = self.presentFrame;
    return pc;
}

// 谁类负责弹出动画
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    isPresent = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNontificationPopoverWillShow object:nil userInfo:nil];
    return self;
}

// 谁来负责消失动画
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    isPresent = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNontificationPopoverWillDismiss object:nil userInfo:nil];
    return self;
}

#pragma mark - 动画效果
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
// 具体动画怎么进行
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if (isPresent) {
        //1 拿到要展现的视图
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.transform = CGAffineTransformMakeScale(1.0, 0.0); //缩小到不显示
        toView.layer.anchorPoint = CGPointMake(0, 0);//锚点
        //2将要展现的视图添加到容器上
        [[transitionContext containerView] addSubview:toView];
        //3 执行动画
        [UIView animateWithDuration:0.4 animations:^{
            toView.transform = CGAffineTransformIdentity; //重置下变正常;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];//告诉系统执行完了
        } ];
    }else{
        //关闭
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        [UIView animateWithDuration:0.4 animations:^{
            fromView.alpha = 0;
        }completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];//告诉系统执行完了
        }];
    }    
}

@end
