//
//  NetManager.m
//  WebServiceDemo
//
//  Created by niit on 16/3/31.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "NetManager.h"

#import "SoapHelper.h"

@implementation NetManager

+ (void)requestInfoByMobileId:(NSString *)mobileId
                 successBlock:(void (^)(NSDictionary *resultInfo))successBlock
                    failBlock:(void (^)(NSError *error))failBlock;
{
    NSString *urlStr = @"http://web.36wu.com/MobileService.asmx?op=GetMobileOwnership";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 设置请求体
    NSString *str = [SoapHelper makeSoapInfo:mobileId];
    NSLog(@"%@",str);
    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    // 设置请求的header
    [request addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(connectionError == nil)
        {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",str);
            
            NSDictionary *dict = [SoapHelper parseSoapInfo:data];
            successBlock(dict);
        }
        else
        {
            failBlock(connectionError);
        }
    }];
}
@end
