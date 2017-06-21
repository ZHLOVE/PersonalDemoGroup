//
//  JYNetwork.m
//  SafeDark
//
//  Created by MBP on 16/6/18.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "JYNetwork.h"
#import "MD5.h"
#import "define.h"
#import "Sign.h"


@interface JYNetwork()

@end


@implementation JYNetwork



static NSString *appKey = nil;
static NSString *appSecret = nil;
//static NSString *specKey = nil;

static JYNetwork *instance = nil;  // 只初始化一次

+ (instancetype)sharedNetwork{
    // 保证线程安全
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[JYNetwork alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (instance == nil) {
        // 第一次的话保证alloc
        return [super allocWithZone:zone];
    }
    return [JYNetwork sharedNetwork]; // 其余返回已创建的
}

- (id)copyWithZone:(struct _NSZone *)zone {
    // copy只返回已创建的
    return [JYNetwork sharedNetwork];
}



- (void)setAppKey:(NSString *)ak
        appSecret:(NSString *)as

{
    appKey = ak;
    appSecret = as;

}

/**
 *  获取规格信息
 */
+ (void)getSpecInfoSignSpecKey:(NSString *)sk
                  SuccessBlock:(void (^)(NSDictionary *dict))successBlock
                     failBlock:(void (^)(NSString *errorMessage))failBlock

{
    NSString *baseUrl = @"https://api.sdk.camcap.us/";
    NSString *urlStr = [[baseUrl stringByAppendingPathComponent:@"specs"]stringByAppendingPathComponent:sk];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    Sign *s = [[Sign alloc]init];
    NSDictionary *paramsDict = [s creatSignWithAppKey:appKey appSecret:appSecret params:nil];
    [urlRequest addValue:[paramsDict objectForKey:X_App_Key] forHTTPHeaderField:X_App_Key];
    [urlRequest addValue:[paramsDict objectForKey:X_App_Signature] forHTTPHeaderField:X_App_Signature];
    [urlRequest addValue:[paramsDict objectForKey:X_Timestamp] forHTTPHeaderField:X_Timestamp];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (connectionError == nil) {
            successBlock(dict);
        }else{
            NSString *str = dict[@"message"];
            failBlock(str);
        }
    }];
}



/**
 *  创建证件照任务
 */
+ (void)createTask:(UIImage *)img
        BeginColor:(int)bc
          endColor:(int)ec
           SpecKey:(NSString *)sk
      successBlock:(void (^)(NSDictionary *dict))successBlock
        failBlock:(void (^)(NSString *errorMessage))failBlock
{
    NSString *baseUrl = @"https://api.sdk.camcap.us/";
    NSString *urlStr = [[baseUrl stringByAppendingPathComponent:@"tasks"]stringByAppendingPathComponent:@"create"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.HTTPMethod = @"POST";
    TaskRequest *task = [[TaskRequest alloc]init];
    NSDictionary *taskDict = [task taskRequestDataWithImage:img SpecKey:sk BeginColor:bc EndColor:ec];
    Sign *s = [[Sign alloc]init];
    NSDictionary *signParams = [s creatSignWithAppKey:appKey appSecret:appSecret params:taskDict];

    [urlRequest addValue:[signParams objectForKey:X_App_Key] forHTTPHeaderField:X_App_Key];
    [urlRequest addValue:[signParams objectForKey:X_App_Signature] forHTTPHeaderField:X_App_Signature];
    [urlRequest addValue:[signParams objectForKey:X_Timestamp] forHTTPHeaderField:X_Timestamp];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    urlRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:taskDict options:0 error:nil];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (connectionError == nil) {
            successBlock(dict);
        }else{
            NSString *str = dict[@"message"];
            failBlock(str);
        }
    }];
}

/**
 *  获取任务信息
 */
+ (void)getTaskState:(NSString *)taskId
        successBlock:(void (^)(NSDictionary *dict))successBlock
           failBlock:(void (^)(NSString *errorMessage))failBlock

{
    NSString *baseUrl = @"https://api.sdk.camcap.us/";
    NSString *urlStr = [[[baseUrl stringByAppendingPathComponent:@"tasks"]stringByAppendingPathComponent:taskId]stringByAppendingPathComponent:@"state"];
    NSURL *url = [NSURL URLWithString:urlStr];
    //签名
    Sign *s = [[Sign alloc]init];
    NSDictionary *signParams = [s creatSignWithAppKey:appKey appSecret:appSecret params:nil];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    //请求头
    [urlRequest addValue:[signParams objectForKey:X_App_Key] forHTTPHeaderField:X_App_Key];
    [urlRequest addValue:[signParams objectForKey:X_App_Signature] forHTTPHeaderField:X_App_Signature];
    [urlRequest addValue:[signParams objectForKey:X_Timestamp] forHTTPHeaderField:X_Timestamp];
    //异步请求
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (connectionError == nil) {
            successBlock(dict);
        }else{
            NSString *str = dict[@"message"];
            failBlock(str);
        }
    }];
}

/**
 *  创建订单
 */
+ (void)createOrder:(NSString *)taskId
      successBlock:(void (^)(NSDictionary *dict))successBlock
         failBlock:(void (^)(NSString *errorMessage))failBlock
{
    NSString *baseUrl = @"https://api.sdk.camcap.us/";
    NSString *urlStr = [[baseUrl stringByAppendingPathComponent:@"orders"]stringByAppendingPathComponent:@"create"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.HTTPMethod = @"POST";
    Sign *si = [[Sign alloc]init];
    NSDictionary *pa = @{@"task_id":taskId};
    NSDictionary *signParams = [si creatSignWithAppKey:appKey appSecret:appSecret params:pa];
    [urlRequest addValue:[signParams objectForKey:X_App_Key] forHTTPHeaderField:X_App_Key];
    [urlRequest addValue:[signParams objectForKey:X_App_Signature] forHTTPHeaderField:X_App_Signature];
    [urlRequest addValue:[signParams objectForKey:X_Timestamp] forHTTPHeaderField:X_Timestamp];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *params = @{@"task_id":taskId};
    urlRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (connectionError == nil) {
            successBlock(dict);
        }else{
            NSString *str = dict[@"message"];
            failBlock(str);
        }
    }];
}

/**
 * 获取订单对应的证件照
 */
+ (void)getURLofOrder:(NSString *)orderNo
           successBlock:(void (^)(NSDictionary *dict))successBlock
              failBlock:(void (^)(NSString *errorMessage))failBlock

{
    NSString *baseUrl = @"https://api.sdk.camcap.us/";
    NSString *urlStr = [[baseUrl stringByAppendingPathComponent:@"orders"]stringByAppendingPathComponent:orderNo];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    Sign *si = [[Sign alloc]init];
    NSDictionary *signParams = [si creatSignWithAppKey:appKey appSecret:appSecret params:nil];
    [urlRequest addValue:[signParams objectForKey:X_App_Key] forHTTPHeaderField:X_App_Key];
    [urlRequest addValue:[signParams objectForKey:X_App_Signature] forHTTPHeaderField:X_App_Signature];
    [urlRequest addValue:[signParams objectForKey:X_Timestamp] forHTTPHeaderField:X_Timestamp];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (connectionError == nil) {
            successBlock(dict);
        }else{
            NSString *str = dict[@"message"];
            failBlock(str);
        }
    }];
}


@end
