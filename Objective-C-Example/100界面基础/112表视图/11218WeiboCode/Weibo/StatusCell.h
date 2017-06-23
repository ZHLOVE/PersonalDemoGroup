//
//  StatusCell.h
//  Weibo
//
//  Created by niit on 16/3/8.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StatusModel.h"

@interface StatusCell : UITableViewCell

@property (nonatomic,strong) StatusModel *status;

- (CGFloat)cellHeight;

@end
