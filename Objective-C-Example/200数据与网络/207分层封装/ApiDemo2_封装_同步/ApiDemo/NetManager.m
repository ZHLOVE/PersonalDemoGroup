//
//  NetManager.m
//  ApiDemo
//
//  Created by niit on 16/3/29.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "NetManager.h"

@implementation NetManager

+ (NSString *)requestInfoByPersonId:(NSString *)personId
{
    NSString *httpUrl = @"http://apis.baidu.com/apistore/idservice/id";
    NSString *httpArg = [NSString stringWithFormat:@"id=%@",personId];
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    // 设置请求头
    [request addValue: @"60defbd45a27b44aee82ba6755c9a9c3" forHTTPHeaderField: @"apikey"];
    
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if(error != nil)
    {
        return nil;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary *dict1 = dict[@"retData"];
    NSString *result = [NSString stringWithFormat:@"生日:%@\n地址:%@\n性别:%@",dict1[@"birthday"],dict1[@"address"],dict1[@"sex"]];
    
    return result;
}

@end
