//
//  TableListViewController.h
//  11402PresidentList
//
//  Created by student on 16/3/10.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresidentDetail.h"
@interface TableListViewController : UITableViewController

@property (nonatomic,strong) PresidentDetail *preDetail;
@property (nonatomic,strong) NSArray *presidentsArray;
@end
