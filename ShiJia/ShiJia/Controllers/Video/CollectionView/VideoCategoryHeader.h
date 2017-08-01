//
//  AttachedFileHeader.h
//  SelfService
//
//  created by iSwift on 12/25/13.
//  Copyright (c) 2013 Exigen Insurance Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCategory.h"

extern NSString * const cVideoCategoryHeaderID;

/**
 *  首页以及分类显示里面的表头，如“高清电影”等
 */
@interface VideoCategoryHeader : UICollectionReusableView

@property (strong, nonatomic) VideoCategory* videoCategory;

@end
