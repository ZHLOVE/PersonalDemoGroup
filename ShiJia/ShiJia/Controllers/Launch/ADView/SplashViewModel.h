//
//  SplashViewModel.h
//  ShiJia
//
//  Created by 峰 on 2017/3/15.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "launchAdModel.h"

@interface SplashViewModel : NSObject
/**
 *  @brief 缓存的DATA
 */
@property (nonatomic, strong) NSData *CacheData;
/**
 *  @brief 需要下载的图片地址
 */
@property (nonatomic, strong) NSString *sourceURL;
/**
 *  @brief 图片是否是GIF
 */
@property (nonatomic, strong) launchAdModel *admodel;

@property (nonatomic, strong) launchAdModel *cacheModel;

@property (nonatomic, assign) BOOL downLoadSuccess;
@end
