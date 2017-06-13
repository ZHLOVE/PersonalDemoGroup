//
//  Network.h
//  Tesla
//
//  Created by MBP on 16/7/21.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Network : NSObject


/**
 *  创建单例
 */
+ (instancetype)sharedNetwork;

/**
 *  设置账号密码
 *
 *  @param ak appKey
 *  @param sk specKey
 */
+ (void)setApiAccount:(NSString *)account
            ApiPasswd:(NSString *)passwd
                 uuid:(NSString *)uuid;

/**
 *  请求车牌识别
 *
 *  @param image        车牌图片
 *  @param ext          图片格式
 *  @param successBlock 请求成功
 *  @param failBlock    请求失败
 */
+ (void)licensePlateImage:(UIImage *)image
                      ext:(NSString *)ext
             successBlock:(void (^)(NSDictionary *responseObject))successBlock
                failBlock:(void (^)(NSError *error))failBlock;
@end
