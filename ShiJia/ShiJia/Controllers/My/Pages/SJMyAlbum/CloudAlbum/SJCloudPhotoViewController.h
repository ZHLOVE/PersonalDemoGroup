//
//  SJCloudPhotoViewController.h
//  ShiJia
//
//  Created by 峰 on 16/8/31.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "BaseViewController.h"
#import "SJAlbumModel.h"

@interface SJCloudPhotoViewController : BaseViewController
/**
 *  当前相册的名字
 */
@property (nonatomic, strong) NSString *cloudAlbumName;
/**
 *  当前云相册对象
 */
@property (nonatomic, strong) CloudAlbumModel *AlbumModel;

@end
