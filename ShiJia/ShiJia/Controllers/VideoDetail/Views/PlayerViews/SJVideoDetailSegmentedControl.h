//
//  SJVideoDetailSegmentedControl.h
//  ShiJia
//
//  Created by yy on 16/3/10.
//  Copyright © 2016年 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kSJVideoDetailSegmentedControlItemTitleKey;
extern NSString * const kSJVideoDetailSegmentedControlItemBadgeKey;

@interface SJVideoDetailSegmentedControlItem : UIControl

//标题
@property (nonatomic, copy)   NSString *title;

//标记
@property (nonatomic, assign) NSInteger badge;


@property (nonatomic, copy) void(^didSelectItemBlock)(SJVideoDetailSegmentedControlItem *);

@end


@interface SJVideoDetailSegmentedControl : UIControl

@property (nonatomic, strong) NSArray        *items;
@property (nonatomic, strong) UIViewController *activeController;
@property (nonatomic, assign) NSInteger selectedSegmentIndex;

- (instancetype)initWithItems:(NSArray *)array;


@end
