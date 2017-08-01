//
//  SJVideoRecommendCell.h
//  ShiJia
//
//  Created by yy on 16/6/20.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class SJVideoRecommendModel;
@class WatchListEntity;

extern NSString * const kSJVideoRecommendCellIdentifier;

@interface SJVideoRecommendCell : UICollectionViewCell

- (void)showData:(WatchListEntity *)data;


@end
