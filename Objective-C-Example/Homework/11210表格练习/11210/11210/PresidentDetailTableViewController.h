//
//  PresidentDetailTableViewController.h
//  11210
//
//  Created by student on 16/3/7.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIDPresident.h"

// 定义一个协议，通过协议让前一个页面刷新，以及传递数据给前一个页面
@protocol PresidentDetailTableViewControllerDelegate <NSObject>

- (void)refresh;

@end


@interface PresidentDetailTableViewController : UITableViewController

@property(nonatomic,weak) BIDPresident *pre;
@property(nonatomic,weak) id<PresidentDetailTableViewControllerDelegate> delegate;

@end
