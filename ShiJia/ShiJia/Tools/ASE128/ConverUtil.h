//
//  ConverUtil.h
//  HiTV
//
//  Created by 蒋海量 on 15/6/1.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConverUtil : NSObject
/**
 64编码
 */
+(NSString *)base64Encoding:(NSData*) text;
/**
 字节转化为16进制数
 */
+(NSString *) parseByte2HexString:(Byte *) bytes;
/**
 字节数组转化16进制数
 */
+(NSString *) parseByteArray2HexString:(Byte[]) bytes;
/*
 将16进制数据转化成NSData 数组
 */
+(NSData*) parseHexToByteArray:(NSString*) hexString;

@end
