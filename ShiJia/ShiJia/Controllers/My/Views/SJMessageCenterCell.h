//
//  SJMessageCenterCell.h
//  ShiJia
//
//  Created by yy on 16/4/18.
//  Copyright © 2016年 yy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TPMessageCenterDataModel;

extern NSString * const kSJMessageCenterCellIdentifier;

@interface SJMessageCenterCell : UITableViewCell

@property (nonatomic, assign) BOOL isDeleting;
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, copy) void(^checkButtonClicked)(BOOL isChecked);
@property (nonatomic, copy) void(^deleteButtonClicked)(SJMessageCenterCell *sender);
- (void)showMessage:(TPMessageCenterDataModel *)model;

@end
