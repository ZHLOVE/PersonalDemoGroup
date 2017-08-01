//
//  SJCloudPhotoViewModel.h
//  ShiJia
//
//  Created by 峰 on 16/9/3.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJAlbumModel.h"
#import "SJAlbumNetWork.h"


@interface SJCloudPhotoViewModel : NSObject

/**
 *  请求资源
 *
 *  @param model 请求参数
 *
 *  @return 请求结果 modelsarray Or error
 */
-(RACSignal *)QueryPhotoAndVedios:(CloudRequestPhotoModel *)model;

/**
 *  删除图片或视频
 *
 *  @param model
 *
 *  @return 
 */
-(RACSignal *)DeletePhotoOrVedios:(DeletePhotoRequestModel *)model;
/**
 *  添加图片或者视频
 *
 *  @param model
 *
 *  @return 
 */
-(RACSignal *)AddPhotoOrVedios:(AddPhotoRequestModel *)model;

@end
