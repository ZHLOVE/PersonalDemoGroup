//
//  RecentViewController.h
//  HiTV
//
//  created by iSwift on 3/9/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "BaseVideoListViewController.h"

/**
 *  最近访问过的视频
 */
@interface RecentViewController : BaseVideoListViewController
//add by jhl 20150909
@property (nonatomic, strong) NSString* pUid;       //好友uid，用于查询好友观看记录
//end
@end
