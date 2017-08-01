//
//  NSString+Conversion.h
//  HiTV
//
//  Created by yy on 15/8/24.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Conversion)

/**
 *  汉字转拼音
 *
 *  @return 返回拼音字符串
 */
- (NSString *)convertChineseToPinYin;

/**
 *  大写转小写并去掉特殊字符
 *
 *  @return 返回处理后的字符串
 */
- (NSString *)lowercaseStringWithoutIllegalcharacters;

/**
 *  生成uuid
 *
 *  @return uuid
 */
+ (NSString *)generateUUID;


/**
 去空格
 */
- (NSString *)replaceJSONStrToStr:(NSString *)str;

@end
