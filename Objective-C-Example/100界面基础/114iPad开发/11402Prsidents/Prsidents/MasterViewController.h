//
//  MasterViewController.h
//  Prsidents
//
//  Created by niit on 16/3/11.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@interface MasterViewController : UITableViewController

@property (nonatomic,weak) DetailViewController *detailVC;

@end
