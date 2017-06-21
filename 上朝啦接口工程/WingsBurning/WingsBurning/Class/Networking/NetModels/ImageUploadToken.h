//
//  ImageUploadToken.h
//  WingsBurning
//
//  Created by MBP on 16/8/22.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  上传七牛云用的令牌
 */
@interface ImageUploadToken : NSObject

/**
 *  上传令牌对应的文件 Key
 */
@property(nonatomic,copy) NSString *key;

/**
 *  上传令牌本身
 */
@property(nonatomic,copy) NSString *token;
@end
