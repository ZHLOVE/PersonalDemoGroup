//
//  LMJKeyboardShowHiddenNotificationCenter.h
//
//  Created by MajorLi on 15/3/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LMJKeyboardShowHiddenNotificationCenterDelegate <NSObject>

- (void)showOrHiddenKeyboardWithHeight:(CGFloat)height withDuration:(CGFloat)animationDuration isShow:(BOOL)isShow;

@end

@interface LMJKeyboardShowHiddenNotificationCenter : NSObject

+ (LMJKeyboardShowHiddenNotificationCenter *)defineCenter;

@property (nonatomic,assign) id <LMJKeyboardShowHiddenNotificationCenterDelegate> delegate;

// 在对象dealloc时候调用
- (void)closeCurrentNotification;

@end
