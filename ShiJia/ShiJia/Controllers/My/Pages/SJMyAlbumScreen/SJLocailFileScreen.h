//
//  SJLocailFileScreen.h
//  ShiJia
//
//  Created by 峰 on 16/7/7.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface SJLocailFileScreen : NSObject

/**
 *
 *
 *  @param params 本地文件路径
 *  @param type   文件类型 0 图片 1 视频
 *  @param block
 */
+(void)SJ_locailFileScreen:(ALAsset *)params
               andFileType:(int)type
                     Block:(void(^)(id result ,NSError *error,CGFloat percent))block;



- (NSString * )getSaveKeyWith:(NSString *)suffix;
/**
 *  上传资源到又拍云
 *
 *  @param params   图片 或者 资源路径
 *  @param fileType 0 图片 1 视频
 */
-(void)upLocalFile:(id)params
              type:(int)fileType
             Block:(void(^)(id result,NSError *error,CGFloat percent))HandlerCallBack;


//需要优化 上传本地视频到UCloud
-(void)UpLocalVideoALAsset:(ALAsset *)params
                     Block:(void(^)(id result,NSError *error,CGFloat percent))block;




//6.4 New======================================================================//
/**
 *  相册视频上传到UCloud
 */
-(void)SJFileUpLoadToUCloud_VideoSourceType:(ALAsset *)videoasset
                                  WithBlock:(void(^)(id result,NSError *error,CGFloat percent))block;             //
/**
 *  相册图片上传到UCloud
 */
-(void)SJFileUpLoadToUCloud_PhotoSourceType:(ALAsset *)photoasset
                                  WithBlock:(void(^)(id result,NSError *error,CGFloat percent))block;             //
/**
 *  短视频上传到UCloud
 */
-(void)SJFileUpSandboxToUCloud_PhotoSourceType:(NSData *)data
                                     WithBlock:(void(^)(id result,NSError *error,CGFloat percent))block;
//6.4 New======================================================================//


@end
