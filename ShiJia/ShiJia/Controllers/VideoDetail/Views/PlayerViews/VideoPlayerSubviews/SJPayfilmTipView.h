//
//  SJPayfilmTipView.h
//  ShiJia
//
//  Created by 蒋海量 on 16/9/3.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    ShowTypeMax,
    ShowTypeMin,
    ShowTypeFull
} ShowType;

@interface SJPayfilmTipView : UIView
@property (nonatomic, copy) void(^buyButtonClickBlock)();
@property (nonatomic, assign) ShowType showType;

-(void)setTipMessage:(NSString *)message andBuyBtnTitle:(NSString *)title;
@end
