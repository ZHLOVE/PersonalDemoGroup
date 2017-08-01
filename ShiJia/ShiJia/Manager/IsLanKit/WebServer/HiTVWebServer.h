//
//  HiTVWebServer.h
//  HiTV
//
//  Created by Lanbo Zhang on 1/10/15.
//  Copyright (c) 2015 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef GCDWebServer
#import <GCDWebServer/GCDWebServerFileResponse.h>
@import AssetsLibrary;

@interface AssetWebServerResponse : GCDWebServerFileResponse

- (instancetype)initWithAsset:(ALAssetRepresentation*) assetRepresentation
                 andByteRange:(NSRange)range;

@end
#endif
/**
 *  内置网络服务器支持
 */
@interface HiTVWebServer : NSObject

@property(nonatomic, copy) void(^block)(NSString*);
/**
 *  单例
 *
 *  @return 单例对象
 */
+ (instancetype)sharedInstance;

/**
 *  启动web服务器
 */
- (void)start;

/**
 *  停止web服务器
 */
- (void)stop;

/**
 *  本地资源地址和远程访问地址映射
 *
 *  @param localUrl 本地资源文件
 *  for video and image
 *  assets-library://asset/asset.MOV?id=336068EA-C1B1-481C-82DA-F2419561A91A&ext=MOV
 *
 *  for music
 *  ipod-library://item/item.mp3?id=-4017276016911605928
 *
 *  @return 电视访问的url
 */
- (NSString*)webURLForLocalUrl:(NSString*)localUrl;

@end
