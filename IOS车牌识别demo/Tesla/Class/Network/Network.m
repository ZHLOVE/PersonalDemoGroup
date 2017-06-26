//
//  Network.m
//  Tesla
//
//  Created by MBP on 16/7/21.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "Network.h"
#import "AFNetworking.h"
#import "Verify.h"
#import "MD5.h"
@interface Network()

@end

@implementation Network


static Network *instance = nil;  // 只初始化一次
static NSString *apiAccount = nil;
static NSString *apiPasswd = nil;
static NSString *apiPasswdMD5 = nil;
static NSString *uuid = nil;

+ (instancetype)sharedNetwork{
    // 保证线程安全
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[Network alloc] init];
    });
    return instance;
}


+ (void)setApiAccount:(NSString *)account
            ApiPasswd:(NSString *)passwd
                 uuid:(NSString *)u{
    apiAccount = account;
    apiPasswd = passwd;
    apiPasswdMD5 = [MD5 md5:passwd];
    uuid = u;
}



+ (void)licensePlateImage:(UIImage *)image
                      ext:(NSString *)ext
             successBlock:(void (^)(NSDictionary *responseObject))successBlock
                failBlock:(void (^)(NSError *error))failBlock
{
    //将图片转为data数据
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    //将数据转为base64字符串
    NSString *dataFile = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *time = [Verify getTimestamp];
    NSString *verify = [Verify getVerifyWithApiAccount:apiAccount apiPasswd:apiPasswd uuid:uuid time:time];
//    NSString *urlStr = @"http://httpbin.org/post";
//    NSString *urlStr = @"http://192.168.1.134:8002/chepai";
    NSString *urlStr = @"http://120.76.157.6:6667/chepai";
    NSDictionary *requestDict = @{@"type":@"chepai",
                           @"api_account":apiAccount,
                           @"api_password":apiPasswdMD5,
                           @"uuid":uuid,
                           @"time":time,
                           @"verify":verify,
                           @"file":dataFile,
                           @"ext":ext};

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer ];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:urlStr parameters:requestDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功");
        NSLog(@"%@",responseObject);
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];
}
@end



