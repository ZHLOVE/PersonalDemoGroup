//
//  SJSettingTableViewCell.h
//  ShiJia
//
//  Created by yy on 16/3/14.
//  Copyright © 2016年 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger, SJSettingTableViewCellStyle){
//    SJSettingTableViewCellStyleTitle,
//    SJSettingTableViewCellStyleTitleAndDetail,
//};

@interface SJSettingCell : UITableViewCell

@property (nonatomic,   copy) NSString *title;
@property (nonatomic,   copy) NSString *detail;
@property (nonatomic, assign) BOOL     showSwitch;
@property (nonatomic, assign) BOOL     SwitchOn;
@property (nonatomic,   copy) void (^switchValueChanged)(BOOL isOn);


@end
