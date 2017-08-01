//
//  VideoCollectionViewCell.h
//  HiTV
//
//  created by iSwift on 3/8/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoSummary.h"

extern NSString * const cVideoCollectionViewCellID;

/**
 *  首页以及分类显示的具体视频信息
 */
@interface VideoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) VideoSummary* video;

@end
