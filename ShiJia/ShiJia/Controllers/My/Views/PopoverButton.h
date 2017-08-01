//
//  PopoverButton.h
//  TakeoutUserApp
//
//  Created by iss on 14-8-25.
//  Copyright (c) 2014年 YouYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HiTVDeviceInfo;
@class PopoverButton;

@protocol PopoverButtonDelegate<NSObject>

@optional
- (void)popoverButton:(PopoverButton *)sender didSelectItemAtIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger,ButtonEventType)
{
    ButtonEventType_ShowList,//显示列表
    ButtonEventType_Custom   //用户自定义
};

typedef NS_ENUM(NSInteger, PopoverButtonSelectState)
{
    PopoverButtonSelectState_SelectNone,
    PopoverButtonSelectState_SelectAll,
    PopoverButtonSelectState_Custom

};

@interface PopoverButton : UIView

/**
 *  @author youyan, 15-05-28 15:05:31
 *
 *  标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  @author youyan, 15-05-28 15:05:50
 *
 *  tableview 要显示的数据
 */
@property (nonatomic, retain) NSArray *list;

/**
 *  @author youyan, 15-05-28 15:05:20
 *
 *  标题文字颜色
 */
@property (nonatomic, retain) UIColor *textColor;

/**
 *  @author youyan, 15-06-01 15:06:26
 *
 *  标题文字字体
 */
@property (nonatomic, retain) UIFont *font;

/**
 *  @author youyan, 15-05-28 15:05:41
 *
 *  标题后向上的箭头图标
 */
@property (nonatomic, retain) UIImage *upArrowImage;

/**
 *  @author youyan, 15-05-28 15:05:41
 *
 *  标题后向下的箭头图标
 */
@property (nonatomic, retain) UIImage *downArrowImage;

/**
 *  文字前icon图片
 */
@property (nonatomic, retain) UIImage *iconImage;

@property (nonatomic, assign) ButtonEventType buttonEventType;
@property (nonatomic, weak) IBOutlet id<PopoverButtonDelegate>delegate;


@property (nonatomic, retain) HiTVDeviceInfo *selectedDevice;

@property (nonatomic, assign) PopoverButtonSelectState selectState;


@property (nonatomic, copy) void(^buttonClickEventBlock)();


@end


