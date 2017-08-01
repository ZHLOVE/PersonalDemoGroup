//
//  CircularlyView.h
//  ShiJia
//
//  Created by 峰 on 2017/3/6.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "homeModel.h"


@protocol CircularlyDelegate <NSObject>

@optional

- (void)CircularlyDidSelectItemAtIndex:(NSInteger)index;

- (void)CircularlyCurrentPageIndex:(NSInteger)pageNumber;

@end


@interface CircularlyView : UIView

@property (nonatomic, strong) NSArray<contents *> *dataSource;
@property (nonatomic, assign) NSTimeInterval rollTime;
@property (nonatomic, weak) id<CircularlyDelegate> delegate;
@end
