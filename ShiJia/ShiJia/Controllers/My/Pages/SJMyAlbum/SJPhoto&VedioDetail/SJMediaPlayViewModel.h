//
//  SJMediaPlayViewModel.h
//  ShiJia
//
//  Created by 峰 on 16/9/5.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJAlbumModel.h"
#import "SJAlbumNetWork.h"

@interface SJMediaPlayViewModel : NSObject
/**
 *  删除图片或视频
 *
 *  @param model
 *
 *  @return
 */
-(RACSignal *)DeletePhotoOrVedios:(DeletePhotoRequestModel *)model;


@end
