//
//  SJSetFavoriteCell.h
//  ShiJia
//
//  Created by yy on 16/6/14.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WatchListEntity;

extern NSString *kSJSetFavoriteCellIdentifier;

@interface SJSetFavoriteCell : UICollectionViewCell

@property (nonatomic, assign) BOOL checked;
@property (nonatomic, copy) void (^checkButtonClickBlock)(SJSetFavoriteCell *);

- (void)showData:(WatchListEntity *)data;

@end
