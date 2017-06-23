//
//  NetManager.m
//  Net2
//
//  Created by niit on 16/3/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "NetManager.h"

#import "def.h"

@implementation NetManager

// 单例
SingletonM(NetManager)

/**
 *  1. 登陆
 *
 *  @param username     用户名
 *  @param password     密码
 */
- (void)loginWithUserName:(NSString *)username
              andPassword:(NSString *)password
{
    // 请求地址的字符串
    NSString *str = [NSString stringWithFormat:@"http://192.168.13.28:8080/MJServer/login?username=%@&pwd=%@&method=get&type=JSON",username,password];
    
    [self requestInfoWithURLStr:str
                   successBlock:^(NSData *data) {
       // 处理数据
       NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
       if(dict[@"error"] != nil)
       {
           // 定义一个NSError对象
           NSError *error = [NSError errorWithDomain:@"com.niit.net2Demo"                           // 域
                                                code:kErrorLogin                                    // 错误编号
                                            userInfo:@{NSLocalizedDescriptionKey:dict[@"error"]}];  // 错误信息
           // 发登陆失败的通知
           [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginFail object:nil userInfo:@{@"error":error}];
       }
       else
       {
           // 登陆成功通知
           [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginSuccess object:nil userInfo:nil];
       }
    } faileBlock:^(NSError *error) {
        // 发登陆失败的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginFail object:nil userInfo:@{@"error":error}];

    }];
}

/**
 *  2. 获取电影列表
 *
 */
- (void)requestMovieList
{
    //
}

/**
 *  请求数据
 *
 *  @param urlStr       请求网址
 *  @param successBlock 请求成功时执行的block
 *  @param failBlock    获取失败时执行的block
 */
- (void)requestInfoWithURLStr:(NSString *)urlStr
                 successBlock:(void (^)(NSData *))successBlock
                   faileBlock:(void (^)(NSError *))failBlock
{
    // 请求网址
    NSURL *url = [NSURL URLWithString:urlStr];
    // 请求
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    // 发送异步请求
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if(connectionError == nil)
        {
            // 请求成功
            successBlock(data);
        }
        else
        {
            // 请求失败
            failBlock(connectionError);
        }
    }];
}

@end
