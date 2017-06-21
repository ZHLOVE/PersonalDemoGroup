//
//  JYManager.h
//  SafeDarkVC
//
//  Created by M on 16/6/21.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAMPicContext.h"
#import "CAMBuffer.h"

@interface JYManager : NSObject

/**
 *  初始化
 */
-(void)chuShiHua;

/**
 *  计算人脸数
 *
 */
#define MY_MAX_PIXELS CGSizeMake(720, 960)//800,800//960,1280
-(int)renLianShu:(UIImage*)image;

/**
 *  计算区域
 */
-(void)jiSuanKuang;


/**
 *  设置图片
 */
-(void)sheZhiTuPian:(UIImage*)extImage;

/**
 *  打分
 */
-(NSArray *)daFeng;

@end
