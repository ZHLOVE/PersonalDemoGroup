//
//  NetManageer.m
//  apiDemo3_block
//
//  Created by student on 16/3/29.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "NetManageer.h"

@implementation NetManageer


+ (void)requestInfoByPersonId:(NSString *)personId
                 successBlock:(void(^)(NSString *))successBlock
                    failBlock:(void(^)(NSError *))failBlock{
    NSString *httpUrl = @"http://apis.baidu.com/apistore/idservice/id";
    NSString *httpArg = [NSString stringWithFormat:@"id=%@",personId];
    NSString *urlStr = [[NSString alloc]initWithFormat:@"%@?%@",httpUrl,httpArg];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [request addValue:@"25b8643f96b223e777d88ee519141eb9" forHTTPHeaderField:@"apiKey"];
    NSError *error;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary *dict1 = dict[@"retData"];
           NSString *result = [NSString stringWithFormat:@"生日:%@\n地址:%@\n性别:%@",dict1[@"birthday"],dict1[@"address"],dict1[@"sex"]];
            successBlock(result);
        }else{
            failBlock(connectionError);
        }
    }];
}



@end
