//
//  SJVideoPlayerSeriesView.h
//  ShiJia
//
//  Created by yy on 16/4/15.
//  Copyright © 2016年 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const kSeriesItemViewWidth;
extern NSInteger const kSeriesColumnCount;

typedef NS_ENUM(NSInteger, SJSeriesViewStyle)
{
    SJSeriesViewStyleCollectionView,
    SJSeriesViewStyleTableView
};

@interface SJVideoPlayerSeriesView : UIView

@property (nonatomic, copy) void(^didSelectVideoAtIndex)(NSInteger index);
@property (nonatomic, assign) NSInteger currentVideoIndex;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, assign) BOOL descending;

//- (instancetype)initWithSeriesCount:(NSInteger)count;
- (instancetype)initWithSeriesList:(NSArray *)list style:(SJSeriesViewStyle)seriesStyle;

- (void)showInView:(UIView *)view;

- (void)hide;
-(void)handle_dealloc;
@end
