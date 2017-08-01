//
//  SJAlbumToolViewModel.h
//  ShiJia
//
//  Created by 峰 on 16/9/5.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SJAlbumModel.h"
#import "SJLocailFileResponseModel.h"
#import "SJ30SVedioRequestModel.h"


typedef void(^downPrecent)(NSInteger value);
@interface SJAlbumToolViewModel : NSObject

@property (nonatomic, strong) RACSubject *downSubject;
@property (nonatomic, copy) downPrecent downprecent;
/**
 *  投屏 本地文件投屏
 */
-(RACSignal *)localSourceScreenToTV:(NSString *)asset andSourceType:(Media_TYPE )type;

/**
 *  云资源投屏
 */
-(RACSignal *)cloudSourceScreenToTV:(CloudPhotoModel *)model andSourceType:(Media_TYPE )type;

/**
 *  上传本地资源
 */
-(RACSignal *)UpLoadLocalSourceModel:(ALAsset *)model andMediaType:(Media_TYPE )mediaType;

/**
 *  云资源下载
 */
-(void)downLoadCloudSource:(CloudPhotoModel *)model andSourceType:(Media_TYPE )type;

/**
 *  旋转图片
 */
-(RACSignal *)changeThePhotoOrotate:(NSString *)string andPhotoModel:(NSString *)model;

/**
 *  短视频生成H5页面
 */
-(RACSignal *)shortVideoToH5:(SJ30SVedioRequestModel *)Params;

/**
 *  上传到云相册
 */
//-(RACSignal *)upLoadLocalSourceToCloudAlbumPhoto:(Media_TYPE)type andSourceUrl:(NSString *)urlString;

-(RACSignal *)SMSShareLoaclSourceGenerationH5WebURL:(SMSLocalRequestParams *)params;

@end
