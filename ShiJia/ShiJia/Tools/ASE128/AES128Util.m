//
//  AES128Util.m
//  ASE128Demo
//
//  Created by zhenghaishu on 11/11/13.
//  Copyright (c) 2013 Youku.com inc. All rights reserved.
//

#import "AES128Util.h"
#import <CommonCrypto/CommonCryptor.h>
#import <GTMBase64/GTMBase64.h>
#import "ConverUtil.h"
#include <iconv.h>
#import "NSData+AES.h"


@implementation AES128Util

+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];

    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        return [GTMBase64 stringByEncodingData:resultData];

    }
    free(buffer);
    return nil;
}


+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key
{

    NSData *data = [ConverUtil parseHexToByteArray:encryptText];

    NSData *decreptedData=[data AES128DecryptedDataWithKey:key];
    NSString *str2 = [[NSString alloc] initWithData:decreptedData encoding:NSUTF8StringEncoding];
    return str2;
//    char keyPtr[kCCKeySizeAES256 + 1];
//    memset(keyPtr, 0, sizeof(keyPtr));
//    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
//
//    NSData *data = [ConverUtil parseHexToByteArray:encryptText];
//    NSUInteger dataLength = [data length];
//    size_t bufferSize = dataLength;
//    void *buffer = malloc(bufferSize);
//
//    size_t numBytesCrypted = 0;
//    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
//                                          kCCAlgorithmAES128,
//                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
//                                          keyPtr,
//                                          kCCBlockSizeAES128,
//                                          NULL,
//                                          [data bytes],
//                                          dataLength,
//                                          buffer,
//                                          bufferSize,
//                                          &numBytesCrypted);
//    if (cryptStatus == kCCSuccess) {
//        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:strlen((char*)buffer)];
//        //NSString *result = [[NSString alloc] initWithBytes:buffer length:strlen((char*)buffer)encoding:NSUTF8StringEncoding];
//        NSMutableData *data = [[NSMutableData alloc]initWithData:resultData];
//        NSInteger c = resultData.length%4;
//
//        if (c>0) {
//            resultData = [data subdataWithRange:NSMakeRange(0, resultData.length-c)];
//        }
//        NSString *result = [[NSString alloc] initWithData:[self cleanUTF8:resultData] encoding:NSUTF8StringEncoding];
//        return result;
//
//    }
//    free(buffer);
//    return nil;
}
+(NSString *)AESNES128Decrypt:(NSString *)encryptText key:(NSString *)key{
    NSData *data = [ConverUtil parseHexToByteArray:encryptText];

    NSData *decreptedData=[data AES128DecryptedDataWithKey:key];
    NSString *str2 = [[NSString alloc] initWithData:decreptedData encoding:NSUTF8StringEncoding];
    return str2;
}


+(NSData *)cleanUTF8:(NSData *)data {
    iconv_t cd = iconv_open("UTF-8", "UTF-8"); // 从utf8转utf8
    int one = 1;
    iconvctl(cd, ICONV_SET_DISCARD_ILSEQ, &one); // 丢弃不正确的字符

    size_t inbytesleft, outbytesleft;
    inbytesleft = outbytesleft = data.length;
    char *inbuf  = (char *)data.bytes;
    char *outbuf = malloc(sizeof(char) * data.length);
    char *outptr = outbuf;
    if (iconv(cd, &inbuf, &inbytesleft, &outptr, &outbytesleft)
        == (size_t)-1) {
        DDLogInfo(@"this should not happen, seriously");
        return nil;
    }
    NSData *result = [NSData dataWithBytes:outbuf length:data.length - outbytesleft];
    iconv_close(cd);
    free(outbuf);
    return result;
}
@end
