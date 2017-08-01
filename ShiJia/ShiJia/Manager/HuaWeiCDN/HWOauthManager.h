//
//  HWOauthManager.h
//  ShiJia
//
//  Created by 蒋海量 on 2017/3/21.
//  Copyright © 2017年 Ysten.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWVideoModel.h"

@interface HWOauthManager : NSObject

@property(nonatomic,strong) NSString *accessToken;   //访问令;


+ (instancetype)sharedInstance;

/**
 *   认证接口,获取当前手机应用对应的服务 器地址。手机应用在启动时请求。
 */
-(void)Authentication;

/**
 *   获取访问令牌
 */
-(void)getEncryToken;

/**
 *  内容播放授权
 *  @param content 播放内容
 *  @param handler 处理回调
 */
-(void)playContentAuthorize:(HWVideoModel *)content completion:(void(^)(NSString *playUrl,NSString *error))handler;

/**
 *   更新访问令牌
 */
-(void)toUpdateAccessToken;
@end
