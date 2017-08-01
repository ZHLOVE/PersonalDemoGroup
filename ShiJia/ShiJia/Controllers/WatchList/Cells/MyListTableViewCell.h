//
//  MyListTableViewCell.h
//  ShiJia
//
//  Created by 峰 on 2017/5/9.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WatchListEntity.h"

@protocol MyListDelegate <NSObject>

@optional

-(void)refreshAfterDeleteCurrentRow;

@end

@interface MyListTableViewCell : UITableViewCell

@property (nonatomic, strong) WatchListEntity *cellEntity;
@property (nonatomic, assign) BOOL isLivingRow;
@property (nonatomic, assign) id<MyListDelegate>delegate;
@end
