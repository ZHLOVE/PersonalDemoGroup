//
//  SJInvertUserViewController.h
//  ShiJia
//
//  Created by yy on 16/3/7.
//  Copyright © 2016年 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SJInviteUserViewModel;
@class TPIMUser;

@interface SJInviteUserViewController : UIViewController

@property (nonatomic, strong) SJInviteUserViewModel *viewModel;
@property (nonatomic, strong) NSArray <TPIMUser *> *disabledUserList;

@property (nonatomic, copy) void(^didSelectedUserList)(NSArray *list);

@end
