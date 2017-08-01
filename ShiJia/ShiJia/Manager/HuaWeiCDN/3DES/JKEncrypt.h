//
//  main.m
//  3DES研究
//
//  Created by apple on 15/10/22.
//  Copyright © 2015年 apple. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface JKEncrypt : NSObject

/**字符串加密 */
+(NSString *)doEncryptStr:(NSString *)originalStr;
/**字符串解密 */
+(NSString*)doDecEncryptStr:(NSString *)encryptStr;
/**十六进制解密 */
+(NSString *)doEncryptHex:(NSString *)originalStr;
/**十六进制加密 */
+(NSString*)doDecEncryptHex:(NSString *)encryptStr;
/**十六进制转换为普通字符串的*/
+(NSString *)convertHexStrToString:(NSString *)str;
/**普通字符串转十六进制*/
+(NSString *)convertStringToHexStr:(NSString *)str ;
@end
