//
//  FavoriteViewController.h
//  ShiJia
//
//  Created by 蒋海量 on 16/6/29.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVideoListViewController.h"
/**
 *  收藏
 */
@interface FavoriteViewController : BaseVideoListViewController
@property (nonatomic, strong) NSString* pUid;       //好友uid，用于查询好友观看记录

@end
