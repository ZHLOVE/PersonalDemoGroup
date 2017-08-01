//
//  SJVideoRecommendView.h
//  ShiJia
//
//  Created by yy on 16/6/20.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJVideoRecommendView : UIView

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong, readonly) UICollectionView *collectionview;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, copy) void(^didSelectRecommendItemAtIndex)(NSInteger index);
@property (nonatomic, assign) BOOL canSelected;
@end
