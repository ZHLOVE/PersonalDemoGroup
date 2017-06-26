//
//  NetManager.m
//  Net2_Delegate
//
//  Created by student on 16/3/30.
//  Copyright © 2016年 马千里. All rights reserved.
//
#import "def.h"
#import "NetManager.h"

@implementation NetManager

// 单例
SingletonM(NetManager)

/**
 *  1. 登陆
 *
 *  @param username     用户名
 *  @param password     密码
 */
- (void)loginWithUserName:(NSString *)userName
                andPasswd:(NSString *)passwd{
    NSString *str = [NSString stringWithFormat:@"http://192.168.13.28:8080/MJServer/login?username=%@&pwd=%@&method=get&type=JSON",userName,passwd];
   
    [self requestInfoWithURLStr:str successBlock:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if (dict[@"error"]!=nil) {
            //定义一个NSError对象
            NSError *error = [NSError errorWithDomain:@"com.mql.net2Demo" code:kErrorLogin userInfo:@{NSLocalizedDescriptionKey:dict[@"error"]}];
 
            //发送登陆失败的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginFail object:nil userInfo:@{@"error":error}];
        }else{
            //发送登陆成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginSuccess object:nil userInfo:nil];
        }
        
    } failBlock:^(NSError *error) {
        //发送登陆失败的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginFail object:nil userInfo:@{@"error":error}];
    }];
    

}


/**
 *  2. 获取电影列表
 *
 *  @param successBock 获取成功时执行的block
 *  @param failBlock   获取失败时执行的block
 */
- (void)requestMovieList{
    
}

/**
 *  请求数据
 *
 *  @param urlStr       请求网址
 *  @param successBlock 请求成功时执行的block
 *  @param failBlock    获取失败时执行的block
 */
- (void)requestInfoWithURLStr:(NSString *)urlStr successBlock:(void(^)(NSData *data))successBlock failBlock:(void(^)(NSError *error))failBlock
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
