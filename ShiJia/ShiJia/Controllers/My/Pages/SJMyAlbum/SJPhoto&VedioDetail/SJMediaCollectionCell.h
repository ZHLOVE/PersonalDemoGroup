//
//  SJMediaCollectionCell.h
//  ShiJia
//
//  Created by 峰 on 16/9/18.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJAlbumModel.h"

typedef void(^playCurrentVideo)(NSIndexPath *currentIndex);

@interface SJMediaCollectionCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath *currentIndex;

@property (nonatomic, copy) playCurrentVideo playVideo;
/**
 * 本地资源
 */
-(void)creatWithLocalModel:(ALAsset *)local andSourceType:(Media_TYPE )type;

/**
 * 云端资源
 */
-(void)creatWithCloudModel:(CloudPhotoModel *)cloud andSourceType:(Media_TYPE )type;




@end
