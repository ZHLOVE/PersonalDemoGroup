//
//  FriendsWatchView.h
//  ShiJia
//
//  Created by 蒋海量 on 2017/3/13.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WatchListEntity.h"
typedef void (^GetFriendsDataBlock)(NSArray *list);

@protocol FriendsWatchViewDelegate
-(void)goDetailVC:(WatchListEntity *)content;
    
@end
@interface FriendsWatchView : UIView
@property(nonatomic,assign) id<FriendsWatchViewDelegate>m_delegate;
@property (nonatomic, strong) GetFriendsDataBlock getFriendsDataBlock;

@end
