//
//  MasterViewController.h
//  UISplitViewControllerDemo
//
//  Created by niit on 16/3/10.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "DetailViewController.h"

@interface MasterViewController : UITableViewController

// 创建了DetailViewController的弱引用，以便在程序中随时传递消息给他
@property (nonatomic,weak) DetailViewController *detailVC;

@end
