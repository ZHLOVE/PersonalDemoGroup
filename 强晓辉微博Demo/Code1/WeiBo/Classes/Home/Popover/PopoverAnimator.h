//
//  PopoverAnimator.h
//  WeiBo
//
//  Created by student on 16/4/26.
//  Copyright © 2016年 BNG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopoverAnimator : NSObject<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>

@property (nonatomic,assign) CGRect presentFrame;

@end
