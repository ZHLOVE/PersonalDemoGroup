//
//  VisitorView.h
//  WeiBo
//
//  Created by student on 16/4/22.
//  Copyright © 2016年 BNG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  VisitorViewDelegate<NSObject>

- (void)loginBtnWillPressed;
- (void)registerBtnWillPressed;

@end

@interface VisitorView : UIView

@property(nonatomic,weak) id<VisitorViewDelegate> delegate;
- (void)setupVisitorInfo:(BOOL)isHome imageName:(NSString *)imageName message:(NSString *)message;
@end
