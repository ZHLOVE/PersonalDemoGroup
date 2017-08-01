//
//  MyListView.h
//  ShiJia
//
//  Created by 蒋海量 on 2017/3/13.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WatchListEntity.h"

@protocol MyListViewDelegate
-(void)goDetailVC:(WatchListEntity *)content;
    
@end
@interface MyListView : UIView
@property(nonatomic,assign) id<MyListViewDelegate>m_delegate;
- (void)p_reloadData;
@end
