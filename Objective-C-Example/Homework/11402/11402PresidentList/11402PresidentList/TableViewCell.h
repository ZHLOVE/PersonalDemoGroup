//
//  TableViewCell.h
//  11402PresidentList
//
//  Created by student on 16/3/10.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "President.h"
@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (nonatomic,weak) President *president;

@end
