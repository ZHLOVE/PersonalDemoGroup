//
//  TPDownloadVideoManager.h
//  HiTV
//
//  Created by yy on 15/10/28.
//  Copyright © 2015年 Lanbo Zhang. All rights reserved.
//
/**
 *  下载微视频类
*/
#import <Foundation/Foundation.h>

@interface TPDownloadVideoManager : NSObject

/**
 *  下载微视频
 *
 *  @param URL     视频url地址
 *  @param success 成功回调 已下载到本地返回本地path
 *  @param failure 失败回调
 */
- (void)downloadMp4FileWithURL:(NSURL *)URL success:(void (^)(NSURL* videoPath))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

@end
