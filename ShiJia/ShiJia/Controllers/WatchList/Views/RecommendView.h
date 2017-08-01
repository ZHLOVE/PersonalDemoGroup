//
//  RecommendView.h
//  ShiJia
//
//  Created by 蒋海量 on 2017/3/13.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WatchListEntity.h"

@protocol RecommendViewDelegate
-(void)goDetailVC:(WatchListEntity *)content;
    
@end
@interface RecommendView : UIView
@property(nonatomic,assign) id<RecommendViewDelegate>m_delegate;

@end
