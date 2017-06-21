//
//  PunchesModel.h
//  WingsBurning
//
//  Created by MBP on 16/8/22.
//  Copyright © 2016年 leqi. All rights reserved.
//


/**
 *  「创建打卡」接口服务器响应
 */
#import <Foundation/Foundation.h>
#import "Punch.h"
#import "ImageUploadToken.h"
@interface PunchesModel : NSObject

@property(nonatomic,strong) Punch *punch;
@property(nonatomic,strong) ImageUploadToken *image_upload_token;

@end
