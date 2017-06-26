//
//  BaseViewController.h
//  Weibo
//
//  Created by qiang on 4/22/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserAccount.h"

@class VisitorView;

@interface BaseViewController : UITableViewController

// 访客视图
@property (nonatomic,strong) VisitorView *vistorView;

@end
