//
//  UIViewController+NaviGradient.m
//  MqlNavi
//
//  Created by MBP on 2017/4/14.
//  Copyright © 2017年 leqi. All rights reserved.
//

#import "UIViewController+NaviGradient.h"
#import <objc/runtime.h>
#import "UINavigationController+Transparent.h"

@implementation UIViewController (NaviGradient)

//必须是C语言字符串
static char *CradientKey = "CradientKey";

/**
 使用runTime来关联属性，达到给UIViewController增加属性的目的
 */
- (void)setNavBarBgAlpha:(NSString *)navBarBgAlpha {
    objc_setAssociatedObject(self, CradientKey, navBarBgAlpha, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.navigationController.navBarBgAlpha = navBarBgAlpha;
}

- (NSString *)navBarBgAlpha {
    return objc_getAssociatedObject(self, CradientKey) ? : @"1.0";
}


@end
