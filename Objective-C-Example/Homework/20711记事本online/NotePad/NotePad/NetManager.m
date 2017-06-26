//
//  NetManager.m
//  NotePad
//
//  Created by student on 16/3/30.
//  Copyright © 2016年 马千里. All rights reserved.
//

#import "NetManager.h"

#import "NoteData.h"
#import <AFNetworking.h>
@implementation NetManager


//查询note的方法
+ (void)queryFromNet:(NSString *)urlStr
        successBlock:(void(^)(NSArray *array))successBlock
           failBlock:(void(^)(NSError *error))failBlock{
    // 请求的manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /*
     * desc  : GET请求
     * param : URLString - 请求的地址
     * parameters - 请求参数（GET请求，参数可以为nil 或者 可以提交一个时间戳）
     * success - 请求成功回调的block
     * failure - 请求失败回调的block
     */
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             // 处理请求成功，服务器返回的JSON数据
             NSArray *array = responseObject[@"Record"];
             NSMutableArray *mArray = [[NSMutableArray alloc]init];
             for (NSDictionary *dict in array) {
                 NoteData *noteData = [NoteData dataWithDict:dict];
                 [mArray addObject:noteData];
             }
             successBlock([mArray copy]);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             failBlock(error);
         }];
}

//添加note的方法
+ (void)addFromNet:(NSString *)content
           andDate:(NSString *)date
      successBlock:(void(^)(NSString *str))successBlock
         failBlock:(void(^)(NSError *error))failBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.51work6.com/service/mynotes/WebService.php?email=301063915@qq.com&type=JSON&action=add&content=%@&date=%@",content,date];
    //转码，不然会崩溃
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             successBlock(responseObject[@"ResultCode"]);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             failBlock(error);
         }];
}

+ (void)deleteFromNet:(NSString *)deleteId{
    // 请求的manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.51work6.com/service/mynotes/WebService.php?email=301063915@qq.com&type=JSON&action=remove&id=%@",deleteId];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             // 处理请求成功，服务器返回的JSON数据
//             successBlock([mArray copy]);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
//             failBlock(error);
         }];

}













@end
