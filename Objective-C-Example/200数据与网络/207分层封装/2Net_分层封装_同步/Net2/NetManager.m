//
//  NetManager.m
//  Net2
//
//  Created by niit on 16/3/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "NetManager.h"

#import "def.h"
#import "Video.h"

@implementation NetManager

/**
 *  登陆
 *
 *  @param username 用户名
 *  @param password 密码
 *
 *  @return 是否登陆
 */
+ (BOOL)loginWithUserName:(NSString *)username andPassword:(NSString *)password
{
    // 1. 请求数据
    NSString *str = [NSString stringWithFormat:@"http://192.168.13.28:8080/MJServer/login?username=%@&pwd=%@&method=get&type=JSON",username ,password];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];// 发送同步请求
    if(error != nil)
    {
        return NO;
    }
    // 2. 数据解析
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    //{"success":"登录成功"}
    //{"error":"密码不正确"}
    if(dict[@"error"] != nil)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

/**
 *  请求电影列表
 *
 *  @return 电影对象数组
 */
+ (NSArray *)requestMovieList
{
    // 1. 请求数据
    NSString *str = @"http://192.168.13.28:8080/MJServer/video?method=get&type=JSON";// 请求地址的字符串
    NSURL *url = [NSURL URLWithString:str];// 请求网址
    NSURLRequest *request = [NSURLRequest requestWithURL:url];// 请求
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];// 发送同步请求
    if(error != nil)// 请求有错误
    {
        return nil;// 返回空
    }

    // 2. 数据解析
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSArray *arr = dict[@"videos"];
    NSMutableArray *list = [NSMutableArray array];
    for(NSDictionary *d in arr)
    {
        Video *v = [Video videoWithDict:d];
        [list addObject:v];
    }
    return list;
}

@end
