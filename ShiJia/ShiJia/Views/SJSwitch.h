//
//  YYSwitch.h
//  ShiJia
//
//  Created by yy on 16/3/15.
//  Copyright © 2016年 yy. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface SJSwitch : ASControlNode

@property (nonatomic, strong) UIColor *onTintColor;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *thumbTintColor;

@property (nonatomic, strong) UIImage *onImage;
@property (nonatomic, strong) UIImage *offImage;

@property (nonatomic, copy)   NSString *onText;
@property (nonatomic, copy)   NSString *offText;

@property (nonatomic,getter=isOn) BOOL on;
@property (nonatomic, assign) BOOL changeValueAfterAction;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
