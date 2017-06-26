//
//  NetManageer.m
//  apiDemo3_block
//
//  Created by student on 16/3/29.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "NetManageer.h"

@implementation NetManageer


+ (void)requestInfoByPhone:(NSString *)phone
                 successBlock:(void(^)(NSString *result))successBlock
                    failBlock:(void(^)(NSError *error))failBlock{
    NSString *httpUrl = @"http://apis.baidu.com/apistore/mobilenumber/mobilenumber";
    NSString *httpArg = [NSString stringWithFormat:@"phone=%@",phone];
//    NSString *httpArg = @"phone=15210011578";
    NSString *urlStr = [[NSString alloc]initWithFormat:@"%@?%@",httpUrl,httpArg];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [request addValue:@"25b8643f96b223e777d88ee519141eb9" forHTTPHeaderField:@"apiKey"];
    NSError *error;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary *dict1 = dict[@"retData"];
           NSString *result = [NSString stringWithFormat:@"手机号码:%@\n运行商:%@\n省份:%@\n城市:%@\n",dict1[@"phone"],dict1[@"supplier"],dict1[@"province"],dict1[@"city"]];
            successBlock(result);
        }else{
            failBlock(connectionError);
        }
    }];
}


+ (void)requestInfoByCNY:(NSString *)CNY
              successBlock:(void(^)(NSDictionary *result))successBlock
                 failBlock:(void(^)(NSError *error))failBlock{
    NSString *httpUrl = @"http://apis.baidu.com/netpopo/exchange/single";
    NSString *httpArg = [NSString stringWithFormat:@"currency=%@",CNY];
    NSString *urlStr = [[NSString alloc]initWithFormat:@"%@?%@",httpUrl,httpArg];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [request addValue:@"25b8643f96b223e777d88ee519141eb9" forHTTPHeaderField:@"apiKey"];
    NSError *error;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary *dict1 = dict[@"result"];
            NSDictionary *dictList = dict1[@"list"];
                successBlock(dictList);
            
        }else{
            failBlock(connectionError);
        }
    }];
}

+ (void)requestWeatherInfoByCityName:(NSString *)cityName
            successBlock:(void(^)(NSDictionary *result))successBlock
               failBlock:(void(^)(NSError *error))failBlock{
    NSString *httpUrl = [NSString stringWithFormat:@"http://apistore.baidu.com/microservice/weather?cityname=%@",cityName];
    //转换编码格式，不然url带中文会为nil
    httpUrl = [httpUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:httpUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [request setHTTPMethod:@"GET"];
//    [request addValue:@"25b8643f96b223e777d88ee519141eb9" forHTTPHeaderField:@"apiKey"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary *dict1 = dict[@"retData"];
            successBlock(dict1);
            
        }else{
            failBlock(connectionError);
        }
    }];
}


@end
