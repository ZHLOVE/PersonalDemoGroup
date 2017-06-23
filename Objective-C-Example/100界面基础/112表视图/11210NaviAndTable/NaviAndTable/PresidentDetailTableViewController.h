//
//  PresidentDetailTableViewController.h
//  NaviAndTable
//
//  Created by niit on 16/3/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BIDPresident.h"

// 定义一个协议，通过协议让前一个页面刷新
@protocol PresidentDetailTableViewControllerDelegate <NSObject>

- (void)refresh;

@end

@interface PresidentDetailTableViewController : UITableViewController

// 定义一个属性用于前一个页面把数据传递过来
@property (nonatomic,weak) BIDPresident *pre;

// 定义一个代理人
@property (nonatomic,weak) id<PresidentDetailTableViewControllerDelegate> delegate;

@end
