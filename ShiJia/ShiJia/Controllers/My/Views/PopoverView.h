//
//  PopoverView.h
//  HiTV
//
//  Created by yy on 15/9/9.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HiTVDeviceInfo;
@class PopoverView;

typedef NS_ENUM(NSInteger, PopoverViewSelectState)
{
    PopoverViewSelectState_SelectNone,
    PopoverViewSelectState_SelectAll,
    PopoverViewSelectState_Custom
};

@protocol PopoverViewDelegate<NSObject>

- (void)popoverView:(PopoverView *)sender didSelectCellAtIndex:(NSInteger)index;
- (void)hidePopoverView;

@end

@interface PopoverView :UIView

@property (nonatomic, retain) NSArray *list;
@property (nonatomic, assign) CGFloat originY;
@property (nonatomic, weak) id<PopoverViewDelegate>delegate;
@property (nonatomic, retain) HiTVDeviceInfo *selectedDevice;
@property (nonatomic, assign) PopoverViewSelectState selectState;

- (id)initWithItems:(NSArray *)items;

- (void)showPopoverView;

- (void)hidePopoverView;

@end
