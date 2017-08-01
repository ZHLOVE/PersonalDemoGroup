//
//  SJMessageSettingCell.h
//  ShiJia
//
//  Created by yy on 16/3/15.
//  Copyright © 2016年 yy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SJSwitch;

@interface SJMessageSettingCell : UITableViewCell

@property (nonatomic, strong, readonly) SJSwitch *rightSwitch;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *detailText;
@property (nonatomic,   copy) void (^switchValueChanged)(BOOL isOn);
//@property (nonatomic, assign) BOOL     SwitchOn;
- (void)setTheSwitch:(BOOL)boolValue;

@end
