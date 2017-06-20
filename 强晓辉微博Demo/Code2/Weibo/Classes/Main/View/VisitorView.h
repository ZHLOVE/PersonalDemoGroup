//
//  VisitorView.h
//  Weibo
//
//  Created by qiang on 4/22/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import <UIKit/UIKit.h>

// 登录、注册按钮的代理方法
@protocol VisitorViewDelegate <NSObject>

- (void)loginBtnWillPressed;
- (void)registerBtnWillPressed;

@end

@interface VisitorView : UIView

// 登录、注册按钮事件处理的代理人
@property (nonatomic,weak) id<VisitorViewDelegate> delegate;

// 设置访客视图的信息
- (void)setupVisitorInfo:(BOOL)isHome imageName:(NSString *)imageName message:(NSString *)message;

@end
