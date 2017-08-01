//
//  UINavigationController+TopVC.m
//  OneTravel
//
//  Created by xiaochengfei on 15/8/5.
//  Copyright (c) 2015年 Didi.Inc. All rights reserved.
//

#import "UINavigationController+TopVC.h"

@implementation UINavigationController (TopVC)

/**
 *  get top vc of navgationcontroller
 */
- (id)getTopVC {
    if ([self.viewControllers count]) {
        if ([[self.viewControllers lastObject]isKindOfClass:[UINavigationController class]]){
            UINavigationController *nav = [self.viewControllers lastObject];
            [nav getTopVC];
        }else if ([[self.viewControllers lastObject]isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)[self.viewControllers lastObject];
        }
    }
    return nil;
}

@end
