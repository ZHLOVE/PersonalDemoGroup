//
//  UIViewController+BackButtonHandler.h
//  mugshot
//
//  Created by junyu on 15/6/17.
//  Copyright (c) 2015年 dexter. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackButtonHandlerProtocol <NSObject>

@optional

// Override this method in UIViewController derived class to handle 'Back' button click

-(BOOL)navigationShouldPopOnBackButton;

@end

@interface UIViewController (BackButtonHandler) <BackButtonHandlerProtocol>

@end