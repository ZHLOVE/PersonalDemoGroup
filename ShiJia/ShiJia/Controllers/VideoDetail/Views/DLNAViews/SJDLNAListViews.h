//
//  SJDLNAListViews.h
//  ShiJia
//
//  Created by 峰 on 2017/3/14.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DLNAViewDelegate <NSObject>

@optional

-(void)DLNAViewButtonClickWithIndex:(NSInteger)index;
-(void)DLNAViewScreenActionWithType:(NSInteger)type;//type 1 为 DLNA设备 0 为自己电视投屏操作

@end


@interface SJDLNAListViews : UIView
-(void)ShowDLNAListViewsIn:(UIView *)superView;
-(void)HiddenDLNAListView;

@property (nonatomic, weak) id<DLNAViewDelegate>delegate;
@property (nonatomic, strong) NSString *currentVideoURL;

@end

