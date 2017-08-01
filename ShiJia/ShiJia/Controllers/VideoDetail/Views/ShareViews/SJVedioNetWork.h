//
//  SJVedioNetWork.h
//  ShiJia
//
//  Created by 峰 on 16/7/13.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJ30SVedioRequestModel.h"

@interface SJVedioNetWork : NSObject
/**
 *  @brief 获取H5页面 Link
 *
 *  @param params
 *  @param block
 */
+(void)SJ_VedioCutManange:(id)params Block:(void(^)(id result ,NSString *error))block;

//-----------20170410-------------//
/**
 *  @author Allen, 17-04-05 10:04:14
 *
 *  @brief  	正片的的视频分享(公共接口对接SMS)
 *
 *  @param params
 *  @param block
 *
 *  @since 
 */
+(void)ShareSmsVideoWithParams:(SMSRequestParams *)params Block:(void(^)(SMSResponseModel *model ,NSString *error))block;
/**
 *  @author Allen, 17-04-10 14:04:51
 *
 *  @brief  本地文件频分享(公共接口对接SMS)
 *
 *  @param params
 *  @param completeBlock
 *
 *  @since
 */
+(void)ShareSMSLocalSource:(SMSLocalRequestParams *)params Block:(void(^)(SMSResponseModel *model ,NSString *error))completeBlock;


@end
