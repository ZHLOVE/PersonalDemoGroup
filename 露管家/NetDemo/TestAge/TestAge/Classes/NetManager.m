//
//  NetMananger.m
//  TestAge
//
//  Created by niit on 16/4/11.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "NetManager.h"
#import "AnalysisHelper.h"

#import <AFNetworking.h>

@implementation NetManager

//1. 搜索图片
+ (void)searchImagesByName:(NSString *)name
              successBlok:(void (^)(NSArray *imgList))successBlock
                 failBlok:(void (^)(NSError *error))failBlock
{
    // 网址
    NSString *urlStr = [@"http://www.how-old.net/?q=%@" stringByAppendingString:name];
//    [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];// 二进制数据
    
    [mgr GET:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功");
        NSString *content = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",content);
        if(responseObject !=nil)
        {
            NSArray *results = [AnalysisHelper analysisImagesResult:responseObject];
            if(results != nil)
            {
                successBlock(results);
            }
            else
            {
                failBlock(nil);
            }
        }
        else
        {
            failBlock(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
        failBlock(error);
    }];
}

//2. 测试年龄
//@"image/png"
+ (void)testAgeByImageData:(NSData *)imageData
               successBlock:(void (^)(NSDictionary *ageInfos))successBlock
                  failBlock:(void (^)(NSError *error))failBlock
{
    NSString *urlStr = @"http://www.how-old.net/Home/Analyze?isTest=False&source=&version=www.how-old.net";
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 1.请求时提交的数据格式
    //    mgr.requestSerializer = [AFJSONRequestSerializer serializer ];// JSON
    
    // 2. 返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];// 二进制数据
    
    // 上传
    [mgr POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 构建请求的body
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"test.jpeg" mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功 ");
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",str);
        NSDictionary *info = [AnalysisHelper analysisInfo:str];
    
        if(info!=nil)
        {
            successBlock(info);
        }
        else
        {
            failBlock(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
        failBlock(error);
    }];
}
@end
