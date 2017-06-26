//
//  NetManager.m
//  Net2
//
//  Created by student on 16/3/29.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "NetManager.h"

#import "def.h"
@implementation NetManager

+ (BOOL)loginWithUserName:(NSString *)username andPasswd:(NSString *)passwd{
    //地址str
    NSString *str = [NSString stringWithFormat:@"http://192.168.13.28:8080/MJServer/login?username=%@&pwd=%@&method=get&type=JSON",username ,passwd];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];//同步请求
    NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //数据解析
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if (dict[@"error"] !=nil) {
        return  NO;
    }else{
        return YES;
    }
}

+ (void)loginWithUserName:(NSString *)username
                andPasswd:(NSString *)passwd
             successBlock:(void(^)())successBlock
                failBlock:(void(^)(NSError *error))failBlock
{
    NSString *str = [NSString stringWithFormat:@"http://192.168.13.28:8080/MJServer/login?username=%@&pwd=%@&method=get&type=JSON",username,passwd];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    //异步请求
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError == nil) {
            NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (dict[@"error"] !=nil) {
                //定义一个NSError对象
                NSError *error = [NSError errorWithDomain:@"com.MQL.net2" code:kErrorLogin userInfo:@{NSLocalizedDescriptionKey:dict[@"error"]}];
                // 执行失败时要执行block代码
                failBlock(error);
            }else{
                // 成功时的block
                successBlock();
            }
        }
        else{
            failBlock(connectionError);
        }
    }];
}

/**
 *  请求电影列表
 *
 *  @param NSArray 请求成功是
 *
 *  @return <#return value description#>
 */

//+ (void)requestMoveListWithSuccessBlock:(void(^)(NSArray*))successBlock failBlock:(void(^)(NSError*)){
//    
//}

/**
 *  请求数据
 *
 *  @param urlStr       请求网址
 *  @param successBlock 请求成功时执行的block
 *  @param failBlock    获取失败时执行的block
 */
+ (void)requestInforWithUrlStr:(NSString *)urlStr
                 successBloack:(void(^)(NSData *))successBloack
                   faileBloack:(void(^)(NSError*))failBlock{
    //请求网址
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError == nil) {
            //请求成功
            successBloack(data);
        }else{
            //请求失败
            failBlock(connectionError);
        }
    }];
}



















@end
